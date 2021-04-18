package dapc11

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
}
