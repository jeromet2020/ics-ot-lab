# How to deploy the VMs using Terraform on Proxmox

## Requirements
* VM template with cloud-init configured. Refer to the instructions in this repo on how to create the template VM.
* Proxmox API token with sufficient permissions to run terraform. Refer to the instructions in this repo on how to configure Proxmox to allow VM deployment using terraform.

## How to deploy VMs using terraform

* Install terraform on your Linux, MacOS, or Windows machine.
* Clone the source from this repo. Or, download the main.tf, transform.tfvars, and variables.tf.
* Modify the terraform.tfvars file with VM name, IP, disk, ID, etc. according to your desired specifications. In this file, copy the code block that's enclosed in curly brackets and modify it to create new VM entry. For example:
```
  {
    name           = "XS-ENT-AD2"
    vm_id           = 90023
    target_node    = "ks"
    clone_template = "T1-template-Win2019-ci"
    full_clone     = false
    cores          = 2
    sockets        = 1
    cpu_type       = "kvm64"
    memory         = 4096
    disk_type      = "scsi"
    disk_size      = "32G"
    disk_storage   = "local-zfs"
    nic_model      = "virtio"
    nic0_bridge    = "vmbr2"
    nic0_tag       = 1
    nic1_bridge    = ""
    nic1_tag       = 0
    nic2_bridge    = ""
    nic2_tag       = 0
    ipconfig0      = "ip=10.21.5.32/24,gw=10.21.5.1"
    ipconfig1      = ""
    ipconfig2      = ""
    nameserver     = "8.8.8.8"
    searchdomain   = "mydomain.local"
    username       = "Administrator"
    password       = "P@ssw0rd$"
    bootdisk       = "scsi0"
    scsihw         = "virtio-scsi-single"
  }
```
Note: Each code block should be separated by a comma (,).

* Execute the following command to export the API token.
```
export PM_API_TOKEN_ID='<your_token_id>'

export PM_API_TOKEN_SECRET="<token_secret_value>"
```
* Run the following:
```
terraform init
terraform plan
terraform apply
```