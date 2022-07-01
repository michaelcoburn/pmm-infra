#!/bin/bash
START=${1}
END=${2}

seq=$(seq $START $END)

for i in $seq; do
	team="team"${i}
	echo $team " - " $(date)
	# Switch to workspace
	terraform workspace select $team
	time terraform destroy -auto-approve &
	sleep 10
done

date
terraform workspace select default
for i in $seq; do
	team="team"${i}
        echo $team " - " $(date)
        # Delete workspace
        terraform workspace delete $team
done
