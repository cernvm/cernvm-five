# CernVM 5

1. [About CernVM 5](##1.-about-cernvm-5)
2. [Building the image](##2.building-the-image)
    1. [With Docker](###with-docker)
    2. [With Podman](###with-podman)


## 1. About CernVM 5
This repository contains the source code and build scripts for the EL8-based CernVM 5 container image. 
The image is intended to be a JeOS (Just enough OS) and provides:

 - A [CernVM-File System](https://github.com/cvmfs/cvmfs) client with its minimal dependencies
 - HEP_OSlibs

For most Use Cases it is sensible to run the image with CernVM-FS either mounted from the host or from the inside of the container. 
 
 <img src="./graphics/architecture.png" title="" style="max-width: 70%;"  />
 

## 2. Building the image


### With Docker
    docker build -f docker/Dockerfile . -t cernvm:5 

### With Podman
    podman bud -t cernvm:5 -f docker/Dockerfile .  


## 3. Run the image as a container 
It is recommended to run the image with either CernVM-FS mounted from the host

    docker run -it --cap-add SYS_ADMIN -v /cvmfs:/cvmfs:ro cvm:5 bash

or with an independent CernVM-FS client inside the container

    docker run -it --device /dev/fuse --cap-add SYS_ADMIN cernvm:5 bash














