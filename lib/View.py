#!/usr/bin/python3
import jinja2
from lib import utils


class View:
    """Class for handling templates."""
    def __init__(self, theme):
        super().__init__()
        self.env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="./templates/"))
        self.context = utils.get_context(theme)

    def _get_template(self, name):
        template = self.env.get_template(name)
        return template.render(self.context)

    def get_context_value(self, key) -> str:
        return self.context[key]

    def render(self, name, destination) -> None:
        print(f"Writing to {destination}")

        template = self._get_template(name)
        with open(destination, "w") as destination_file:
            destination_file.write(template)
