#!/bin/bash
#
# Get a GitHub Apps token.
#
set -eu
base_dir=$(cd $(dirname ${0}); pwd)

# Environments
github_apps_id_path=${GITHUB_APPS_ID_PATH}
github_apps_pem_path=${GITHUB_APPS_PEM_PATH}

# Main
github_app_id=$(cat "${github_apps_id_path}" | jq -r '.GITHUB_APP_ID')

now=$(date "+%s")
jwt_header=$(jq -c <<EOF | base64 -w 0
{
  "alg": "RS256",
  "typ": "JWT"
}
EOF
)
jwt_payload=$(jq -c <<EOF | base64 -w 0
{
  "iat": $((${now} - 60)),
  "exp": $((${now} + 600)),
  "iss": ${github_app_id}
}
EOF
)

jwt_raw_token="${jwt_header}.${jwt_payload}"
jwt_signed_token=$(
    echo -n "${jwt_raw_token}" \
    | openssl dgst -binary -sha256 -sign "${github_apps_pem_path}" \
    | base64 -w 0
)
jwt_token="${jwt_raw_token}.${jwt_signed_token}"

installation_id=$(
    curl -fLsS \
        -H "Authorization: Bearer ${jwt_token}" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/app/installations" \
    | jq -r ".[] | select(.app_id == ${github_app_id}) | .id"
)

access_token=$(
    curl -fLsS -XPOST \
        -H "Authorization: Bearer ${jwt_token}" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/app/installations/${installation_id}/access_tokens"  \
    | jq -r '.token'
)

echo ${access_token}
