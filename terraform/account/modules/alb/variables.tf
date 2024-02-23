variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "sandbox-cluster"

}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8000
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
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to create the ALB in"
  type        = set(string)
}



variable "public" {
  description = "The bool to check if the loadbalancer is publi"
  type        = bool
  default     = false
}

variable "web_security_group" {
  description = "The security group from the EC2 web instance to allow access from"
  type        = string
  default     = ""
}

variable "app_security_group" {
  description = "The security group to allow egressoutbound traffic"
  type        = string
  default     = ""
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
