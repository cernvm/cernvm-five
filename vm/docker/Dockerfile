### This file is part of CernVM 5. ### 
### Dockerfile used to build root-filesystem for CernVM5
FROM registry.cern.ch/cernvm/five/cernvm-five:latest
USER root

RUN dnf update -y

# TODO: Use meta-rpm
RUN dnf install -y kernel-core  \
systemd         \
NetworkManager  \
e2fsprogs       \
sudo 
    
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