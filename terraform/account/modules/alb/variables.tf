variable "web_cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "web-cluster-sandbox"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "custom_tags" {
  description = "Custom tags for ASG"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC for the loadbalancer to use"
  type        = string
}

variable "subnet_ids" {
  description = "The subnets to create the ALB in"
  type        = set(string)
}

variable "availability_zones" {
  description = "The availability zones to create the ALB in"
  type        = set(string)
}

variable "ec2_security_group" {
  description = "The EC2 security group for outbound traffic"
  type        = string
}

/*
variable "subnet_count" {
  description = "How many subnets to use"
  type        = number

  validation {
    condition     = var.subnet_count > 0 && var.subnet_count <= 3
    error_message = "The subnet count must be between 1 and 3."
  }
}
*/
