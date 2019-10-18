#!/bin/bash
#======================================================================================
#title:         Frontend-Switcher.sh
#description:   Lets you switch between Emulationstation and Pegasus frontends easily
#author:        SolemnSpirit
#created:       September 19 2019
#version:       0.8
#last updated: October 10 2019
#usage:         ./Frontend-Switcher.sh
#======================================================================================

#should hide cursor (but probably won't) - tput norm to make visible

if [ ! -f "/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc" ]
then

dialog --create-rc "/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc"
fi

# General Declarations


#tput civis 



setterm -cursor off
tput civis
function main_menu() {
DIALOGRC="/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc"
	
	
	local choice

    while true; do
        choice=$(dialog --begin 2 1 --no-shadow \
	    --hline "  HLINE  " --backtitle "Backtitle" --title " TITLE " \
            --ok-label Select --cancel-label Cancel \
            --menu "\nSelect an option:" 26 38 20\
            1 "Option 1" \
            2 "Option 2" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) EmulationStation  ;;
            2) Pegasus  ;;
            *)  break ;;
        esac
    done
}

function EmulationStation() {
	FrontendName="EmulationStation"
	#if grep -q emulationstation /opt/retropie/configs/all/autostart.sh; then
		#MessageBox "\Z1\ZbFRONTEND ALREADY SET\Zn" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\n$FrontendName is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
	#else
		Steps=4
		StepsComplete=0
		 ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nPlease wait..."
		sleep 10s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nChecking autostart..."
		grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh > /dev/null 2>&1
		#sleep 10s
		((++StepsComplete))
		#sleep 10s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nConfiguring autostart..."
		sudo sed -i 's/pegasus-fe/emulationstation/g' /opt/retropie/configs/all/autostart.sh > /dev/null 2>&1
		((++StepsComplete))
		#sleep 10s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nChecking safe shutdown..."
		grep -q 'pegasus-fe(' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		((++StepsComplete))
		#sleep 10s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nConfiguring safe shutdown..."
		sudo sed -i 's/pegasus-fe/emulationstation/g' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		sudo sed -i '155 s/^..//' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		sudo sed -i '156 s/^..//' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		sudo sed -i -e '159d' /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1
		((++StepsComplete))
		#sleep 10s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nDone !"
		#sleep 10s
		YesNoPrompt "Reboot required" "  GPi Case Users  " "Reboot required" "Now" "Later" "\nA reboot is required for the changes to take effect.\n\nDo you want to do this now?" "exit" "sudo reboot"
	#fi
}

function Pegasus() {
	FrontendName="Pegasus"
	#if grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh; then
		#MessageBox "\Z1\ZbFRONTEND ALREADY SET\Zn" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\n$FrontendName is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
	#else

		Steps=6
		StepsComplete=0

		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nPlease wait..."
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nChecking for existing $FRONTENDNAME install..."
		if [ -d "/opt/retropie/configs/all/pegasus-fe" ]; then
			((++StepsComplete))
		else
			((++StepsComplete))
			ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nInstalling $FRONTENDNAME..."
			cd ~/RetroPie-Setup > /dev/null 2>&1
			sudo ./retropie_packages.sh pegasus-fe > /dev/null 2>&1
			((++StepsComplete))
		fi
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nChecking Pegasus theme directory..."
		#sleep 6s
		if [ -d "/opt/retropie/configs/all/pegasus-fe/themes/pegasus-theme-gpiOS" ]; then
			echo "I found theme-gpiOS ! :-D"
			cd ~/.config/pegasus-frontend/themes/pegasus-theme-gpiOS
		if ! git diff --quiet remotes/origin/HEAD; then
			echo "CHANGES DETECTED ! :-O"
			YesNoPrompt "Update available" "$HLINETEXT" "Update available" "Now"  "Later" "\nAn update is available for GPiOS.\n\nDo you want to install this now?" "git pull" ":"
		else
			echo "NO CHANGES DETECTED ! :-|"
		fi
			
		#	sleep 30s
		else
			echo "Installing default theme (gpiOS)..."
			cd ~/.config/pegasus-frontend/themes/ && git clone https://github.com/SinisterSpatula/pegasus-theme-gpiOS.git --branch master --depth 1
		fi  
		((++StepsComplete))     
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nChecking autostart..."
		grep -q emulationstation /opt/retropie/configs/all/autostart.sh;
		((++StepsComplete))
		#sleep 5s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nConfiguring autostart..."
		sudo sed -i 's/emulationstation/pegasus-fe/g' /opt/retropie/configs/all/autostart.sh
		((++StepsComplete))
		#sleep 5s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nChecking safe shutdown..."
		grep -q 'emulationstation(' /opt/RetroFlag/multi_switch.sh;
		((++StepsComplete))
		#sleep 5s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nConfiguring safe shutdown..."
		sudo sed -i 's/emulationstation/pegasus-fe/g' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '155 s/^/#/' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '156 s/^/#/' /opt/RetroFlag/multi_switch.sh
		sudo sed -i '158 a sudo shutdown -h now' /opt/RetroFlag/multi_switch.sh
		((++StepsComplete))
		#sleep 5s
		ProgressBar "|--- $FrontendName ---|" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\nDone !"
		#sleep 5s
		YesNoPrompt "Reboot required" "  GPi Case Users  " "Reboot required" "Now" "Later" "\nA reboot is required for the changes to take effect.\n\nDo you want to do this now?" "exit" "sudo reboot"
	sleep 30s
	#fi
}

function MessageBox {
	dialog --begin 2 1 --no-shadow --title "$1" --hline "$2" --backtitle "$3" --colors --msgbox "$4" 27 38
	sleep 1s
	exit 1
}

function YesNoPrompt {
    if ! dialog --begin 2 1 --no-shadow --title "$1" --hline "$2" \
        --backtitle "$3" --yes-label "$4" --no-label "$5" \
        --yesno "$6" 26 38 20>&1 > /dev/tty
    then
    	eval "$7" > /dev/null 2>&1
    else
    	eval "$8" > /dev/null 2>&1
    fi
}

function ProgressBar {
	echo $((StepsComplete * 100 / Steps)) | dialog --begin 2 1 --no-shadow --title "$1" --hline "$2" --backtitle "$3" --gauge "$4" 26 38 20
}

# Main

main_menu
