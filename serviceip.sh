localip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
nginxIp=$(cat global/ip)

add_hosts() {
  checkHost=$(cat /sites/$1/.hosts/hosts |grep $1.$2.ept-dev.net |awk '{print $1}')
  if [ "$checkHost" == "" ]; then
  echo "$localip $1.$2.ept-dev.net" >> /sites/$1/.hosts/hosts
  fi
}
add_cron () {
    shopt -s nullglob dotglob

    for pathname in "$2"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            pathReplace=$(echo $pathname | sed "s/\/$1//g")
            docker exec $1 sh -c "crontab $pathReplace"
        fi
    done
}

mkdir /sites/$2/.hosts -p
touch /sites/$2/.hosts/hosts
mkdir /sites/$2/cron.d
touch /sites/$2/cron.d/cronlist

docker run --privileged \
        -p $1:22 \
        --name="$2" \
        -d -e "PASSWORD=$3" \
        -v /sites/$2:/sites \
        -v /sites/$2/.nvm:/root/.nvm \
        -v /sites/$2/cron.d:/etc/cron.d \
        -v /sites/$2/.hosts/hosts:/etc/hosts \
        -v /sites/$2/.configs:/root/.configs \
        -v /root/.docker-environment/etc/nginx/$2:/usr/local/nginx \
        -v /root/.docker-environment/httpd/sites-enabled/$2:/usr/local/httpd \
        --network lemp_net hakanbaysal/devenv:latest

sleep 5

ips=$(docker container inspect  $(docker ps --format '{{.Names}} {{.Image}}' |grep devenv |awk '{print $1}') --format '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | sed 's#^/##')
echo "" > /root/.docker-environment/etc/nginx/docker_service_ip.conf
echo "map \$username \$serviceip {" >> /root/.docker-environment/etc/nginx/docker_service_ip.conf
while IFS= read -r line; do
   echo "$line;" >> /root/.docker-environment/etc/nginx/docker_service_ip.conf
done <<< "$ips"
echo "}" >> /root/.docker-environment/etc/nginx/docker_service_ip.conf

sleep 2

docker exec $2 sh -c "echo $2 > /root/.username"

docker exec $2 sh -c "echo '[credential]
	helper = store --file /root/.configs/.git-credential' > /root/.gitconfig"

add_cron $2 "/sites/$2/cron.d"

add_hosts $2 "epa-api"
add_hosts $2 "payment"
add_hosts $2 "fe"
add_hosts $2 "evo-api"
add_hosts $2 "order"
add_hosts $2 "hgs-api"
add_hosts $2 "admin"
add_hosts $2 "evo"

docker exec -it nginx sh -c "nginx -s reload"
docker exec -it httpd sh -c "apache2ctl restart"

docker exec -it $2 sh -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && . /root/.nvm/nvm.sh"
