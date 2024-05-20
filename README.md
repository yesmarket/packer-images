# packer-images

Misc Hashicorp Packer 'image as code' templates.

Includes the following templates:

* Azure Data Factory (ADF) self-hosted integration runtime (SHIR). There're mutliple use-cases for an ADF SHIR. One example is an SFTP sink activity might execute on a SHIR, so that third parties can whitelist a single IP address that we own (as opposed to multiple IP ranges owned my Microsoft).
* Strongswan IPSec VPN customer gateway. This was used for a site-to-site VPN POC in AWS and Azure.
* Tailscale app-connector - used to provide remote access to private third-party PaaS and SaaS applications - see [here](https://tailscale.com/kb/1281/app-connectors).
* Tailscale subnet-router used to provide remote access to a VMs in a private subnet (or peered network) - see [here](https://tailscale.com/kb/1019/subnets).

