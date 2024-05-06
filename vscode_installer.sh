####################################################################
# Get System Info
####################################################################

cyan='\e[1;37;44m'
red='\e[1;31m'
endColor='\e[0m'
datetime=$(date +%Y%m%d%H%M%S)

lowercase(){
	echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

shootProfile(){
	OS=`uname`
	KERNEL=`uname -r`
	MACH=`uname -m`

	if [ "${OS}" = "windowsnt" ]; then
		OS=windows
	elif [ "${OS}" = "darwin" ]; then
		OS=mac
	else
		if [ "${OS}" = "SunOS" ] ; then
			OS=Solaris
			ARCH=`uname -p`
			OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
		elif [ "${OS}" = "AIX" ] ; then
			OSSTR="${OS} `oslevel` (`oslevel -r`)"
		elif [ "${OS}" = "Linux" ] ; then
			if [ -f /etc/redhat-release ] ; then
				DistroBasedOn='RedHat'
				DIST=`cat /etc/redhat-release |sed s/\ release.*//`
				PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
				REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
			elif [ -f /etc/SuSE-release ] ; then
				DistroBasedOn='SuSe'
				PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
				REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
			elif [ -f /etc/mandrake-release ] ; then
				DistroBasedOn='Mandrake'
				PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
				REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
			elif [ -f /etc/debian_version ] ; then
				DistroBasedOn='Debian'
				if [ -f /etc/lsb-release ] ; then
			        	DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
			                PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
			                REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
            			fi
			fi
			if [ -f /etc/UnitedLinux-release ] ; then
				DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
			fi
			OS=`lowercase $OS`
			DistroBasedOn=`lowercase $DistroBasedOn`
		 	readonly OS
		 	readonly DIST
			readonly DistroBasedOn
		 	readonly PSUEDONAME
		 	readonly REV
		 	readonly KERNEL
		 	readonly MACH
		fi

	fi
}
echo "Analysing system"
shootProfile

####################################################################
# Install VSCode
####################################################################

vscode_install_linux(){
	echo "Download VSCode, just wait"
    
	if [ "$1" = "debian" ];
    then
        sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt install apt-transport-https
        sudo apt update
        echo "installing VSCode"
        sudo apt install code
        # echo "command debian"
    elif [ "$1" = "aix" ];
    then
		git clone https://aur.archlinux.org/visual-studio-code-bin.git
        cd visual-studio-code-bin
        makepkg -sri
        echo "For troubleshooting visit: https://aur.archlinux.org"
        # echo "command arch linux"
    elif [ "$1" = "suse" ];
    then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
        sudo zypper refresh
		echo "installing VSCode"
        sudo zypper install code
        # echo "command opensuse"
    else
        echo "\nERROR: System not recognized.\nERROR: download VSCODE latest version from source https://code.visualstudio.com/docs/setup/linux"
    fi
}

####################################################################
# Get program version
####################################################################

program_exist(){
    program_name=$1
    program_version=`$program_name -v`
    
    if [ `$program_version` != "" ];
    then
        echo "$program_version"
    else 
        echo "install $1"     
    fi

}


vscode_install=`vscode_install_linux $DistroBasedOn`
vscode_exist=`program_exist code`
echo "$vscode_exist"

if [ "$vscode_exist" = "install code" ];
then 
    echo $vscode_install
	echo `code .`
fi