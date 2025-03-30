# output "vm_private_keys" {
#   description = "Private keys of all VMs"
#   value       = { for vm in local.vm_names : vm => module.swarm-cluster[vm].private_key_pem }
#   sensitive   = true
# }

# output "vm_public_ips" {
#   description = "Public IP addresses of all VMs"
#   value       = { for vm in local.vm_names : vm => module.swarm-cluster[vm].vm_public_ips }
# }

# output "network_interfaces" {
#   description = "Private IP addresses of all VMs"
#   value       = { for vm in local.vm_names : vm => module.swarm-cluster[vm].network_interfaces }
# }
