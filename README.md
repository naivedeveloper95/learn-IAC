# learn-IAC — Terraform examples and backend experiments

This repository contains small Terraform example projects used to learn Infrastructure-as-Code patterns and to experiment with remote backends (S3 + DynamoDB locking).

Repository layout

- `01-benefits-iac/` — Notes and state files demonstrating why IaC is useful. (contains local `terraform.tfstate`)
- `02.hcl/` — Example using HCL features
- `03-first-tf-project/` — A small first Terraform project. Contains `providers.tf` (provider + backend blocks may be present here).
- `04-backends/` — Backend examples and configuration files (S3 backend, backend config files such as `dev.s3.tfbackend` and `prod.s3.tfbackend`).

Why you might not be seeing S3 as the backend

If Terraform is still creating local `terraform.tfstate`, common causes are:

- You're running Terraform from a directory that does NOT contain the `backend "s3"` configuration (Terraform only reads backend config from the root module / current working directory).
- You haven't run `terraform init` after adding the backend block.
- `terraform init` failed quietly due to credentials, missing bucket, or permission errors and Terraform left the local state as-is.
- The backend block is placed inside a child module — backend blocks are ignored in child modules.

How to enable and migrate to the S3 backend (safe steps)

1) Change to the directory that contains the backend block (example):

```bash
cd /home/satyam95/Learn/terraform/03-first-tf-project
```

2) Initialize Terraform so it configures the backend and plugins:

```bash
terraform init
```

- Terraform will print a message when it successfully configures the `s3` backend.
- If local state already exists Terraform will prompt whether to copy local state to the new backend. Answer `yes` to migrate.

If you need to force reconfiguration or run non-interactively:

```bash
# Reconfigure backend (asks to migrate state if needed)
terraform init -reconfigure

# Force copy local state into the remote backend non-interactively (use carefully)
terraform init -reconfigure -force-copy
```

3) Verify Terraform is using remote state

```bash
# This reads the state from the configured backend
terraform state pull

# Or re-run init to see the "Successfully configured the backend \"s3\"" message
terraform init
```

Optional: Use AWS CLI to inspect the S3 bucket (replace BUCKET and REGION):

```bash
aws s3 ls s3://BUCKET/ --region REGION
```

If you use state locking (recommended for teams), make sure your backend block includes a `dynamodb_table` and that the DynamoDB table exists and IAM permissions allow locking operations.

AWS Credentials & Permissions

Make sure the credentials Terraform uses can read/write the S3 bucket and (if used) put locks in the DynamoDB table. Quick checks:

```bash
# Check current AWS identity
aws sts get-caller-identity

# Check bucket access (list)
aws s3 ls s3://your-backend-bucket --region your-region
```

Troubleshooting checklist

- Confirm the `backend "s3"` block is present in `providers.tf` (or a root `*.tf` file) in the directory where you run `terraform`.
- Run `terraform init` and carefully read any errors or prompts about migration.
- If `terraform init` reports a failure, fix credentials/bucket/permissions and re-run `terraform init -reconfigure`.
- If you still see a local `terraform.tfstate` after successful migration, you can archive or remove it locally (the remote backend will be authoritative). Do not delete remote state unless you know what you're doing.

Example minimal S3 backend block

```hcl
terraform {
  backend "s3" {
    bucket = "example-terraform-backend-bucket"
    key    = "path/to/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "terraform-locks"  # optional for state locking
  }
}
```
Enjoy experimenting!