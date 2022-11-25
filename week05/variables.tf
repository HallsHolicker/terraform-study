locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

variable "db_name" {
  description = "Hallsholicker Test DB"
  type        = string
  default     = "devHallsholickerDb"
}
