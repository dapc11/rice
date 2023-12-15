#!/usr/bin/python3
"""Controller class for handling of the themes."""
import glob
import os
import sys


class ThemeController:  # pylint: disable=R0903
    def __init__(self, args) -> None:
        self.list_themes = args.list
        self.theme = args.theme

    @staticmethod
    def get_themes():
        """Visualize which themes that are available."""
        theme_names = []

        for theme_path in glob.glob("themes/*.json"):
            if "settings" in theme_path:
                continue
            theme_names.append(os.path.splitext(os.path.basename(theme_path))[0])

        return theme_names

    def print_available_themes(self) -> None:
        print("Specify theme with --theme (-t) flag.\nAvailable themes:")

        for theme in self.get_themes():
            print(f"  - {theme}")
        sys.exit(0)

    def validate_theme(self, themes) -> bool:
        return self.theme is not None and self.theme in themes

    def get_theme(self) -> str:
        """Get theme if valid, otherwise print list of available themes."""
        themes = self.get_themes()
        if not self.validate_theme(themes) or self.list_themes:
            self.print_available_themes()
        return self.theme
