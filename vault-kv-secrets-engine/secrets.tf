# Create a KV secrets engine
resource "vault_mount" "main" {
  path        = var.kv_secrets_mount
  type        = "kv"
  options     = { version = "2" }
  description = "Key/Value mount for Workload Identity demo"
}

# Create a secret in the KV engine
resource "vault_kv_secret_v2" "team_secrets" {
  mount = vault_mount.main.path
  name  = var.kv_team_secrets_name
  data_json = jsonencode(
    {
      team     = "solution engineers and architects",
      location = "sydney"
    }
  )
}

resource "vault_kv_secret_v2" "simons_secrets" {
  mount = vault_mount.main.path
  name  = var.kv_simons_secrets_name
  data_json = jsonencode(
    {
      role     = "Sr Solutions Architecture Specialist",
      location = "Sydney"
    }
  )
}

resource "vault_kv_secret_v2" "aarons_secrets" {
  mount = vault_mount.main.path
  name  = var.kv_aarons_secrets_name
  data_json = jsonencode(
    {
      role     = "Solutions Engineer",
      location = "kiama"
    }
  )
}