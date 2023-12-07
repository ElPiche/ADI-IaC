data "proxmox_virtual_environment_datastores" "default" {
  node_name = data.proxmox_virtual_environment_nodes.default.names[0]
}

output "data_proxmox_virtual_environment_datastores_default_datastore_ids" {
  value = data.proxmox_virtual_environment_datastores.default.datastore_ids
}