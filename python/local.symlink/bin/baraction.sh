#!/bin/bash
#
# $scrotwm: baraction.sh,v 1.17 2010/07/01 19:49:37 marco Exp $

ACPI=/usr/bin/acpi
IOSTAT=/usr/bin/iostat
TOP=/usr/bin/top

print_date() {
	# The date is printed to the status bar by default.
	# To print the date through this script, set clock_enabled to 0
	# in scrotwm.conf.  Uncomment "print_date" below.
	FORMAT="%r %F"
	DATE=`date "+${FORMAT}"`
	echo -n "${DATE}"
}

print_mem() {
	echo -n "$3/$2"
}

_print_cpu() {
	echo -n "User ${1}% Nice ${2}% Sys ${3}% Idle ${6}%"
}

print_cpu() {
	OUT=""
	# is 100, it jams up agains the preceeding one. sort this out.
	while [ "${1}x" != "x" ]; do
		OUT="$OUT `echo $1 | cut -d '.' -f 1`"
		shift;
	done
	_print_cpu $OUT
}

print_acpi() {
	BAT_STATUS=$3
	BAT_LEVEL=`echo $4 | tr -d ','`
	BAT_REM=`echo $5 | tr -d ','`

	case $BAT_STATUS in
	"Charging,")
		FULL="> (${BAT_LEVEL} ${BAT_REM})"
		;;
	"Discharging,")
		FULL="< (${BAT_LEVEL} ${BAT_REM})"
		;;
	"Full,")
		FULL="> (100%)"
		;;
	"Unknown,")
		FULL="? (100%)"
		;;
	*)
		FULL="$3 $4"
		;;
	esac;

	echo -n "$FULL"
}

print_cpuspeed() {
	#CPU_SPEED=`/sbin/sysctl hw.cpuspeed | cut -d "=" -f2`
	#echo -n "CPU speed: $CPU_SPEED MHz  "
	echo -n "Freq:"$(cat /proc/cpuinfo | grep 'cpu MHz' | sed 's/.*: //g; s/\..*//g;')
	echo -n " Load:$(uptime | sed 's/.*://; s/,//g')"
}

print_spaces() {
	echo -n "       "
}

# instead of sleeping, use iostat as the update timer.
# cache the output of acpi(1), no need to call that every second.
PID="$!"
ACPI_DATA=""
I=0
trap "kill $PID; exit" TERM
${IOSTAT} -c 3 2>&1 |
while read IOSTAT_DATA; do
	if [ $(( ${I} % 10 )) -eq 0 ]; then
		ACPI_DATA=`${ACPI} -b`
	fi
	MEM=`free -m | grep Mem`
	if [ $(( ${I} % 3 )) -eq 0 ] && [ ${I} -gt 2 ]; then
		print_cpu $IOSTAT_DATA
		print_spaces
		print_mem $MEM
		print_spaces
		print_cpuspeed
		print_spaces
		print_acpi $ACPI_DATA
		print_spaces
		print_date
		echo ""
	fi
	I=$(( ${I} + 1 ));
done
