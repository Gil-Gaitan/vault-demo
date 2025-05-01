# Generate server and client certificates and keys
resource "aws_acm_certificate" "vpn_cert" {
  private_key      = file("${path.module}/certs/vpn-server-key.pem")  # Path to the private key
  certificate_body = file("${path.module}/certs/vpn-server-cert.pem") # Path to the server certificate
}

# Create a Client VPN Endpoint
resource "aws_ec2_client_vpn_endpoint" "vault_vpn" {
  description            = "Vault VPN Demo"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = "10.10.0.0/24" # VPN clients get IPs here
  split_tunnel           = true
  vpc_id                 = aws_vpc.vault_vpc.id # VPC ID for the VPN
  self_service_portal    = "enabled"
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_cert.arn
  }
  connection_log_options {
    enabled = false
  }
}

# Associate a target network with the Client VPN Endpoint
resource "aws_ec2_client_vpn_network_association" "vpn_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vault_vpn.id
  subnet_id              = aws_subnet.vault_subnet.id
}

# Create a Client VPN Authorization Rule
resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vault_vpn.id
  target_network_cidr    = var.subnet_cidr
  authorize_all_groups   = true
}

# Provide access to the internet

# Create a Route for the Client VPN Endpoint?
