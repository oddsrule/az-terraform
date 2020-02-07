output "bastionPublicIpOutput" {
  value       = data.azurerm_public_ip.bastionpublicip.ip_address
  description = "The Public IP Address of the bastion server is"
}
