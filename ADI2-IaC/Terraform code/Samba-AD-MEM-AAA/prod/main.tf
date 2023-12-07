terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.33.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.virtual_environment_endpoint
  username = var.PROXMOX_VE_USERNAME
  password = var.PROXMOX_VE_PASSWORD
  insecure = true
}

resource "proxmox_virtual_environment_container" "lxc-ad" {
  description = "Administrado desde Terraform"
  count = 1

  disk {
    datastore_id = element(data.proxmox_virtual_environment_datastores.default.datastore_ids, index(data.proxmox_virtual_environment_datastores.default.datastore_ids, "local-lvm"))
    size         = 15
  }

  initialization {
    dns {
      domain = "ltadi02.tim.edu.uy"
      server = "127.0.0.1"
    }

    hostname = "lt-${basename(abspath(path.module))}-ad${count.index+1}"

    ip_config {
      ipv4 {
        address = "176.160.0.20${count.index+1}/24"
        gateway = "176.160.0.1"
      }      
    }

    user_account {
      keys = [var.ROOT_SSH_KEY]
      password = var.LXC_ROOT_PASSWORD
    }
  }

  network_interface {
    name = "veth0"
    mtu  = 1450
  }
  node_name = data.proxmox_virtual_environment_nodes.default.names[0]

  operating_system {
    template_file_id = var.LXC_DEFAULT_TEMPLATE
    type             = var.LXC_DEFAULT_TYPE
  }

  features {
    nesting = true
    fuse = true
    keyctl = true
  }  

  tags = [
    "container",
    "terraform",
    "${basename(abspath(path.module))}"
  ]
}

resource "proxmox_virtual_environment_container" "lxc-miembro" {
  description = "Administrado desde Terraform"
  count = 1

  disk {
    datastore_id = element(data.proxmox_virtual_environment_datastores.default.datastore_ids, index(data.proxmox_virtual_environment_datastores.default.datastore_ids, "local-lvm"))
    size         = 15
  }

  initialization {
    dns {
      domain = "ltadi02.tim.edu.uy"
      server = "176.160.0.201"
    }

    hostname = "lt-${basename(abspath(path.module))}-mem${count.index+1}"

    ip_config {
      ipv4 {
        address = "176.160.0.21${count.index+1}/24"
        gateway = "176.160.0.1"
      }      
    }

    user_account {
      keys = [var.ROOT_SSH_KEY]
      password = var.LXC_ROOT_PASSWORD
    }
  }

  network_interface {
    name = "veth0"
    mtu  = 1450
  }
  node_name = data.proxmox_virtual_environment_nodes.default.names[0]

  operating_system {
    template_file_id = var.LXC_DEFAULT_TEMPLATE
    type             = var.LXC_DEFAULT_TYPE
  }

  features {
    nesting = true
    fuse = true
    keyctl = true
  }  

  tags = [
    "container",
    "terraform",
    "${basename(abspath(path.module))}"
  ]
}

resource "proxmox_virtual_environment_container" "lxc-aaa" {
  description = "Administrado desde Terraform"
  count = 1

  disk {
    datastore_id = element(data.proxmox_virtual_environment_datastores.default.datastore_ids, index(data.proxmox_virtual_environment_datastores.default.datastore_ids, "local-lvm"))
    size         = 15
  }

  initialization {
    dns {
      domain = "ltadi02.tim.edu.uy"
      server = "176.160.0.201"
    }

    hostname = "lt-${basename(abspath(path.module))}-aaa${count.index+1}"

    ip_config {
      ipv4 {
        address = "176.160.0.212/24"
        gateway = "176.160.0.1"
      }      
    }

    user_account {
      keys = [var.ROOT_SSH_KEY]
      password = var.LXC_ROOT_PASSWORD
    }
  }

  network_interface {
    name = "veth0"
    mtu  = 1450
  }
  node_name = data.proxmox_virtual_environment_nodes.default.names[0]

  operating_system {
    template_file_id = var.LXC_DEFAULT_TEMPLATE
    type             = var.LXC_DEFAULT_TYPE
  }

  features {
    nesting = true
    fuse = true
    keyctl = true
  }  

  tags = [
    "container",
    "terraform",
    "${basename(abspath(path.module))}"
  ]
}


