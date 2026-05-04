terraform {
  required_version = ">= 1.7"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.35"
    }
    alz = {
      source  = "Azure/alz"
      version = "~> 0.1"
    }
  }
}

provider "azapi" {}

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
