# MySQL DDL for Vault Dynamic Database Secrets Engine

This file provides MySQL statements formatted for Vault database roles.
Use these in Vault role fields such as `creation_statements`, `revocation_statements`, and `rollback_statements`.

## Placeholders used by Vault

- `{{name}}`: generated username
- `{{password}}`: generated password
- `{{expiration}}`: lease expiration timestamp (UTC)

## Prerequisite: Vault DB admin account privileges

The MySQL account configured in Vault for the database connection should have enough privileges to:

- Create and alter users
- Grant and revoke privileges on target schemas
- Drop users

Example (run once as a privileged DBA user):

```sql
CREATE USER IF NOT EXISTS 'vault_admin'@'%' IDENTIFIED BY 'REPLACE_ME_STRONG_PASSWORD';

GRANT CREATE USER, ALTER USER, DROP USER, PROCESS ON *.* TO 'vault_admin'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON appdb.* TO 'vault_admin'@'%';

FLUSH PRIVILEGES;
```

## Dynamic role: read-only user for one schema

Use as Vault `creation_statements`:

```sql
CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT ON appdb.* TO '{{name}}'@'%';
```

Optional `renew_statements`:

```sql
ALTER USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';
```

Use as `revocation_statements` and `rollback_statements`:

```sql
REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'%';
DROP USER IF EXISTS '{{name}}'@'%';
```

## Dynamic role: read-write user for one schema

Use as Vault `creation_statements`:

```sql
CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO '{{name}}'@'%';
```

Optional `renew_statements`:

```sql
ALTER USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';
```

Use as `revocation_statements` and `rollback_statements`:

```sql
REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'%';
DROP USER IF EXISTS '{{name}}'@'%';
```

## Notes

- Replace `appdb` with your target schema.
- Restrict `'%'` host to specific CIDRs or hostnames if possible.
- If your MySQL policy requires SSL-only logins, add `REQUIRE SSL` to each `CREATE USER` statement.

