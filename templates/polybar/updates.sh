#!/usr/bin/env bash

updates=$(/usr/lib/update-notifier/apt-check --human-readable | cut -d" " -f1 | head -1)

if [ "$updates" != "" ]; then
    echo " $updates"
else
    echo ""
fi
