terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    alz = {
      source  = "Azure/alz"
      version = "~> 0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      path = "platform/slz"
      ref  = "2026.04.2"
    }
  ]
}

variable "root_management_group_id" {
  type        = string
  description = "The ID of the root management group where the landing zone will be deployed"
}

variable "architecture" {
  type        = string
  description = "The architecture to deploy (alz or slz)"
  default     = "slz"
  
  validation {
    condition     = contains(["alz", "slz"], var.architecture)
    error_message = "The architecture must be either 'alz' or 'slz'."
  }
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources"
  default     = "East US"
}

# Example: Deploy the Sovereign Landing Zone architecture
# This will create the management group hierarchy and apply policies
resource "alz_architecture" "slz" {
  name                       = var.architecture
  parent_management_group_id = var.root_management_group_id
  location                   = var.location
  
  # Override default policy values if needed
  # policy_default_values = {
  #   "param1" = "value1"
  #   "param2" = "value2"
  # }
}

output "management_group_ids" {
  description = "The IDs of the created management groups"
  value       = alz_architecture.slz.management_groups
}

output "deployed_policies" {
  description = "The policies deployed as part of the architecture"
  value       = alz_architecture.slz.policy_assignments
}
