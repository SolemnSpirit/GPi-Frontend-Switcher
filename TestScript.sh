#!/bin/bash
#=============================================================================
#title:         Frontend-Switcher.sh
#description:   Lets you switch between Emulationstation and Pegasus frontends easily
#author:        SolemnSpirit
#created:       September 19 2019
#version:       1.0
#usage:         ./Frontend-Switcher.sh
#==============================================================================

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --title "GPi Frontend Switcher " \
		--no-shadow  --backtitle "Brought to you by: Gpi Case User group" \
            --ok-label Select --cancel-label Cancel & Exit \
            --menu "Select a frontend:" 25 75 20 \
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
if grep -q emulationstation /opt/retropie/configs/all/autostart.sh; then
echo "--------------------------------------------------------------------------------"
echo "Frontend is already set to EmulationStation !"
echo ""
echo "Returning to Retropie menu..."
echo "--------------------------------------------------------------------------------"
sleep 1s
exit 1
else
echo "--------------------------------------------------------------------------------"
echo "Changing frontend to EmulationStation..."
echo ""
echo "Please wait..."
echo "--------------------------------------------------------------------------------"
echo ""
echo ""
echo "Configuring autostart..."
grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh;
sudo sed -i 's/pegasus-fe/emulationstation/g' /opt/retropie/configs/all/autostart.sh
echo ""
echo "Done !"
echo ""
echo ""
# debug wait time
sleep 5s
# ---------------
echo "Configuring safe shutdown..." 
grep -q 'pegasus-fe(' /opt/RetroFlag/multi_switch.sh;
sudo sed -i 's/pegasus-fe/emulationstation/g' /opt/RetroFlag/multi_switch.sh
echo ""
echo "Done !"
echo ""
echo ""
# debug wait time
sleep 5s
# ---------------
echo "Frontend changed to EmulationStation !"
echo ""
echo ""
#echo "Returning to Retropie menu..."
#echo "--------------------------------------------------------------------------------"
sleep 1s
RebootPrompt
fi
}

function Pegasus() {
if grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh; then
echo "--------------------------------------------------------------------------------"
echo "Frontend is already set to Pegasus !"
echo ""
echo "Returning to Retropie menu..."
echo "--------------------------------------------------------------------------------"
sleep 1s
exit 1
else
echo "--------------------------------------------------------------------------------"
echo "Changing frontend to Pegasus..."
echo ""
echo "Please wait..."
echo "--------------------------------------------------------------------------------"
echo ""
echo ""
echo "Installing Pegasus..."
echo ""
echo ""
cd ~/RetroPie-Setup
sudo ./retropie_packages.sh pegasus-fe
echo ""
echo "Install complete !"
echo ""
echo ""
# debug wait time
sleep 5s
# ---------------
echo "Checking Pegasus theme directory..."
if [ -d "/opt/retropie/configs/all/pegasus-fe/themes/pegasus-theme-gpiOS" ]; then
echo "I found theme-gpiOS  !"
# dialog --backtitle "Update available !" --title " Update available  " \
#    --yesno "\nAn update to gpiOS is available.\nDo you want to install it?" \
#    15 75 2>&1 > /dev/tty \
#    || exit
echo "Update would happen here!"
#sleep 1s
else
echo "Installing default theme (gpiOS)..."
cd ~/.config/pegasus-frontend/themes/ && git clone https://github.com/SinisterSpatula/pegasus-theme-gpiOS.git --branch master --depth 1
echo ""
echo "Done !"
echo ""
echo ""
# debug wait time
sleep 5s
# ---------------
fi     
echo "Setting theme..."
echo "general.theme: themes/pegasus-theme-gpiOS/" > ~/.config/pegasus-frontend/settings.txt
echo ""
echo "Done !"
echo ""
echo ""   
# debug wait time
sleep 5s
# ---------------
echo "Configuring autostart..."
grep -q emulationstation /opt/retropie/configs/all/autostart.sh;
sudo sed -i 's/emulationstation/pegasus-fe/g' /opt/retropie/configs/all/autostart.sh
echo ""
echo "Done !"
echo ""
echo ""
# debug wait time
sleep 5s
# ---------------
echo "Configuring safe shutdown..." 
grep -q 'emulationstation(' /opt/RetroFlag/multi_switch.sh;
sudo sed -i 's/emulationstation/pegasus-fe/g' /opt/RetroFlag/multi_switch.sh
echo ""
echo "Done !"
echo ""
echo ""
# debug wait time
sleep 5s
# ---------------
echo "Frontend changed to Pegasus !"
echo ""
echo ""
#echo "Returning to Retropie menu..."
#echo "--------------------------------------------------------------------------------"
sleep 1s
RebootPrompt
fi
}

function RebootPrompt() {
 dialog --colors --yes-label "Sure" --no-label "Nah" --hline "Brought to you by: Gpi Case User group" --no-shadow  --backtitle "Reboot required" --title " Reboot required  " \
    --yesno "\nA reboot is required for the changes to take effect.\n\nDo you want do this now?" \
    15 75 2>&1 > /dev/tty \
	|| exit
	sudo reboot
}


# Main

main_menu
