###########################################################
# Dockerfile that builds a L4D2 Gameserver
###########################################################
FROM cm2network/steamcmd:root

#LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 222860
ENV STEAMAPP l4d2
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV DLURL https://github.com/MoeVsMachine/l4d2-server

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
        # Add entry script
        && wget "${DLURL}/master/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
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

#ENV SRCDS_FPSMAX=300 \
#       SRCDS_TICKRATE=66 \
#       SRCDS_PORT=27015 \
#       SRCDS_TV_PORT=27020 \
#   SRCDS_NET_PUBLIC_ADDRESS="0" \
#   SRCDS_IP="0" \
#       SRCDS_MAXPLAYERS=16 \
#       SRCDS_TOKEN=0 \
#       SRCDS_RCONPW="changeme" \
#       SRCDS_PW="changeme" \
#       SRCDS_STARTMAP="ctf_2fort" \
#       SRCDS_REGION=3 \
#   SRCDS_HOSTNAME="New \"${STEAMAPP}\" Server" \
#   SRCDS_WORKSHOP_START_MAP=0 \
#   SRCDS_HOST_WORKSHOP_COLLECTION=0 \
#   SRCDS_WORKSHOP_AUTHKEY=""

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27015/tcp \
        27015/udp \
        27020/udp
