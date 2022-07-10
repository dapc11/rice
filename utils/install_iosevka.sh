#!/bin/bash
RELEASE="14.0.1"

mkdir -p /tmp/iosevka-font/$RELEASE
cd /tmp/iosevka-font/$RELEASE

wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss01-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss02-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss03-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss04-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss05-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss06-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss07-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss08-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss09-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss10-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss11-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss12-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss13-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss14-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss15-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss16-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss17-$RELEASE.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$RELEASE/ttf-iosevka-term-ss18-$RELEASE.zip

unzip \*.zip

sudo mkdir /usr/local/share/fonts/iosevka-font
sudo mv *.ttf /usr/local/share/fonts/iosevka-font/.

sudo fc-cache -fv
