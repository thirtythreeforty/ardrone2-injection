#!/bin/sh

LD_PRELOAD=/lib/inject.so /bin/program.elf $1
gpio 181 -d ho 1

while [ ! -f /tmp/.norespawn ]; do
	echo "Respawning program.elf"
	/bin/program.elf $1 -emergency.restart
	gpio 181 -d ho 1
done

