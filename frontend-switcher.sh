#!/bin/bash
#=============================================================================
#title:         Frontend-Switcher.sh
#description:   Lets you switch between Emulationstation and Pegasus frontends easily
#author:        SolemnSpirit
#created:       September 19 2019
#version:       0.5
#usage:         ./Frontend-Switcher.sh
#==============================================================================

BACKTITLETEXT="Brought to you by GPi Case Users Group"
HLINETEXT="  GPi Case Users  "
FRONTENDNAME=""
TITLETEXT=""
MSGBODY=""
PROGRESSNUMBER=0
PROGRESSMSG=""

#screen_color = (CYAN,BLACK,ON)


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --begin 2 1 --no-shadow \
		--hline "$HLINETEXT" \
		--backtitle "$BACKTITLETEXT" \
		--title " GPi FRONTEND SWITCHER " \
        --ok-label Select --cancel-label Cancel \
            --menu "\nSelect a frontend:" 26 38 20\
            1 "EmulationStation" \
            2 "Pegasus" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) EmulationStation  ;;
            2) Pegasus  ;;
            *)  break ;;
        esac
    done
}

function EmulationStation() {
	FRONTENDNAME="EmulationStation"
	#if grep -q emulationstation /opt/retropie/configs/all/autostart.sh; then
		#TITLETEXT="\Z1\ZbFRONTEND ALREADY SET\Zn"
		#MSGBODY="\n\n$FRONTENDNAME is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
		#MessageBox
	#else
		STEPS=4
		STEPSCOMPLETE=0
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nPlease wait..." 26 38 20
		#sleep 20s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nChecking autostart..." 26 38 20
		grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh > /dev/null 2>&1
		#sleep 20s
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nConfiguring autostart..." 26 38 20
		sudo sed -i 's/pegasus-fe/emulationstation/g' /opt/retropie/configs/all/autostart.sh > /dev/null 2>&1
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nChecking safe shutdown..." 26 38 20
		grep -q 'pegasus-fe(' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nConfiguring safe shutdown..." 26 38 20
		sudo sed -i 's/pegasus-fe/emulationstation/g' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		sudo sed -i '155 s/^..//' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '156 s/^..//' /opt/RetroFlag/multi_switch.sh
		sudo sed -i -e '159d' /opt/RetroFlag/multi_switch.sh
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nDone !" 26 38 20
		#sleep 5s
		RebootPrompt
	#fi
}

function Pegasus() {
	FRONTENDNAME="Pegasus"
	#if grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh; then
		#TITLETEXT="\Z1\ZbFRONTEND ALREADY SET\Zn"
		#MSGBODY="\n\n$FRONTENDNAME is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
		#MessageBox
	#else

		STEPS=6
		STEPSCOMPLETE=0

		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nPlease wait..." 26 38 20
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nChecking for existing $FRONTENDNAME install..." 26 38 20
		if [ -d "/opt/retropie/configs/all/pegasus-fe" ]; then
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		else
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nInstalling $FRONTENDNAME..." 26 38 20
		cd ~/RetroPie-Setup > /dev/null 2>&1
		sudo ./retropie_packages.sh pegasus-fe > /dev/null 2>&1
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		fi
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nChecking Pegasus theme directory..." 26 38 20
		#sleep 6s
		if [ -d "/opt/retropie/configs/all/pegasus-fe/themes/pegasus-theme-gpiOS" ]; then
			echo "I found theme-gpiOS  !"
			cd ~/.config/pegasus-frontend/themes/pegasus-theme-gpiOS
		if ! git diff --quiet remotes/origin/HEAD; then
		echo "CHANGES DETECTED !"
				dialog --begin 2 1 --no-shadow --title "Update available" --hline "$HLINETEXT" --backtitle "Update available" --yes-label "Now" --no-label "Later" --yesno "\nAn update is available for GPiOS.\n\nDo you want to install this now?" 26 38
		
			response=$?
			case $response in
			0) git pull;;
			1) :;;
			esac
		else
		echo "NO CHANGES DETECTED !" 
		fi
			
		#	sleep 30s
		else
			echo "Installing default theme (gpiOS)..."
			cd ~/.config/pegasus-frontend/themes/ && git clone https://github.com/SinisterSpatula/pegasus-theme-gpiOS.git --branch master --depth 1
		fi  
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))      
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nChecking autostart..." 26 38 20
		grep -q emulationstation /opt/retropie/configs/all/autostart.sh;
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nConfiguring autostart..." 26 38 20
		sudo sed -i 's/emulationstation/pegasus-fe/g' /opt/retropie/configs/all/autostart.sh
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nChecking safe shutdown..." 26 38 20
		grep -q 'emulationstation(' /opt/RetroFlag/multi_switch.sh;
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nConfiguring safe shutdown..." 26 38 20
		sudo sed -i 's/emulationstation/pegasus-fe/g' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '155 s/^/#/' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '156 s/^/#/' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '158 a sudo shutdown -h now' /opt/RetroFlag/multi_switch.sh
		STEPSCOMPLETE=$((STEPSCOMPLETE + 1))
		#sleep 5s
		echo $((STEPSCOMPLETE * 100 / STEPS)) | dialog --begin 2 1 --no-shadow --title "Setting $FRONTENDNAME as frontend" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --gauge "\n\nDone !" 26 38 20
		#sleep 5s
		RebootPrompt "Reboot required" "  GPi Case Users  " "Reboot required" "Now" "Later" "\nA reboot is required for the changes to take effect.\n\nDo you want to do this now?" $(exit) $(sudo reboot)
	sleep 30s
	#fi
}

function MessageBox {
	dialog --begin 2 1 --no-shadow --title "$TITLETEXT" --hline "$HLINETEXT" --backtitle "$BACKTITLETEXT" --colors --msgbox "$MSGBODY" 27 38
		sleep 1s
		exit 1
}

function RebootPrompt {
		dialog --begin 2 1 --no-shadow --title "$1" --hline "$2" --backtitle "$3" --yes-label $4 --no-label $5 --yesno "$6" 26 38 20>&1 > /dev/tty \
		"|| $7"
		"$8"	
}

# Main

main_menu
