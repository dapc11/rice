#!/usr/bin/python3
# -*- coding: UTF-8 -*-
# Play:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
# Pause:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause
# Play/Pause toggle:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
# Previous:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
# Next:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next

import dbus
import sys

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
    spotify_properties = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
    is_playing = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')
    metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
except Exception:
    sys.exit(1)


def get_title():
    return metadata['xesam:title']


def get_artist():
    return metadata['xesam:artist'][0]


try:
    if is_playing == "Playing":
        print("奈 {} - {}".format(get_artist(), get_title()))
    else:
        print('')
    sys.exit(0)
except Exception:
    print('')
sys.exit(0)
