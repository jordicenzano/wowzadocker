#Install wowza licence
if [ -n "${WOWZA_KEY}" ]; then
  echo "Installing Wowza Streaming Engine license..."
  rm -f /usr/local/WowzaStreamingEngine/conf/Server.license
  echo "${WOWZA_KEY}" > /usr/local/WowzaStreamingEngine/conf/Server.license
else
  echo "No wowza key found!!!!"
fi

# start supervisord
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf