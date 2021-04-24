#!/bin/sh

get_icon() {
    case $1 in
        # Icons for Font Awesome 5 Pro
        01d) icon="滛";; # day clear sky
        01n) icon="望";; # night clear sky
        02d) icon="杖";; # day few clouds
        02n) icon="杖";; # night few clouds
        03*) icon="";;  # scattered clouds
        04*) icon="";;  # broken clouds
        09*) icon="歹";; # shower rain
        10*) icon="殺";; # day rain
        11*) icon="朗";; # thunderstorm
        13*) icon="流";; # snow
        50*) icon="敖";; # mist
        *) icon="";;
    esac

    echo $icon
}

get_duration() {

    osname=$(uname -s)

    case $osname in
        *BSD) date -r "$1" -u +%H:%M;;
        *) date --date="@$1" -u +%H:%M;;
    esac

}

KEY="6ca3ecf5354c3eaed6997d204d20bd85"
CITY="2701712"
UNITS="metric"
SYMBOL=""

API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        current=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
    fi
fi

if [ -n "$current" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")

    echo "$(get_icon $current_icon) $current_temp$SYMBOL"
fi
