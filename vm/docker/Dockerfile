### This file is part of CernVM 5. ### 
### Dockerfile used to build root-filesystem for CernVM5
### Use for e. g. docker build -f docker/Dockerfile . --build-arg BASE="my_image"
ARG BASE=registry.cern.ch/cernvm/five/cernvm-five:latest
FROM $BASE
USER root

RUN dnf -y update && dnf -y clean all

### Installing cernvm-kernel-default meta-package
RUN dnf install -y http://ecsft.cern.ch/dist/cernvm/five/rpms/latest/cernvm-kernel-default-latest-noarch.rpm
    
RUN systemctl enable NetworkManager && \
    systemctl unmask systemd-remount-fs.service && \
    systemctl unmask getty.target

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    systemctl enable dbus.service && \
    systemctl set-default graphical.target

RUN echo "NETWORKING=yes" >> /etc/sysconfig/network && \
    echo -e 'DEVICE="eth0"\nONBOOT="yes"\nBOOTPROTO="dhcp"\n' > /etc/sysconfig/network-scripts/ifcfg-eth0

RUN dracut --no-hostonly --regenerate-all --force && \
    cd /boot && \
    ln -s $(find . -name 'vmlinuz-*') vmlinuz && \
    ln -s $(find . -name 'initramfs-*.img') initrd.img

RUN rpm -e selinux-policy-minimum selinux-policy --nodeps
RUN rm -rf /etc/selinux/targeted /etc/selinux/config

# TODO: Remove once cloud-init is implemented
RUN echo "root:root" | chpasswd