# CernVM 5

1. [About CernVM 5](##about-cernvm)
    1. [CernVM-FS](###CernVM-FS)
2. [Building the image](##building-the-image)
    1. [With Docker](###with-docker)
    2. [With Buildah](#bud)
3. [Running the image as a Container](##running-the-image-as-a-container)
    1. [Using Docker](###using-docker)
    2. [Using Podman](###using-podman)

<br>

---

<br>

## About CernVM 5
This repository contains the source code and build scripts for the EL8-based CernVM 5 container image. 
The image is intended to be a JeOS (Just enough OS) and provides:

 - A [CernVM-File System](https://github.com/cvmfs/cvmfs) client with its minimal dependencies
 - HEP_OSlibs

### CernVM-FS
For most Use Cases it is sensible to run the image with CernVM-FS either mounted from the host or from the inside of the container. 

 - The repository cernvm-five.cern.ch provides common **User Applications** like editors, browsers or cloud tools. It features a Gentoo Prefix to isolate the installed applications from either local or other libraries installed on CernVM-FS
 - Other repositories with **Scientific Applications** can be mounted as usual.
  
 <img src="./graphics/architecture.png" title="CernVM Layout" style="max-width: 70%;"  />

> **_NOTE:_**  User Applications don't use LD_LIBRARY_PATH and therefore can be run in parallel to other applications from other repositories safely.

<br>
 
---

<br>

## Building the image


### With Docker 
    docker build -f docker/Dockerfile . -t cernvm:5 

### With [Buildah](https://buildah.io/) in for e.g. [in a build container](https://github.com/containers/buildah) 

    buildah bud -t cernvm:5 -f docker/Dockerfile .  

<br>

---

<br>

## Running the image as a container 
It is recommended to run the image with either CernVM-FS mounted from the host  
### Using Docker

    docker run -it --cap-add SYS_ADMIN -v /cvmfs:/cvmfs:ro cvm:5 bash

or with an independent CernVM-FS client inside the container

    docker run -it --device /dev/fuse --cap-add SYS_ADMIN cernvm:5 bash
<br>

### Using Podman  

    podman run -it --cap-add SYS_ADMIN -v /cvmfs:/cvmfs:ro cvm:5 bash

or with an independent CernVM-FS client inside the container

    podman run -it --device /dev/fuse --cap-add SYS_ADMIN cernvm:5 bash


---











 