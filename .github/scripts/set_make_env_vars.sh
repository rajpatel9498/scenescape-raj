#!/bin/bash
# SPDX-FileCopyrightText: (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

echo "Setting environment variables for Makefile logic..."

# Set branch_name from GITHUB_REF_NAME
echo "branch_name=$GITHUB_REF_NAME" >> "$GITHUB_OUTPUT"

# Log event name for debug
echo "GitHub Event: $GITHUB_EVENT_NAME"

# Set change_target only for PRs
if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
  CHANGE_TARGET=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")
  echo "change_target=$CHANGE_TARGET" >> "$GITHUB_OUTPUT"
else
  echo "change_target=" >> "$GITHUB_OUTPUT"
fi
