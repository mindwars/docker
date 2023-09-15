ips=$(docker container inspect  $(docker ps -a --format '{{.Names}} {{.Image}}' |grep devenv |awk '{print $1}') --format '{{.Name}}' | sed 's#^/##')

commands=()
while IFS= read -r username; do
   password_cmd=$(docker container inspect $username --format='{{index (index (.Config.Env)) 0 }}')
   IFS='='
   read -a strarr <<< "$password_cmd"
   password=${strarr[1]}

   port=$(docker container inspect $username --format '{{ (index (index .HostConfig.PortBindings "22/tcp") 0).HostPort }}')
   commands+=("docker rm $username -f")
   commands+=("bash /root/.docker-environment/serviceip.sh $port $username $password")
done <<< "$ips"

docker pull hakanbaysal/devenv:latest

for command in "${commands[@]}"
do
  eval $command
done
