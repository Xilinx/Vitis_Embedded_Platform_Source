#!/bin/bash

source /etc/trd/trd-utils.sh

supported_res=("3840x2160" "1920x1080" "1280x720")

echo "****************************************************"
echo "** Zynq UltraScale+ MPSoC Base TRD Qt Application **"
echo "****************************************************"

function print_help() {
	echo -e "Usage:"
	echo -e "  $0 [-r|--resolution <width>x<height>] [-l|--list] [-h|--help]"
	echo -e "Options:"
	echo -e "  -h, --help        Display this help and exit"
	echo -e "  -l, --list        List supported resolutions for -r"
	echo -e "  -r, --resolution  Set resolution"
	echo -e "  -d, --device      Set device. 0 = DP, 1 = HDMI"
}

function print_resolutions() {
	echo -e "Supported resolutions:"
	for r in "${supported_res[@]}"; do
		echo -e "  ${r}"
	done
}

resolution=""
while [ "$1" != "" ]; do
	case $1 in
	-h | --help )
		print_help $0
		exit 0
		;;
	-l | --list )
		print_resolutions
		exit 0
		;;
	-r | --resolution )
		shift
		resolution=$1
		if [[ ! " ${supported_res[@]} " =~ " ${resolution} " ]]; then
			echo "invalid resolution '$resolution'"
			exit 1
		fi
		;;
	-d | --device )
		shift
		device=$1
		if [[ ${device} != 1 && ${device} != 0 ]]; then
			echo "invalid device '${device}'"
			exit 1
		fi
		;;
	*)
		echo "invalid argument '$1'"
		exit 1
		;;
	esac
	shift
done

if [ -z "${device}" ]; then
	device=$(detect_screen)

	if [ -z "${device}" ]; then
		echo "ERROR: No display device found"
		exit 2
	fi
fi

# adjust xorg.conf
sed -i -e "s/\(Option\s\+\"DRICard\"\s\+\)\"[0-9]\+\"/\1\"${device}\"/" /etc/X11/xorg.conf

echo "Starting application..."
VIDEO_QT_ARGS=""
if [ "${resolution}" != "" ]; then
	VIDEO_QT_ARGS="-r ${resolution} ${VIDEO_QT_ARGS}"
fi

startx $(which video_qt2) -d ${device} ${VIDEO_QT_ARGS}
