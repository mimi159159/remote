#!bin/bash



Tdate=$(date)
today=$(date +"%d-%m-%Y")
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)
blue=$(tput setaf 4)

#requesting for the local system password 
figlet "welcome to my first project"
echo -e "${bold}${yellow}please enter your system password for any needed installion \n${reset}" 
read -s password
echo -e "checking for any needed installion \n" 

#creating a foler that will hold all the files that was requsted 
mkdir ~/Desktop/remote_script_files_$today
echo -e "$today \n" > ~/Desktop/remote_script_files_$today/project_log_$today.log 	


#a function for writing the log file
function log_message()
{
    echo -e "$Tdate - $1 \n" >> ~/Desktop/remote_script_files_$today/project_log_$today.log
}


#checking for nipe toll and installing it if does not exist	
function nipe_install()
{
	log_message "nipe function started"
	echo -e "checking now for the nipe tool \n" 
	excist_check=$(find -type f -name nipe.pl )
	if [ $excist_check ]
	then 
		echo -e "wow, you already have 'nipe' installed, continuing \n" 
		cd ~/Desktop/nipe
	else
		echo -e "${bold}oh you dont have nipe, installing it on ~/Desktop directory it can take a few moments \n${reset}"
		cd ~/Desktop 
		echo "$password" | sudo -S git clone https://github.com/htrgouvea/nipe >/dev/null 2>&1
		cd ~/Desktop/nipe
		echo "$password" | sudo -S apt-get install -y cpanminus >/dev/null 2>&1
		echo "$password" | sudo cpanm --installdeps . >/dev/null 2>&1
		echo "$password" | sudo cpan install try::Tiny Config::Simple JSON >/dev/null 2>&1    
		echo "$password" | sudo perl nipe.pl install >/dev/null 2>&1
		echo -e "finish nipe installion continuing to next toll \n" 
	fi
	log_message "nipe function finished"		
}

#starting nipe tool and checking if the local system is anonymous
function anonymous_check()
{
	log_message "annoymous function started"
	echo -e "${green}congratulation you now have all the needed tools \n${reset}" 
	echo -e "starting nipe tool \n" 
	echo "$password" | sudo -S perl nipe.pl start
	echo "$password" | sudo -S perl nipe.pl restart
	echo "$password" | sudo -S perl nipe.pl status
	ip=$(echo "$password" | sudo -S perl nipe.pl status | grep -i "ip" | awk '{print$(NF)}')
	country=$(geoiplookup $ip | grep -i "Country" | awk '{print$(NF)}')
	if [ "$country" == "Israel" ]
	then
		echo -e "${bold}${red}YOU ARE NOT ANONYMOUS, EXITING${reset}" 
		exit
	else
		echo -e "${bold}${green}shhhh now you are anonymous, you are now operating from $country \n${reset}" 
	fi	
	log_message "anonymous function finished"
}

#checking for geoip and installing it if does not exist
function geoip_install()
{
	log_message "geoip function started"
    echo -e "ok checking for the geoip tool \n" 
    gipl=$(which geoiplookup 2>/dev/null)
    
    if [ -z "$gipl" ]
    then
        echo -e "${bold}sorry You don't have geoip,please hold while its being installed... \n${reset}" 
        echo "$password" | sudo -S apt-get update >/dev/null 2>&1
        echo "$password" | sudo -S apt install geoip-bin >/dev/null 2>&1
        echo "$password" | sudo -S apt-get install -y geoip-bin >/dev/null 2>&1
        anonymous_check
    else
		echo -e "yay you already have geoip, countiuing \n" 
        anonymous_check
    fi 
    log_message "geoip function finished"       
}

#checking for sshpass and installing it if does not exist
function sshpass_install()
{
	log_message "sshpass function started"
	echo -e "checking for the sshpass tool \n" 
    ssh_check=$(which sshpass 2>/dev/null)
    
    if [ -z "$ssh_check" ]
    then
        echo -e "${bold}You don't have sshpass, installing... please wait \n${reset}" 
        echo "$password" | sudo -S apt-get install -y sshpass >/dev/null 2>&1
        
    else
        echo -e "you already have the sshpass tool, contiuing \n" 
    fi   
    log_message "sshpass function finished"     
}

