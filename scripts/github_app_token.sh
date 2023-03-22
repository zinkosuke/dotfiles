#!/bin/bash
#
# Get a GitHub Apps token.
#
set -euo pipefail
cd "$(dirname "${0}")"
# ----- Environments -----
GITHUB_APPS_ID_PATH=${GITHUB_APPS_ID_PATH}
GITHUB_APPS_PEM_PATH=${GITHUB_APPS_PEM_PATH}
# ----- Args -----
# ----- Main -----
github_app_id=$(jq -r '.GITHUB_APP_ID' < "${GITHUB_APPS_ID_PATH}")

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
  "iat": $((now - 60)),
  "exp": $((now + 600)),
  "iss": ${github_app_id}
}
EOF
)

jwt_raw_token="${jwt_header}.${jwt_payload}"
jwt_signed_token=$(
    echo -n "${jwt_raw_token}" \
    | openssl dgst -binary -sha256 -sign "${GITHUB_APPS_PEM_PATH}" \
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

echo "${access_token}"
