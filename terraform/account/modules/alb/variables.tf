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
