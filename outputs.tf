output "instance_public_ip" {
  value = aws_instance.vault_server.public_ip
}
