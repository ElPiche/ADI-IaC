variable "virtual_environment_endpoint" {
    //change this accord your needs
    default = "https://176.160.0.100:8006/"
}

variable "PROXMOX_VE_USERNAME" {
    default = "root@pam"
}

variable "PROXMOX_VE_PASSWORD" {
    default = "root123"
}
//You should add your host ssh key, and your ansible ssh key
variable "ROOT_SSH_KEY" {

    default = ""    
}

variable "LXC_ROOT_PASSWORD" {
    default = "Passw0rd"
}

variable "LXC_DEFAULT_TEMPLATE" {
    default = "local:vztmpl/debian-11-standard_11.7-1_amd64.tar.zst"
}

variable "LXC_DEFAULT_TYPE" {
    default = "debian"
}