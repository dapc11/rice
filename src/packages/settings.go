package rice

import (
	"fmt"
	"os"
	"regexp"
	"strings"
)

type Settings struct {
	Font          string `json:"font"`
	Shell         string `json:"shell"`
	Terminal      string `json:"terminal"`
	Browser       string `json:"browser"`
	Editor        string `json:"editor"`
	Keymap        string `json:"keymap"`
	ZshTheme      string `json:"zsh_theme"`
	GtkTheme      string `json:"gtk_theme"`
	WindowManager string `json:"window_manager"`
	Wifi          string
}

func GetWifi() string {
	content, _ := os.ReadFile("/proc/net/wireless")
	re := regexp.MustCompile("(?m)(^.*\n){2}")
	res := re.ReplaceAllString(string(content), "")
	wifi := strings.Split(res, ":")[0]
	fmt.Printf("Using network interface: %v\n", wifi)
	return wifi
}

func RenderSettings(content []byte, settings Settings) []byte {
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
		"{{wifi_if}}", settings.Wifi,
	)

	result := r.Replace(c)
	return []byte(result)
}