#connecting to the remote server and running the needed scans
function remote_control()
{
    log_message "remote_control function started"
#getting the public ip of the remote server in order to locate its locaition	
    public_remote_ip=$(echo "$ssh_pass" | sudo -S sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip 'curl ifconfig.me')
    remote_country=$(geoiplookup $public_remote_ip | grep -i "Country" | awk '{print $(NF)}')
    remote_uptime=$(echo "$ssh_pass" | sudo -S sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip 'uptime')
    echo -e "${bold}${green}connected to the server with the IP address: $ssh_ip \n located at: $remote_country \n system uptime: $remote_uptime ${reset}" 
    log_message "connected to the server with the IP address: $ssh_ip" 
    log_message "the connected server is located at: $remote_country"
    log_message "the connected system uptime is: $remote_uptime"
    log_message "running second script on the remote server"
    folder=$(sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip 'find /home/kali/Desktop -type d -name remote')
#checking if a foulder for the remote server files already exist    
    if [ "$folder" ]
    then
#transferring the secound script to run on the renote server and running it while transferring the password as well        
        sshpass -p "$ssh_pass" scp /home/kali/Desktop/remot_install.sh $ssh_user@$ssh_ip:/home/kali/Desktop/remote
        sshpass -p "$ssh_pass" ssh $ssh_user@$ssh_ip "bash /home/kali/Desktop/remote/remot_install.sh '$ssh_pass'"
    else
#creating a foulder for the remote server files and transferring the secound script to run on the renote server and running it while transferring the password as well    
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip 'mkdir /home/kali/Desktop/remote'
        sshpass -p "$ssh_pass" scp /home/kali/Desktop/remot_install.sh $ssh_user@$ssh_ip:/home/kali/Desktop/remote
        sshpass -p "$ssh_pass" ssh $ssh_user@$ssh_ip "bash /home/kali/Desktop/remote/remot_install.sh '$ssh_pass'"
    fi
#asking for an ip to scan with the remote server    
    log_message "finished running second script on the remote server"
    echo -e "${bold}${yellow}Please provide the address to scan via the remote server${reset}" 
    read wanted_address
    log_message "starting nmap and whois scans on the given address: $wanted_address" 
#running the needed nmap and whois scans from the remote server     
    whois_scan=$(echo "$ssh_pass" | sudo -S sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip "whois $wanted_address")
    nmap_scan=$(echo "$ssh_pass" | sudo -S sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip "nmap -p- $wanted_address --open")
#transferring the info of the given ip whois and nmap scans results to the folder on the local system 
    echo -e "whois scan results of the ip: $wanted_address \n $whois_scan" > ~/Desktop/remote_script_files_$today/whois_$today.txt
    echo -e "nmap scan results of the ip: $wanted_address \n $nmap_scan" > ~/Desktop/remote_script_files_$today/nmap_$today.txt
    sleep 3
    nmap_sum=$(cat ~/Desktop/remote_script_files_$today/nmap_$today.txt | grep -w "open" | wc -l)
    whois_sum=$(cat ~/Desktop/remote_script_files_$today/whois_$today.txt | grep "Country" | awk '{print$(NF)}')
    log_message "the number of open ports of the given address : $nmap_sum"
    log_message "the country of the given address is : $whois_sum"
    echo -e "${bold}${green}the number of open ports of the given address : $nmap_sum \n${reset}"
    echo -e "${bold}${green}the country of the given address is : $whois_sum \n${reset}"
    echo -e "${blue}finish scannimg,for more and full info please check the folder named remote_script_files_$today on the desktop of the local system \n${reset}" 
    echo -e "${bold}${blue}well that was fun, see you on my next project${reset}" 
    figlet "goodbye"
    log_message "remote_control function finished"
}

	
#calling the functions and requsting for the remote server info in order to connect 
sshpass_install
nipe_install
geoip_install
echo -e "${bold}${yellow}Please type the username for the remoste server:${reset}" 
read ssh_user
echo -e "${bold}${yellow}Please provide the password for the user of the remote server${reset}" 
read -s ssh_pass
echo -e "${bold}${yellow}Please provide the IP address of the remote server:${reset}" 
read ssh_ip
echo -e "conncting to the remote control"
remote_control

log_message "project script finished"


# michal koren
# student code: s10
# unit: TMagen773632
# lecturer`s name : erel
