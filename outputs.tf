output "Bastion_public_ip" {
  description = "Bastion host public IP"
  value       = data.aws_instance.bastion.public_ip
}
