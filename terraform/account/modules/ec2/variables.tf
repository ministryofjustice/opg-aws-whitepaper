variable "server_port" {
  default     = 8080
  type        = number
  description = "The port the server will use for HTTP"
}

variable "cluster_name" {
  description = "The name for the cluster resources"
  type        = string
}
