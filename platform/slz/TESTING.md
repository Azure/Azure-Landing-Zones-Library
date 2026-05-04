# Testing Guide for Sovereign Landing Zone

This guide walks through the steps to validate, test, and deploy the Sovereign Landing Zone using the ALZ Terraform provider.

## Prerequisites

- Terraform >= 1.0
- Azure CLI configured with appropriate credentials
- Management group access in your Azure subscription
- The ALZ Terraform Provider installed (automatically handled by `terraform init`)

## Step 1: Install Dependencies

```bash
# If using make (Linux/macOS)
make tools

# This installs the ALZ library tool required for validation
```

## Step 2: Prepare Configuration

1. Copy the example configuration:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your actual Azure details:
```hcl
root_management_group_id = "/subscriptions/YOUR_SUBSCRIPTION/providers/Microsoft.Management/managementGroups/YOUR_MG_ID"
architecture = "slz"
location = "East US"
```

## Step 3: Validate the Configuration

```bash
# Initialize Terraform (downloads providers and modules)
terraform init

# Format check
terraform fmt -check

# Syntax validation
terraform validate

# Check library integrity
make lib-check LIB=platform/slz

# Check documentation builds
make docs-check LIB=platform/slz
```

## Step 4: Plan the Deployment

```bash
# Create an execution plan
terraform plan -out=tfplan

# Review the plan output to ensure it matches your expectations
```

## Step 5: Apply the Configuration

```bash
# Deploy the landing zone (requires confirmation)
terraform apply tfplan

# Or apply with auto-approval (use with caution)
terraform apply -auto-approve tfplan
```

## Step 6: Verify Deployment

```bash
# Show current state
terraform show

# List outputs
terraform output

# Check management group hierarchy in Azure
az account management-group list --output table

# List policies applied
terraform output deployed_policies
```

## Testing Best Practices

### Local Testing
- Always run `terraform plan` first to review changes
- Use `terraform validate` to catch syntax errors early
- Run `terraform fmt` to maintain consistent formatting

### Pre-Deployment Checks
- Verify your management group permissions: `az account management-group show --name YOUR_MG_ID`
- Ensure Azure CLI is authenticated: `az account show`
- Check if policies already exist to avoid conflicts

### Post-Deployment Validation
- Verify management group structure in Azure Portal
- Check Azure Policy assignments are applied correctly
- Review Azure Activity Log for any deployment errors
- Test policy enforcement on a test resource

## Troubleshooting

### Common Issues

**Error: "Provider configuration missing"**
- Ensure you've configured the ALZ provider correctly in `example.tf`
- Run `terraform init` to download the provider

**Error: "Management group not found"**
- Verify the `root_management_group_id` is correct
- Ensure your account has permissions: `az account management-group show --name YOUR_MG_ID`

**Error: "Policy assignment conflict"**
- Check if policies are already assigned
- Use `library_overwrite_enabled = true` to override existing assignments

**Terraform state issues**
- Always back up your `terraform.tfstate` file
- Use remote state management for production: `terraform backend "azurerm" { ... }`

## Cleanup

To remove the deployed landing zone:

```bash
terraform destroy -auto-approve
```

**Warning**: This will remove all management groups and policy assignments created by this configuration. Ensure you have backed up any important configurations.

## Additional Resources

- [ALZ Terraform Provider Documentation](https://registry.terraform.io/providers/Azure/alz/latest/docs)
- [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure CLI Management Groups](https://learn.microsoft.com/cli/azure/account/management-group)
