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


variable "network_address_space" {
    type        = string
    description = "Base CIDR Block for VPC"
    default = "10.0.0.0/16"
}
variable "subnet1_address_space" {
    type        = string
    description = "Base CIDR Block for subnet 1"
    default = "10.0.1.0/24"
}
variable "subnet2_address_space" {
    type        = string
    description = "Base CIDR Block for subnet 2"
    default = "10.0.2.0/24"
}
  
variable "cName" {
    type        = string
    description = "Common name for tagging"
    default = "itkmitl"    
}
  
variable "itclass" {
    type        = string
    description = "Class name for tagging"
}

variable "itgroup" {
    type        = string
    description = "Group number for tagging"
}

variable "private_key_path" {
      type        = string
      description = "Private key path"
      sensitive   = true
  }

variable "key_name" {
      type        = string
      description = "Private key path"
      sensitive   = false
  }
