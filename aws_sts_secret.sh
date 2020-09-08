#!/bin/bash
set -euo pipefail

echo "Login to vault with approle and fetching vault token..."
TOKEN=$(curl -s -S -f \
    -X POST -d "{\"role_id\":\"${ROLE_ID}\",\"secret_id\":\"${SECRET_ID}\"}" \
    "${VAULT_ADDR}/v1/auth/approle/login" | jq -r '.auth.client_token')

echo "Fetching aws credentials..."
RESPONSE=$(curl -s -S -f \
    -H "X-Vault-Token: ${TOKEN}" \
    "${VAULT_ADDR}/v1/aws/sts/${VAULT_AWS_SECRET_BACKEND_ROLE}?role_arn=${ASSUME_ROLE_ARN}")

AWS_ACCESS_KEY_ID="$(echo "${RESPONSE}" | jq -r '.data.access_key')"
AWS_SESSION_TOKEN="$(echo "${RESPONSE}" | jq -r '.data.security_token')"
AWS_SECRET_ACCESS_KEY="$(echo "${RESPONSE}" | jq -r '.data.secret_key')"

echo "Exporting aws credential as environment variables..."
echo ::add-mask::"${AWS_ACCESS_KEY_ID}"
echo ::add-mask::"${AWS_SESSION_TOKEN}"
echo ::add-mask::"${AWS_SECRET_ACCESS_KEY}"

echo ::set-env name=AWS_ACCESS_KEY_ID::"${AWS_ACCESS_KEY_ID}"
echo ::set-env name=AWS_SESSION_TOKEN::"${AWS_SESSION_TOKEN}"
echo ::set-env name=AWS_SECRET_ACCESS_KEY::"${AWS_SECRET_ACCESS_KEY}"
echo ::set-output name=aws_access_key_id::"${AWS_ACCESS_KEY_ID}"
echo ::set-output name=aws_session_token::"${AWS_SESSION_TOKEN}"
echo ::set-output name=aws_secret_access_key::"${AWS_SECRET_ACCESS_KEY}"

echo ::set-env name=ASSUME_ROLE_ARN::"${ASSUME_ROLE_ARN}"
echo ::set-output name=assume_role_arn::"${ASSUME_ROLE_ARN}"

echo ::set-env name=VAULT_AWS_SECRET_BACKEND_ROLE::"${VAULT_AWS_SECRET_BACKEND_ROLE}"
echo ::set-output name=vault_aws_secret_backend_role::"${VAULT_AWS_SECRET_BACKEND_ROLE}"

