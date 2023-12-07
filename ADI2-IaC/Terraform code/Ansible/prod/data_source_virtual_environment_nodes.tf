data "proxmox_virtual_environment_nodes" "default" {}
output "data_proxmox_virtual_environment_nodes_default_names" {
  value = data.proxmox_virtual_environment_nodes.default.names
}