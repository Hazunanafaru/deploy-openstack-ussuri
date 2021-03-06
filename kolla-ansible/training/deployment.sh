#!/bin/bash
cd ~/workspace
ansible all -i multinode -m ping
kolla-ansible -i multinode bootstrap-servers
kolla-ansible -i multinode prechecks
kolla-ansible -i multinode deploy
kolla-ansible -i multinode post-deploy

# Install OpenStack client
pip install python-openstackclient

# Verify OpenStack
source /etc/kolla/admin-openrc.sh
openstack hypervisor list

# Turn up br-ex
for i in controller compute; do
	ssh $i ip link set br-ex up
done