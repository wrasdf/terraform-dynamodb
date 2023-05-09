resource "aws_backup_selection" "this" {
  
  count = var.backup_enabled ? length(var.selections) : 0

  iam_role_arn = var.backup_iam_role_arn != null ? var.backup_iam_role_arn : aws_iam_role.this[0].arn
  name         = lookup(element(var.selections, count.index), "name", null)
  plan_id      = aws_backup_plan.this[0].id

  resources     = lookup(element(var.selections, count.index), "resources", null)
  not_resources = lookup(element(var.selections, count.index), "not_resources", null)

  dynamic "selection_tag" {
    for_each = length(lookup(element(var.selections, count.index), "selection_tags", [])) == 0 ? [] : lookup(element(var.selections, count.index), "selection_tags", [])
    content {
      type  = lookup(selection_tag.value, "type", null)
      key   = lookup(selection_tag.value, "key", null)
      value = lookup(selection_tag.value, "value", null)
    }
  }

  condition {
    dynamic "string_equals" {
      for_each = lookup(lookup(element(var.selections, count.index), "conditions", {}), "string_equals", [])
      content {
        key   = lookup(string_equals.value, "key", null)
        value = lookup(string_equals.value, "value", null)
      }
    }
    dynamic "string_like" {
      for_each = lookup(lookup(element(var.selections, count.index), "conditions", {}), "string_like", [])
      content {
        key   = lookup(string_like.value, "key", null)
        value = lookup(string_like.value, "value", null)
      }
    }
    dynamic "string_not_equals" {
      for_each = lookup(lookup(element(var.selections, count.index), "conditions", {}), "string_not_equals", [])
      content {
        key   = lookup(string_not_equals.value, "key", null)
        value = lookup(string_not_equals.value, "value", null)
      }
    }
    dynamic "string_not_like" {
      for_each = lookup(lookup(element(var.selections, count.index), "conditions", {}), "string_not_like", [])
      content {
        key   = lookup(string_not_like.value, "key", null)
        value = lookup(string_not_like.value, "value", null)
      }
    }
  }

  depends_on = [aws_dynamodb_table.this]
}
