#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install.sh | bash
INSTALL_EXT_BINARY="https://raw.githubusercontent.com/osmedeus/osmedeus-base/main/data/scripts/install-external-binaries.sh"

# global stuff
BASE_PATH="$HOME/osmedeus-base"
BINARIES_PATH="$BASE_PATH/binaries"
DATA_PATH="$BASE_PATH/data"
TMP_DIST="/tmp/tmp-binaries"
BAK_DIST="/tmp/bak-osm"
DEFAULT_SHELL="$HOME/.bashrc"
CWD=$(pwd)
PACKGE_MANAGER="apt-get"

# Detect OS and ARCH
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

SUDO="sudo"
if [ "$(whoami)" == "root" ]; then
    SUDO=""
fi
[ -x "$(command -v apt)" ] && PACKGE_MANAGER="apt"
if [ -f "$HOME/.zshrc" ]; then
    DEFAULT_SHELL="$HOME/.zshrc"
fi

announce() {
    echo -e "\033[1;37m[\033[1;31m+\033[1;37m]\033[1;32m $1 \033[0m"
}

install_banner() {
    echo -e "\033[1;37m[\033[1;34m+\033[1;37m]\033[1;32m Installing $1 \033[0m"
}

download() {
    wget -q -O $1 $2
    if [ ! -f "$1" ]; then
        wget -q -O $1 $2
    fi
}

download_multi_platform() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    DOWNLOAD_URL=$(echo $2 | sed -E 's/linux/darwin/g')
  else
    DOWNLOAD_URL=$(echo $2 | sed -E 's/darwin|osx|macos/linux/g')
  fi

  if [[ $(uname -p) == "arm" || $(uname -p) == "aarch64" ]]; then
    DOWNLOAD_URL=$(echo $DOWNLOAD_URL | sed -E 's/amd/arm/g')
  else
    DOWNLOAD_URL=$(echo $DOWNLOAD_URL | sed -E 's/arm/amd/g')
  fi

  wget -q -O $1 $DOWNLOAD_URL
  if [ ! -f "$1" ]; then
    wget -q -O $1 $DOWNLOAD_URL
  fi
}

extractZip() {
	unzip -q -o -j $1 -d $BINARIES_PATH/
	rm -rf $1
}

extractGz() {
	tar -xf $1 -C $BINARIES_PATH/
	rm -rf $1
}

detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        PACKAGE_MANAGER="apt-get"
    elif command -v apt &> /dev/null; then
        PACKAGE_MANAGER="apt"
    elif command -v yum &> /dev/null; then
        PACKAGE_MANAGER="yum"
    elif command -v dnf &> /dev/null; then
        PACKAGE_MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"
    elif command -v brew &> /dev/null; then
        PACKAGE_MANAGER="brew"
    else
        announce "No compatible package manager detected! The installation may be broken."
    fi
    announce "Detected package manager: $PACKAGE_MANAGER"
}
detect_package_manager

announce "Please be aware that this installation is only compatible with\033[0m Linux (amd64) and MacOS Intel chip systems"
if [[ $EUID -ne 0 ]]; then
  announce "You're running the script as\033[1;34m $USER \033[0m. It is recommended to run as root user by running\033[1;34m sudo su \033[0mfirst and then run the script"
  announce "If you're already have essential tools installed, you can continue the installation as normal"
  echo -e "\033[1;37m[\033[1;31m+\033[1;37m]\033[1;32m Press any key to continue ... \033[0m"; read -n 1; echo
