#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from sys import argv
import requests

def get_version(repo):
    print("[*] Getting latest version of {}".format(repo))
    response = requests.get("https://api.github.com/repos/{0}/releases/latest".format(repo))
    version = response.json()["name"]
    if version == "":
        version = response.json()["tag_name"]
    return version


def generate_content():
    content = ''
    content += 'install_banner "Amass"\n'
    line = "download $TMP_DIST/amass.gz https://github.com/OWASP/Amass/releases/download/{version}/amass_linux_amd64.tar.gz".format(version=get_version("OWASP/Amass"))
    line += "\nextractGz $TMP_DIST/amass.gz\n"
    content += line + "\n"

    content += 'install_banner "httprobe"\n'
    binary_version = get_version("tomnomnom/httprobe").strip("v")
    line = "download $TMP_DIST/httprobe.gz https://github.com/tomnomnom/httprobe/releases/download/v{version}/httprobe-linux-amd64-{version}.tgz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/httprobe.gz\n"
    content += line + "\n"

    content += 'install_banner "subfinder"\n'
    binary_version = get_version("projectdiscovery/subfinder").strip("v")
    line = "download $TMP_DIST/subfinder.zip https://github.com/projectdiscovery/subfinder/releases/download/v{version}/subfinder_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/subfinder.zip\n"
    content += line + "\n"

    content += 'install_banner "nuclei"\n'
    binary_version = get_version("projectdiscovery/nuclei").strip("v")
    line = "download $TMP_DIST/nuclei.zip https://github.com/projectdiscovery/nuclei/releases/download/v{version}/nuclei_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/nuclei.zip\n"
    content += line + "\n"

    content += 'install_banner "httpx"\n'
    binary_version = get_version("projectdiscovery/httpx").strip("v")
    line = "download $TMP_DIST/httpx.zip https://github.com/projectdiscovery/httpx/releases/download/v{version}/httpx_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/httpx.zip\n"
    content += line + "\n"

    content += 'install_banner "tlsx"\n'
    binary_version = get_version("projectdiscovery/tlsx").strip("v")
    line = "download $TMP_DIST/tlsx.zip https://github.com/projectdiscovery/tlsx/releases/download/v{version}/tlsx_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/tlsx.zip\n"
    content += line + "\n"

    content += 'install_banner "katana"\n'
    binary_version = get_version("projectdiscovery/katana").strip("v")
    line = "download $TMP_DIST/katana.zip https://github.com/projectdiscovery/katana/releases/download/v{version}/katana_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/katana.zip\n"
    content += line + "\n"

    content += 'install_banner "dnsx"\n'
    binary_version = get_version("projectdiscovery/dnsx").strip("v")
    line = "download $TMP_DIST/dnsx.zip https://github.com/projectdiscovery/dnsx/releases/download/v{version}/dnsx_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/dnsx.zip\n"
    content += line + "\n"

    content += 'install_banner "alterx"\n'
    binary_version = get_version("projectdiscovery/alterx").strip("v")
    line = "download $TMP_DIST/alterx.zip https://github.com/projectdiscovery/alterx/releases/download/v{version}/alterx_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/alterx.zip\n"
    content += line + "\n"

    content += 'install_banner "urlfinder"\n'
    binary_version = get_version("projectdiscovery/urlfinder").strip("v")
    line = "download $TMP_DIST/urlfinder.zip https://github.com/projectdiscovery/urlfinder/releases/download/v{version}/urlfinder_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/urlfinder.zip\n"
    content += line + "\n"

    content += 'install_banner "notify"\n'
    binary_version = get_version("projectdiscovery/notify").strip("v")
    line = "download $TMP_DIST/notify.zip https://github.com/projectdiscovery/notify/releases/download/v{version}/notify_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/notify.zip\n"
    content += line + "\n"

    content += 'install_banner "naabu"\n'
    binary_version = get_version("projectdiscovery/naabu").strip("v")
    line = "download $TMP_DIST/naabu.zip https://github.com/projectdiscovery/naabu/releases/download/v{version}/naabu_{version}_linux_amd64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/naabu.zip\n"
    content += line + "\n"

    content += 'install_banner "gau"\n'
    binary_version = get_version("lc/gau").strip("v")
    line = "download $TMP_DIST/gau.gz https://github.com/lc/gau/releases/download/v{version}/gau_{version}_linux_amd64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/gau.gz\n"
    content += line + "\n"

    content += 'install_banner "ffuf"\n'
    binary_version = get_version("ffuf/ffuf").strip("v")
    line = "download $TMP_DIST/ffuf.gz https://github.com/ffuf/ffuf/releases/download/v{version}/ffuf_{version}_linux_amd64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/ffuf.gz\n"
    content += line + "\n"

    content += 'install_banner "gospider"\n'
    binary_version = get_version("jaeles-project/gospider")
    line = "download $TMP_DIST/gospider.zip https://github.com/jaeles-project/gospider/releases/download/{version}/gospider_{version}_linux_x86_64.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/gospider.zip\n"
    content += line + "\n"

    content += 'install_banner "jaeles"\n'
    binary_version = get_version("jaeles-project/jaeles")
    line = "download $TMP_DIST/jaeles.zip https://github.com/jaeles-project/jaeles/releases/download/{version}/jaeles-{version}-linux.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/jaeles.zip\n"
    content += line + "\n"

    content += 'install_banner "metabigor"\n'
    binary_version = get_version("j3ssie/metabigor")
    line = "download $TMP_DIST/metabigor.gz https://github.com/j3ssie/metabigor/releases/download/{version}/metabigor_{version}_linux_amd64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/metabigor.gz\n"
    content += line + "\n"

    content += 'install_banner "trufflehog"\n'
    binary_version = get_version("trufflesecurity/trufflehog").strip("v")
    line = "download $TMP_DIST/trufflehog.gz https://github.com/trufflesecurity/trufflehog/releases/download/v{version}/trufflehog_{version}_linux_amd64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/trufflehog.gz\n"
    content += line + "\n"

    content += 'install_banner "gitleaks"\n'
    binary_version = get_version("gitleaks/gitleaks").strip("v")
    line = "download $TMP_DIST/gitleaks.gz https://github.com/gitleaks/gitleaks/releases/download/v{version}/gitleaks_{version}_linux_x64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/gitleaks.gz\n"
    content += line + "\n"

    content += 'install_banner "findomain"\n'
    binary_version = get_version("Findomain/Findomain").split(" ")[1].strip("v")
    line = "download $TMP_DIST/findomain.zip https://github.com/Findomain/Findomain/releases/download/{version}/findomain-linux.zip".format(version=binary_version)
    line += "\nextractZip $TMP_DIST/findomain.zip\n"
    content += line + "\n"

    content += 'install_banner "durl"\n'
    binary_version = "0.2"
    line = "download $TMP_DIST/durl.gz https://github.com/j3ssie/durl/releases/download/v{version}/durl_{version}_linux_amd64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/durl.gz\n"
    content += line + "\n"

    content += 'install_banner "json-cleaner"\n'
    binary_version = "0.1"
    line = "download $TMP_DIST/json-cleaner.gz https://github.com/j3ssie/json-cleaner/releases/download/v{version}/json-cleaner_{version}_linux_amd64.tar.gz".format(version=binary_version)
    line += "\nextractGz $TMP_DIST/json-cleaner.gz\n"
    content += line + "\n"

    return content

def main():
    content = generate_content()
    with open("install-external-binaries.sh", "w") as f:
        f.write(content)
    print("==> Written to install-external-binaries.sh")

main()
