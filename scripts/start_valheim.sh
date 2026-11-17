#!/bin/bash
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

echo "Starting server PRESS CTRL-C to exit"

./valheim_server.x86_64 -name "MON_SERVEUR_VALHEIM" -port 2456 -world "Dedicated" -password "MOT_DE_PASSE_SECURISE" -modifier portals casual

export LD_LIBRARY_PATH=$templdpath
