#!/usr/bin/python3
"""Class containing utility classes used when ricing."""
import json
import os


def get_context(theme):
    """Load context of the given theme that should be used when ricing."""

    with open(f"themes/{theme}.json", "r") as colors_context, open(
        "themes/settings.json", "r"
    ) as settings_context:
        theme_path = os.path.abspath(theme)
        print(f"Using context: '{theme_path}.json'")
        context = {**json.load(settings_context), **json.load(colors_context)}
        context["wifi_if"] = get_wireless_if()

        return context


def make_executable(file):
    """Make given file executeable."""
    mode = os.stat(file).st_mode
    mode |= (mode & 0o444) >> 2  # copy R bits to X
    os.chmod(file, mode)


def get_wireless_if():
    """Read wireless data for obtaining wireless network interface."""
    lines = open("/proc/net/wireless", "r").readlines()
    try:
        interface = lines[2:][0].split(":")[0]
        print(f"Wireless network interface: {interface}")

        return interface
    except IndexError:
        return "N/A"
