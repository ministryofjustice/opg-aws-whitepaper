variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "target_group_arns" {
  description = "The target group ARNs from the ALB module"
  type        = set(string)
}

variable "alb_security_group" {
  description = "The security group from the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "The subnets to use"
  type        = set(string)
}



variable "cluster_name" {
  description = "The name for the cluster of resources"
  type        = string
}

variable "public" {
  description = "Whether the EC2 instance is publicly accessible"
  type        = bool
  default     = false
}

variable "app_alb_fqdn" {
  description = "The URL for the app server ALB"
  type        = string
  default     = ""
}

variable "app_server_port" {
  description = "The outbound app server port"
  type        = number
}

variable "vpc_id" {
  description = "The VPC for the loadbalancer to use"
  type        = string
}
