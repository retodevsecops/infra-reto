variable "resource_group_name" {
  default = "#{resourceGroup}#"
}

variable "location" {
  default = "#{location}#"
}

variable "client_id" {
  default = "#{spId}#"
}
variable "client_secret" {
  default = "#{spPassword}#"
}

variable "agent_count" {
  default = 1
}

variable "dns_prefix" {
default = "#{aksName}#"
}

variable "cluster_name" {
  default = "#{aksName}#"
}