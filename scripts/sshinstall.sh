# configure supervisord to start ssh 
cat > /etc/supervisor/conf.d/sshd.conf <<EOF
[program:sshd]
priority=20
directory=/usr/sbin
command=/usr/sbin/sshd -D
user=root
autostart=true
autorestart=true
stdout_logfile=/var/log/sshd/supervisor/%(program_name)s.log
stderr_logfile=/var/log/sshd/supervisor/%(program_name)s.log
EOF
#Necessary dir for sshd
mkdir /var/run/sshd

#Create logs dir 
mkdir -m 0755 -p /var/log/sshd/supervisor
chown -R root:root /var/log/sshd/supervisor