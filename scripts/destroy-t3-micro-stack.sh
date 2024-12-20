#!/bin/bash

# Default region
DEFAULT_REGION="us-west-2"

# Function to validate the environment
validate_environment() {
  echo "Validating environment..."

  # Verify macOS
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This script is designed for macOS only."
    exit 1
  fi

  # Verify AWS CLI is installed
  if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and try again."
    exit 1
  fi

  # Check for latest AWS CLI version
  CURRENT_VERSION=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
  LATEST_VERSION=$(curl -s https://api.github.com/repos/aws/aws-cli/releases/latest | grep '"tag_name"' | awk -F '"' '{print $4}')
  if [[ "$CURRENT_VERSION" != "$LATEST_VERSION" ]]; then
    echo "Note: A new AWS CLI version is available: $LATEST_VERSION. You are using $CURRENT_VERSION."
  fi

  # Verify valid AWS session
  if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: No valid AWS session found. Please configure your AWS credentials."
    exit 1
  fi

  echo "Environment validated, preparing to destroy $STACK_NAME in $REGION."
}

# Function to check if a stack exists in the specified region
stack_exists() {
  echo "Checking if stack $STACK_NAME exists in $REGION..."
  STACK_STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region "$REGION" 2>&1)
  if echo "$STACK_STATUS" | grep -q "does not exist"; then
    echo "Stack $STACK_NAME not found in $REGION. Nothing to destroy."
    return 1
  else
    echo "Stack $STACK_NAME exists in $REGION."
    return 0
  fi
}

# Variables
STACK_NAME="t3-micro-stack"
REGION="${1:-$DEFAULT_REGION}"

# Run validation
validate_environment

# Check if the stack exists
if ! stack_exists; then
  exit 0  # Gracefully exit if the stack does not exist
fi

# Destroy stack
echo "Destroying stack $STACK_NAME in $REGION..."
if aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION"; then
  echo "Destroyed $STACK_NAME in $REGION."
else
  echo "Error: Failed to destroy $STACK_NAME in $REGION."
  exit 1
fi
