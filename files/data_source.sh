#!/bin/bash
set -eu -o pipefail

eval "$(jq -r '@sh "export ssh_user=\(.ssh_user) ssh_key=\(.ssh_key) ssh_pass=\(.ssh_pass) automate_ip=\(.automate_ip) data_script=\(.data_script)"')"

ssh-keyscan -H ${automate_ip} >> ~/.ssh/known_hosts 2>/dev/null

if [[ ! -z "${ssh_key}" ]]; then
  ssh -i ${ssh_key} ${ssh_user}@${automate_ip} "${data_script}"
else 
  if ! hash sshpass; then
    echo "must install sshpass"
    exit 1
  else
    sshpass -p ${ssh_pass} ssh ${ssh_user}@${automate_ip} "${data_script}"
  fi
fi
