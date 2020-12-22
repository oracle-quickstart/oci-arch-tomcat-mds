## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

##orlando
#variable "user_ocid" {} 

variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}
variable "fingerprint" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "availablity_domain_name" {}
variable "mysql_db_system_admin_password" {}

variable "igw_display_name" {
  default = "internet-gateway"
}

variable "vcn01_cidr_block" {
  default = "10.0.0.0/16"
}
variable "vcn01_dns_label" {
  default = "vcn01"
}
variable "vcn01_display_name" {
  default = "vcn01"
}

variable "vcn01_subnet_pub01_cidr_block" {
  default = "10.0.1.0/24"
}

variable "vcn01_subnet_pub01_display_name" {
  default = "vcn01_subnet_pub01"
}

variable "vcn01_subnet_pub02_cidr_block" {
  default = "10.0.2.0/24"
}

variable "vcn01_subnet_pub02_display_name" {
  default = "vcn01_subnet_pub02"
}

variable "vcn01_subnet_app01_cidr_block" {
  default = "10.0.10.0/24"
}

variable "vcn01_subnet_app01_display_name" {
  default = "vcn01_subnet_app01"
}

variable "vcn01_subnet_db01_cidr_block" {
  default = "10.0.20.0/24"
}

variable "vcn01_subnet_db01_display_name" {
  default = "vcn01_subnet_db01"
}

variable "lb_shape" {
  default = "10Mbps"
}

variable "InstanceShape" {
    default = "VM.Standard2.1"
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.8"
}

variable "mysql_db_system_admin_username" {
  default = "admin"
}

variable "mysql_db_name" {
  default = "mydb"
}

# variable mysql_db_system_availability_domain {}
# variable mysql_configuration_id {}
# variable mysql_shape_name {} 
variable mysql_db_system_backup_policy_is_enabled {
  default = true
}
variable mysql_db_system_data_storage_size_in_gb {
  default = 50
}
variable mysql_db_system_display_name {
  default = "mysql_service"
}
variable mysql_db_system_hostname_label {
  default = "mysqlhost"
}