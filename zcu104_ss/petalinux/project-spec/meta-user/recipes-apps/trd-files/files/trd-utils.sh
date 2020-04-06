# return DRICard number
function detect_screen() {
	MONITOR_DP="/sys/class/drm/card*-DP*/status"
	MONITOR_HDMI="/sys/class/drm/card*-HDMI*/status"

	if [ $(cat ${MONITOR_DP} 2>/dev/null) = "connected" ]; then
		echo 0
	elif [ $(cat ${MONITOR_HDMI} 2>/dev/null) = "connected" ]; then
		echo 1
	fi
}
