#!/bin/sh

# -----------------------------------------------------------------------------
# script.sh: Hardened Package Installer for Runtime-Node
# This script parses dependencies from requirements.txt and installs them via apk.
# -----------------------------------------------------------------------------

DEP_DIR="dependencies"
REQ_FILE="$DEP_DIR/requirements.txt"

# Security Check: Ensure the script is running with root privileges
# Required for 'apk add' to modify the system.
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Please run as root/sudo." >&2
    exit 1
fi

# Validation: Check if the requirements file exists
if [ ! -f "$REQ_FILE" ]; then
    echo "Error: $REQ_FILE not found." >&2
    exit 1
fi

echo "--- Validating and Installing Packages ---"

# 1. grep -v '^#': Ignores comment lines in requirements.txt
# 2. tr -d '\r': Strips Windows-style line endings (CRLF) to prevent shell errors
# 3. sed ...: Normalizes the version syntax (converts '==' to '=' if used)
PACKAGES=$(grep -v '^#' "$REQ_FILE" | tr -d '\r' | sed -e 's/ *= *=*/=/g')

# Check if the requirements file is empty after filtering
if [ -z "$PACKAGES" ]; then
    echo "No valid packages found."
    exit 0
fi

# Execute installation with --no-cache to keep the builder stage small.
# The exit status is checked to ensure all pinned versions are available in Alpine repos.
if apk add --no-cache $PACKAGES; then
    echo "--- Successfully installed all pinned versions ---"
else
    echo "Error: Installation failed. Check if version numbers match 'apk info -v <pkg>'." >&2
    exit 1
fi