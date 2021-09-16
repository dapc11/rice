#!/usr/bin/python3
import jinja2

from lib import utils


class View:
    """Class for handling templates."""

    def __init__(self, theme):
        super().__init__()
        self.env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(searchpath="./templates/")
        )
        self.context = utils.get_context(theme)

    def _get_template(self, name):
        template = self.env.get_template(name)
        return template.render(self.context)

    def get_context_value(self, key) -> str:
        return self.context[key]

    def render(self, template) -> None:
        print(f"Writing to {template.target}")

        content = self._get_template(template.path)
        with open(template.target, "w") as target:
            target.write(content)
