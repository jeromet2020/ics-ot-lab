## Setting up Proxmox to allow VM deployments using Terraform

To automate deployment of multiple VMs with predefined configurations such as network configuration, and credentials, terraform is used.

To setup Proxmox to allow terraform usage, create a role, user, and API token using the following commands:
```
pveum role add Terraform -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"

pveum user add terraform-team1@pve

pveum aclmod / -user terraform-team1@pve -role Terraform

pveum user token add terraform-team1@pve terraform-team1-token --privsep 0

```