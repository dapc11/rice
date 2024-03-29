#!/usr/bin/python3
"""Software for setting up Dapc Linux development environment."""

import argparse
import getpass
import json
import os
import sys
from pathlib import Path
from shutil import copyfile, copytree, rmtree

import jinja2
from jinja2.exceptions import TemplateNotFound

from lib import utils
from lib.ThemeController import ThemeController


class Templates:
    def __init__(self, templates_path, overwrite, theme) -> None:
        self.templates_path = templates_path
        self.overwrite = overwrite
        self.env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(searchpath="./templates/"),
        )
        self.context = utils.get_context(theme)

    def __enter__(self):
        with open(self.templates_path, "r", encoding="utf-8") as file:
            templates = json.load(file)
            return [Template(t, self.overwrite, self.env, self.context) for t in templates]

    def __exit__(self, *_):
        pass


class Template:
    def __init__(self, metadata, overwrite, env, context) -> None:
        self.metadata = metadata
        self.overwrite = overwrite
        self.env = env
        self.context = context

    @property
    def template(self) -> str:
        return self.metadata.get("template")

    @property
    def target(self) -> Path:
        target = self.metadata.get("destination")
        if "utils/" in self.template:
            return Path(f"{target}".replace("~", f"/home/{getpass.getuser()}"))
        if not self.overwrite or not target:
            target = (
                f"/home/{getpass.getuser()}/.config" if self.overwrite else f"{os.getcwd()}/target"
            )
        f = f"{target}/{self.template}"
        return Path(
            f.replace("~", f"/home/{getpass.getuser()}"),
        )

    @property
    def executable(self) -> bool:
        return self.metadata.get("executable")

    @property
    def onlyCopy(self) -> bool:
        copy_only = self.metadata.get("onlyCopy")
        return copy_only if copy_only else False

    @property
    def content(self):
        try:
            t = self.env.get_template(self.template)
        except jinja2.exceptions.TemplateSyntaxError:
            print(f"Could not render {self.template}")
            sys.exit(1)
        return t.render(self.context)

    def __repr__(self) -> str:
        return f"{self.template}"

    def create_parents(self) -> None:
        if not os.path.exists(self.target.parent):
            os.makedirs(self.target.parent)

    def render(self) -> None:
        print(f"Writing to {self.target}")

        try:
            with open(self.target, "w", encoding="UTF-8") as target:
                target.write(self.content)
        except TemplateNotFound:
            print(f"Template not found {self.template}")

    def make_executable(self):
        """Make target file executeable."""
        mode = os.stat(self.target).st_mode
        mode |= (mode & 0o444) >> 2  # copy R bits to X
        os.chmod(self.target, mode)


class TemplateController:
    """Class for transforming the templates into actual config files for various software."""

    def __init__(self, theme: str, overwrite: bool):
        self.theme = theme
        self.overwrite = overwrite

    @staticmethod
    def copy_file(template: Template) -> None:
        """Move source to target, without render any template value placeholders."""
        source = f"templates/{template.template}"
        target = template.target

        print(f"Writing to {target}")
        if os.path.isdir(source):
            if os.path.exists(target):
                rmtree(target)
            copytree(source, target, dirs_exist_ok=False)
        else:
            copyfile(source, str(target))

    def render_templates(self) -> None:
        """Render templates defined in templates.json."""
        with Templates("templates.json", self.overwrite, self.theme) as templates:
            for template in templates:
                template.create_parents()
                if template.onlyCopy:
                    TemplateController.copy_file(template)
                else:
                    template.render()

                    if template.executable:
                        template.make_executable()

    @staticmethod
    def run_commands(commands_file_path) -> None:
        """Potentially dangerous feature, make sure that you know what's in the commands file."""
        if not commands_file_path or os.path.exists(commands_file_path):
            return
        with open(commands_file_path, mode="r", encoding="utf-8") as commands_file:
            for command in commands_file.readlines():
                command = command.replace("\n", "")
                print(f"Running command: '{command}'", end="")
                os.system(command)
                print()


def setup_argparser() -> argparse.ArgumentParser:
    """Setup the arguments of the program."""
    arg_parser = argparse.ArgumentParser(
        prog="rice_it",
        description="Render dotfile templates based on base16 theme",
    )
    arg_parser.add_argument(
        "-o",
        "--overwrite",
        help="Make rice_it overwrite existing dotfiles in your home directory, use with caution!",
        action="store_true",
        default=False,
    )
    arg_parser.add_argument(
        "-c",
        "--commands",
        action="store",
        dest="commands",
        help="Specify path to commands declaration",
    )
    arg_parser.add_argument(
        "-t",
        "--theme",
        action="store",
        dest="theme",
        help="specify which theme the context will be loaded from.",
    )
    arg_parser.add_argument("-l", "--list", action="store_true", help="List available themes")

    return arg_parser


def main():
    """Entrypoint to the Controller."""
    parser = setup_argparser()
    args = parser.parse_args()
    tc = ThemeController(args)
    theme = tc.get_theme()
    controller = TemplateController(theme, args.overwrite)
    controller.run_commands(args.commands)
    controller.render_templates()

    sys.exit(0)


if __name__ == "__main__":
    main()
