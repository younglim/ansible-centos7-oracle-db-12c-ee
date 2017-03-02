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

 echo "Installing VBox Guest Additions"
 yum -y install dkms wget gcc kernel-devel-3.10.0-327.4.5.el7.x86_64
 echo "Downloading VBoxGuestAdditions from virtualbox.org. This will take a while..."
 wget  -nc --tries=0 --continue --server-response --timeout=0 --retry-connrefused "http://download.virtualbox.org/virtualbox/5.1.14/VBoxGuestAdditions_5.1.14.iso" -nv -O "VBoxGuestAdditions_5.1.14.iso"
 mkdir /media/VBoxGuestAdditions
 mount -o loop,ro VBoxGuestAdditions_5.1.14.iso /media/VBoxGuestAdditions
 sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
 rm -f VBoxGuestAdditions_5.1.14.iso
 umount /media/VBoxGuestAdditions
 rmdir /media/VBoxGuestAdditions

 echo "Installing Ansible dependencies and Git."
 yum install epel-release git -y 
 yum install ansible -y
fi

cp $PROVISION_DIR/${ANSIBLE_HOSTS} ${TEMP_HOSTS} && chmod -x ${TEMP_HOSTS}
echo "Running Ansible provisioner defined in Vagrantfile."
ansible-playbook $PROVISION_DIR/${ANSIBLE_PLAYBOOK} --inventory-file=${TEMP_HOSTS} --extra-vars "${SETUP_ARGS}" --connection=local

rm ${TEMP_HOSTS}