else
  $SUDO $PACKGE_MANAGER update -qq >/dev/null 2>&1
  DEBIAN_FRONTEND=noninteractive $SUDO $PACKGE_MANAGER install -y --no-install-recommends tzdata -qq >/dev/null 2>&1
  touch /var/lib/cloud/instance/locale-check.skip >/dev/null 2>&1
  install_banner "Essential tool: wget, git, make, nmap, masscan, chromium"
  # reinstall all essioontials tools just to double check
  [ -x "$(command -v wget)" ] || $SUDO $PACKGE_MANAGER -qq install wget -y >/dev/null 2>&1
  [ -x "$(command -v curl)" ] || $SUDO $PACKGE_MANAGER -qq install curl -y >/dev/null 2>&1
  [ -x "$(command -v tmux)" ] || $SUDO $PACKGE_MANAGER -qq install tmux -y >/dev/null 2>&1
  [ -x "$(command -v git)" ] || $SUDO $PACKGE_MANAGER -qq install git -y >/dev/null 2>&1
  [ -x "$(command -v nmap)" ] || $SUDO $PACKGE_MANAGER -qq install nmap -y >/dev/null 2>&1
  [ -x "$(command -v masscan)" ] || $SUDO $PACKGE_MANAGER -qq install masscan -y >/dev/null 2>&1
  [ -x "$(command -v make)" ] || $SUDO $PACKGE_MANAGER -qq install build-essential -y >/dev/null 2>&1
  [ -x "$(command -v unzip)" ] || $SUDO $PACKGE_MANAGER -qq install unzip -y >/dev/null 2>&1
  [ -x "$(command -v chromium)" ] || $SUDO $PACKGE_MANAGER -qq install chromium -y >/dev/null 2>&1
  [ -x "$(command -v chromium-browser)" ] || $SUDO $PACKGE_MANAGER -qq install chromium-browser -y >/dev/null 2>&1
  [ -x "$(command -v jq)" ] || $SUDO $PACKGE_MANAGER -qq install jq -y >/dev/null 2>&1
  [ -x "$(command -v make)" ] || $SUDO $PACKGE_MANAGER -qq install build-essential -y >/dev/null 2>&1
  [ -x "$(command -v rsync)" ] || $SUDO $PACKGE_MANAGER -qq install rsync -y >/dev/null 2>&1
  [ -x "$(command -v netstat)" ] || $SUDO $PACKGE_MANAGER -qq install coreutils net-tools -y >/dev/null 2>&1
  [ -x "$(command -v htop)" ] || $SUDO $PACKGE_MANAGER -qq install htop -y >/dev/null 2>&1
  [ -x "$(command -v timeout)" ] || $SUDO $PACKGE_MANAGER install timeout -y >/dev/null 2>&1
  [ -x "$(command -v pip)" ] || $SUDO $PACKGE_MANAGER install python3 python3-pip -y >/dev/null 2>&1
fi

