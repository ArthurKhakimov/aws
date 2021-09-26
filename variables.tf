variable "region" {}
variable "vpc1_cidr" {}
variable "public_subnet_vpc1" {}
variable "private_subnet_vpc1" {}
variable "vpc2_cidr" {}
variable "public_subnet_vpc2" {}
variable "private_subnet_vpc2" {}
variable "public_subnet3_vpc2" {}
variable "private_subnet3_vpc2" {}
variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
}
variable "az1" {}
variable "az2" {}
