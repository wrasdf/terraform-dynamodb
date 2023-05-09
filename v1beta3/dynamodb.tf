resource "aws_dynamodb_table" "this" {

  count = var.create_table ? 1 : 0
  
  name             = var.name
  table_class      = var.table_class
  billing_mode     = var.billing_mode

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  hash_key         = var.hash_key
  range_key        = var.range_key

  write_capacity   = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  read_capacity    = var.billing_mode == "PROVISIONED" ? var.read_capacity : null

  dynamic "attribute" {
    for_each  = var.attributes

    content {
      name    = attribute.value.name
      type    = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = var.billing_mode == "PROVISIONED" ? global_secondary_index.read_capacity : null
      write_capacity     = var.billing_mode == "PROVISIONED" ? global_secondary_index.write_capacity : null
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes

    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region_name = replica.value
    }
  }

  ttl {
    attribute_name = var.ttl_attribute_name
    enabled        = var.ttl_enabled
  }

  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }

  deletion_protection_enabled = var.deletion_protection_enabled

  ## Used for restore
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  tags = merge(
    local.default_tags,
    var.tags,
    {
      name = format("%s", var.name)
    },
  )

  lifecycle {
    ignore_changes = [
      billing_mode,
      write_capacity,
      read_capacity
    ]
  }

}