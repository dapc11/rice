package main

import (
	structs "dapc11/src/structs"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func init_args() (bool, string, bool) {
	var overwrite = flag.Bool("o", false, "Overwrite existing configuration")
	var theme = flag.String("t", "", "Overwrite existing configuration")
	var list = flag.Bool("l", false, "List themes")
	flag.Parse()
	return *overwrite, *theme, *list
}

func list_themes(list bool) {
	if list {
		files, err := ioutil.ReadDir("./themes/")
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println("Choose between themes:")
		for _, file := range files {
			if strings.Contains(file.Name(), "settings") {
				continue
			}
			fmt.Println("- " + strings.TrimSuffix(file.Name(), ".json"))
		}
		os.Exit(0)
	}
}

func unmarshal(file string, obj interface{}) {
	f, err := os.ReadFile(file)
	if err != nil {
		log.Fatal(err)
	}
	err = json.Unmarshal(f, obj)
	if err != nil {
		fmt.Println("error:", err)
	}
}

func get_context(file string) (structs.Theme, structs.Settings) {
	var theme structs.Theme
	var settings structs.Settings

	unmarshal(fmt.Sprintf("themes/%v.json", file), &theme)
	unmarshal("themes/settings.json", &settings)

	return theme, settings
}

func render_templates(theme structs.Theme, settings structs.Settings) {
	templates := [34]string{
		"alacritty/alacritty.yml",
		"dunst/dunstrc",
		"ranger/rc.conf",
		"yamllint/config",
		"compton/compton.conf",
		".tmux.conf",
		".zshrc",
		".xprofile",
		".zprofile",
		".Xresources",
		"nvim/init.vim",
		"nvim/mappings.vim",
		"nvim/plugins.vim",
		"nvim/statusline.vim",
		"nvim/fzf.vim",
		"nvim/options.vim",
		"nvim/dapc11.vim",
		"i3/config",
		"awesome/rc.lua",
		"awesome/theme.lua",
		// "templates/awesome/sysact",
		"Code/User/settings.json",
		"Code/User/keybindings.json",
		"rofi/config.rasi",
		"rofi/powermenu.rasi",
		"rofi/rofi-power",
		"rofi/rofi-randr",
		"polybar/config",
		"polybar/startup.sh",
		"polybar/updates.sh",
		"polybar/now_playing.py",
		"bin/dimmer",
		"bin/nightmode",
		"bin/gita",
	}

	for _, t := range templates {
		template_path := fmt.Sprintf("templates/%v", t)
		content, _ := os.ReadFile(template_path)
		content = render_theme(content, theme)
		content = render_settings(content, settings)

		parent := filepath.Dir(t)
		err := os.MkdirAll(fmt.Sprintf("target/%v", parent), 0755)
		if err != nil {
			log.Fatal(err)
		}
		os.WriteFile(fmt.Sprintf("target/%v", t), content, 0755)
		fmt.Println(t)
	}
}

func render_theme(content []byte, theme structs.Theme) []byte {
	c := string(content)
	r := strings.NewReplacer(
		"{{bg}}", theme.Bg,
		"{{base00}}", theme.Base00,
		"{{base01}}", theme.Base01,
		"{{base02}}", theme.Base02,
		"{{base03}}", theme.Base03,
		"{{base04}}", theme.Base04,
		"{{base05}}", theme.Base05,
		"{{base06}}", theme.Base06,
		"{{base07}}", theme.Base07,
		"{{base08}}", theme.Base08,
		"{{base09}}", theme.Base09,
		"{{base0A}}", theme.Base0A,
		"{{base0B}}", theme.Base0B,
		"{{base0C}}", theme.Base0C,
		"{{base0D}}", theme.Base0D,
		"{{base0E}}", theme.Base0E,
		"{{base0F}}", theme.Base0F,
		"{{base00}}", theme.Base00Hex,
		"{{base01_hex}}", theme.Base01Hex,
		"{{base02_hex}}", theme.Base02Hex,
		"{{base03_hex}}", theme.Base03Hex,
		"{{base04_hex}}", theme.Base04Hex,
		"{{base05_hex}}", theme.Base05Hex,
		"{{base06_hex}}", theme.Base06Hex,
		"{{base07_hex}}", theme.Base07Hex,
		"{{base08_hex}}", theme.Base08Hex,
		"{{base09_hex}}", theme.Base09Hex,
		"{{base0A_hex}}", theme.Base0AHex,
		"{{base0B_hex}}", theme.Base0BHex,
		"{{base0C_hex}}", theme.Base0CHex,
		"{{base0D_hex}}", theme.Base0DHex,
		"{{base0E_hex}}", theme.Base0EHex,
		"{{base0F_hex}}", theme.Base0FHex,
	)

	result := r.Replace(c)
	return []byte(result)
}

func render_settings(content []byte, settings structs.Settings) []byte {
	c := string(content)
	r := strings.NewReplacer(
		"{{editor}}", settings.Editor,
		"{{font}}", settings.Font,
		"{{shell}}", settings.Shell,
		"{{terminal}}", settings.Terminal,
		"{{browser}}", settings.Browser,
		"{{keymap}}", settings.Keymap,
		"{{zsh_theme}}", settings.ZshTheme,
		"{{gtk_theme}}", settings.GtkTheme,
		"{{window_manager}}", settings.WindowManager,
	)

	result := r.Replace(c)
	return []byte(result)
}

func main() {
	_, theme, list := init_args()
	list_themes(list)

	t, s := get_context(theme)
	render_templates(t, s)
}
