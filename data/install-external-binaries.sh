install_banner "Amass"
download $TMP_DIST/amass.zip https://github.com/OWASP/Amass/releases/download/v3.23.3/amass_linux_amd64.zip
extractZip $TMP_DIST/amass.zip

install_banner "subfinder"
download $TMP_DIST/subfinder.zip https://github.com/projectdiscovery/subfinder/releases/download/v2.6.0/subfinder_2.6.0_linux_amd64.zip
extractZip $TMP_DIST/subfinder.zip

install_banner "nuclei"
download $TMP_DIST/nuclei.zip https://github.com/projectdiscovery/nuclei/releases/download/v2.9.7/nuclei_2.9.7_linux_amd64.zip
extractZip $TMP_DIST/nuclei.zip

install_banner "httpx"
download $TMP_DIST/httpx.zip https://github.com/projectdiscovery/httpx/releases/download/v1.3.3/httpx_1.3.3_linux_amd64.zip
extractZip $TMP_DIST/httpx.zip

install_banner "tlsx"
download $TMP_DIST/tlsx.zip https://github.com/projectdiscovery/tlsx/releases/download/v1.1.0/tlsx_1.1.0_linux_amd64.zip
extractZip $TMP_DIST/tlsx.zip

install_banner "katana"
download $TMP_DIST/katana.zip https://github.com/projectdiscovery/katana/releases/download/v1.0.2/katana_1.0.2_linux_amd64.zip
extractZip $TMP_DIST/katana.zip

install_banner "dnsx"
download $TMP_DIST/dnsx.zip https://github.com/projectdiscovery/dnsx/releases/download/v1.1.4/dnsx_1.1.4_linux_amd64.zip
extractZip $TMP_DIST/dnsx.zip

install_banner "alterx"
download $TMP_DIST/alterx.zip https://github.com/projectdiscovery/alterx/releases/download/v0.0.2/alterx_0.0.2_linux_amd64.zip
extractZip $TMP_DIST/alterx.zip

install_banner "gau"
download $TMP_DIST/gau.gz https://github.com/lc/gau/releases/download/v2.1.2/gau_2.1.2_linux_amd64.tar.gz
extractGz $TMP_DIST/gau.gz

install_banner "ffuf"
download $TMP_DIST/ffuf.gz https://github.com/ffuf/ffuf/releases/download/v2.0.0/ffuf_2.0.0_linux_amd64.tar.gz
extractGz $TMP_DIST/ffuf.gz

install_banner "gospider"
download $TMP_DIST/gospider.zip https://github.com/jaeles-project/gospider/releases/download/v1.1.6/gospider_v1.1.6_linux_x86_64.zip
extractZip $TMP_DIST/gospider.zip

install_banner "jaeles"
download $TMP_DIST/jaeles.zip https://github.com/jaeles-project/jaeles/releases/download/beta-v0.17/jaeles-v0.17-linux.zip
extractZip $TMP_DIST/jaeles.zip

install_banner "metabigor"
download $TMP_DIST/metabigor.gz https://github.com/j3ssie/metabigor/releases/download/v1.2.4/metabigor_v1.2.4_linux_amd64.tar.gz
extractGz $TMP_DIST/metabigor.gz

install_banner "goverview"
download $TMP_DIST/goverview.gz https://github.com/j3ssie/goverview/releases/download/v1.0.1/goverview_v1.0.1_linux_amd64.tar.gz
extractGz $TMP_DIST/goverview.gz

install_banner "aquatone"
download $TMP_DIST/aquatone.zip https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
extractZip $TMP_DIST/aquatone.zip

install_banner "gowitness"
download $TMP_DIST/gowitness https://github.com/sensepost/gowitness/releases/download/2.5.0/gowitness-2.5.0-linux-amd64
cp $TMP_DIST/gowitness $BINARIES_PATH/gowitness

install_banner "trufflehog"
download $TMP_DIST/trufflehog.gz https://github.com/trufflesecurity/trufflehog/releases/download/v3.42.0/trufflehog_3.42.0_linux_amd64.tar.gz
extractGz $TMP_DIST/trufflehog.gz

install_banner "gitleaks"
download $TMP_DIST/gitleaks.gz https://github.com/gitleaks/gitleaks/releases/download/v8.17.0/gitleaks_8.17.0_linux_x64.tar.gz
extractGz $TMP_DIST/gitleaks.gz

install_banner "findomain"
download $TMP_DIST/findomain.zip https://github.com/Findomain/Findomain/releases/download/9.0.0/findomain-linux.zip
extractZip $TMP_DIST/findomain.zip

