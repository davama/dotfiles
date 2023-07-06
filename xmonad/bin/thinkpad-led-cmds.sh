#!/bin/bash

# P15s Gen 1

# control power button led
echo "0 off" | sudo tee /proc/acpi/ibm/led 1> /dev/null
echo "0 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
echo "0 blink" | sudo tee /proc/acpi/ibm/led 1> /dev/null

# control keyboard leds
echo 0 | sudo tee /sys/class/leds/tpacpi\:\:kbd_backlight/brightness 1> /dev/null
echo 1 | sudo tee /sys/class/leds/tpacpi\:\:kbd_backlight/brightness 1> /dev/null
echo 2 | sudo tee /sys/class/leds/tpacpi\:\:kbd_backlight/brightness 1> /dev/null
