#!/usr/bin/env zsh

awk '{ print $1 "/" $2 "/" $3 " / " $4 " / " $5 }' < /proc/loadavg
