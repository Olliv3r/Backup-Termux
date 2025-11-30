#!/usr/bin/env bash

interval="86400000"
count=1

function alert() {
	echo "$1 tarefas agendas."
}

for job_id in {1..3}; do
	script="/data/data/com.termux/files/home/Backup-Termux/backup_termux_0${job_id}.sh"

	termux-job-scheduler --period-ms $interval \
		--job-id $job_id \
		--script "$script" \
		--battery-not-low false \
		--persisted true

	(( job_id++ ))
	(( count++ ))
	
	alert $count
done
