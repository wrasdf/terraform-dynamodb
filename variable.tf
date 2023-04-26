variable "name" {
  description = "The name of the dynamodb."
  type = string
  default = ""
}

variable "table_class" {
  description = "Storage class of the table. Valid values are `STANDARD` and `STANDARD_INFREQUENT_ACCESS`"
  type        = string
  default     = "STANDARD"
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 5
}

variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 5
}

variable "stream_enabled" {
  description = "Indicates whether DynamoDB Streams is enabled (true) or disabled (false) on the table."
  type        = bool
  default     = true
}

variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream."
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type        = any
  default     = []
}

variable "local_secondary_indexes" {
  description = "Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  type        = any
  default     = []
}

variable "replica_regions" {
  description = "Region names for creating replicas for a global DynamoDB table."
  type        = any
  default     = []
}

variable "ttl_enabled" {
  description = "Indicates whether ttl is enabled"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = string
  default     = "TimeToExist"
}

variable "point_in_time_recovery_enabled" {
  description = "Whether to enable Point In Time Recovery for the replica."
  type        = bool
  default     = false
}

variable "server_side_encryption_enabled" {
  description = "Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK)."
  type        = bool
  default     = false
}

variable "server_side_encryption_kms_key_arn" {
  description = "ARN of the CMK that should be used for the AWS KMS encryption.This argument should only be used if the key is different from the default KMS-managed DynamoDB key, alias/aws/dynamodb."
  type = string
  default = null
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table."
  type = bool
  default = false
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}