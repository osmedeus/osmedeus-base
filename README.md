# Osmedeus Base Community

<p align="center">
  <img alt="Osmedeus" src="https://raw.githubusercontent.com/osmedeus/assets/main/logo-transparent.png" height="140" />
  <br />
  <strong>Osmedeus - A Workflow Engine for Offensive Security</strong>

  <p align="center">
  <a href="https://docs.osmedeus.org/"><img src="https://img.shields.io/badge/Documentation-0078D4?style=for-the-badge&logo=GitBook&logoColor=39ff14&labelColor=black&color=black"></a>
  <a href="https://docs.osmedeus.org/donation/"><img src="https://img.shields.io/badge/Sponsors-0078D4?style=for-the-badge&logo=GitHub-Sponsors&logoColor=39ff14&labelColor=black&color=black"></a>
  <a href="https://twitter.com/OsmedeusEngine"><img src="https://img.shields.io/badge/%40OsmedeusEngine-0078D4?style=for-the-badge&logo=Twitter&logoColor=39ff14&labelColor=black&color=black"></a>
  <a href="https://discord.gg/gy4SWhpaPU"><img src="https://img.shields.io/badge/Discord%20Server-0078D4?style=for-the-badge&logo=Discord&logoColor=39ff14&labelColor=black&color=black"></a>
  <a href="https://discord.gg/gy4SWhpaPU"><img src="https://img.shields.io/github/release/j3ssie/osmedeus?style=for-the-badge&labelColor=black&color=2fc414&logo=Github"></a>
  </p>
</p>

***

## Installation for Linux

> NOTE that you need some essential tools like `curl, wget, git, zip` and login as **root** to start

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install.sh)"
```

## Installation for MacOS (experimental)

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install-macos.sh)"
```

Check out [this page](https://docs.osmedeus.org/installation/) for more the install on other platforms


## Usage

```shell
# Practical Usage:
osmedeus scan -f [flowName] -t [target]
osmedeus scan -f [flowName] -T [targetsFile]
osmedeus scan -f /path/to/flow.yaml -t [target]
osmedeus scan -m /path/to/module.yaml -t [target] --params 'port=9200'
osmedeus scan -m /path/to/module.yaml -t [target] -l /tmp/log.log
cat targets | osmedeus scan -f sample

## Start a simple scan with default 'general' flow
osmedeus scan -t sample.com

## Start a scan directly with a module with inputs as a list of http domains like this https://sub.example.com
osmedeus scan -m ~/osmedeus-base/workflow/direct-module/dirbscan.yaml -t http-file.txt

## Start a general scan but exclude some of the module
osmedeus scan -t sample.com -x screenshot -x spider

## Start a simple scan with other flow
osmedeus scan -f vuln -t sample.com

## Scan for CIDR with file contains CIDR with the format '1.2.3.4/24'
osmedeus scan -f cidr -t list-of-cidrs.txt
osmedeus scan -f cidr -t '1.2.3.4/24' # this will auto convert the single input to the file and run

## Directly run the vuln scan and directory scan on list of domains
osmedeus scan -f vuln-and-dirb -t list-of-domains.txt

## Directly run the general but without subdomain enumeration scan on list of domains
osmedeus scan -f domains -t list-of-domains.txt

## Use a custom wordlist
osmedeus scan -t sample.com -p 'wordlists={{.Data}}/wordlists/content/big.txt' -p 'fthreads=40'

## Scan list of targets
osmedeus scan -T list_of_targets.txt

## Get target from a stdin and start the scan with 2 concurrency
cat list_of_targets.txt | osmedeus scan -c 2

## Start the scan with your custom workflow folder
osmedeus scan --wfFolder ~/custom-workflow/ -f your-custom-workflow -t sample.com

# Example Commands:
osmedeus scan -t target.com
osmedeus scan -T list_of_targets.txt -W custom_workspaces
osmedeus scan -t target.com -w workspace_name --debug
osmedeus scan -f single -t www.sample.com
osmedeus scan -f ovuln-T list_of_target.txt
osmedeus scan -m ~/osmedeus-base/workflow/test/dirbscan.yaml -t list_of_urls.txt
osmedeus health
ls ~/.osmedeus/storages/summary/ | osmedeus scan -m ~/osmedeus-base/workflow/test/dirbscan.yaml
ls ~/.osmedeus/storages/summary/ | osmedeus scan -m ~/osmedeus-base/workflow/test/busting.yaml -D

# Start Web UI at https://<your-instance-machine>:8000/ui/
osmedeus server
# login with credentials from `~/.osmedeus/config.yaml`

# Delete workspace
osmedeus config delete -w workspace_name

# Utils Commands

osmedeus utils tmux ls
osmedeus utils tmux logs -A -l 10
osmedeus utils ps
osmedeus utils ps --proc 'jaeles'
osmedeus utils cron --cmd 'osmdeus scan -t example.com' --sch 60
osmedeus utils cron --for --cmd 'osmedeus scan -t example.com'
```

## Using Docker

```shell
docker run -it j3ssie/osmedeus:latest scan -t example.com
```

Check this page for more [docker usage](https://docs.osmedeus.org/installation/using-docker/)

## 💬 Community & Discussion

Join Our Discord server [here](https://discord.gg/gy4SWhpaPU)

## 💎 Donation & Sponsor

<p align="center">
 <img alt="Osmedeus" src="https://raw.githubusercontent.com/osmedeus/assets/main/premium-package.gif" />

 <p align="center"> Check out for a couple of <strong><a href="https://docs.osmedeus.org/donation/">donation methods here</a></strong> to get a <strong><a href="https://docs.osmedeus.org/premium/">premium package</a></strong><p>
</p>


## License

`Osmedeus` is made with ♥ by [@j3ssiejjj](https://twitter.com/j3ssiejjj) and it is released under the MIT license.
