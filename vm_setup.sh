#!/bin/bash
echo ---- create zubrnet OVS bridge ----
ovs-vsctl add-br zubrnet
ip addr add 192.168.100.1/24 dev zubrnet
ip link set up zubrnet

echo ---- run dhcpd ----
dhcpd -4 -cf dhcpd.conf zubrnet

echo ---- create VMs ----

virsh create middlebox.xml
virsh create containerbox.xml
virsh create httpproxybox.xml
virsh create videoservbox.xml

echo ---- ping VMs ----
echo 192.168.100.11 middlebox.zubr >> /etc/hosts
echo 192.168.100.12 containerbox.zubr >> /etc/hosts
echo 192.168.100.13 httpproxybox.zubr >> /etc/hosts
echo 192.168.100.14 videoservbox.zubr >> /etc/hosts


sleep 10
ping -c1 middlebox.zubr
ping -c1 containerbox.zubr
ping -c1 httpproxybox.zubr
ping -c1 videoservbox.zubr

echo ---- end ----
