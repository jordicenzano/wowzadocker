#Fisrt parameter is the image ID/name
if [ "$#" -ne 1 ]
then
  echo "Usage: startcontainer.sh CONTAINER_ID/NAME"
  exit 1
fi

WOWZA_KEY=$(cat creds/wowzalicense)
#With --rm all modification to the container files are deleted when exit
docker run --name='wowzatest_container' -it -e "WOWZA_KEY=${WOWZA_KEY}" -p 2222:22 -p 1935:1935 -p 8086:8086 -p 8087:8087 -p 8088:8088 $1
