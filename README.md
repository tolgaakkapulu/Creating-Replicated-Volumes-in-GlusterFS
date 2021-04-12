# Creating Replicated Volumes in GlusterFS

**SERVER_HOSTS, SERVES_DISKS, GFS_DIR_NAME, GFS_VOL_NAME, COMMON_PATH"** parameters in prepared scripts must be updated in accordance with the structure.

These scripts are prepared in a way that glusterfs server will be installed on **4 servers** and **2 replicas**. Server and replica information can be edited in the script and updated according to the requested structure.

### Usage - CentOS/Ubuntu
```
chmod +x glusterfs_servers_for_centos/ubuntu.sh
./glusterfs_servers_for_centos/ubuntu.sh
```
