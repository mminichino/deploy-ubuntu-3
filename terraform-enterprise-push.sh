#!/bin/bash
# shellcheck disable=SC2086
# shellcheck disable=SC2046

SCRIPTDIR=$(cd $(dirname $0) && pwd)
TOKEN=$(jq -r '.credentials["app.terraform.io"]["token"]' "${HOME}/.terraform.d/credentials.tfrc.json")

if [ -z "$1" ]; then
  echo "Usage: $0 <organization>/<workspace>"
  exit 0
fi

CONTENT_DIRECTORY="$SCRIPTDIR/content"
TEMP_DIRECTORY="$SCRIPTDIR/temp"
ORG_NAME="$(cut -d'/' -f1 <<<"$1")"
WORKSPACE_NAME="$(cut -d'/' -f2 <<<"$1")"

echo "Organization: $ORG_NAME"
echo "Workspace: $WORKSPACE_NAME"

# Create the File for Upload

UPLOAD_FILE_NAME="$CONTENT_DIRECTORY/content-$(date +%s).tar.gz"
tar -zcvf "$UPLOAD_FILE_NAME" ./*.tf

# Look Up the Workspace ID

WORKSPACE_ID=$(curl -s \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$WORKSPACE_NAME \
  | jq -r '.data.id')

echo "Workspace ID $WORKSPACE_ID"
# Create a New Configuration Version

echo '{"data":{"type":"configuration-versions"}}' > $TEMP_DIRECTORY/create_config_version.json

UPLOAD_URL=$(curl -s \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data "@$TEMP_DIRECTORY/create_config_version.json" \
  https://app.terraform.io/api/v2/workspaces/$WORKSPACE_ID/configuration-versions \
  | jq -r '.data.attributes."upload-url"')

# Upload the Configuration Content File
echo "Uploading file $UPLOAD_FILE_NAME"

curl -s \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  "$UPLOAD_URL"

echo "Done."
