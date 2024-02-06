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

variable "default_aws_subnets" {
  description = "The default subnets in AWS"
  type        = set(string)
}

variable "web_cluster_name" {
  description = "The name for the cluster of resources"
  type        = string
}

variable "web_server" {
  description = "Whether the EC2 instance is publicly accessible"
  type        = bool
}