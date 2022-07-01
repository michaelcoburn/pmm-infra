#!/bin/bash
START=${1}
END=${2}

seq=$(seq $START $END)

for i in $seq; do
	team="team"${i}
	echo $team " - " $(date)
	# Create new workspace
	terraform workspace new $team
	# team name domain
	#sed -i -e "s/team99/${team}/" terraform.tfvars
	rm terraform.tfvars
	echo "pmm_domain = \"${team}.perconatest.com\"" 	>  terraform.tfvars
	echo "owner_email = \"michael.coburn@percona.com\"" 	>> terraform.tfvars
	
	time terraform apply -parallelism=20 -auto-approve &
	sleep 10
done
