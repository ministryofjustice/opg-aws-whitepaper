/* variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
*/

variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

variable "quotes" {
  description = "map"
  type        = map(string)
  default = {
    "neo"      = "loser"
    "morpheus" = "giga loser"
    "trinity"  = "ultra loser"
  }
}

output "quote" {
  value = { for name, role in var.quotes : "${name}" => upper(role) }
}
