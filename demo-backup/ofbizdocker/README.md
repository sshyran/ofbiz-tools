# Docker deployments of OFBiz

As part of OFBIZ-12757, OFBIZ-12786 and OFBIZ-12798, docker deployments are being carried on VM ofbiz-vm1.apache.org for the
demo-trunk and demo-next sites.

Work under OFBIZ-12757 also created 3 experimental sites:
* exp1.ofbiz.apache.org
* exp2.ofbiz.apache.org
* exp3.ofbiz.apache.org

These sites may be disabled at any time, but the hostnames will be left configured to enable rapid experimentation with 
demo sites in the future.

Files in this subdirectory of the ofbiz-tools repository reflect files which should be created on the root filesystem of ofbiz-vm1.apache.org with the following additions and/or settings:
* /etc/cron.d/ofbizdocker
  * Owned by root with permissions 0644
* /home/ofbizdocker/pull-and-restart.sh
  * Owned by ofbizdocker user with permissions 0755
* /home/ofbizdocker/ofbiz-framework
  * Git clone of https://github.com/apache/ofbiz-framework with the experimental-docker branch checked otu.


## How do the Docker deployments work

At 02:35h UTC each day, the cronttab defined by `/etc/cron.d/ofbizdocker` will execute script `pull-and-restart.sh`. 

The `pull-and-restart.sh` script does the following:
* For each directory in /home/ofbizdocker/[demo-trunk, exp*]
  * Change to the directory.
  * Run `docker compose pull` to pull the latest container images needed to support the docker compose application.
  * Run `docker compose down --volumes` to shutdown and remove any existing containers and volumes for the docker compose application.
  * Run `docker compose up -d` to start the containers for the docker compose application.

The `demo-trunk` application listens on AJP port 8009.

The `demo-next` application listens on AJP port 28009.

If in use, the `exp1` application listens on AJP port 38009, the `exp2` application listens on AJP port 48009, and the `exp3` application listens on AJP port 58009. The Apache server on ofbiz-vm1.apache.org has been configured to reverse-proxy to these applications for hostnames exp1.ofbiz.apache.org, exp2.ofbiz.apache.org and exp3.ofbiz.apache.org respectively.


## Default user namespace remapping

The docker daemon on ofbiz-vm1.apache.org has been configured to use default user namespace remapping. This means that the UIDs of processes running within containers are mapped to a range of 'high' non-existing UIDs on the host system. Since the UIDs are non-existant, processes with those UIDs will have no priviledges on the host system.

See the `dockremap` entry in file /etc/subuid to see the range of UIDs that will be used for remapping.