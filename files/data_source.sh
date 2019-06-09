#!/bin/bash
set -eu -o pipefail

export ssh_user
export ssh_key
export ssh_pass
export automate_ip
export data_script


ssh-keyscan -H ${automate_ip} >> ~/.ssh/known_hosts 2>/dev/null

if [[ ! -z "${ssh_key}" ]]; then
  ssh -i ${ssh_key} ${ssh_user}@${automate_ip} "${data_script}"
else 
  if ! hash sshpass; then
    echo "must install sshpass"
    exit 1
  else
    ssh -i ${ssh_key} ${ssh_user}@${automate_ip} "${data_script}"
    sshpass -p ${ssh_pass} ssh ${ssh_user}@${automate_ip} "${data_script}"
  fi
fi
