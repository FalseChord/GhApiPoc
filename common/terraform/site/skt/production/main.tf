variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "ssh_key_public" {}
variable "ssh_key_private" {}

variable "azure_username" {}
variable "azure_password" {}
variable "git_url" {}
variable "git_branch" {}

variable "az_devops_tag" {}
variable "az_devops_token" {}
variable "az_function_gpu_trigger_url" {}

variable "mongodbatlas_public_key" {}
variable "mongodbatlas_private_key" {}
variable "mongodbatlas_project_id" {}

variable "site_name" { default = "skt" }
variable "site_type" { default = "production" }

provider "azurerm" {
  version         = "~> 2.0"
  features {}
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.3"
}

resource "azurerm_resource_group" "rg_general" {
  location = "southeastasia"
  name     = "mosa-${var.site_name}-${var.site_type}"
}


  source_port_range                     = "*"
  source_application_security_group_ids = []
  source_address_prefixes = [
    // * Linker
    "0.0.0.0/32",
    "0.0.0.0/32",
    "0.0.0.0/32",
    "0.0.0.0/32",
    "0.0.0.0/32",

    // * Beijing
    "1.2.3.4/32",

  ]

  destination_application_security_group_ids = []

  resource_group_name         = azurerm_resource_group.rg_general.name
  network_security_group_name = module.vm_nginx.vm_network_security_group_name[0]
}
