#!/bin/bash

# Generate configuration
while IFS='=' read -r -d '' n v; do
    if [[ $n == *'CONDOR'* ]]; then
        name=`echo $n | sed -e "s/^CONDOR_//"`
        echo Writing $name to config
        echo $name = $v >> /etc/condor/config.d/docker
    fi
done < <(env -0)

# Prepare for CVMFS
rm -f /dev/fuse
mknod -m 666 /dev/fuse c 10 229

# CVMFS
mount -t cvmfs config-egi.egi.eu /cvmfs/config-egi.egi.eu
mount -t cvmfs grid.cern.ch /cvmfs/grid.cern.ch
mount -t cvmfs cms.cern.ch /cvmfs/cms.cern.ch

# Run HTCondor
/usr/sbin/condor_master -f
