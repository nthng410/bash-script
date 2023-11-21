#!/bin/bash

#---SETTINGS SECTION---
	#Set maximum number of log files
	max_logs=4

	#Set path for you logs - directory needs to be present and writable / TO DO: add directory cheack to this
	log_path=./

	#Set your log file name
	log_name=paste-log-file-name-here

	#Set you log file extention
	file_ext=.log
	#Select command to log
	log_com=nmap

	#Select command options
	log_com_options="-sS -O" 

	#Select command arguments
	log_com_arg="192.168.69.2"

#---END OF SETTINGS SECTION---

#---SETTING SCRIPTS VAR---
log_name_path=${log_path}${log_name}
log_name_path_zero=${log_path}${log_name}-0

# TO DO - check if "which" is avalueable, if not install it or stop the script.
# Checking for full command path
command=$(which $log_com)

#---SETTINGS SCRIPTS VAR END---

function rotate_files {
#Rotate existing log files, 0 is the newest, max_log-1 is oldest
	local max_logs=$1
	local log_name_path=$2
	local file_ext=$3
	for ((i=max_logs-1; i>=0; i--)); do
	    if [ -e "${log_name_path}-$i${file_ext}" ]; then
		next_log=$((i+1))
		mv "${log_name_path}-$i${file_ext}" "${log_name_path}-$next_log${file_ext}"
	    fi
  done

	if [ -e "${log_name_path}-$max_logs${file_ext}" ]; then
		rm "${log_name_path}-$max_logs${file_ext}"
	fi
}

function loging {
# Things to log.
	local to_exec=""
	local path_separator=0
	local i=""
	local path=""
	#Concatinatio for loop	
	for i in "$@"
	do
		if [ "$i" = "---" ]; then
			path_separator=1
		continue
		fi
	
		if [ $path_separator -eq 0 ]; then
			to_exec+="$i "
		else
			path+="$i"
		fi
	done
	
	#execute command
	$to_exec > $path

# End things to log
}

# Run ---
rotate_files $max_logs $log_name_path $file_ext
loging $log_com $log_com_options $log_com_arg --- $log_name_path_zero $file_ext

echo "Done!"
