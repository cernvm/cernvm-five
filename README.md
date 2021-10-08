# cernvm-five

This repository contains the source code and build scripts for the EL8-based CernVM 5 container image. 
The **baselayer image** is intended to be a JeOS (Just enough OS) and provides:

 - A CernVM Filesystem client with its minimal dependencies
 - HEP_OSlibs
 
The baselayer can be run as a container or act as a base image to derive from.