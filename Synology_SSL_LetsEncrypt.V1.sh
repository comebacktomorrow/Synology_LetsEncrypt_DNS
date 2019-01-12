#CERT_STORE=/usr/syno/etc/certificate/system/default/
CERT_STORE=/usr/syno/etc/certificate/
DOCKER_VOL=/volume1/docker/letsencrypt/certs/example.com
#NGCN is the path to a known certificate
ngcn="$DOCKER_VOL"/cert.pem
echo $ngcn
#find all cert.pem files that are older (date created) than the docker script
#where there is a cert.pem, we assume the others will follow and that all fiels will be .pem files
# -exedir runs a command .. we choose to open bash
sudo find $CERT_STORE -type f \( -name "cert.pem" -and -not -newer "$DOCKER_VOL"/cert.pem \) -execdir bash -c '

# for each file in the parent directory of this found file
#operating  from cert_store
for file in "$1" ;
do
	#find the certificate name of the file- tfcn= this found cname in cert_store
	tfcn=$(openssl x509 -subject -noout  -in ${file});
	
	#newly generated cname = the cname of cert in docker, referenced by var 3
	##note .. we cant pass the cname in directly because it contains a space
	ngcn=$(openssl x509 -subject -noout  -in $3);
	
	#we now echo the two strings
	echo “compare” $tfcn “vs” “$ngcn”;
	
	#if they match then... #running from in cert_store
	if [ "$tfcn" == "$ngcn" ];
		then
			#we now confirm they match and say what were going to do
			echo "cname match" $(sudo openssl x509 -subject -enddate -noout  -in ${file});
			echo "found out of date version.. replace";
			echo "file is in" $(pwd) " " ${file};
			
			#I have a feeling i needed to do this
			#pwd is print working directory
			#Find is run fron the cert_store .. but this isnt outting anything. I think the syntax is wrong \ useless
			pwd=$(pwd);
			
			#we turn on extended regex globbing
			#we us eval to construct the argument usning regex below
			shopt -s extglob;
			
			#we list the files in the docker directory that arent hypnennated (the most recent) that are going to be copied
			#2 refers to the dock_vol variable passed in
			eval "ls "$2"/!(*-*).pem";
			
			#we now copy them .. to the current working diretory. 
			#force overwrite. copy files, not links of files. only overwrite if copied file is newer
			eval "cp "$2"/!(*-*).pem $pwd -ufL";
			
			#turn off extended attributes
			shopt -u extglob;
			
		else 
			echo "this only runs if you have a CNAME mismatch";
			echo "youve either changed your cname or have restarted the system";
			
			#need to figure out the quote escapes for this
			uptime=awk '{print $1}' /proc/uptime
			if [$uptime < 120];
				shopt -s extglob;
				eval "cp "$2"/!(*-*).pem $pwd -ufL";
				shopt -u extglob;
			fi;
	fi;
done'

#we're passing in variables below
none {} "$DOCKER_VOL" $ngcn \;

#if the above code works we have no need for this
sudo cp -fuL $DOCKER_VOL/cert.pem $CERT_STORE/cert.pem -v
sudo cp -fuL $DOCKER_VOL/privkey.pem $CERT_STORE/privkey.pem -v
sudo cp -fuL $DOCKER_VOL/fullchain.pem $CERT_STORE/fullchain.pem -v
sudo cp -fuL $DOCKER_VOL/chain.pem $CERT_STORE/chain.pem -v

#restart should go before the done
sudo /usr/syno/etc/rc.sysv/nginx.sh reload

# $p is none
# $1 is the 'found' directory
# $2 is the DOCKER_VOL
# $3 is the $ngcn file in directory
