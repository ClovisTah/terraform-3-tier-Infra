variable "vpc_cidr_block" {
  description = "CIDR block for main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  description = "Availability zones "
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  type = map # a collection of keys and vlues
  description = "tags"
  
}