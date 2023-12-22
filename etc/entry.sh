#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				+quit

cd "${STEAMAPPDIR}"

bash "${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
                        -steam_dir "${STEAMCMDDIR}" \
                        -steamcmd_script "${HOMEDIR}/${STEAMAPP}_update.txt" \
                        -port "${SRCDS_PORT}" \
                        +clientport "${SRCDS_CLIENT_PORT}" \
                        -maxplayers "${SRCDS_MAXPLAYERS}" \
                        -ip "${SRCDS_IP}" \
                        +exec "${SRCDS_CFG}" \
			            +map "${SRCDS_STARTMAP}" \
                        -high \
                        -tickrate 100 \
                        -strictportbind