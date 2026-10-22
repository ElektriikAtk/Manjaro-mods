#!/bin/zsh
# DO NOT CHANGE FROM ZSH TO BASH AT IT WON'T SUPPORT FLOAT CONVERSION

#Number of steps that the brightness should increment at
steps_increment=20

if [[ "$#" -eq "0" ]]
then
    echo "Please input a valid input parameter:\n1 to increase or 0 to decrease."
    exit 1
fi

brightness=`qdbus6 org.kde.ScreenBrightness /org/kde/ScreenBrightness/display0 org.kde.ScreenBrightness.Display.Brightness`
echo "brightness: "$brightness

max_brightness=`qdbus6 org.kde.ScreenBrightness /org/kde/ScreenBrightness/display0 org.kde.ScreenBrightness.Display.MaxBrightness`
echo "max_brightness: "$max_brightness

normalized_brightness=`echo "scale=2;($brightness/$max_brightness)" | bc`
echo "normalized_brightness: "$normalized_brightness

    if [[ "$1" -eq 1 ]]
    then
        modified_brightness=`echo "$(($normalized_brightness*10000+$steps_increment*100))/1" | bc`
    elif [[ "$1" -eq 0 ]]
    then
        if [[ "$brightness" -ne 0 ]]
        then
            modified_brightness=`echo "$(($normalized_brightness*10000-$steps_increment*100))/1" | bc`
        else
            brightnessctl set 0
            exit 1
        fi
    fi
    echo "modified_brightness: "$modified_brightness


qdbus6 org.kde.ScreenBrightness /org/kde/ScreenBrightness/display0 org.kde.ScreenBrightness.Display.SetBrightness $modified_brightness 0
