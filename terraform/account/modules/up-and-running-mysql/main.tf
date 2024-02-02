/* resource "aws_db_instance" "sandbox" {
  identifier_prefix   = "sandbox"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = "sandbox"

  username = var.db_username
  password = var.db_password
}
*/
resource "aws_iam_user" "sandbox-user" {
  for_each = toset(var.user_names)
  name     = each.value
}
