import json
import unittest
from io import StringIO
from unittest.mock import patch

from lib.utils import get_context, get_wireless_if


class MyModuleTests(unittest.TestCase):
    def setUp(self):
        self.theme_path = "themes/mytheme.json"
        self.settings_path = "themes/settings.json"

    def test_get_context(self):
        theme = "mytheme"
        expected_context = {
            "wifi_if": "wlan0",
            "setting1": "value1",
            "setting2": "value2",
            "color1": "#ffffff",
            "color2": "#000000",
        }

        with patch("lib.utils.get_wireless_if", return_value="wlan0"):
            with patch("builtins.open") as mock_open:
                mock_open.side_effect = [
                    StringIO(json.dumps({"setting1": "value1", "setting2": "value2"})),
                    StringIO(json.dumps({"color1": "#ffffff", "color2": "#000000"})),
                ]
                context = get_context(theme)

        self.assertEqual(context, expected_context)
        mock_open.assert_any_call(self.settings_path, "r", encoding="utf-8")
        mock_open.assert_any_call(self.theme_path, "r", encoding="utf-8")

    def test_get_context_wireless_not_available(self):
        theme = "mytheme"
        expected_context = {
            "wifi_if": "N/A",
            "setting1": "value1",
            "setting2": "value2",
            "color1": "#ffffff",
            "color2": "#000000",
        }

        with patch("lib.utils.get_wireless_if", return_value="N/A"):
            with patch("builtins.open") as mock_open:
                mock_open.side_effect = [
                    StringIO(json.dumps({"setting1": "value1", "setting2": "value2"})),
                    StringIO(json.dumps({"color1": "#ffffff", "color2": "#000000"})),
                ]
                context = get_context(theme)

        self.assertEqual(context, expected_context)
        mock_open.assert_any_call(self.settings_path, "r", encoding="utf-8")
        mock_open.assert_any_call(self.theme_path, "r", encoding="utf-8")

    def test_get_wireless_if(self):
        expected_interface = "wlan0"
        wireless_data = [
            "Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE",
            " face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22",
            "wlan0: 0000   70.  -36.  -256        0      0      0      0      0        0",
            "wlan1: 0000   70.  -36.  -256        0      0      0      0      0        0",
        ]

        with patch("builtins.open") as mock_open:
            mock_open.return_value.__enter__.return_value.readlines.return_value = wireless_data
            interface = get_wireless_if()

        self.assertEqual(interface, expected_interface)
        mock_open.assert_called_once_with("/proc/net/wireless", "r", encoding="utf-8")

    def test_get_wireless_if_no_interface(self):
        expected_interface = "N/A"
        wireless_data = [
            "Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE",
            " face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22",
        ]

        with patch("builtins.open") as mock_open:
            mock_open.return_value.__enter__.return_value.readlines.return_value = wireless_data
            interface = get_wireless_if()

        self.assertEqual(interface, expected_interface)
        mock_open.assert_called_once_with("/proc/net/wireless", "r", encoding="utf-8")


if __name__ == "__main__":
    unittest.main()
