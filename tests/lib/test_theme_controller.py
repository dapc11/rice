import io
import unittest
from unittest.mock import patch, MagicMock, call
import sys

from lib.ThemeController import ThemeController


class TestThemeController(unittest.TestCase):

    def setUp(self):
        self.args = MagicMock()
        self.args.list = False
        self.args.theme = None

    def test__get_themes(self):
        with patch('glob.glob') as mock_glob:
            mock_glob.return_value = [
                'themes/catpuccin.json',
                'themes/doom-one.json',
                'themes/settings.json'
            ]
            controller = ThemeController(self.args)
            themes = controller._get_themes()
            expected_themes = ['catpuccin', 'doom-one']
            self.assertEqual(themes, expected_themes)

    @patch('sys.exit')
    def test__print_available_themes(self, mock_exit):
        controller = ThemeController(self.args)
        controller._get_themes = MagicMock(return_value=['catpuccin', 'doom-one'])

        # Capture print output using StringIO
        output = io.StringIO()
        sys.stdout = output

        controller._print_available_themes()

        # Reset sys.stdout
        sys.stdout = sys.__stdout__

        expected_output = "Specify theme with --theme (-t) flag.\nAvailable themes:\n  - catpuccin\n  - doom-one\n"
        self.assertEqual(output.getvalue(), expected_output)
        mock_exit.assert_called_with(0)

    def test__validate_theme(self):
        controller = ThemeController(self.args)
        controller.theme = 'catpuccin'
        themes = ['catpuccin', 'doom-one']
        self.assertTrue(controller._validate_theme(themes))

    @patch('builtins.print')
    @patch('sys.exit')
    def test_get_theme_valid(self, mock_exit, mock_print):
        controller = ThemeController(self.args)
        controller._validate_theme = MagicMock(return_value=True)
        controller._get_themes = MagicMock(return_value=['catpuccin', 'doom-one'])
        theme = controller.get_theme()
        self.assertEqual(theme, None)
        mock_exit.assert_not_called()
        mock_print.assert_not_called()

    @patch('builtins.print')
    @patch('sys.exit')
    def test_get_theme_invalid(self, mock_exit, mock_print):
        controller = ThemeController(self.args)
        controller._validate_theme = MagicMock(return_value=False)
        controller._get_themes = MagicMock(return_value=['catpuccin', 'doom-one'])
        theme = controller.get_theme()
        expected_output = [
            call('Specify theme with --theme (-t) flag.\nAvailable themes:'),
            call('  - catpuccin'),
            call('  - doom-one')
        ]
        mock_print.assert_has_calls(expected_output)
        mock_exit.assert_called_with(0)
        self.assertEqual(theme, None)

    def test_get_theme_list_themes(self):
        self.args.list = True
        controller = ThemeController(self.args)
        controller._get_themes = MagicMock(return_value=['catpuccin', 'doom-one'])
        with self.assertRaises(SystemExit):
            controller.get_theme()


if __name__ == '__main__':
    unittest.main
