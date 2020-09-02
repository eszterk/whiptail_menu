#!/bin/sh

#<------------------------------------------------MENU BOX | WHILE LOOP-------------------------------------------------------------------->
while true;do
	choice=$(whiptail --title "Helpdesk Menu" --menu "Please choose an option" 25 78 16 \
		"1" "Display the available interfaces on the router" \
		"2" "Select an interface and display the IP address" \
		"3" "Select an interface and display the MAC address" \
		"4" "Display the uptime of the router" \
		"5" "Display the disk usage and CPU utilisation of the router" \
		"6" "Restart the networking service on the router" \
		"7" "Restart the ssh service on the router" \
		"8" "Enter a port number and run an nmap scan on this port" \
		"9" "Return the value of the nmap scan" \
		"10" "Display the different firewall zones" \
		"11" "Display the config for each of the firewall zones" \
		"12" "Reboot the router" \
		"13" "Exit" 3>&1 1>&2 2>&3)

	
	MENU_TEXT="Back to main menu"

	case $choice in
	#<----------------------------------------------MESSAGE BOX | INTERFACES------------------------------------------------------------>
		1)clear
			message=$(ip link show)
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "Available Interfaces" "$message" 30 78
			;;

	#<-------------------------------------------MESSAGE BOX | IP ADDRESS-------------------------------------------------------------->

		2)interface=$(whiptail --inputbox "Enter Interface: " --nocancel 15 25 3>&1 1>&2 2>&3)
			clear
			message=$(ifconfig "$interface" | grep 'inet ')
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "Interface's IP" "$message" 10 58
		;;

	#<-------------------------------------------MESSAGE BOX | MAC ADDRESS----------------------------------------------------------->
		
		3)interface=$(whiptail --inputbox "Enter interface: " 15 25 3>&1 1>&2 2>&3)
			clear
			message=$(ifconfig "$interface" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "Interface's MAC" "$message" 10 58
		;;
			
	#<----------------------------------------MESSAGE BOX | ROUTER UPTIME------------------------------------------------------------>

		4)clear
			message=$(uptime)
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "Uptime of router" "$message" 10 58
		;;

	#<---------------------------------------MESSAGE BOX | DISK USAGE------------------------------------------------------------------>

		5)clear
			message=$(df -h)
			whiptail --msgbox --ok-button "See the CPU ussage" --title "Disk Usage" "$message" 30 58

			message=$(top -n 1 -b)
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "Disk Usage" "$message" 30 58
		;;
	
	#<------------------------------------MESSAGE BOX | RESTARTING NETWORKING SERVICE----------------------------------------------->

		6)/etc/init.d/network restart;

			whiptail --msgbox --title "Restart" "Restarting networking service" 10 58
		;;
	
	#<---------------------------------------MESSAGE BOX | RESTARTING SSH-------------------------------------------------------------->

		7)/etc/init.d/dropbear restart;
			whiptail --msgbox --title "Restart" "Restarting SSH service" 10 58
		;;
	
	#<-----------------------------------INPUT BOX | PORT NUMBER FOR NMAP SCAN--------------------------------------------------------->

		8)number=$(whiptail --inputbox "Enter port number: " 15 25 3>&1 1>&2 2>&3)
			nmap localhost -p "$number" > /tmp/.nmap.result
		;;
	
	#<-------------------------------------MESSAGE BOX | NMAP SCAN RESULTS------------------------------------------------------------->

		9)clear
			if [ -f /tmp/.nmap.result ];then 
				message=$(cat /tmp/.nmap.result)
			else
				message="PLEASE RUN SCAN FIRST"
			fi
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "Scan Report" "$message" 30 58	
		;;
	
	#<------------------------------------MESSAGE BOX | FIREWALL ZONES----------------------------------------------------------------->

		10)clear
            message="$(uci show firewall | grep 'firewall.@zone\[[0-9]\].name')"
             whiptail --msgbox --ok-button "$MENU_TEXT" --title "Firewall Zones" "$message" 30 58
		;;
	
	#<-------------------------------------MESSAGE BOX | CONFIG----------------------------------------------------------------------->


		11)clear
			 message="$(uci show firewall | grep 'firewall.@zone\[[0-9]\]')"
			 whiptail --msgbox --ok-button "$MENU_TEXT" --title "Config for each of the firewalls zones" "$message" 30 58
		;;
	
	#<----------------------------------MESSAGE BOX | ROUTER REBOOT------------------------------------------------------------------->

		12)whiptail --msgbox --title "Reboot" "Rebooting router" 10 58
            reboot
		;;
	
	#<------------------------------------------EXIT---------------------------------------------------------------------------------->

		13)
		  exit 0 ;;
		*)	
			whiptail --msgbox --ok-button "$MENU_TEXT" --title "ERROR" "INVALID CHOICE" 30 88
		;;
	esac
done