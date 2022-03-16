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

SUDO="sudo"
if [ "$(whoami)" == "root" ]; then
    SUDO=""
fi
[ -x "$(command -v apt)" ] && PACKGE_MANAGER="apt"

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
    wget --no-check-certificate -q -O $1 $2
    if [ ! -f "$1" ]; then
        wget --no-check-certificate -q -O $1 $2
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

announce "NOTE that this installation only works on\033[0m Linux and MacOS Intel chip"
if [[ "$OSTYPE" == "linux"* ]]; then
    $SUDO $PACKGE_MANAGER update -qq > /dev/null 2>&1
    touch /var/lib/cloud/instance/locale-check.skip > /dev/null 2>&1
    install_banner "wget, git, make, nmap, masscan, chromium, golang"
    [ -x "$(command -v wget)" ] || $SUDO $PACKGE_MANAGER install wget -y >/dev/null 2>&1
    [ -x "$(command -v curl)" ] || $SUDO $PACKGE_MANAGER install curl -y >/dev/null 2>&1
    [ -x "$(command -v tmux)" ] || $SUDO $PACKGE_MANAGER install tmux -y >/dev/null 2>&1
    [ -x "$(command -v git)" ] || $SUDO $PACKGE_MANAGER install git -y >/dev/null 2>&1
    [ -x "$(command -v nmap)" ] || $SUDO $PACKGE_MANAGER install nmap -y >/dev/null 2>&1
    [ -x "$(command -v masscan)" ] || $SUDO $PACKGE_MANAGER install masscan -y >/dev/null 2>&1
    [ -x "$(command -v chromium)" ] || $SUDO $PACKGE_MANAGER install chromium -y >/dev/null 2>&1
    [ -x "$(command -v make)" ] || $SUDO $PACKGE_MANAGER install build-essential -y >/dev/null 2>&1
    [ -x "$(command -v rg)" ] || $SUDO $PACKGE_MANAGER install ripgrep -y >/dev/null 2>&1
    [ -x "$(command -v unzip)" ] || $SUDO $PACKGE_MANAGER install unzip -y >/dev/null 2>&1
    [ -x "$(command -v chromium-browser)" ] || $SUDO $PACKGE_MANAGER install chromium-browser -y >/dev/null 2>&1
    [ -x "$(command -v make)" ] || $SUDO $PACKGE_MANAGER install build-essential -y >/dev/null 2>&1
else
    PACKGE_MANAGER="brew"
    [ -x "$(command -v wget)" ] || $PACKGE_MANAGER install wget -q >/dev/null 2>&1
    [ -x "$(command -v curl)" ] || $PACKGE_MANAGER install curl -q >/dev/null 2>&1
    [ -x "$(command -v tmux)" ] || $PACKGE_MANAGER install tmux -q >/dev/null 2>&1
    [ -x "$(command -v git)" ] || $PACKGE_MANAGER install git -q >/dev/null 2>&1
    [ -x "$(command -v nmap)" ] || $PACKGE_MANAGER install nmap -q >/dev/null 2>&1
    [ -x "$(command -v masscan)" ] || $PACKGE_MANAGER install masscan -q >/dev/null 2>&1
    [ -x "$(command -v chromium)" ] || $PACKGE_MANAGER install chromium -q >/dev/null 2>&1
    [ -x "$(command -v make)" ] || $PACKGE_MANAGER install build-essential -q >/dev/null 2>&1
    [ -x "$(command -v rg)" ] || $PACKGE_MANAGER install ripgrep -q >/dev/null 2>&1
    [ -x "$(command -v unzip)" ] || $PACKGE_MANAGER install unzip -q >/dev/null 2>&1
    [ -x "$(command -v chromium-browser)" ] || $PACKGE_MANAGER install chromium-browser -q >/dev/null 2>&1
    [ -x "$(command -v make)" ] || $PACKGE_MANAGER install build-essential -q >/dev/null 2>&1
fi

announce "\033[1;34mSet Data Directory:\033[1;37m $DATA_PATH \033[0m"
announce "\033[1;34mSet Binaries Directory:\033[1;37m $BINARIES_PATH \033[0m"

