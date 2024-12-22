#!bin/bash

#A script to run on the remote server for all the needed installation



#transferring the password from the original file
ssh_pass=$1



#checking for nipe toll and installing it if does not exist	
function remote_installion()
{
	exist_nipe=$(find -type f -name nipe.pl)
	if [ $excist_nipe ]
	then 
		cd ~/Desktop/remote/nipe
	else
		echo -e "you dont have nipe yet on the remote server,installing it on ~/Desktop/remote directory on the remote server" 
		cd ~/Desktop/remote
		echo "$ssh_pass" | sudo -S git clone https://github.com/htrgouvea/nipe >/dev/null 2>&1
		cd nipe
		echo "$ssh_pass" | sudo -S apt-get install -y cpanminus >/dev/null 2>&1
		echo "$ssh_pass" | sudo cpanm --installdeps . >/dev/null 2>&1
		echo "$ssh_pass" | sudo cpan install try::Tiny Config::Simple JSON >/dev/null 2>&1           
		echo "$ssh_pass" | sudo perl nipe.pl install >/dev/null 2>&1
		echo "finish nipe installion on the remote server" 
	fi	
}

#checking for geoip and installing it if does not exist
function geoinstall()
{	
	geo_remote=$(which geoiplookup 2>/dev/null)
    if [ -z "$geo_remote" ]
    then
        echo -e "you dont have geoip yet on the remote server,installing it on the remote server" 
        echo "$ssh_pass" | sudo -S apt-get update >/dev/null 2>&1
        echo "$ssh_pass" | sudo -S apt-get install -y geoip-bin >/dev/null 2>&1
        anony
    else 
		anony
    fi   
}

#starting nipe tool and checking if the remote server is anonymous
function anony()
{
    echo "starting nipe tool on the remote server" 
    cd ~/Desktop/remote/nipe 
	echo "$ssh_pass" | sudo -S perl nipe.pl start
	echo "$ssh_pass" | sudo -S perl nipe.pl restart
	echo "$ssh_pass" | sudo -S perl nipe.pl status
	new_remote_ip=$(echo "$ssh_pass" | sudo -S perl nipe.pl status | grep -i "ip" | awk '{print$(NF)}')
	new_remote_country=$(geoiplookup $new_remote_ip | grep -i "Country" | awk '{print$(NF)}')
	if [ "$new_remote_country" == "Israel" ]
	then
		echo -e "THE REMOTE SERVER IS NOT ANONYMOUS, EXITING"  
		exit
	else
		echo -e "the remote server is now anonymous, working from $new_remote_country" 
	fi	     
}	

#calling the functions
remote_installion
geoinstall



# michal koren
# student code: s10
# unit: TMagen773632
# lecturer`s name : erel
