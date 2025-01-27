#!/bin/bash

server="https://rcn-ee.net/repos/latest/buster-armhf/LATEST-"

current_kernel () {
	if [ -f /tmp/LATEST-${var} ] ; then
		rm -rf /tmp/LATEST-${var} | true
	fi
	wget --quiet --directory-prefix=/tmp/ ${server}${var}
	unset latest_kernel
	latest_kernel=$(cat "/tmp/LATEST-${var}" | grep "ABI:1 ${ver}" | awk '{print $3}')
	unset old_kernel
	if [ "x${filter1}" = "x" ] ; then
		old_kernel=$(cat "configs/kernel.data" | grep "${var}" | grep "${ver}" | awk '{print $3}')
	else
		old_kernel=$(cat "configs/kernel.data" | grep -v "${filter1}" | grep -v "${filter2}" | grep "${var}" | grep "${ver}" | awk '{print $3}')
		unset filter1
		unset filter2
	fi
	if [ ! "x${latest_kernel}" = "x${old_kernel}" ] ; then
		echo "kernel bump: ${git_msg}: ($latest_kernel)"
		echo "[sed -i -e 's:'$old_kernel':'$latest_kernel':g']"
		sed -i -e 's:'$old_kernel':'$latest_kernel':g' configs/*.conf
		sed -i -e 's:'$old_kernel':'$latest_kernel':g' configs/kernel.data
		git commit -a -m "kernel bump: ${git_msg}: ($latest_kernel)" -s
	else
		echo "x${latest_kernel} = x${old_kernel}"
	fi
}

if [ -f configs/kernel.data ] ; then
	git_msg="5.4.x-xM"
#	var="armv7"      ; ver="LTS419"       ; current_kernel
	var="armv7"      ; ver="LTS54"       ; current_kernel
#	var="armv7"      ; ver="STABLE"       ; current_kernel
#	var="armv7"      ; ver="TESTING"      ; current_kernel
#	var="armv7"      ; ver="EXPERIMENTAL" ; current_kernel

	git_msg="4.19.x-bone-rt"
	var="bone-rt"    ; ver="LTS419" ; current_kernel

	git_msg="5.8.x-bone"
	var="omap-psp"   ; ver="STABLE" ; current_kernel
	#var="omap-psp"   ; ver="TESTING" ; current_kernel

	git_msg="4.14.x-ti"
	filter1="rt"
	filter2="rt"
	var="ti"         ; ver="LTS414"  ; current_kernel

	git_msg="4.14.x-ti-rt"
	var="ti-rt"      ; ver="LTS414"  ; current_kernel

	git_msg="4.19.x-ti"
	filter1="rt"
	filter2="rt"
	var="ti"         ; ver="LTS419"  ; current_kernel

	git_msg="4.19.x-ti-rt"
	var="ti-rt"      ; ver="LTS419"  ; current_kernel

	git_msg="5.4.x-ti"
	filter1="rt"
	filter2="rt"
	var="ti"         ; ver="LTS54"  ; current_kernel

	git_msg="5.4.x-ti-rt"
	var="ti-rt"      ; ver="LTS54"  ; current_kernel
fi
