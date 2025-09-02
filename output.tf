output "user-passwords" {
  description = "The following is the passwords for the newly created IAM users. Users will have reset their password on first login."
  value       = { for user in aws_iam_user_login_profile.user-login : user.user => user.password }
  sensitive   = true
