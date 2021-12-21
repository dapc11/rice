package rice

import (
	"strings"
)

type Theme struct {
	Bg        string `json:"bg"`
	NvimTheme string `json:"nvim_theme"`
	Base00    string `json:"base00"`
	Base01    string `json:"base01"`
	Base02    string `json:"base02"`
	Base03    string `json:"base03"`
	Base04    string `json:"base04"`
	Base05    string `json:"base05"`
	Base06    string `json:"base06"`
	Base07    string `json:"base07"`
	Base08    string `json:"base08"`
	Base09    string `json:"base09"`
	Base0A    string `json:"base0A"`
	Base0B    string `json:"base0B"`
	Base0C    string `json:"base0C"`
	Base0D    string `json:"base0D"`
	Base0E    string `json:"base0E"`
	Base0F    string `json:"base0F"`
}

func RenderTheme(content []byte, theme Theme) []byte {
	c := string(content)
	r := strings.NewReplacer(
		"{{bg}}", theme.Bg,
		"{{nvim_theme}}", theme.NvimTheme,
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
	)

	result := r.Replace(c)
	return []byte(result)
}
