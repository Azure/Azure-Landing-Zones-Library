variable "location" {
  type        = string
  default     = "uksouth"
  description = "Location for the resources"
}

variable "email_security_contact" {
  type        = string
  default     = ""
  description = "Email address for security alerts"
}

variable "subscription_ids" {
  type        = map(string)
  description = "Map of subscription IDs for different management group placements"

  validation {
    condition     = contains(keys(var.subscription_ids), "management")
    error_message = "subscription_ids must include 'management' key"
  }
}
