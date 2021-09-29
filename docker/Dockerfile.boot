### CernVM 5 with start-up logic ###
FROM cvm-five:baselayer  
ENV BOOT_SCRIPTS=/init \
    HOME=/
WORKDIR $HOME
COPY system/boot/ $BOOT_SCRIPTS
COPY system/common/ $BOOT_SCRIPTS
ENTRYPOINT [ "bash", "/init/start.sh" ]
CMD [ "--wait" ]

