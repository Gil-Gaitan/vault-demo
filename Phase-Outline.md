# ✅ Terraform + Vault + AWS VPN Demo Notes

## Phase 0: Prep

**Goal**: Ensure all prerequisites are ready.

- ✅ **Terraform Cloud**  
  - Username: Gaitan  
  - Email: chefgaitan  
  - Password: `S1`  

- ✅ **AWS Account (IAM User)**  
  - Email: <gaitanAWS@plantseedscook.com>  
  - Password: `a&Taa&T80` (works in Safari)

- ✅ **Vault CLI Installed Locally**  
  - Check: `vault version`  
  - Install: `brew install vault`

- ✅ **AWS VPN Client Installed**  
  - Install: `brew install --cask aws-vpn-client`

> ✅ *Phase 0 Complete*

---

## Phase 1: Terraform Infrastructure

**Goal**: Deploy VPC, Subnet, EC2.

- Run `terraform apply`
- Confirm EC2 is up
- ✅ *Done*

---

## Phase 2: Vault Setup

**Goal**: Install and run Vault on EC2.

1. **SSH into EC2 instance**  

   ```bash
   ssh -i ~/.ssh/vault-demo-key.pem ubuntu@<PUBLIC_IP>
   ```

2. **Install Vault manually**

   ```bash
   sudo apt-get update -y
   sudo apt-get install -y unzip curl
   curl -O https://releases.hashicorp.com/vault/1.15.4/vault_1.15.4_linux_amd64.zip
   unzip vault_1.15.4_linux_amd64.zip
   sudo mv vault /usr/local/bin/vault
   vault version
   ```

3. **Start Vault in dev mode**

   ```bash
   vault server -dev
   ```

4. **Open second terminal** (keep dev server running)

   ```bash
   ssh -i ~/.ssh/vault-demo-key.pem ubuntu@<PUBLIC_IP>
   export VAULT_ADDR='http://127.0.0.1:8200'
   export VAULT_TOKEN='hvs.xxxxxxx'  # Use the actual root token from vault dev output
   vault status
   ```

> 📸 Screenshot taken of initialized + unsealed state

---

## Phase 3: VPN Setup

**Goal**: Securely connect to the VPC via VPN.

### 1. Generate SSL Certificate

```bash
chmod +x scripts/generate_cert.sh
./scripts/generate_cert.sh
```

Creates:

- `vpn-server-cert.pem`
- `vpn-server-key.pem`

### 2. Apply VPN Terraform

- Run `terraform apply`
- Takes ~5–10 minutes (normal for AWS VPN provisioning)

### 3. Confirm in AWS Console

- Navigate to:  
  **VPC → Client VPN Endpoints**
- Check:
  - Endpoint Status: *Available*
  - Subnet Association: *Available*
  - Authorization Rules: Allows access to VPC CIDR

---

## VPN Client Setup

1. Create a `.ovpn` file using generated certs:

```bash
client
dev tun
proto udp
remote <VPN_ENDPOINT_DNS> 443
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server

<ca>
# Paste vpn-server-cert.pem
</ca>

<cert>
# Paste vpn-server-cert.pem again
</cert>

<key>
# Paste vpn-server-key.pem
</key>
```

2. Import into AWS VPN Client
3. Connect (may take up to 1–2 min on first attempt)

> ✅ If connected: VPN assigned IP in `10.10.0.0/22`

---

## Next Phase (when resuming)

**Vault Dynamic Secrets**

- Create policy (`app_policy.hcl`)
- Enable AppRole or Token Auth
- Issue short-lived secrets
