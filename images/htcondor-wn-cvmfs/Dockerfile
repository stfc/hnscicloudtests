FROM centos:6

# Dependencies
RUN yum -y install wget

# Install yum repository
RUN cd /etc/yum.repos.d && wget http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel6.repo

# Import signing key
RUN wget http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && rpm --import RPM-GPG-KEY-HTCondor

# Install HTCondor
RUN yum -y install condor

# EPEL
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# Install HEP_OSlibs
RUN yum -y install http://linuxsoft.cern.ch/wlcg/sl6/x86_64/HEP_OSlibs_SL6-1.0.20-0.el6.x86_64.rpm

# Install CVMFS
RUN yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el6.noarch.rpm  && \
    yum -y install cvmfs

# Setup CVMFS
COPY default.local /etc/cvmfs/
RUN mkdir -p /cvmfs/grid.cern.ch /cvmfs/cms.cern.ch /cvmfs/config-egi.egi.eu

# CA
RUN cd /etc/yum.repos.d && wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo
RUN yum -y install ca-policy-egi-core

# Add dedicated CA
COPY root-ca.crt /etc/grid-security/certificates/.
COPY root-ca.signing_policy /etc/grid-security/certificates/.
RUN ln -s /etc/grid-security/certificates/root-ca.crt /etc/grid-security/certificates/b43d3874.0
RUN ln -s /etc/grid-security/certificates/root-ca.signing_policy /etc/grid-security/certificates/b43d3874.signing_policy

# HTCondor slot users
RUN useradd user01 ; useradd user02 ; useradd user03 ; useradd user04 ; useradd user05 ; useradd user06 ; useradd user07 ; useradd user08

# CMS
RUN echo "export CMS_LOCAL_SITE=T3_UK_GridPP_Cloud" > /etc/cvmfs/config.d/cms.cern.ch.local

# Entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN echo "DISCARD_SESSION_KEYRING_ON_STARTUP = False" > /etc/condor/config.d/docker
