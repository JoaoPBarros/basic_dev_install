####################################################################
# Get program version
####################################################################

program_exist(){
    program_name=$1
    command_line=`$program_name --version`
    program_version=`echo $command_line`
    
    if [ "$program_version" != "" ];
    then
        echo "programa existe"
        echo "$program_version"
    else 
        echo "programa não existe"        
    fi

}

if 

####################################################################
# Install ZSH POWERLEVEL10K
####################################################################

sudo apt-get install zsh | 
zsh | 
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" |
Y |
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y |
gh auth login |
GitHub.com |
HTTPS |
Yes |
Login with a web browser |
gh repo clone romkatv/powerlevel10k $ZSH_CUSTOM/themes/powerlevel10k |
