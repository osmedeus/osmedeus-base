#!/bin/bash

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
if [[ "$OSTYPE" == "darwin"* ]]; then
  PACKGE_MANAGER="brew"
else
  PACKGE_MANAGER="apt"
fi

install_banner() {
  echo -e "\033[1;37m[\033[1;34m+\033[1;37m]\033[1;32m Installing $1 \033[0m"
}

announce() {
  echo -e "\033[1;37m[\033[1;31m+\033[1;37m]\033[1;32m $1 \033[0m"
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

if [[ "$OSTYPE" == "linux"* ]]; then
  $SUDO $PACKGE_MANAGER update -qq >/dev/null 2>&1
  DEBIAN_FRONTEND=noninteractive $SUDO $PACKGE_MANAGER install -y --no-install-recommends tzdata -qq >/dev/null 2>&1
  touch /var/lib/cloud/instance/locale-check.skip >/dev/null 2>&1
  install_banner "wget, git, make, nmap, masscan, chromium, golang"
  [ -x "$(command -v wget)" ] || $SUDO $PACKGE_MANAGER install wget -y >/dev/null 2>&1
  [ -x "$(command -v curl)" ] || $SUDO $PACKGE_MANAGER install curl -y >/dev/null 2>&1
  [ -x "$(command -v tmux)" ] || $SUDO $PACKGE_MANAGER install tmux -y >/dev/null 2>&1
  [ -x "$(command -v git)" ] || $SUDO $PACKGE_MANAGER install git -y >/dev/null 2>&1
  [ -x "$(command -v jq)" ] || $SUDO $PACKGE_MANAGER install jq -y >/dev/null 2>&1
  [ -x "$(command -v nmap)" ] || $SUDO $PACKGE_MANAGER install nmap -y >/dev/null 2>&1
  [ -x "$(command -v masscan)" ] || $SUDO $PACKGE_MANAGER install masscan -y >/dev/null 2>&1
  [ -x "$(command -v chromium)" ] || $SUDO $PACKGE_MANAGER install chromium -y >/dev/null 2>&1
  [ -x "$(command -v make)" ] || $SUDO $PACKGE_MANAGER install build-essential libpcap-dev -y >/dev/null 2>&1
  [ -x "$(command -v rg)" ] || $SUDO $PACKGE_MANAGER install ripgrep -y >/dev/null 2>&1
  [ -x "$(command -v unzip)" ] || $SUDO $PACKGE_MANAGER install unzip -y >/dev/null 2>&1
  [ -x "$(command -v chromium-browser)" ] || $SUDO $PACKGE_MANAGER install chromium-browser -y >/dev/null 2>&1
  [ -x "$(command -v make)" ] || $SUDO $PACKGE_MANAGER install build-essential -y >/dev/null 2>&1
  [ -x "$(command -v pip)" ] || $SUDO $PACKGE_MANAGER install python3 python3-pip -y >/dev/null 2>&1
else
  PACKGE_MANAGER="brew"
  [ -x "$(command -v wget)" ] || $PACKGE_MANAGER install wget -q >/dev/null 2>&1
  [ -x "$(command -v curl)" ] || $PACKGE_MANAGER install curl -q >/dev/null 2>&1
  [ -x "$(command -v tmux)" ] || $PACKGE_MANAGER install tmux -q >/dev/null 2>&1
  [ -x "$(command -v git)" ] || $PACKGE_MANAGER install git -q >/dev/null 2>&1
  [ -x "$(command -v jq)" ] || $PACKGE_MANAGER install jq -q >/dev/null 2>&1
  [ -x "$(command -v nmap)" ] || $PACKGE_MANAGER install nmap -q >/dev/null 2>&1
  [ -x "$(command -v masscan)" ] || $PACKGE_MANAGER install masscan -q >/dev/null 2>&1
  [ -x "$(command -v chromium)" ] || $PACKGE_MANAGER install chromium -q >/dev/null 2>&1
  [ -x "$(command -v make)" ] || $PACKGE_MANAGER install build-essential -q >/dev/null 2>&1
  [ -x "$(command -v rg)" ] || $PACKGE_MANAGER install ripgrep -q >/dev/null 2>&1
  [ -x "$(command -v unzip)" ] || $PACKGE_MANAGER install unzip -q >/dev/null 2>&1
  [ -x "$(command -v chromium-browser)" ] || $PACKGE_MANAGER install chromium-browser -q >/dev/null 2>&1
  [ -x "$(command -v timeout)" ] || $PACKGE_MANAGER install coreutils -q >/dev/null 2>&1
fi

announce "\033[1;34mSet Data Directory:\033[1;37m $DATA_PATH \033[0m"
announce "\033[1;34mSet Binaries Directory:\033[1;37m $BINARIES_PATH \033[0m"

announce "Remove the existing base directory if it is present"
rm -rf $BINARIES_PATH/* $TMP_DIST && mkdir -p $BINARIES_PATH >/dev/null 2>&1
if [ -d "$HOME/osmedeus-base/data" ]; then
  announce "Backup old osmedeus custom data. If you want a fresh install please run the command: \033[0mrm -rf $HOME/osmedeus-base $HOME/.osmedeus\033[0m"
  rm -rf $BAK_DIST
  mv $HOME/osmedeus-base $BAK_DIST
fi

announce "Cloning Osmedeus base repo:\033[0m https://github.com/osmedeus/osmedeus-base"
rm -rf $BASE_PATH && git clone --quiet --depth=1 https://github.com/osmedeus/osmedeus-base $BASE_PATH
# retry to clone in case of anything wrong with the connection
if [ ! -d "$BASE_PATH" ]; then
  git clone --quiet --depth=1 https://github.com/osmedeus/osmedeus-base $BASE_PATH
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
  cp bin/massdns $BINARIES_PATH/massdns 2>&1 >/dev/null
  rm -rf build-massdns/.git
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

install_banner "metabigor"
download_multi_platform $TMP_DIST/metabigor.gz https://github.com/j3ssie/metabigor/releases/download/v2.0.1/metabigor_v2.0.1_darwin_arm64.tar.gz
extractGz $TMP_DIST/metabigor.gz

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

##########################################################
#      Start to install golang external binaries         #
##########################################################

# update golang version
install_banner "Install Latest Golang"

# Map to GOOS and GOARCH
case $OS in
  linux)
    GOOS="linux"
    ;;
  darwin)
    GOOS="darwin"
    ;;
  *)
    echo "Unsupported OS: $OS. Defaulting to Linux build"
    GOOS="linux"
    ;;
esac

case $ARCH in
  x86_64)
    GOARCH="amd64"
    ;;
  i686)
    GOARCH="386"
    ;;
  arm64)
    GOARCH="arm64"
    ;;
  aarch64)
    GOARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $GOARCH. Defaulting to amd64 build"
    GOARCH="amd64"
    ;;
esac

# Get latest stable version
STABLE_VERSIONS=$(curl -s https://go.dev/dl/?mode=json | grep '"version":' | cut -d '"' -f 4 | egrep '^go[0-9]+\.[0-9]+(\.[0-9]+)?$')
LATEST_VERSION=$(echo "$STABLE_VERSIONS" | sort -V | tail -1)
# Construct filename
GO_PKG="${LATEST_VERSION}.${GOOS}-${GOARCH}.tar.gz"
# clean up previous
rm -rf "$HOME/.go/" /tmp/$GO_PKG
# Download
wget -qO /tmp/$GO_PKG https://dl.google.com/go/$GO_PKG

# Extract and move to $HOME/.go
rm -rf /tmp/go && tar -xzf /tmp/$GO_PKG -C /tmp/
rm -rf $HOME/.go && mv /tmp/go $HOME/.go

export GO_BIN="$HOME/.go/bin/go"
export GOROOT="$HOME/.go"
export GOPATH="$HOME/go"
export GO_DIR="$GOPATH/bin"
export PATH="$HOME/.go/bin:$GOPATH:$PATH"

##########################################################
##      End to install golang external binaries        ###
##########################################################

##########################################################
#      Start to download golang external binaries        #
##########################################################

install_banner "osmedeus"
$GO_BIN install github.com/j3ssie/osmedeus@latest 2>&1 >/dev/null
install_banner "goaltdns"
$GO_BIN install github.com/subfinder/goaltdns@latest 2>&1 >/dev/null
install_banner "assetfinder"
$GO_BIN install github.com/tomnomnom/assetfinder@latest 2>&1 >/dev/null
install_banner "httprobe"
$GO_BIN install github.com/tomnomnom/httprobe@master 2>&1 >/dev/null
install_banner "unfurl"
$GO_BIN install github.com/tomnomnom/unfurl@latest 2>&1 >/dev/null
$GO_BIN install github.com/tomnomnom/anew@latest 2>&1 >/dev/null
install_banner "go cli-utils"
$GO_BIN install github.com/shenwei356/rush@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/go-auxs/chrunk@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/cdnstrip@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/str-replace@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/durl@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/json-cleaner@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/go-auxs/ourl@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/go-auxs/urp@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/go-auxs/cleansub@latest 2>&1 >/dev/null
$GO_BIN install github.com/j3ssie/go-auxs/junique@latest 2>&1 >/dev/null
install_banner "github-endpoints"
$GO_BIN install github.com/gwen001/github-endpoints@latest 2>&1 >/dev/null
install_banner "github-subdomains"
$GO_BIN install github.com/gwen001/github-subdomains@latest 2>&1 >/dev/null
GO111MODULE=off $GO_BIN get -u github.com/Josue87/gotator 2>&1 >/dev/null
install_banner "puredns"
$GO_BIN install github.com/d3mondev/puredns/v2@latest 2>&1 >/dev/null
install_banner "amass"
$GO_BIN install github.com/owasp-amass/amass/v4/...@master 2>&1 >/dev/null
install_banner "gau"
$GO_BIN install github.com/lc/gau@latest 2>&1 >/dev/null
install_banner "shuffledns"
$GO_BIN install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest 2>&1 >/dev/null
install_banner "dnsx"
$GO_BIN install github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>&1 >/dev/null
install_banner "tlsx"
$GO_BIN install github.com/projectdiscovery/tlsx/cmd/tlsx@latest 2>&1 >/dev/null
install_banner "alterx"
$GO_BIN install github.com/projectdiscovery/alterx/cmd/alterx@latest 2>&1 >/dev/null
install_banner "katana"
$GO_BIN install github.com/projectdiscovery/katana/cmd/katana@latest 2>&1 >/dev/null
install_banner "httpx"
$GO_BIN install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>&1 >/dev/null
install_banner "nuclei"
$GO_BIN install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>&1 >/dev/null
install_banner "naabu"
$GO_BIN install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>&1 >/dev/null
install_banner "subfinder"
$GO_BIN install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>&1 >/dev/null
install_banner "notify"
$GO_BIN install github.com/projectdiscovery/notify/cmd/notify@latest 2>&1 >/dev/null
install_banner "uncover"
$GO_BIN install github.com/projectdiscovery/uncover/cmd/uncover@latest 2>&1 >/dev/null
install_banner "cdncheck"
$GO_BIN install github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest 2>&1 >/dev/null
$GO_BIN install github.com/ipinfo/cli/ipinfo@latest 2>&1 >/dev/null
install_banner "gospider"
$GO_BIN install github.com/jaeles-project/gospider@latest 2>&1 >/dev/null
install_banner "jaeles"
$GO_BIN install github.com/jaeles-project/jaeles@latest 2>&1 >/dev/null
install_banner "ffuf"
$GO_BIN install github.com/ffuf/ffuf/v2@latest 2>&1 >/dev/null

# just to make sure the binary has been installed
[ -x "$(command -v osmedeus)" ] || $GO_BIN install github.com/j3ssie/osmedeus@latest 2>&1 >/dev/null

##########################################################
#      End to download golang external binaries        #
##########################################################

announce "Copy all go tools from:\033[1;37m $GO_DIR\033[0m"
cp $GO_DIR/* $BINARIES_PATH/ >/dev/null 2>&1
chmod +x $BINARIES_PATH/*
export PATH=$BINARIES_PATH:$PATH
echo "export PATH=$BINARIES_PATH:\$PATH" >> $DEFAULT_SHELL

###### done the binaries part

install_banner "Osmedeus Web UI"
rm -rf $HOME/.osmedeus/server/* >/dev/null 2>&1
mkdir -p $HOME/.osmedeus/server >/dev/null 2>&1
cp -R $BASE_PATH/ui $HOME/.osmedeus/server/ui >/dev/null 2>&1

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
rm -rf $HOME/nuclei-templates && git clone --quiet --depth=1 https://github.com/projectdiscovery/nuclei-templates.git $HOME/nuclei-templates >/dev/null 2>&1

if [ -d "$BAK_DIST/data" ]; then
  announce "Updating old data + cloud config ..."
  rm -rf $HOME/osmedeus-base/data && cp -R $BAK_DIST/data $HOME/osmedeus-base/data
fi
if [ -d "$BAK_DIST/cloud" ]; then
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
osmedeus config set --threads-hold=10
osmedeus config set --client-name PublicIP
announce "You can change the default Threads Hold with the command:\033[0m osmedeus config set --threads-hold=<number-of-threads> \033[1;32m"
