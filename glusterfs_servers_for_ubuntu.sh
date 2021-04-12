#!/bin/bash

SERVER_HOSTS=("server1" "server2" "server3" "server4")
SERVES_DISKS="/dev/sdb1"

GFS_DIR_NAME="glusterfs"
GFS_VOL_NAME="gvol0"

COMMON_PATH="/data"

for SERVER_HOST in "${SERVER_HOSTS[@]}"
do
	ssh $SERVER_HOST apt-get install -y --force-yes glusterfs-server
	ssh $SERVER_HOST systemctl enable glusterd
	ssh $SERVER_HOST systemctl start glusterd
	
	ssh $SERVER_HOST mkdir /$GFS_DIR_NAME
	echo "$SERVES_DISKS /$GFS_DIR_NAME ext4 defaults 1 2"| ssh $SERVER_HOST "cat >> /etc/fstab"
	ssh $SERVER_HOST mount /$GFS_DIR_NAME
	ssh $SERVER_HOST mkdir -p /$GFS_DIR_NAME/$GFS_VOL_NAME
done

for SERVER_HOST in "${SERVER_HOSTS[@]}"
do
	gluster peer probe $SERVER_HOST
done

echo "y" | gluster volume create $GFS_VOL_NAME replica 2 ${SERVER_HOSTS[0]}:/$GFS_DIR_NAME/$GFS_VOL_NAME ${SERVER_HOSTS[1]}:/$GFS_DIR_NAME/$GFS_VOL_NAME ${SERVER_HOSTS[2]}:/$GFS_DIR_NAME/$GFS_VOL_NAME ${SERVER_HOSTS[3]}:/$GFS_DIR_NAME/$GFS_VOL_NAME
gluster volume start $GFS_VOL_NAME
gluster volume status
gluster volume set $GFS_VOL_NAME network.ping-timeout "5"

for SERVER_HOST in "${SERVER_HOSTS[@]}"
do
	ssh $SERVER_HOST mkdir $COMMON_PATH
	echo "$SERVER_HOST:/$GFS_VOL_NAME $COMMON_PATH $GFS_DIR_NAME defaults,_netdev 0 0" | ssh $SERVER_HOST "cat >> /etc/fstab"
	ssh $SERVER_HOST mount $COMMON_PATH
done
