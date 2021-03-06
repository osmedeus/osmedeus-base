install_banner "Amass"
download $TMP_DIST/amass.zip https://github.com/OWASP/Amass/releases/download/v3.19.3/amass_linux_amd64.zip
extractZip $TMP_DIST/amass.zip

install_banner "subfinder"
download $TMP_DIST/subfinder.zip https://github.com/projectdiscovery/subfinder/releases/download/v2.5.2/subfinder_2.5.2_linux_amd64.zip
extractZip $TMP_DIST/subfinder.zip

install_banner "nuclei"
download $TMP_DIST/nuclei.zip https://github.com/projectdiscovery/nuclei/releases/download/v2.7.3/nuclei_2.7.3_linux_amd64.zip
extractZip $TMP_DIST/nuclei.zip

install_banner "httpx"
download $TMP_DIST/httpx.zip https://github.com/projectdiscovery/httpx/releases/download/v1.2.3/httpx_1.2.3_linux_amd64.zip
extractZip $TMP_DIST/httpx.zip

install_banner "dnsx"
download $TMP_DIST/dnsx.zip https://github.com/projectdiscovery/dnsx/releases/download/v1.1.0/dnsx_1.1.0_linux_amd64.zip
extractZip $TMP_DIST/dnsx.zip

install_banner "gau"
download $TMP_DIST/gau.gz https://github.com/lc/gau/releases/download/v2.1.1/gau_2.1.1_linux_amd64.tar.gz
extractGz $TMP_DIST/gau.gz

install_banner "ffuf"
download $TMP_DIST/ffuf.gz https://github.com/ffuf/ffuf/releases/download/v1.5.0/ffuf_1.5.0_linux_amd64.tar.gz
extractGz $TMP_DIST/ffuf.gz

install_banner "gospider"
download $TMP_DIST/gospider.zip https://github.com/jaeles-project/gospider/releases/download/v1.1.6/gospider_v1.1.6_linux_x86_64.zip
extractZip $TMP_DIST/gospider.zip

install_banner "jaeles"
download $TMP_DIST/jaeles.zip https://github.com/jaeles-project/jaeles/releases/download/beta-v0.17/jaeles-v0.17-linux.zip
extractZip $TMP_DIST/jaeles.zip

install_banner "metabigor"
download $TMP_DIST/metabigor.gz https://github.com/j3ssie/metabigor/releases/download/v1.12.1/metabigor_v1.12.1_linux_amd64.tar.gz
extractGz $TMP_DIST/metabigor.gz

install_banner "goverview"
download $TMP_DIST/goverview.gz https://github.com/j3ssie/goverview/releases/download/v1.0.1/goverview_v1.0.1_linux_amd64.tar.gz
extractGz $TMP_DIST/goverview.gz

install_banner "aquatone"
download $TMP_DIST/aquatone.zip https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
extractZip $TMP_DIST/aquatone.zip

install_banner "gowitness"
download $TMP_DIST/gowitness https://github.com/sensepost/gowitness/releases/download/2.4.0/gowitness-2.4.0-linux-amd64
