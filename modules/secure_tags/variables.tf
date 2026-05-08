// 
variable "parent" {
  description = "The resource name of the new TagKey's parent. Must be of the form organizations/{org_id} or projects/{project_id_or_number}."
  type        = string
}

variable "purpose_data" {
  description = "Purpose data cannot be changed once set. Purpose data corresponds to the policy system that the tag is intended for. For example, the GCE_FIREWALL purpose expects data in the following format: 'network = '/''."
  type        = map(string)
}

// Variables for Tag Keys
variable "short_name" {
  description = "(Required) Input only. The user friendly name for a TagKey. The short name should be unique for TagKeys within the same tag namespace. The short name must be 1-63 characters, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between."
  type        = string
}

variable "description" {
  description = "User-assigned description of the TagKey. Must not exceed 256 characters."
  type        = string
}

// Variables for Tag Values
variable "tag_values" {
  description = "A map of tag values to create. The key is the short name of the tag value, and the value is a map of the tag value properties."
  type = map(object({
    tagvalue_short_name  = string // Input only. User-assigned short name for TagValue. The short name should be unique for TagValues within the same parent TagKey. The short name must be 63 characters or less, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between.
    tagvalue_description = string // User-assigned description of the TagValue. Must not exceed 256 characters.
  }))
}

// Variables for IAM bindings
variable "iam_viewer_members" {
  description = "Members that will have viewer permissions to this tag/value"
  type        = list(string)
}

variable "iam_user_members" {
  description = "Members that will have user permissions to this tag/value"
  type        = list(string)
}