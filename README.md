# Dapc11 Ricer

## Getting started

Make __first_setup__ executable and invoke it as following in order to setuo your environment:

```shell
bash first_setup
```

One can at any time after first setup invoke __rice_it__ in order to re-generate dotfiles, see below for usage.

### Usage

```
❯ python3 rice_it -h
usage: rice_it [-h] [-o] [-t THEME] [-l]

Dapc ricer, make your environment consistent from a color perspective with a declarative approach.

optional arguments:
  -h, --help            show this help message and exit
  -o, --overwrite       Make rice_it overwrite existing dotfiles in your home directory, use with
                        caution!
  -t THEME, --theme THEME
                        Specify which theme the context will be loaded from.
  -l, --list            List available themes
```

## Base 16

Base16 aims to group similar language constructs with a single color. For example, floats, ints, and doubles would belong to the same colour group. The colors for the default theme were chosen to be easily separable, but scheme designers should pick whichever colours they desire, e.g. base0B (green by default) could be replaced with red. There are, however, some general guidelines below that stipulate which base0B should be used to highlight each construct when designing templates for editors.

Since describing syntax highlighting can be tricky, please see base16-vim and base16-textmate for reference. Though it should be noted that each editor will have some discrepancies due the fact that editors generally have different syntax highlighting engines.

Colors base00 to base07 are typically variations of a shade and run from darkest to lightest. These colors are used for foreground and background, status bars, line highlighting and such. Colors base08 to base0F are typically individual colors used for types, operators, names and variables. In order to create a dark theme, colors base00 to base07 should span from dark to light. For a light theme, these colours should span from light to dark.

    base00 - Default Background
    base01 - Lighter Background (Used for status bars)
    base02 - Selection Background
    base03 - Comments, Invisibles, Line Highlighting
    base04 - Dark Foreground (Used for status bars)
    base05 - Default Foreground, Caret, Delimiters, Operators
    base06 - Light Foreground (Not often used)
    base07 - Light Background (Not often used)
    base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A - Classes, Markup Bold, Search Text Background
    base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D - Functions, Methods, Attribute IDs, Headings
    base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

## Samples

### Onedark
<img src="./samples/onedarker.png" alt="onedarker" width="400px">


## TODO

### Vim
- Zoomable split
- Bold operators
- Dim inactive splits
