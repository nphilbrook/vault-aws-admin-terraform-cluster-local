resource "vault_mount" "database" {
  count = local.dynamic_database_configured ? 1 : 0

  local       = true
  path        = var.vault_database_mount_path
  type        = "database"
  description = "Database secrets engine for dynamic MySQL credentials"
}

resource "vault_database_secret_backend_connection" "mysql" {
  count = local.dynamic_database_configured ? 1 : 0

  backend       = vault_mount.database[0].path
  name          = var.vault_mysql_connection_name
  allowed_roles = [var.vault_mysql_readonly_role_name, var.vault_mysql_readwrite_role_name]

  mysql {
    connection_url      = "{{username}}:{{password}}@tcp(${var.mysql_host}:${var.mysql_port})/${var.mysql_database}"
    username            = "vault_admin"
    password_wo         = var.initial_db_password
    password_wo_version = 1
  }
}

resource "vault_database_secret_backend_role" "mysql_readonly" {
  count = local.dynamic_database_configured ? 1 : 0

  backend = vault_mount.database[0].path
  name    = var.vault_mysql_readonly_role_name
  db_name = vault_database_secret_backend_connection.mysql[0].name

  creation_statements = [<<-EOT
		CREATE USER '{{name}}'@'${var.mysql_dynamic_user_host}' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 90 DAY;
		GRANT SELECT ON ${var.mysql_database}.* TO '{{name}}'@'${var.mysql_dynamic_user_host}';
	EOT
  ]

  renew_statements = [<<-EOT
		ALTER USER '{{name}}'@'${var.mysql_dynamic_user_host}' IDENTIFIED BY '{{password}}';
	EOT
  ]

  revocation_statements = [<<-EOT
		REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'${var.mysql_dynamic_user_host}';
		DROP USER IF EXISTS '{{name}}'@'${var.mysql_dynamic_user_host}';
	EOT
  ]

  rollback_statements = [<<-EOT
		REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'${var.mysql_dynamic_user_host}';
		DROP USER IF EXISTS '{{name}}'@'${var.mysql_dynamic_user_host}';
	EOT
  ]

}

resource "vault_database_secret_backend_role" "mysql_readwrite" {
  count = local.dynamic_database_configured ? 1 : 0

  backend = vault_mount.database[0].path
  name    = var.vault_mysql_readwrite_role_name
  db_name = vault_database_secret_backend_connection.mysql[0].name

  creation_statements = [<<-EOT
		CREATE USER '{{name}}'@'${var.mysql_dynamic_user_host}' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 90 DAY;
		GRANT SELECT, INSERT, UPDATE, DELETE ON ${var.mysql_database}.* TO '{{name}}'@'${var.mysql_dynamic_user_host}';
	EOT
  ]

  renew_statements = [<<-EOT
		ALTER USER '{{name}}'@'${var.mysql_dynamic_user_host}' IDENTIFIED BY '{{password}}';
	EOT
  ]

  revocation_statements = [<<-EOT
		REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'${var.mysql_dynamic_user_host}';
		DROP USER IF EXISTS '{{name}}'@'${var.mysql_dynamic_user_host}';
	EOT
  ]

  rollback_statements = [<<-EOT
		REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'${var.mysql_dynamic_user_host}';
		DROP USER IF EXISTS '{{name}}'@'${var.mysql_dynamic_user_host}';
	EOT
  ]

}
