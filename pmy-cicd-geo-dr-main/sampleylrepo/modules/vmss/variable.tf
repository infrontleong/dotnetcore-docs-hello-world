variable "name" {
  type        = string
  description = "Name of the VMSS"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VMSS"
}

variable "computer_name_prefix" {
  type        = string
  description = "Computer name prefix"
}

variable "sku" {
  type        = string
  description = "SKU/size of the VM instances"
}

variable "instances" {
  type        = number
  description = "Number of VM instances"
}

variable "zones" {
  type        = list(string)
  description = "Availability zones for the VMSS"
}

variable "ssh_public_key" {
  description = "The public SSH key"
  type        = string
}

variable "source_image_id" {
  type        = string
  description = "Source image ID for VMSS"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the VMSS"
}

variable "backend_address_pool_ids" {
  type        = list(string)
  description = "List of backend address pool IDs for Load Balancer"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
