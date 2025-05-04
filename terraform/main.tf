terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://localhost:8006/api2/json"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "vms" {
  for_each    = { for vm in var.vms : vm.name => vm }

  name        = each.value.name
  target_node = each.value.target_node
  clone       = each.value.clone_template
  full_clone  = each.value.full_clone

  agent       = 1
  onboot      = true

  cores       = each.value.cores
  sockets     = each.value.sockets
  cpu         = each.value.cpu_type
  memory      = each.value.memory

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = each.value.disk_storage
        }
      }
    }
    dynamic "scsi" {
      for_each = each.value.disk_type == "scsi" ? [1] : []
      content {
        scsi0 {
          disk {
            size     = each.value.disk_size
            storage  = each.value.disk_storage
            discard  = true
            iothread = true
          }
        }
      }
    }

    dynamic "sata" {
      for_each = each.value.disk_type == "sata" ? [1] : []
      content {
        sata0 {
          disk {
            size     = each.value.disk_size
            storage  = each.value.disk_storage
            discard  = true
          }
        }
      }
    }

  }

  # Required NIC 0
  network {
    id     = 0
    model  = each.value.nic_model
    bridge = each.value.nic0_bridge
    tag    = each.value.nic0_tag
  }

  # Optional NIC 1
  dynamic "network" {
    for_each = each.value.nic1_bridge != "" ? [1] : []
    content {
      id     = 1
      model  = each.value.nic_model
      bridge = each.value.nic1_bridge
      tag    = each.value.nic1_tag
    }
  }

  # Optional NIC 2
  dynamic "network" {
    for_each = each.value.nic2_bridge != "" ? [1] : []
    content {
      id     = 2
      model  = each.value.nic_model
      bridge = each.value.nic2_bridge
      tag    = each.value.nic2_tag
    }
  }

  ipconfig0    = each.value.ipconfig0
  ipconfig1    = each.value.ipconfig1
  ipconfig2    = each.value.ipconfig2
  nameserver   = each.value.nameserver
  searchdomain = each.value.searchdomain
  ciuser       = each.value.username
  cipassword   = each.value.password
  boot         = "c"
  bootdisk     = each.value.bootdisk
  scsihw       = each.value.scsihw
}
