package rice

import (
	"strings"
)

type Theme struct {
	Bg        string `json:"bg"`
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
	Base00Hex string `json:"base00_hex"`
	Base01Hex string `json:"base01_hex"`
	Base02Hex string `json:"base02_hex"`
	Base03Hex string `json:"base03_hex"`
	Base04Hex string `json:"base04_hex"`
	Base05Hex string `json:"base05_hex"`
	Base06Hex string `json:"base06_hex"`
	Base07Hex string `json:"base07_hex"`
	Base08Hex string `json:"base08_hex"`
	Base09Hex string `json:"base09_hex"`
	Base0AHex string `json:"base0A_hex"`
	Base0BHex string `json:"base0B_hex"`
	Base0CHex string `json:"base0C_hex"`
	Base0DHex string `json:"base0D_hex"`
	Base0EHex string `json:"base0E_hex"`
	Base0FHex string `json:"base0F_hex"`
}

func RenderTheme(content []byte, theme Theme) []byte {
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
		"{{base00_hex}}", theme.Base00Hex,
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
