output "private_key_pem" {
  description = "The private key in PEM format"
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "vm_public_ips" {
  description = "The public IP address of the virtual machine"
  value       = module.linuxvm.public_ips
}

output "network_interfaces" {
  description = "The private IP address of the virtual machine"
  value       = module.linuxvm.network_interfaces
}
