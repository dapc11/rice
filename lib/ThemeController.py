#!/usr/bin/python3
"""Controller class for handling of the themes."""
import glob
import os
import sys


class ThemeController:
    def __init__(self, args) -> None:
        self.list_themes = args.list
        self.theme = args.theme

    @staticmethod
    def _get_themes():
        """Utility function for visualizing which themes that are available."""
        theme_names = []

        for theme_path in glob.glob("themes/*.json"):
            if "settings" in theme_path:
                continue
            theme_names.append(os.path.splitext(os.path.basename(theme_path))[0])

        return theme_names

    def _print_available_themes(self) -> None:
        print("Specify theme with --theme (-t) flag.\nAvailable themes:")

        for theme in self._get_themes():
            print(f"  - {theme}")
        sys.exit(0)

    def _validate_theme(self, themes) -> bool:
        return self.theme is not None and self.theme in themes

    def get_theme(self) -> str:
        """Get theme if valid, otherwise print lsit of available themes."""
        themes = self._get_themes()
        if not self._validate_theme(themes) or self.list_themes:
            self._print_available_themes()
        return self.theme
