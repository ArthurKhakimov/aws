output "Bastion_public_ip" {
  description = "Bastion host public IP"
  value       = data.aws_instance.bastion.public_ip
}
output "Bastion_private_ip" {
  description = "Bastion host private IP"
  value       = data.aws_instance.bastion.private_ip
}
