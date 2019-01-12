#this is a bit of a hack
#you could probably just use this script as a simple replacement to the other more complicated one

CERT_PATH=/usr/syno/etc/certificate/system/default
VOL_PATH=/volume1/docker/letsencrypt/certs/example.com

cp -rfL $VOL_PATH/cert.pem $CERT_PATH/cert.pem
cp -rfL $VOL_PATH/privkey.pem $CERT_PATH/privkey.pem
cp -rfL $VOL_PATH/fullchain.pem $CERT_PATH/fullchain.pem
cp -rfL $VOL_PATH/chain.pem $CERT_PATH/chain.pem

sudo /usr/syno/etc/rc.sysv/nginx.sh reload
