variable "vault_address" {
  type        = string
  description = "vault address"
}

variable "kv_secrets_mount" {
  type        = string
  description = "Where the secret backend will be mounted"
}
variable "kv_team_secrets_name" {
  type        = string
  description = "Full name of the secret. For a nested secret, the name is the nested path excluding the mount and data prefix. For example, for a secret at 'kvv2/data/foo/bar/baz', the name is 'foo/bar/baz'"
}

variable "kv_simons_secrets_name" {
  type        = string
  description = "Full name of the secret. For a nested secret, the name is the nested path excluding the mount and data prefix. For example, for a secret at 'kvv2/data/foo/bar/baz', the name is 'foo/bar/baz'"
}

variable "kv_aarons_secrets_name" {
  type        = string
  description = "Full name of the secret. For a nested secret, the name is the nested path excluding the mount and data prefix. For example, for a secret at 'kvv2/data/foo/bar/baz', the name is 'foo/bar/baz'"
}