### Check if the machine is ARM-based or MacOS-based machine
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\033[1;34m[!] MacOS machine detected. Exit the script\033[0m"
    announce "Check out https://docs.osmedeus.org/installation/#install-for-macos-or-arm-based-machine for more MacOS installation"
    exit 1
fi

if [[ $(uname -p) == "arm" || $(uname -p) == "aarch64" ]]; then
    echo -e "\033[1;34m[!] An ARM-based machine has been identified. The installation will now proceed with the ARM-specific script.\033[0m"
    bash <(curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install-arm.sh)
    exit 1
fi
announce "\033[1;34mSet Data Directory:\033[1;37m $DATA_PATH \033[0m"
announce "\033[1;34mSet Binaries Directory:\033[1;37m $BINARIES_PATH \033[0m"

announce "Remove the existing base directory if it is present"
rm -rf $BINARIES_PATH/* && mkdir -p $BINARIES_PATH 2>/dev/null
if [ -d "$HOME/osmedeus-base/data" ]; then
    announce "Backup old osmedeus custom data. If you want a fresh install please run the command: \033[0mrm -rf $HOME/osmedeus-base $HOME/.osmedeus\033[0m"
    rm -rf $BAK_DIST 
    mv $HOME/osmedeus-base $BAK_DIST
fi

# Download the latest osm base repo
announce "Cloning Osmedeus base repo:\033[0m https://github.com/osmedeus/osmedeus-base"
rm -rf $BASE_PATH && git clone --quiet --depth=1 https://github.com/osmedeus/osmedeus-base $BASE_PATH
# # retry to clone in case of anything wrong with the connection
if [ ! -d "$BASE_PATH" ]; then
    git clone --quiet --depth=1 https://github.com/osmedeus/osmedeus-base $BASE_PATH
fi

# setting up the osmedeus binary
[ -z "$(which osmedeus)" ] && osmBin=/usr/local/bin/osmedeus || osmBin=$(which osmedeus)
announce "Setup Osmedeus Core Engine:\033[0m $osmBin"
unzip -q -o -j $BASE_PATH/dist/osmedeus-linux-amd64.zip -d $BASE_PATH/dist/
rm -rf $osmBin && cp $BASE_PATH/dist/osmedeus $osmBin && chmod +x $osmBin
if [ ! -f "$osmBin" ]; then
    echo -e "[!] Unable to copy the Osmedeus binary to:\033[0m $osmBin \033[1;32m"
    osmBin="$BINARIES_PATH/osmedeus"
    announce "Copying Osmedeus binary to \033[0m $osmBin \033[1;32m instead"
    mkdir -p $HOME/osmedeus-base/binaries/ 2>&1 > /dev/null
    cp $BASE_PATH/dist/osmedeus $osmBin
fi

###################################################
#      Start to install external binaries         #
###################################################
mkdir -p $BINARIES_PATH $TMP_DIST >/dev/null 2>&1

install_banner "massdns"
cd $BINARIES_PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install massdns -q
  cp $(which massdns) $BINARIES_PATH/massdns
else
  git clone --depth=1 --quiet https://github.com/blechschmidt/massdns build-massdns 2>&1 >/dev/null
  cd build-massdns
  make &>/dev/null
  cp bin/massdns "$BINARIES_PATH/massdns" > /dev/null 2>&1
  rm -rf build-massdns
fi
cd $BASE_PATH

install_banner "semgrep"
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install semgrep -q 2>&1 >/dev/null
else
  PIP_BREAK_SYSTEM_PACKAGES=1 python3 -m pip -q install semgrep --break-system-packages --root-user-action=ignore 2>&1 >/dev/null
fi
cp $(which semgrep) $BINARIES_PATH/semgrep 2>&1 >/dev/null

install_banner "findomain"
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install findomain -q
  cp $(which findomain) $BINARIES_PATH/findomain
else
  if [[ $(uname -p) == "arm" || $(uname -p) == "aarch64" ]]; then
    download $TMP_DIST/findomain.zip https://github.com/findomain/findomain/releases/latest/download/findomain-armv7.zip
  else
    download $TMP_DIST/findomain.zip https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
  fi
  extractZip $TMP_DIST/findomain.zip
fi

install_banner "packer"
rm -rf $TMP_DIST/packer.zip 2>&1 >/dev/null
export PACKER_VERSION=1.10.2
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ $(uname -p) == "arm" ]]; then
    download $TMP_DIST/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_darwin_arm64.zip
  else
    download $TMP_DIST/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_darwin_amd64.zip
  fi
else
  if [[ $(uname -p) != "arm" ]]; then
    download $TMP_DIST/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
  else
    download $TMP_DIST/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_arm64.zip
  fi
fi
extractZip $TMP_DIST/packer.zip

install_banner "csvtk"
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install csvtk -q
  cp $(which csvtk) $BINARIES_PATH/csvtk
else
  if [[ $(uname -p) == "arm" || $(uname -p) == "aarch64" ]]; then
    download $TMP_DIST/csvtk.gz https://github.com/shenwei356/csvtk/releases/download/v0.33.0/csvtk_linux_arm64.tar.gz
  else
    download $TMP_DIST/csvtk.gz https://github.com/shenwei356/csvtk/releases/download/v0.33.0/csvtk_linux_amd64.tar.gz
  fi
  extractGz $TMP_DIST/csvtk.gz
fi

install_banner "trufflehog"
TRUFFLEHOG_VERSION=$(curl -s https://api.github.com/repos/trufflesecurity/trufflehog/releases/latest | jq -r '.name' | sed 's/v//g')
download_multi_platform $TMP_DIST/trufflehog.gz https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_darwin_arm64.tar.gz
extractGz $TMP_DIST/trufflehog.gz

install_banner "rustscan"
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install rustscan -q
else
  if [[ $(uname -p) == "arm" || $(uname -p) == "aarch64" ]]; then
    download $TMP_DIST/rustscan.zip https://github.com/bee-san/RustScan/releases/download/2.4.1/aarch64-linux-rustscan.zip
    extractZip $TMP_DIST/rustscan.zip
  else
    # yes, this is weird due to the author naming release
    download $TMP_DIST/rustscan.gz.zip https://github.com/bee-san/RustScan/releases/download/2.4.1/x86_64-linux-rustscan.tar.gz.zip
    unzip -q -o -j $TMP_DIST/rustscan.gz.zip -d $TMP_DIST/
    extractGz $TMP_DIST/x86_64-linux-rustscan.tar.gz
  fi
fi

###################################################
#        End to install external binaries         #
###################################################

# Download the external binaries with the pre-built binaries
curl -fsSL $INSTALL_EXT_BINARY > $TMP_DIST/external-binaries.sh
source "$TMP_DIST/external-binaries.sh"
rm -rf $BINARIES_PATH/LICENSE*  $BINARIES_PATH/README* $BINARIES_PATH/CHANGELOG* $BINARIES_PATH/config.ini 2>/dev/null

# Download the auxiliary tools as some of them are not available in the official repo
install_banner "auxiliary tools"
if [ ! -d "$TMP_DIST/auxs-binaries" ]; then
  git clone --quiet --depth=1 https://github.com/osmedeus/auxs-binaries $TMP_DIST/auxs-binaries 2>&1 >/dev/null
fi

# retry to clone in case of anything wrong with the connection
if [ ! -d "$TMP_DIST/auxs-binaries" ]; then
  git clone --quiet --depth=1 https://github.com/osmedeus/auxs-binaries $TMP_DIST/auxs-binaries 2>&1 >/dev/null
fi

# copy all the binaries to the binaries path
cp $TMP_DIST/auxs-binaries/releases/* $BINARIES_PATH/
chmod +x $BINARIES_PATH/*
export PATH=$BINARIES_PATH:$PATH
echo "export PATH=$BINARIES_PATH:\$PATH" >> $DEFAULT_SHELL

### done the binaries part
install_banner "Osmedeus Web UI"
rm -rf ~/.osmedeus/server/* >/dev/null 2>&1
mkdir -p ~/.osmedeus/server >/dev/null 2>&1
cp -R $BASE_PATH/ui ~/.osmedeus/server/ui >/dev/null 2>&1

#############################################
#        Start to setup the workflow        #
#############################################

install_banner "Osmedeus Community Workflow:\033[0m https://github.com/osmedeus/osmedeus-workflow"
rm -rf $BASE_PATH/workflow >/dev/null 2>&1
git clone --quiet --depth=1 https://github.com/osmedeus/osmedeus-workflow $BASE_PATH/workflow
## retry to clone in case of anything wrong with the connection
if [ ! -d "$BASE_PATH/workflow" ]; then
    git clone --quiet --depth=1 https://github.com/osmedeus/osmedeus-workflow $BASE_PATH
fi

#############################################
#        Done to setup the workflow        #
#############################################


announce "Downloading Vulnerability templates"
jaeles config init >/dev/null 2>&1
rm -rf ~/nuclei-templates && git clone --quiet --depth=1 https://github.com/projectdiscovery/nuclei-templates.git ~/nuclei-templates >/dev/null 2>&1

# copy the old data to the new one
if [ -d "$BAK_DIST/data" ]; then
    announce "Updating old data + cloud config ..."
    rm -rf $HOME/osmedeus-base/data && cp -R $BAK_DIST/data $HOME/osmedeus-base/data
fi
if [ -d "$BAK_DIST/cloud/provider.yaml" ]; then
    rm -rf $HOME/osmedeus-base/cloud && cp -R $BAK_DIST/cloud $HOME/osmedeus-base/cloud
fi
if [ -d "$BAK_DIST/token" ]; then
    rm -rf $HOME/osmedeus-base/token && cp -R $BAK_DIST/token $HOME/osmedeus-base/token
fi
rm -rf $BAK_DIST >/dev/null 2>&1

echo "---->>>"
osmedeus health
echo "---->>>"

announce "The installation is done..."
announce "Check here if you want to setup API & token:\033[0m https://docs.osmedeus.org/installation/token/"
announce "Run\033[0m source $DEFAULT_SHELL \033[1;32mto complete the install"
announce "Set default Osmedeus Threads Hold to:\033[0m 10 \033[1;32m"
osmedeus config set --threads-hold=10
osmedeus config set --client-name PublicIP
announce "You can change the default Threads Hold with the command:\033[0m osmedeus config set --threads-hold=<number-of-threads> \033[1;32m"
