# Automatically injected by Terraform
variable "TFC_WORKSPACE_SLUG" {
  type = string
}

variable "vault_database_mount_path" {
  description = "Path where the database secrets engine is mounted in Vault."
  type        = string
  default     = "database"
}

variable "vault_mysql_connection_name" {
  description = "Name for the Vault MySQL database connection."
  type        = string
  default     = "mysql-appdb"
}

variable "vault_mysql_readonly_role_name" {
  description = "Vault role name for dynamic read-only MySQL credentials."
  type        = string
  default     = "appdb-readonly"
}

variable "vault_mysql_readwrite_role_name" {
  description = "Vault role name for dynamic read-write MySQL credentials."
  type        = string
  default     = "appdb-readwrite"
}

variable "vault_mysql_readonly_default_ttl" {
  description = "Default TTL for read-only dynamic MySQL credentials."
  type        = string
  default     = "1h"
}

variable "vault_mysql_readonly_max_ttl" {
  description = "Maximum TTL for read-only dynamic MySQL credentials."
  type        = string
  default     = "24h"
}

variable "vault_mysql_readwrite_default_ttl" {
  description = "Default TTL for read-write dynamic MySQL credentials."
  type        = string
  default     = "1h"
}

variable "vault_mysql_readwrite_max_ttl" {
  description = "Maximum TTL for read-write dynamic MySQL credentials."
  type        = string
  default     = "24h"
}

variable "mysql_host" {
  description = "MySQL hostname for the Vault database connection."
  type        = string
  default     = "philbrook-aws-vault-hvd-appdb.c1qkweyyw7o2.us-west-2.rds.amazonaws.com"
}

variable "mysql_port" {
  description = "MySQL port for the Vault database connection."
  type        = number
  default     = 3306
}

variable "mysql_database" {
  description = "Target MySQL schema for dynamic grants."
  type        = string
  default     = "appdb"
}

variable "initial_db_password" {
  description = "MySQL admin password used by Vault to manage dynamic users."
  type        = string
  sensitive   = true
  default     = null
}

variable "mysql_dynamic_user_host" {
  description = "Host qualifier for created dynamic MySQL users."
  type        = string
  default     = "%"
}
