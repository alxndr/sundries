#!/bin/bash
dd if=`drutil status | grep "/dev" | perl -lne 'print $1 if (m{(/dev/disk\d)})'` of=~/Downloads/dvd.iso bs=2048
