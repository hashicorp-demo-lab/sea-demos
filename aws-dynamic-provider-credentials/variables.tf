variable "tfc_organization" {
  type        = string
  description = "(Required) The name of the TFC organization"
  nullable    = false
}

variable "tfc_project" {
  type        = string
  description = "(Required) The name of the TFC Project that the workspace is located within"
  nullable    = false
}
variable "tfc_workspace" {
  type        = string
  description = "(Required) The name of the TFC workspace"
  nullable    = false
}
variable "role_arns" {
  type        = string
  description = "Amazon Resource Name of the role in AWS IAM "
  nullable    = false
}

variable "VAULT_PATH" {
  type        = string
  description = "Vault path used for mount path of secrets engine and Vault policy"
  nullable    = false
}

variable "vault_address" {
  type        = string
  description = "vault address"
  default     = "http://localhost:8200"
}

variable "region" {
  type        = string
  description = "aws region"
}

variable "doormat_user_arn" {
  type        = string
  description = "arn of doormat user"
}

variable "github_organization" {
  type = string
  description = "Name of the GitHub Organisation used for GitHub Authentication method"
}