#!/bin/bash

set -e

# Settings
CERT_DIR="./certs"
mkdir -p $CERT_DIR

echo "Generating Private Key..."
openssl genrsa -out $CERT_DIR/vpn-server-key.pem 2048

echo "Generating Certificate Signing Request (CSR)..."
openssl req -new -key $CERT_DIR/vpn-server-key.pem -out $CERT_DIR/vpn-server.csr -subj "/CN=vpn.demo.internal"

echo "Generating Self-Signed Certificate..."
openssl x509 -req -in $CERT_DIR/vpn-server.csr -signkey $CERT_DIR/vpn-server-key.pem -out $CERT_DIR/vpn-server-cert.pem -days 365

echo "Certificates generated:"
ls -l $CERT_DIR
