###########################################################
# Dockerfile that builds a L4D2 Gameserver
###########################################################
FROM cm2network/steamcmd:root
ENV STEAMAPPID 222860
ENV STEAMAPP left4dead2
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
COPY entry.sh ${HOMEDIR}/entry.sh
RUN set -x \
        # Add i386 architecture
        && dpkg --add-architecture i386 \
        # Install, update & upgrade packages
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                wget \
                ca-certificates \
                lib32z1 \
                libncurses5:i386 \
                libbz2-1.0:i386 \
                libtinfo5:i386 \
                libcurl3-gnutls:i386 \
                libc6 \
                libc6-dev \
                libc6-dbg \
                autoconf \
                libtool \
                pip \
                nasm \
                libiberty-dev:i386 libelf-dev:i386 libboost-dev:i386 libbsd-dev:i386 libunwind-dev:i386 lib32z1-dev libc6-dev-i386 linux-libc-dev:i386 g++-multilib \
                curl file  bsdmainutils python3 util-linux binutils bc jq netcat lib32gcc-s1 lib32stdc++6 libcurl4-gnutls-dev:i386 \
        && mkdir -p "${STEAMAPPDIR}" \
        # Create autoupdate config
        && { \
                echo '@ShutdownOnFailedCommand 1'; \
                echo '@NoPromptForPassword 1'; \
                echo 'force_install_dir '"${STEAMAPPDIR}"''; \
                echo 'login anonymous'; \
                echo 'app_update '"${STEAMAPPID}"' validate'; \
                echo 'quit'; \
           } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
        && chmod +x "${HOMEDIR}/entry.sh" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
        # Clean up
        && rm -rf /var/lib/apt/lists/*
# Switch to user
USER ${USER}
WORKDIR ${HOMEDIR}
CMD ["bash", "entry.sh"]
# Expose ports
EXPOSE 27015/tcp \
        27015/udp \
        27020/udp
