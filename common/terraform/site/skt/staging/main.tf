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

variable "site_name" { default = "site" }
variable "site_type" { default = "dev" }

terraform {
  backend "remote" {
    organization = "yeeelab"
    workspaces {
      name = "alpha"
    }
  }
}

provider "azurerm" {
  version         = "~> 2.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
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

module "network_general" {
  source              = "Azure/network/azurerm"
  version             = "3.2.1"
  resource_group_name = azurerm_resource_group.rg_general.name
  vnet_name           = "vnet_general"
  address_space       = "127.0.0.1/25"
  subnet_prefixes     = ["127.0.0.1/28", "127.0.0.1/28", "127.0.0.1/27"]
  subnet_names        = ["GatewaySubnet", "DMZSubnet", "FrontendSubnet"]
}

module "vm_1" {
  is_create_public_ip           = "false"
  is_dynamic_allocate_public_ip = "true"
  is_static_allocate_private_ip = "false"
  is_customize_virtual_network  = "true"
  vm_allow_ports                = []
  vm_static_private_ips         = []
}

module "vm_2" {
  is_create_public_ip           = "false"
  is_dynamic_allocate_public_ip = "true"
  is_static_allocate_private_ip = "false"
  is_customize_virtual_network  = "true"
  vm_allow_ports                = []
  vm_static_private_ips         = []
}

module "vm_3" {
  is_create_public_ip           = "true"
  is_dynamic_allocate_public_ip = "false"
  is_static_allocate_private_ip = "false"
  is_customize_virtual_network  = "true"
  vm_allow_ports                = []
  vm_static_private_ips         = []
}

module "vm_4" {
  is_create_public_ip           = "true"
  is_dynamic_allocate_public_ip = "false"
  is_static_allocate_private_ip = "false"
  is_customize_virtual_network  = "true"
  vm_allow_ports                = []
  vm_static_private_ips         = []
}

resource "azurerm_network_security_rule" {
  direction = "Inbound"
  access    = "Allow"

  source_port_range = "*"
  source_address_prefixes = [
    // * Linker
    "1.2.3.4/32",
    "1.2.3.5/32",
    "1.2.3.6/32",
    "100.200.240.254/32",

    // * Beijing
  ]
  source_application_security_group_ids = []

  destination_address_prefix                 = "*"
  destination_application_security_group_ids = []
}

module "dns" {
  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm
  }

  source                  = "dns-attach"
}
