#!/usr/bin/env bash

set -euo pipefail

TIME_FILE=${TIME_FILE:-${HOME}/.hours.timeclock}

function usage {
	scriptName="$(basename ${0})"
	cat <<EOF
Usage: ${scriptName} [COMMAND] [ARGS]
Track time

i|in                "Time in" to begin a task. Args: [optional date] [task project] [optional task description] 
o|out               "Time out" to end a task. Args: [optional date]
s|stat|t|tail       Show the end of the timeclock file. Args: [optional n lines]
b|bal               Show daily balances.
n|sw|next|switch    End (time out of) the current task, and begin the next.
                    task. New task name is the next arg.
e|edit              Edit the timeclock file with \${EDITOR}.
t|tail              Show the last 10 lines of the ledger

EOF

}

if [[ $# == 0 ]]; then
	usage
	exit 0
fi

function time_in {
	local time=$(date '+%Y-%m-%d %H:%M:%S')
	local activity="${@}"
	if [[ "${1}" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
		time="$(date '+%Y-%m-%d') ${1}:00"
		activity="${@:2}"
	fi
	#
	# Split the activity into:
	#
	#   - the project: anything before the first whitespace(s)
	#     whitespace-containing project name aren't supported.
	#     (maps to the hledger transaction virtual account)
	#
	#   - the project task: anything following the first whitespace(s)
	#     (maps to the hledger transaction description)
	#
	local project_task=$(echo "${activity}" | sed -E "s/[[:blank:]]+/  /")
	echo "Begin ${project_task} at ${time}"
	echo "i ${time} ${project_task}" >> $TIME_FILE
}

function time_out {
	local time=$(date '+%Y-%m-%d %H:%M:%S')
	if [[ "${1:-}" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
		time="$(date '+%Y-%m-%d') ${1}:00"
	fi
	echo "End at $time"
	echo "o $time" >> $TIME_FILE
}

function tail_file {
	local n=10
	if [[ $# -gt 0 ]]; then
		n=$1
	fi
	tail -n $n $TIME_FILE
}

case $1 in
	i|in)
		shift
		time_in $*
		;;
	o|out)
		shift
		time_out $*
		;;
	s|stat|t|tail)
		shift
		tail_file $*
		;;
	b|bal)
		hledger -f $TIME_FILE bal
		;;
	d|daily)
		hledger -f $TIME_FILE -p "daily this week" bal
		;;
	w|weekly)
		hledger -f $TIME_FILE -p "weekly this month" bal
		;;
	q|quarterly)
		hledger -f $TIME_FILE -p "quarterly this year" bal
		;;
	n|sw|next|switch)
		shift
		time_out $* && time_in $*
		;;
	e|edit)
		$EDITOR $TIME_FILE
		;;
	*)
		echo "Unknown command ${1}"
		usage
		exit 1
		;;
esac

