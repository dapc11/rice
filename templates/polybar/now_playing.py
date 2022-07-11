#!/usr/bin/python3
# Play:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play # pylint: disable=line-too-long
# Pause:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause # pylint: disable=line-too-long
# Play/Pause toggle:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause # pylint: disable=line-too-long
# Previous:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous # pylint: disable=line-too-long
# Next:
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next # pylint: disable=line-too-long # pylint: disable=line-too-long

import sys

import dbus

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        "org.mpris.MediaPlayer2.spotify",
        "/org/mpris/MediaPlayer2",
    )
    spotify_properties = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
    is_playing = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "PlaybackStatus")
    metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
except Exception:  # pylint: disable=W0703
    sys.exit(1)


def get_title():
    return metadata["xesam:title"]


def get_artist():
    return metadata["xesam:artist"][0]


try:
    if is_playing == "Playing":
        print(f"奈 {get_artist()} - {get_title()}")
    else:
        print("")
    sys.exit(0)
except Exception:  # pylint: disable=W0703
    print("")
sys.exit(0)
