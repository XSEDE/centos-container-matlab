FROM centos:7

################## METADATA ######################

LABEL base_image="centos:7"
LABEL version="1.0.0"
LABEL software="Matlab"
LABEL software.version="R2018a"
LABEL about.summary="Matlab R2018a installed on top of CentOS 7"
LABEL about.home="https://github.com/XSEDE/centos-container-matlab"
LABEL about.documentation="https://github.com/XSEDE/centos-container-matlab"
LABEL about.license_file="https://github.com/XSEDE/centos-container-matlab"
LABEL about.license="MIT"
LABEL about.tags="example-container" 
LABEL extra.binaries="matlab"
LABEL authors="XCRI <help@xsede.org>"

################## ENVIRONMENT ######################

RUN mkdir /opt/mcr && \
yum install wget unzip libXmu -y && \
mkdir /mcr-install && \
cd /mcr-install && \
wget https://ssd.mathworks.com/supportfiles/downloads/R2018a/deployment_files/R2018a/installers/glnxa64/MCR_R2018a_glnxa64_installer.zip && \
unzip MCR_R2018a_glnxa64_installer.zip && \
./install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr && \
rm -Rf /mcr-install

ENV LD_LIBRARY_PATH=/opt/mcr/v94/runtime/glnxa64:/opt/mcr/v94/bin/glnxa64:/opt/mcr/v94/sys/os/glnxa64:/opt/mcr/v94/extern/bin/glnxa64
ENV XAPPLRESDIR=/usr/share/X11/app-defaults

ADD mdimensionalArray /mdimensionalArray
RUN chmod +x mdimensionalArray

# initiate environment
RUN $NIXENV && \
    cd /tmp && \
    bash /root/persist-env.sh /root/prod-env.nix

 Prep dev environment ahead of time
RUN nix-shell /root/dev.nix
