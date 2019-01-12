#this works
CERT_STORE=/usr/syno/etc/certificate
DOCKER_VOL=/volume1/docker/letsencrypt/certs/example.com
ngcn="$DOCKER_VOL"/cert.pem
echo $ngcn
sudo find $CERT_STORE -type f \( -name "cert.pem" -and -not -newer "$DOCKER_VOL"/cert.pem \) -execdir bash -c 'for file in "$1" ; do tfcn=$(openssl x509 -subject -noout  -in ${file}); ngcn=$(openssl x509 -subject -noout  -in $3); echo “compare” $tfcn “vs” “$ngcn”; if [ "$tfcn" == "$ngcn" ]; then echo "cname match" $(sudo openssl x509 -subject -enddate -noout  -in ${file}); echo "found out of date version.. replace"; echo "file is in" $(pwd) " " ${file}; pwd=$(pwd); shopt -s extglob; eval "ls "$2"/!(*-*).pem"; eval "cp "$2"/!(*-*).pem $pwd -ufL"; shopt -u extglob; else echo "this never runs since newer flag only executes on true"; fi; done' none {} "$DOCKER_VOL" $ngcn \;

sudo cp -fuL DOCKER_VOL/cert.pem /usr/syno/etc/certificate/system/default/cert.pem -v
sudo cp -fuL DOCKER_VOL/privkey.pem /usr/syno/etc/certificate/system/default/privkey.pem -v
sudo cp -fuL DOCKER_VOL/fullchain.pem /usr/syno/etc/certificate/system/default/fullchain.pem -v
sudo cp -fuL DOCKER_VOL/chain.pem /usr/syno/etc/certificate/system/default/chain.pem -v

sudo /usr/syno/etc/rc.sysv/nginx.sh reload