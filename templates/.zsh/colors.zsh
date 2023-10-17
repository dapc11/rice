_gen_fzf_default_opts() {
  local color00='{{base00}}'
  local color01='{{base01}}'
  local color02='{{base02}}'
  local color03='{{base03}}'
  local color04='{{base04}}'
  local color05='{{base05}}'
  local color06='{{base06}}'
  local color07='{{base07}}'
  local color08='{{base08}}'
  local color09='{{base09}}'
  local color0A='{{base0A}}'
  local color0B='{{base0B}}'
  local color0C='{{base0C}}'
  local color0D='{{base0D}}'
  local color0E='{{base0E}}'
  local color0F='{{base0F}}'

  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}"\
" --color=bg+:${color01},bg:${color00},spinner:${color0C},hl:${color0D}"\
" --color=fg:${color03},header:${color0D},info:${color0A},pointer:${color0C}"\
" --color=marker:${color0C},fg+:${color06},prompt:${color0A},hl+:${color0D}"
}
