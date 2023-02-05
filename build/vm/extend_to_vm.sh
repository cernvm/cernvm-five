#!/bin/bash 
set -e
### This file is part of CernVM 5. ###
### Script to extend CernVM 5 container / image to full virtual machine image.
### Runs in CernVM 5 VM build container
### docker run --privileged --rm --device $(losetup -f) --device /dev/mapper --device /dev/fuse -v ~/rootfs/:/rootfs/:Z -v ~/dest:/dest:Z -it localhost/vmbuilder bash extend_to_vm.sh $ROOTFS_TAR $TAG
### $1: Path to rootfs
### $2: Tag

# Expected location of CernVM 5 root file system
ROOTFS_TAR=$1
if [[ -z $ROOTFS_TAR ]]; then
  ROOTFS_TAR="rootfs.tar"
else 
  ROOTFS_TAR=$(basename $1)
fi
ROOTFS="/rootfs/${ROOTFS_TAR}"

# Buffered disk
DISK="/cernvm"
SIZE="2G"
BLOCK="${DISK}.raw"
OUTPUT_FILE_NAME=$2
if [[ -z $OUTPUT_FILE_NAME ]]; then
  OUTPUT_FILE_NAME="${DISK}-$(uname -m).raw"
fi

# Shared directory with host. Image output directory
HOST="/dest"

# Scratch directory
BUILD_DIR="/build"

# Logger
log() {
  echo '['$(date +"%D %T %z")']' $1 # | tee -a $logfile
}

# Write empty block
allocate() {
  log "Writing block (${BLOCK} of size ${SIZE}"
  fallocate -l $SIZE $BLOCK
  return $?
}

# Creates new (n) primary (p) partition 1 (1) and flags it as bootable (a)
partition_block() {
  log "Creating bootable primary partition (1,p) in ${BLOCK}"
  (
  echo n 
  echo p 
  echo 1 
  echo   
  echo   
  echo a
  echo w 
  ) | fdisk $BLOCK
  return $?
}

# Attaches block to free loop device
attach_loop() {
  log "Attaching ${BLOCK} to $(losetup -f)"
  BLOCK_ROOT=$(losetup --show -f ${BLOCK})
  return $?
}

# Adds partition mappings
add_mappings() {
  log "Adding partition mappings to ${BLOCK_ROOT}"
  kpartx -v -a $BLOCK_ROOT
  DEVICE=/dev/mapper/"$(basename ${BLOCK_ROOT})p1"
}

# Creates ext4 file system in $DEVICE and mounts it to $BUILD_DIR
mkfs_and_mount() {
  log "Creating ext4 fs in ${DEVICE}"
  mkfs.ext4 $DEVICE

  log "Mounting ${DEVICE} to ${BUILD_DIR}"
  mount $DEVICE ${BUILD_DIR}
  return $?
}

# Copy root fs to $BUILD_DIR
copy_rootfs() {
  log "Copying ${ROOTFS} to ${BUILD_DIR}"
  tar -xf $ROOTFS -C $BUILD_DIR
  rm -f $ROOTFS
  return $?
}

# Sets up fstab
setup_rootfs() {
  log "Setting up root file system"
  PART_UUID=$(blkid -s UUID -o value $DEVICE)
  log "UUID of partition is ${PART_UUID}"
  cat >> "${BUILD_DIR}/etc/fstab" << EOF
UUID=${PART_UUID} / ext4 errors=remount-ro 0 1
EOF
  return $?
}


# Installs extlinux bootloader into /boot of image
install_bootloader() {
  log "Installing extlinux bootloader"
  extlinux --install "${BUILD_DIR}/boot/"
  return $?
}

# Creates syslinux.cfg
create_syslinux() {
  cat <<EOF > "${BUILD_DIR}/boot/syslinux.cfg"
DEFAULT linux
  SAY Booting kernel from EXTLINUX...
 LABEL linux
  KERNEL /boot/vmlinuz
  APPEND ro root=UUID=${PART_UUID} initrd=/boot/initrd.img net.ifnames=0 console=tty0 console=ttyS0,115200n8
EOF
  return $?
}

# Unmounts $BUILD_DIR, removes mappings and detaches $BLOCK from loop
detach_image(){
  log "Unmounting ${BUILD_DIR}"
  umount $BUILD_DIR

  log "Deleting partition mappings"
  kpartx -d $DEVICE

  log "Detach disk from loop"
  losetup -d $BLOCK_ROOT

  return $?
}

# Copies Master Boot Record to BLOCK
copy_mbr() {
  log "Copying Master Boot Record"
  dd if=/usr/share/syslinux/mbr.bin of=$BLOCK bs=440 count=1 conv=notrunc
  return $?
}

copy_block_to_host() {
  log "Copying ${OUTPUT_FILE_NAME} to host"
  mv $BLOCK "${HOST}/${OUTPUT_FILE_NAME}"
  return $?
}

# Extend container image / stopped container's root file system to full VM
allocate
partition_block
attach_loop
add_mappings
mkfs_and_mount
copy_rootfs
setup_rootfs
install_bootloader
create_syslinux
detach_image
copy_mbr
copy_block_to_host