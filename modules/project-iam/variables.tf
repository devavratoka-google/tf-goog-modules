variable "project_id" {
  description = "GCP project ID to grant the IAM binding on."
  type        = string
}

variable "role" {
  description = "IAM role to grant (e.g. roles/run.invoker)."
  type        = string
}

variable "members" {
  description = "List of IAM members to grant the role (e.g. serviceAccount:foo@bar.iam.gserviceaccount.com)."
  type        = list(string)
}

variable "condition" {
  description = "Optional IAM condition. Set to null for unconditional bindings."
  type = object({
    title       = string
    description = optional(string)
    expression  = string
  })
  default = null
}