announce "Clean up old stuff first"
rm -rf $BINARIES_PATH/* && mkdir -p $BINARIES_PATH >/dev/null 2>&1
mkdir -p "$GO_DIR" >/dev/null 2>&1

if [ -d "$HOME/osmedeus-base/data" ]; then
    announce "Backup old osmedeus custom data. If you want a fresh install please run the command: \033[0mrm -rf $HOME/osmedeus-base $HOME/.osmedeus\033[0m"
    rm -rf $BAK_DIST 
    mv $HOME/osmedeus-base $BAK_DIST
fi

announce "Cloning Osmedeus base repo:\033[0m https://github.com/osmedeus/osmedeus-base"
rm -rf $BASE_PATH && git clone --depth=1 https://github.com/osmedeus/osmedeus-base $BASE_PATH
# # retry to clone in case of anything wrong with the connection
if [ ! -d "$BASE_PATH" ]; then
    git clone --depth=1 https://github.com/osmedeus/osmedeus-base $BASE_PATH
fi

[ -z "$(which osmedeus)" ] && osmBin=/usr/local/bin/osmedeus || osmBin=$(which osmedeus)
announce "Setup Osmedeus Core Engine:\033[0m $osmBin"
if [[ "$OSTYPE" == "darwin"* ]]; then
    unzip -q -o -j $BASE_PATH/dist/osmedeus-macos.zip -d $BASE_PATH/dist/
else
    unzip -q -o -j $BASE_PATH/dist/osmedeus-linux.zip -d $BASE_PATH/dist/
fi
rm -rf $osmBin && cp $BASE_PATH/dist/osmedeus $osmBin && chmod +x $osmBin
if [ ! -f "$osmBin" ]; then
    echo "[!] Unable to copy the Osmedeus binary to: $osmBin"
    osmBin="$BINARIES_PATH/osmedeus"
    announce "Copying Osmedeus binary to $osmBin instead"
fi

######## Start to install binaries

mkdir -p $BINARIES_PATH >/dev/null 2>&1

install_banner "massdns"
cd $BINARIES_PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install massdns -q
    cp $(which massdns) $BINARIES_PATH/massdns
else
    git clone --depth=1 https://github.com/blechschmidt/massdns build-massdns
    rm -rf build-massdns/.git
    cd build-massdns
    make 2>&1 > /dev/null
    cp bin/massdns /usr/local/bin/
    cp bin/massdns $BINARIES_PATH/massdns
fi
cd $BASE_PATH

## findomain
install_banner "findomain"
if [[ "$OSTYPE" == "darwin"* ]]; then
    wget -q -O $BINARIES_PATH/findomain https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-osx
else
    wget -q -O $BINARIES_PATH/findomain https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux
fi
chmod +x $BINARIES_PATH/findomain

install_banner "packer"
rm -rf /tmp/packer.zip
if [[ "$OSTYPE" == "darwin"* ]]; then
    download $TMP_DIST/packer.zip https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_darwin_amd64.zip
else
    download $TMP_DIST/packer.zip https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_linux_amd64.zip
fi
extractZip $TMP_DIST/packer.zip

install_banner "csvtk"
if [[ "$OSTYPE" == "darwin"* ]]; then
    download $TMP_DIST/csvtk.gz https://github.com/shenwei356/csvtk/releases/download/v0.22.0/csvtk_darwin_amd64.tar.gz
else
    download $TMP_DIST/csvtk.gz https://github.com/shenwei356/csvtk/releases/download/v0.22.0/csvtk_linux_amd64.tar.gz
fi
extractGz $TMP_DIST/csvtk.gz

install_banner "rustscan"
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install rustscan -q
else
    wget -q -O /tmp/rustscan.deb https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb
    dpkg -i /tmp/rustscan.deb 2>&1 > /dev/null
    rm -rf /tmp/rustscan.deb
fi
cp $(which rustscan) $BINARIES_PATH/rustscan

cd $CWD

# update golang version
install_banner "Golang latest version"
wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

export GO_BIN="$HOME/.go/bin/go"
export GOROOT=$HOME/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# in case the script fail
[[ -f $GO_BIN ]] || GO_BIN=$(which go)
echo -e "\033[1;32m[+] Detected go binary: $GO_BIN \033[0m"
[[ -d $GO_DIR ]] || GO_DIR=$GOPATH/bin
echo -e "\033[1;32m[+] Detected go tools: $GO_DIR \033[0m"

cd $CWD

##
# Install go stuff
##
install_banner "goaltdns"
$GO_BIN get -ldflags "-s -w" -u github.com/subfinder/goaltdns 2>&1 > /dev/null
install_banner "assetfinder"
$GO_BIN get -ldflags "-s -w" -u github.com/tomnomnom/assetfinder 2>&1 > /dev/null
install_banner "httprobe"
$GO_BIN get -ldflags "-s -w" -u github.com/tomnomnom/httprobe 2>&1 > /dev/null
install_banner "unfurl"
$GO_BIN get -ldflags "-s -w" -u github.com/tomnomnom/unfurl 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/tomnomnom/anew 2>&1 > /dev/null
install_banner "go cli-utils"
$GO_BIN get -ldflags "-s -w" -u github.com/shenwei356/rush/ 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/chrunk 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/cinfo 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/eip 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/durl 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/ourl 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/urp 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/cleansub 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/go-auxs/cdnfilter 2>&1 > /dev/null
$GO_BIN get -ldflags "-s -w" -u github.com/theblackturtle/ptools/wurl 2>&1 > /dev/null
install_banner "goverview"
$GO_BIN get -ldflags "-s -w" -u github.com/j3ssie/goverview 2>&1 > /dev/null
install_banner "github-endpoints"
$GO_BIN get -ldflags "-s -w" -u github.com/gwen001/github-endpoints 2>&1 > /dev/null
install_banner "github-subdomains"
$GO_BIN get -ldflags "-s -w" -u github.com/gwen001/github-subdomains 2>&1 > /dev/null
GO111MODULE=off $GO_BIN get -u github.com/Josue87/gotator 2>&1 > /dev/null
install_banner "puredns"
$GO_BIN get -u github.com/d3mondev/puredns/v2 2>&1 > /dev/null

install_banner "amass"
GO111MODULE=on $GO_BIN get github.com/OWASP/Amass/v3/... 2>&1 > /dev/null
install_banner "gau"
GO111MODULE=on $GO_BIN get -u github.com/lc/gau 2>&1 > /dev/null
install_banner "shuffledns"
GO111MODULE=on $GO_BIN get github.com/projectdiscovery/shuffledns/cmd/shuffledns 2>&1 > /dev/null
install_banner "dnsx"
GO111MODULE=on $GO_BIN get github.com/projectdiscovery/dnsx/cmd/dnsx 2>&1 > /dev/null
install_banner "nuclei"
$GO_BIN install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest 2>&1 > /dev/null
install_banner "subfinder"
$GO_BIN install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>&1 > /dev/null
install_banner "jaeles"
GO111MODULE=on $GO_BIN install github.com/jaeles-project/jaeles@latest 2>&1 > /dev/null
install_banner "metabigor"
GO111MODULE=on $GO_BIN install github.com/j3ssie/metabigor@latest 2>&1 > /dev/null

echo -e "\033[1;32m[+] Copy all go tools from: $GO_DIR \033[0m"
cp $GO_DIR/* $BINARIES_PATH/ >/dev/null 2>&1
chmod +x $BINARIES_PATH/*
export PATH=$BINARIES_PATH:$PATH

###### done the binaries part

isInFile=$(cat $DEFAULT_SHELL | grep -c "osm-default.rc")
if [ $isInFile -eq 0 ]; then
   echo 'source $HOME/osmedeus-base/token/osm-default.rc' >> $DEFAULT_SHELL
fi
isInFile=$(cat $DEFAULT_SHELL | grep -c "[[ -f $DEFAULT_SHELL ]]")
if [ $isInFile -eq 0 ]; then
   echo "[[ -f $DEFAULT_SHELL ]] && . $DEFAULT_SHELL" >> $HOME/.bash_profile
fi

osmedeus config reload
install_banner "Osmedeus Web UI"
rm -rf $HOME/.osmedeus/server/* >/dev/null 2>&1
mkdir -p $HOME/.osmedeus/server >/dev/null 2>&1
cp -R $BASE_PATH/ui $HOME/.osmedeus/server/ui >/dev/null 2>&1

install_banner "Osmedeus Community Workflow:\033[0m https://github.com/osmedeus/osmedeus-workflow"
rm -rf $BASE_PATH/workflow >/dev/null 2>&1
git clone --depth=1 https://github.com/osmedeus/osmedeus-workflow $BASE_PATH/workflow
## retry to clone in case of anything wrong with the connection
if [ ! -d "$BASE_PATH/workflow" ]; then
    git clone --depth=1 https://github.com/osmedeus/osmedeus-workflow $BASE_PATH
fi

install_banner "Downloading Vulnscan template"
jaeles config init >/dev/null 2>&1
rm -rf $HOME/nuclei-templates && git clone --depth=1 https://github.com/projectdiscovery/nuclei-templates.git $HOME/nuclei-templates >/dev/null 2>&1

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

###### Private installation for premium package

if [ -f "$BASE_PATH/secret/secret.sh" ]; then
    install_banner "private component"
    . $BASE_PATH/secret/secret.sh
fi

echo "---->>>"
osmedeus health
echo "---->>>"
announce "The installation is done..."
announce "Check here if you want to setup API & token:\033[0m https://docs.osmedeus.org/installation/token/"
announce "Run\033[0m source ~/.bashrc \033[1;32m to complete the install"
announce "Run\033[0m osmedeus config reload \033[1;32m to reload the config file"
