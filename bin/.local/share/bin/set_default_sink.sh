#!/bin/bash
sleep 3
pactl get-default-sink
pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo
