# aws-cloudformation-t3-micro

## Author

This project is maintained by **Stephen Abbot**.  
Feel free to connect with me on [LinkedIn](https://www.linkedin.com/in/stephen-abbot) to discuss this project or other topics.

## Github repository

[aws-cloudformation-t3-micro](https://github.com/stabbotco1/aws-cloudformation-t3-micro)

## Project Structure

Below is an overview of the project structure and the purpose of each file:

### Root Directory

- **`template.yaml`**: The primary CloudFormation template for defining the AWS resources required by this project.
- **`template_good.yaml`**: A validated and enhanced version of the main template, likely used as a reference or fallback.
- **`template copy.yaml`**: A backup or alternate copy of the CloudFormation template for testing or iteration.
- **`README.md`**: Documentation file for understanding and working with the project.
- **`.gitignore`**: Specifies files and directories to be ignored by Git, preventing unnecessary or sensitive files from being committed.

### Scripts Directory

- **`deploy-t3-micro-stack.sh`**: A shell script to deploy the CloudFormation stack defined in `template.yaml`. It automates the deployment process.
- **`destroy-t3-micro-stack.sh`**: A shell script to delete the deployed CloudFormation stack, ensuring clean resource removal.
- **`zip_up_project.sh`**: A utility script for zipping the project files, excluding unnecessary directories (like outputs) and system files (like `.DS_Store`).

### Additional Directories

- **`outputs/`** (Not included in this zip): A directory expected to store outputs like deployment artifacts or logs. This is created dynamically by the scripts.

## Getting Started

### Prerequisites

- **AWS CLI**: Ensure the AWS Command Line Interface is installed and configured with appropriate credentials and permissions.
- **Bash**: Required for running the provided shell scripts.
- **Zip Utility**: Ensure the `zip` command is installed for the `zip_up_project.sh` script.

### Deployment Steps

1. **Navigate to the project directory**:

   ```bash
   cd /path/to/aws-cloudformation-t3-micro
   ```

2. **Deploy the stack**:
   Use the `deploy-t3-micro-stack.sh` script to deploy the CloudFormation stack.

   ```bash
   ./scripts/deploy-t3-micro-stack.sh
   ```

3. **Verify resources**:
   After deployment, verify that the resources have been created successfully using the AWS Management Console or AWS CLI.

4. **Clean up resources**:
   Use the `destroy-t3-micro-stack.sh` script to delete the stack and associated resources.

   ```bash
   ./scripts/destroy-t3-micro-stack.sh
   ```

5. **Package the project**:
   To create a zip archive of the project, run the `zip_up_project.sh` script.

   ```bash
   ./scripts/zip_up_project.sh
   ```

## Notes

- **Validation**: Always validate the CloudFormation templates using the AWS CLI before deployment:

  ```bash
  aws cloudformation validate-template --template-body file://template.yaml
  ```

- **Template Updates**: Use version control (e.g., Git) to track changes to templates and scripts.

## Scripts Overview

### 1. `deploy-t3-micro-stack.sh`

**Purpose**: Automates the deployment of the CloudFormation stack defined in `template.yaml`.

**Logic**:

- Sets up the necessary environment and ensures the AWS CLI is configured correctly.
- Uses the AWS CLI to create or update the stack based on the `template.yaml` file.
- The intent is to streamline the deployment process, eliminating the need for manual CLI commands or AWS Console interactions.

**Context**:
This script is useful for quickly provisioning infrastructure while maintaining consistency across deployments. It is especially relevant in environments requiring frequent updates or testing of CloudFormation templates.

---

### 2. `destroy-t3-micro-stack.sh`

**Purpose**: Cleans up resources by deleting the deployed CloudFormation stack.

**Logic**:

- Uses the AWS CLI to delete the stack specified in the script.
- Waits for the deletion process to complete to ensure all resources are removed.

**Context**:
This script ensures that resources are properly cleaned up after use, avoiding unnecessary costs or resource conflicts. It simplifies teardown operations and reduces the risk of leaving orphaned resources.

---

### 3. `zip_up_project.sh`

**Purpose**: Packages the project directory into a zip file, excluding unnecessary directories and files.

**Logic**:

- Determines the project root and output directory dynamically.
- Creates the `outputs` directory if it does not exist.
- Uses the `zip` command to create a compressed archive of the project, excluding system files (e.g., `.DS_Store`) and specified directories (`outputs`, `.aws-sam`).

**Context**:
This script is useful for archiving the project for sharing, deployment, or backup purposes. It ensures that only relevant files are included in the zip archive, maintaining a clean and efficient package.

---

## Summary

These scripts are designed to automate common tasks associated with deploying, managing, and packaging CloudFormation-based AWS projects. They provide consistency and efficiency, making the project easier to use and maintain.
