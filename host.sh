#!/bin/bash


ANSIBLE_PLAYBOOK=$1
ANSIBLE_HOSTS=$2
PROVISION_DIR=$3
SETUP_ARGS="${@:4}"

TEMP_HOSTS="/tmp/ansible_hosts"

echo $PROVISION_DIR
if [ ! -f $PROVISION_DIR/$ANSIBLE_PLAYBOOK ]; then
  echo "Cannot find Ansible playbook."
  exit 1
fi

if [ ! -f $PROVISION_DIR/$ANSIBLE_HOSTS ]; then
  echo "Cannot find Ansible hosts."
  exit 2
fi

# Install Ansible and its dependencies if it's not installed already.
if [ ! -f /usr/bin/ansible ]; then

 echo "Installing Ansible dependencies and Git."
 yum install epel-release git -y 
 yum install ansible -y
fi

cp $PROVISION_DIR/${ANSIBLE_HOSTS} ${TEMP_HOSTS} && chmod -x ${TEMP_HOSTS}
echo "Running Ansible provisioner defined in Vagrantfile."
ansible-playbook $PROVISION_DIR/${ANSIBLE_PLAYBOOK} --inventory-file=${TEMP_HOSTS} --extra-vars "${SETUP_ARGS}" --connection=local

rm ${TEMP_HOSTS}