#!/bin/bash -l
set -euo pipefail

# Usage:
#   entrypoint.sh <encrypted_path> <decrypted_path> [working_directory]

encrypted_path="${1:-}"
decrypted_path="${2:-}"
working_directory="${3:-}"

if [[ -z "${AGE_PRIVATE_KEY:-}" ]]; then
  echo "AGE_PRIVATE_KEY missing!" >&2
  exit 127
fi

if [[ -z "${encrypted_path}" ]]; then
  echo "encrypted_path argument missing!" >&2
  exit 127
fi

if [[ -z "${decrypted_path}" ]]; then
  echo "decrypted_path argument missing!" >&2
  exit 127
fi

if [[ -n "${working_directory}" ]]; then
  if [[ -d "${working_directory}" ]]; then
    cd "${working_directory}"
  else
    echo "working_directory not found: ${working_directory}" >&2
    exit 127
  fi
fi

export SOPS_AGE_KEY="${AGE_PRIVATE_KEY}"

# Informational: check for .sops.yml or .sops.yaml
if [[ ! -f ".sops.yml" && ! -f ".sops.yaml" ]]; then
  if [[ -f "/github/workspace/.sops.yml" || -f "/github/workspace/.sops.yaml" ]]; then
    # sops will look up config automatically from CWD upwards; no action needed
    :
  else
    echo ".sops.yml not found in current dir or workspace; proceeding without it" >&2
  fi
fi

if [[ ! -f "${encrypted_path}" ]]; then
  echo "Encrypted file not found: ${encrypted_path}" >&2
  exit 127
fi

mkdir -p "$(dirname "${decrypted_path}")"

set +e
sops -d "${encrypted_path}" > "${decrypted_path}"
status=$?
set -e

if [[ ${status} -ne 0 ]]; then
  rm -f "${decrypted_path}"
  echo "Failed to decrypt ${encrypted_path}" >&2
  exit 127
fi

echo "Decryption successful: ${decrypted_path}"
