#!/bin/bash

# Build script for Fresh Leaf App with secure environment configuration.
# 
# Usage:
#   ./lib/scripts/build.sh [env] [type]
#   
# Parameters:
#   env  - Environment: 'local' or 'prod' (default: prod)
#   type - Build type: 'apk' or 'appbundle' (default: appbundle)
#
# Examples:
#   ./lib/scripts/build.sh       # Build for prod as appbundle
#   ./lib/scripts/build.sh prod apk
#   ./lib/scripts/build.sh local apk

set -e

ENV="${1:-prod}"
BUILD_TYPE="${2:-appbundle}"

# Validate parameters
if [[ ! "$ENV" =~ ^(local|prod)$ ]]; then
    echo "ERROR: Invalid environment. Use 'local' or 'prod'"
    exit 1
fi

if [[ ! "$BUILD_TYPE" =~ ^(apk|appbundle)$ ]]; then
    echo "ERROR: Invalid build type. Use 'apk' or 'appbundle'"
    exit 1
fi

# Resolve .env file path
ENV_FILE=".env.$ENV"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "ERROR: Environment file not found: $ENV_FILE"
    exit 1
fi

echo "Loading configuration from: $ENV_FILE"

# Function to parse .env file
declare -A env_vars
while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$key" ]] && continue
    
    # Trim whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    env_vars["$key"]="$value"
done < "$ENV_FILE"

# Validate required variables
required_vars=("API_URL")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [[ -z "${env_vars[$var]}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
    echo "ERROR: Missing required environment variables: ${missing_vars[*]}"
    exit 1
fi

echo "✓ All required environment variables found"

# Build command
BUILD_CMD="flutter build $BUILD_TYPE --release"

# Add dart-define parameters from .env file
for key in "${!env_vars[@]}"; do
    value="${env_vars[$key]}"
    BUILD_CMD="$BUILD_CMD --dart-define=$key=$value"
done

echo ""
echo "Building for: $ENV environment"
echo "Build type: $BUILD_TYPE"
echo ""
echo "Executing: $BUILD_CMD"
echo ""

eval "$BUILD_CMD"

if [[ $? -eq 0 ]]; then
    echo ""
    echo "✓ Build completed successfully!"
    if [[ "$BUILD_TYPE" == "apk" ]]; then
        echo "Output: build/app/outputs/apk/release/app-release.apk"
    else
        echo "Output: build/app/outputs/bundle/release/app-release.aab"
    fi
else
    echo ""
    echo "✗ Build failed!"
    exit 1
fi
