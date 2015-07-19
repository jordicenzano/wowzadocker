#!/bin/bash

#From https://github.com/sameersbn/docker-wowza/blob/master/assets/install
set -e

#Exit if wowza is already installed if wowza is in the system,
if [ -d "/usr/local/WowzaStreamingEngine" ]; then
    exit
fi

WOWZA_INSTALLER_URL="http://www.wowza.com/downloads/WowzaStreamingEngine-4-2-0/WowzaStreamingEngine-4.2.0-linux-x64-installer.run"

# download wowza installer
wget "${WOWZA_INSTALLER_URL}" -O WowzaStreamingEngine.run

#If we sign a contract with wowza they provide us with silent installation method
#http://www.wowza.com/forums/showthread.php?7973-Silent-Installation

# install wowza streaming engine
chmod +x WowzaStreamingEngine.run
./WowzaStreamingEngine.run

# remove installer
rm -rf WowzaStreamingEngine.run 

# configure supervisord to start wowza streaming engine
cat > /etc/supervisor/conf.d/wowza.conf <<EOF
[program:wowza]
priority=10
directory=/usr/local/WowzaStreamingEngine/bin
command=/usr/local/WowzaStreamingEngine/bin/startup.sh
user=root
autostart=true
autorestart=true
stdout_logfile=/var/log/wowza/supervisor/%(program_name)s.log
stderr_logfile=/var/log/wowza/supervisor/%(program_name)s.log
EOF

# configure supervisord to start wowza streaming engine manager
cat > /etc/supervisor/conf.d/wowzamgr.conf <<EOF
[program:wowzamgr]
priority=20
directory=/usr/local/WowzaStreamingEngine/manager/bin
command=/usr/local/WowzaStreamingEngine/manager/bin/startmgr.sh
user=root
autostart=true
autorestart=true
stdout_logfile=/var/log/wowza/supervisor/%(program_name)s.log
stderr_logfile=/var/log/wowza/supervisor/%(program_name)s.log
EOF