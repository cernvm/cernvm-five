### This file is part of CernVM 5.
### CernVM 5 with start-up logic ###
### This Dockerfile is derived from the Cvm5 baselayer and adds some startup scripts to auto-mount cvmfs
### on startup.
FROM cvm-five:baselayer 
ENV REFRESHED_AT=08/10/2021
LABEL LABEL MAINTAINER="Jakob Eberhardt jakob.karl.eberhardt@cern.ch, Jakob Blomer jblomer@cern.ch" \
      io.k8s.display-name="CernVM 5 Boot" \
      io.k8s.description="A dockerimage providing cvmfs and HEP_OSlibs and boot logic" 
ENV BOOT_SCRIPTS=/init \
    HOME=/
WORKDIR $HOME
COPY system/boot/ $BOOT_SCRIPTS
COPY system/common/ $BOOT_SCRIPTS
ENTRYPOINT [ "bash", "/init/start.sh" ]
CMD [ "--wait" ]

