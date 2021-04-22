package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/fs"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	rice "rice/src/packages"
)

var templates = map[string]fs.FileMode{}
var regular = fs.FileMode(0644)
var executable = fs.FileMode(0755)

func init() {
	templates["templates/alacritty/alacritty.yml"] = regular
	templates["templates/dunst/dunstrc"] = regular
	templates["templates/ranger/rc.conf"] = regular
	templates["templates/yamllint/config"] = regular
	templates["templates/compton/compton.conf"] = regular
	templates["templates/.tmux.conf"] = regular
	templates["templates/.zshrc"] = regular
	templates["templates/.xprofile"] = regular
	templates["templates/.zprofile"] = regular
	templates["templates/.Xresources"] = regular
	templates["templates/nvim/init.vim"] = regular
	templates["templates/nvim/mappings.vim"] = regular
	templates["templates/nvim/plugins.vim"] = regular
	templates["templates/nvim/statusline.vim"] = regular
	templates["templates/nvim/fzf.vim"] = regular
	templates["templates/nvim/options.vim"] = regular
	templates["templates/nvim/dapc11.vim"] = regular
	templates["templates/i3/config"] = regular
	templates["templates/awesome/rc.lua"] = regular
	templates["templates/awesome/theme.lua"] = regular
	templates["templates/awesome/sysact"] = executable
	templates["templates/Code/User/settings.json"] = regular
	templates["templates/Code/User/keybindings.json"] = regular
	templates["templates/rofi/config.rasi"] = regular
	templates["templates/rofi/powermenu.rasi"] = regular
	templates["templates/rofi/rofi-power"] = executable
	templates["templates/rofi/rofi-randr"] = executable
	templates["templates/polybar/config"] = regular
	templates["templates/polybar/startup.sh"] = executable
	templates["templates/polybar/updates.sh"] = executable
	templates["templates/polybar/now_playing.py"] = executable
	templates["templates/polybar/weather.sh"] = executable
	templates["templates/bin/dimmer"] = executable
	templates["templates/bin/nightmode"] = executable
	templates["templates/bin/gita"] = executable
}

func initArgs() (bool, string, bool) {
	var overwrite = flag.Bool("o", false, "Overwrite existing configuration")
	var theme = flag.String("t", "", "Overwrite existing configuration")
	var list = flag.Bool("l", false, "List themes")
	flag.Parse()
	return *overwrite, *theme, *list
}

func listThemes(list bool, exitCode int) {
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
		os.Exit(exitCode)
	}
}

func unmarshal(file string, obj interface{}) {
	f, err := os.ReadFile(file)
	if err != nil {
		log.Fatal(err)
	}
	err = json.Unmarshal(f, obj)
	if err != nil {
		log.Fatal(err)
	}
}

func getContext(file string) (rice.Theme, rice.Settings) {
	var theme rice.Theme
	var settings rice.Settings

	unmarshal(fmt.Sprintf("themes/%v.json", file), &theme)
	unmarshal("themes/settings.json", &settings)

	settings.Wifi = rice.GetWifi()

	return theme, settings
}

func renderTemplates(themeId string, shouldOverwrite bool) {
	theme, settings := getContext(themeId)
	var target string
	if shouldOverwrite {
		homeDir, _ := os.UserHomeDir()
		target = fmt.Sprintf("%v/.config", homeDir)
	} else {
		target = "target"
	}

	for templatePath, fsMode := range templates {
		content, _ := os.ReadFile(templatePath)
		content = rice.RenderTheme(content, theme)
		content = rice.RenderSettings(content, settings)

		strippedTemplatePath := strings.Replace(templatePath, "templates/", "", 1)
		destination := fmt.Sprintf("%v/%v", target, strippedTemplatePath)
		saveFile(content, destination, fsMode)
	}
}

func saveFile(content []byte, destination string, fileMode fs.FileMode) {

	err := os.MkdirAll(filepath.Dir(destination), 0755)
	if err != nil {
		log.Fatal(err)
	}
	os.WriteFile(destination, content, fileMode)
	fmt.Printf("Writing to %v\n", destination)
}

func main() {
	overwrite, theme, list := initArgs()
	listThemes(list, 0)

	if theme == "" {
		fmt.Println("No theme selected. Add -t <theme>")
		listThemes(true, 0)
	}

	//TODO link files
	//TODO set background

	renderTemplates(theme, overwrite)
}
