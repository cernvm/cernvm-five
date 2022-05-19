### This file is part of CernVM 5. ### 
### Dockerfile used to build root-filesystem for CernVM5
### Use for e. g. docker build -f docker/Dockerfile . --build-arg BASE="my_image"
ARG BASE=registry.cern.ch/cernvm/five/cernvm-five:latest
FROM $BASE
USER root

RUN dnf update -y

### Installing 
RUN dnf install -y http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-kernel-default-latest-x86_64.rpm
    
RUN systemctl enable NetworkManager && \
    systemctl unmask systemd-remount-fs.service && \
    systemctl unmask getty.target

RUN dracut --no-hostonly --regenerate-all --force && \
    cd /boot && \
    ln -s $(find . -name 'vmlinuz-*') vmlinuz && \
    ln -s $(find . -name 'initramfs-*.img') initrd.img
    
RUN rpm -e selinux-policy-minimum selinux-policy --nodeps
RUN rm -rf /etc/selinux/targeted /etc/selinux/config                           
# TODO: Use ARG
RUN echo "root:root" | chpasswd