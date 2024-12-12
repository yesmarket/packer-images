# Overview

This repo contains some misc Packer 'image as code' templates.

# Packer Images

* Azure Data Factory (ADF) self-hosted integration runtime (SHIR). There're mutliple use-cases for an ADF SHIR. One example is an SFTP sink activity might execute on a SHIR, so that third parties can whitelist a single IP address that we own (as opposed to multiple IP ranges owned my Microsoft).
* Ansible Control Node.
* Strongswan IPSec VPN customer gateway. This was used for a site-to-site VPN POC in AWS and Azure.
* Tailscale app-connector - used to provide remote access to private third-party PaaS and SaaS applications - see [here](https://tailscale.com/kb/1281/app-connectors).
* Tailscale subnet-router used to provide remote access to a VMs in a private subnet (or peered network) - see [here](https://tailscale.com/kb/1019/subnets).

# Building an image

Navigate to one of the packer template sub-directories and run:

`packer build -force .`
