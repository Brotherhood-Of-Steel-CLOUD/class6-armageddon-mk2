resource "aws_iam_group" "s3_bedrock_admin" {
  name = var.group_name #reference to variable file named "group_name", in variable.tf file
  path = "/test-users/"
}

resource "aws_iam_group_policy_attachment" "s3_bedrock_group_policies" {
  for_each = toset(var.policy_arn)

  group      = aws_iam_group.s3_bedrock_admin.name
  policy_arn = each.value
}

resource "aws_iam_user" "users" {
  for_each = toset(var.user_names)

  path = "/test-users/"
  name = each.value
}

resource "aws_iam_user_login_profile" "user-login" {
  for_each = toset(var.user_names)

  user                    = aws_iam_user.users[each.key].name
  password_length         = 12
  password_reset_required = true
}

resource "aws_iam_group_membership" "memb-1" {
  name  = "s3-bedrock-admin-mem"
  users = [for user in aws_iam_user.users : user.name]

  group = aws_iam_group.s3_bedrock_admin.name
}
