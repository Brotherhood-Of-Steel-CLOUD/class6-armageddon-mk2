variable "group_name" {
  description = "The group name to be used in the creation of the group."
  type        = string
  default     = "s3-reader-bedrock_admin"
}

variable "policy_arn" {
  description = "A list of ARN's to be used by the group."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonBedrockFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

variable "user_names" {
  description = "A list of user names to be used user creation."
  type        = list(string)
  default = [
    "andre",
    "timothy"
  ]
}
