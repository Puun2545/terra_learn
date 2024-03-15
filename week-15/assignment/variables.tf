##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {
    type        = string
    description = "AWS Access Key"
    sensitive   = true
}
variable "aws_secret_key" {
    type        = string
    description = "AWS Secret Key"
    sensitive   = true
}
variable "aws_session_token" {
    type        = string
    description = "AWS Session Token"
    sensitive   = true
}

variable "key_name" {
    type        = string
    description = "Private key path"
    sensitive   = false
}
variable "region" {
    type        = string
    description = "value for default region"
    default = "us-east-1"
}

variable "enable_dns_hostnames" {
    type        = bool
    description = "Enable DNS hostnames in VPC"
    default     = true
}

variable "map_public_ip" {
    type        = bool
    description = "Enable Mapping Public IP in the subnet"
    default     = true
}

variable "network_address_space" {
    type        = string
    description = "Base CIDR Block for VPC"
    default = "10.0.0.0/16"
}

variable "subnet_count" {
    type = number
    description = "Number of subnets to create"
    default = 2
}

variable "instance_count"{
    type = number
    description = "Number of instances to create"
    default = 2
}
  
variable "cName" {
    type        = string
    description = "Common name for tagging"
    default = "ITKMITL"    
}
  
variable "itclass" {
    type        = string
    description = "Class name for tagging"
}

variable "itgroup" {
    type        = string
    description = "Group number for tagging"
}