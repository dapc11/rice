#!/usr/bin/python3
"""Class containing utility classes used when ricing."""
import json
import os


def get_context(theme):
    """Load context of the given theme that should be used when ricing."""

    with open(f"themes/{theme}.json", "r", encoding="utf-8") as colors_context, open(
        "themes/settings.json",
        "r",
        encoding="utf-8",
    ) as settings_context:
        theme_path = os.path.abspath(theme)
        print(f"Using context: '{theme_path}.json'")
        context = {**json.load(settings_context), **json.load(colors_context)}
        context["wifi_if"] = get_wireless_if()

        return context


def get_wireless_if():
    """Read wireless data for obtaining wireless network interface."""
    with open("/proc/net/wireless", "r", encoding="utf-8") as wireless:
        try:
            interface = wireless.readlines()[2:][0].split(":")[0]
            print(f"Wireless network interface: {interface}")

            return interface
        except IndexError:
            return "N/A"
