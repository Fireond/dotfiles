#!/bin/bash
TEXT=$(hyprctl clients)
echo "$TEXT" >>~/hyprctl_clients.txt
