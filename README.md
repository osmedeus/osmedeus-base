# Osmedeus Base

<p align="center">
  <a href="https://www.osmedeus.org"><img alt="Osmedeus" src="https://raw.githubusercontent.com/osmedeus/assets/main/osm-logo-with-white-border.png" height="140" /></a>
  <br />
  <strong>Default Workflows & Configuration for Osmedeus Engine</strong>
</p>

<p align="center">
  <a href="https://docs.osmedeus.org/"><img src="https://img.shields.io/badge/Documentation-0078D4?style=for-the-badge&logo=GitBook&logoColor=39ff14&labelColor=black&color=black"></a>
  <a href="https://github.com/j3ssie/osmedeus"><img src="https://img.shields.io/badge/Osmedeus%20Engine-0078D4?style=for-the-badge&logo=Github&logoColor=39ff14&labelColor=black&color=black"></a>
  <a href="https://discord.gg/gy4SWhpaPU"><img src="https://img.shields.io/badge/Discord-0078D4?style=for-the-badge&logo=Discord&logoColor=39ff14&labelColor=black&color=black"></a>
</p>

## Overview

This repository contains the default ready-to-use workflows, configurations, and data files for the [Osmedeus Engine](https://github.com/j3ssie/osmedeus).

Use this as a starting point to run reconnaissance scans or as a reference for building your own custom environments setup.

## Quick Start

1. Install Osmedeus Engine:
   ```bash
   curl -sSL http://www.osmedeus.org/install.sh | bash
   ```

2. Clone this base repository:
   ```bash
   osmedeus install base https://github.com/osmedeus/osmedeus-base.git
   ```

3. Run a scan:
   ```bash
   # Full reconnaissance
   osmedeus run -f general -t example.com

   # Fast scan
   osmedeus run -f fast -t example.com

   # Individual module
   osmedeus run -m subdomain -t example.com
   ```


## Repository Structure

```
├── external-configs/             # Tool configuration files
├── external-data/                # Supporting data files
│   ├── wordlists/                # DNS, content, params wordlists
│   ├── rules/                    # Fingerprints & detection rules
│   └── mics/                     # Miscellaneous data
├── external-scripts/             # Custom scripts
├── external-agent-configs/       # LLM agent configurations
└── markdown-report-templates/    # Report templates
```


## Customization

### Adding API Keys

Edit the provider configuration files in `external-configs/`:

```yaml
# external-configs/subfinder-provider-config.yaml
securitytrails:
  - YOUR_API_KEY
shodan:
  - YOUR_API_KEY
```

## Documentation

- [Osmedeus Documentation](https://docs.osmedeus.org/)
- [CLI Reference](https://docs.osmedeus.org/getting-started/cli)

## License

Osmedeus is made with ♥ by [@j3ssie](https://twitter.com/j3ssie) and it is released under the MIT license.
