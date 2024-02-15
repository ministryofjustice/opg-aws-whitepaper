variable "cidr" {
  description = "The cidr range for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Bool for assigning a public IP to instances"
  default     = false
}

