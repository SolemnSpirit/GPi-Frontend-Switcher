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

if [ ! -f "/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc" ]
then

dialog --create-rc "/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc"
fi

# General Declarations
export DIALOGRC="/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc"

function main_menu() {
 while true; do
        Menu_Options=$(dialog --begin 2 1 --no-shadow \
	    --title " GPi FRONTEND SWITCHER " --hline "  GPi Case Users  " --backtitle "Brought to you by GPi Case Users Group"  \
            --ok-label Select --cancel-label Cancel \
            --menu "\nSelect an option:\n\n" 26 38 20\
            1 "EmulationStation" \
            2 "Pegasus" \
            2>&1 > /dev/tty)

        case "$Menu_Options" in
            1) EmulationStation  ;;
            2) Pegasus  ;;
            *)  break ;;
        esac
    done
}

function EmulationStation() {
    Frontend_Name="${FUNCNAME[0]}"
#Check autostart.sh for EmulationStation

#If autostart = EmulationStation then
#Tell user EmulationStation already set and quit
#If not set then

  ( 
  echo 20; echo "XXX"; echo "TEST 1"; echo "XXX" ; #Configure autostart.sh
  sleep 2 ; 
  echo 40; echo "XXX"; echo "TEST 2"; echo "XXX" ; #Configure safe shutdown (switch pegasus to emulationstation)
  sleep 2 ; 
  echo 60; echo "XXX"; echo "TEST 3"; echo "XXX" ; #uncomment line 155
  sleep 2 ;  
  echo 80; echo "XXX"; echo "TEST 4"; echo "XXX" ; #uncomment line 156
  sleep 2 ; 
  echo 100; echo "XXX"; echo "TEST 5"; echo "XXX" ; #delete line 159
  ) | dialog --gauge "Switching to "${FUNCNAME[0]}"" 6 50

cd ~/RetroPie-Setup

sudo ./retropie_packages.sh pegasus-fe | pv -p | dialog --gauge "TESTING" 6 50 
sleep 10s

}

function Pegasus() {
    echo "${FUNCNAME[0]}"


}

function Progress_Bar() {
    echo $((StepsComplete * 100 / Steps)) | dialog --begin 3 1 --title "$1" --hline "$2" --backtitle "$3" --gauge "$4" 26 38 20    
} 




main_menu
