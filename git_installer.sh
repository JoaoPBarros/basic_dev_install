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
shootProfile

####################################################################
# Install Git
####################################################################


git_install_linux(){
    echo "installing git, just wait"
    
	if [ "$1" = "debian" ];
    then
        echo "command debian"
		echo `apt-get install git;y`
    elif [ "$1" = "aix" ];
    then
        echo "command arch linux"
        echo `pacman -S git;y`
    elif [ "$1" = "suse" ];
    then
        echo "command opensuse"
        echo `zypper install git;y`
    else
        echo "\nERROR: System not recognized.\nERROR: download GIT latest version from source https://git-scm.com/download/linux"
		break
    fi
	echo "installed"
	echo `git -V`
}

####################################################################
# Get program version
####################################################################

program_exist(){
    program_name=$1
    command_line=`$program_name --version`
    program_version=`echo $command_line`
    
    if [ "$program_version" != "" ];
    then
        echo "$program_version"
    else 
        echo "install $1"     
    fi

}


git_install=`git_install_linux $DistroBasedOn`
git_exist=`program_exist git`
echo "$git_exist"

if [ "$git_exist" = "install git" ];
then 
    echo $git_install
fi