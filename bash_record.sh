#!/bin/bash
# bash_record - https://github.com/magikarp-salesman/bash-record

function record_() {
	if [ -z "$1" ]; then
		filename='new_record.script'
	else
		filename="$1.script"
	fi
	timing_file=`mktemp`
	script_file=`mktemp`
	fast_timing_file=`mktemp`
	script -t $script_file 2> $timing_file
	# FAST RECORD
	while read line; do
		var1=${line%\ *}
		var2=${line#*\ }
		max=10
		numeric=${var1%\.*}
		numeric=$(( numeric ))
		if [ $numeric -gt $max ]; then
			var1="10"
		fi
		printf "%s %s\n" "$var1" "$var2" >> $fast_timing_file
	done < $timing_file 
	timing_64=`cat $timing_file | gzip -cn9 | base64 -w 0`
	script_64=`cat $script_file | gzip -cn9 | base64 -w 0`
	fast_timing_64=`cat $fast_timing_file | gzip -cn9 | base64 -w 0`
	template=$(cat <<'END_OF_DOCUMENT'
#!/bin/bash
# script replay file created with: https://github.com/magikarp-salesman/bash-record
set -e
function command_exists(){
	command -v $1 1>/dev/null || ( echo "$1 not found" ; exit 1 )
}
command_exists mktemp
command_exists base64
command_exists gzip
command_exists script
command_exists scriptreplay
timing_file=`mktemp`
script_file=`mktemp`
fast_timing_file=`mktemp`
YELLOW_BG='\033[43m'
BLACK='\033[30m'
RESET='\033[0m'
echo '%s' | base64 -d --ignore-garbage | gzip -cd > $timing_file
echo '%s' | base64 -d --ignore-garbage | gzip -cd > $script_file
echo '%s' | base64 -d --ignore-garbage | gzip -cd > $fast_timing_file
scriptreplay $fast_timing_file $script_file $@
echo -e "${YELLOW_BG}${BLACK} end of script ${RESET}"
rm $timing_file $script_file $fast_timing_file
exit 0

END_OF_DOCUMENT
	)
	printf "$template" $timing_64 $script_64 $fast_timing_64 > $filename
	rm $timing_file $script_file $fast_timing_file
}

# vim: ts=2 sw=4 noexpandtab foldenable foldmethod=indent ff=unix filetype=sh nowrap :
