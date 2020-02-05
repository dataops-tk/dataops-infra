variable "name_prefix" { type = string }
variable "aws_region" { default = null }
variable "vpc_id" { default = null }
variable "create_vpc" { default = false }
variable "resource_tags" { type = map(string) }
variable "github_repo_ref" {
  type = string
  description = "The git repo reference to clone onto the airflow server"
  default = null
}
variable "container_command" {
  type = string
}
variable "container_image" {
  type = string
  default = "airflow"
}
variable "environment_vars" {
  type    = map(string)
  default = {}
}
variable "environment_secrets" {
  type    = map(string)
  default = {}
}
variable "container_num_cores" { default = 2 }
variable "container_ram_gb" { default = 4 }
