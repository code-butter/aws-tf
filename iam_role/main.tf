data "aws_iam_policy_document" "assume" {
  dynamic "statement" {
    for_each = length(var.assume_services) > 0 ? [1]: []
    content {
      sid = "AssumeServices"
      effect = "Allow"
      actions = ["sts:AssumeRole"]
      principals {
        identifiers = var.assume_services
        type        = "Service"
      }
    }
  }
}

data "aws_iam_policy_document" "inline" {
  dynamic "statement" {
    for_each = var.inline_policies
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume.json
  name = var.name
}

resource "aws_iam_role_policy" "this" {
  count = length(var.inline_policies) > 0 ? 1 : 0
  name = var.inline_policy_name
  policy = data.aws_iam_policy_document.inline.json
  role   = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for i, value in var.attach_policy_arns: value => value }
  policy_arn = each.value
  role       = aws_iam_role.this.name
}