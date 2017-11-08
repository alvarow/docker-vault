#!/bin/bash

# enable job control on bash
set -m 

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=00000000-0000-0000-0000-000000000000
echo "VAULT_ADDR=${VAULT_ADDR}"
echo "VAULT_TOKEN=${VAULT_TOKEN}"

echo "Starting Vault with: $@"

$@ &

# Give it a couple of seconds to start up
sleep 2

cd /vault

vault audit-enable file file_path=/vault/logs/audit.log

tail -f /vault/logs/audit.log &

vault write secret/DEV/keys/jwt public=@cert.pem private=@cert.key

cd -
echo "Bringing Vault back to foreground"
fg %1

