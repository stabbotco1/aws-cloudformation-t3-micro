#!/bin/bash

DEFAULT_REGION="us-west-2"

set_ami_image() {
  AMI_IMAGE=$(aws ssm get-parameter --name /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query "Parameter.Value" --output text --region "$REGION")
  if [[ -z "$AMI_IMAGE" ]]; then
    echo "Error: Unable to fetch the latest Amazon Linux 2 AMI."
    exit 1
  fi
}

get_latest_aws_cli_version() {
    # The latest version from the changelog is on line 5
  LATEST_AWS_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst | sed -n '5p' | tr -d '=' | xargs)
  if [[ -z "$LATEST_AWS_CLI_VERSION" ]]; then
    echo "Warning: Unable to fetch the latest AWS CLI version."
  fi
}

validate_environment() {
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This script is designed for macOS only."
    exit 1
  fi

  if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and try again."
    exit 1
  fi

  CURRENT_AWS_CLI_VERSION=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)

  get_latest_aws_cli_version

  if [[ -n "$LATEST_AWS_CLI_VERSION" && "$CURRENT_AWS_CLI_VERSION" != "$LATEST_AWS_CLI_VERSION" ]]; then
    echo "Note: A newer AWS CLI version is available."
    echo "Current version: $CURRENT_AWS_CLI_VERSION"
    echo "Latest version:  $LATEST_AWS_CLI_VERSION"
  fi

  if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: No valid AWS session found. Please configure your AWS credentials."
    exit 1
  fi

  echo "Environment validated, deploying $STACK_NAME to $REGION."
}

STACK_NAME="t3-micro-stack"
REGION="${1:-$DEFAULT_REGION}"

validate_environment

set_ami_image

echo "Deploying stack $STACK_NAME to $REGION with AMI Image $AMI_IMAGE..."
if aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --parameter-overrides AmiImage="$AMI_IMAGE" \
  --capabilities CAPABILITY_NAMED_IAM; then
  echo "Deployed $STACK_NAME to $REGION."
else
  echo "Error: Failed to deploy $STACK_NAME to $REGION."
  exit 1
fi
