GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BRED='\033[1;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

SOURCES_FILES_PATH="/etc/delta/"

welcome_msg="${GREEN}Welcome to the Delta OS CLI installer! We are going to do a step-by-step install of our project. Let's go!${RESET}\n"

echo -e $welcome_msg

echo -e "${CYAN} Firstly, please choose your computer boot mode (EFI or BIOS):"
echo "(1) BIOS"
echo "(2) EFI or UEFI :"

read BOOT_CHOICE

case $BOOT_CHOICE in

	"1")
		echo -e "${YELLOW}[WARNING] You have chosen BIOS mode, please be sure that your computer boots in BIOS mode otherwise your computer will not boot after the installation"
		;;
	"2")
		echo -e "${YELLOW}[WARNING] You have chosen EFI mode, please be sure that your computer boots in EFI mode otherwise your computer will not boot after the installation"
		;;
	*)
		echo -e "${BRED}[ERROR] You haven't entered a valid value. Exiting..."
		exit 1
esac

echo -e "${CYAN} Please choose the partition where Delta OS will be installed"
index=1

for part in /dev/sd*[0-9];
do
	echo "(${index}) ${part}"
	let index+=1
done

read PART_CHOICE

partition=""

index=1
for part in /dev/sd*[0-9];
do
	if [ $index -eq $PART_CHOICE ]
	then
		partition=$part
	fi
	let index+=1
done

if [ -z "$partition" ]
then
	echo -e "${BRED}You haven't chosen a valid partition. Exiting...${RESET}"
	exit 1
fi

echo -e "${YELLOW}[WARNING] You have chosen the ${partition} partition to do the installation"
echo -e "${CYAN} Now you have to choose what edition you are going to install"
echo "(1) Daily Edition"
echo "(2) Gaming Edition"
echo "(3) Developer Edition :"

read EDITION_CHOICE

edition_config_filename=""
case $EDITION_CHOICE in

	"1")
		echo -e "${CYAN}You have chosen the Daily Edition which contains a daily-to-use generic system"
		edition_config_filename="daily.conf"
		;;
	"2")
		echo -e "${CYAN}You have chosen the Gaming Edition which contains the main tools for a gaming system such as Lutris, Wine or Steam."
		
		edition_config_filename="gaming.conf"
		;;
	"3")
		echo -e "${CYAN}You have chosen the Developer Edition which contains some text editors and programming languages to do your work in a ready-to-use system"
		
		edition_config_filename="developer.conf"
		;;
	*)
		echo -e "${BRED}You haven't entered a valid value. If you want a customized edition of Delta OS, please install it manually with our delta-install-cli tool. Exiting...${RESET}"
		exit 1
esac

echo -e "${GREEN} Mounting ${partition} to /mnt"

mount ${partition} /mnt

echo -e "${GREEN} Starting installation..."
