#!/usr/bin/python3
import json
import os


def get_context(theme):
    with open(f'themes/{theme}.json', 'r') as colors_context,\
            open('themes/settings.json', 'r') as settings_context:
        theme_path = os.path.abspath(theme)
        print(f"Using context: '{theme_path}.json'")
        context = {
            **json.load(settings_context),
            **json.load(colors_context)}
        context['wifi_if'] = get_wireless_if()

        return context


def make_executable(dest):
    mode = os.stat(dest).st_mode
    mode |= (mode & 0o444) >> 2  # copy R bits to X
    os.chmod(dest, mode)


def get_wireless_if():
    lines = open("/proc/net/wireless", "r").readlines()
    try:
        interface = lines[2:][0].split(":")[0]
        print(f'Wireless network interface: {interface}')

        return interface
    except IndexError:
        return "N/A"
