name      = "game-v1beta3-alpha-apse2-v1"

hash_key  = "UserId"
range_key = "GameTitle"

global_secondary_indexes = [
  {
    "name"               = "GameTitleIndex"
    "hash_key"           = "GameTitle"
    "range_key"          = "TopScore"
    "write_capacity"     = 2
    "read_capacity"      = 2
    "projection_type"    = "INCLUDE"
    "non_key_attributes" = [
      "UserId",
    ]
  },
]

replica_regions = [
    "us-east-1",
    "eu-west-1",
]

attributes = [
    {  
      "name" = "UserId"
      "type" = "S"
    },
    {  
      "name" = "GameTitle"
      "type" = "S"
    },
    {  
      "name" = "TopScore"
      "type" = "N"
    },
]

backup_enabled = true

# Multiple rules using a list of maps
backup_rules = [
  {
    name                     = "rule-1"
    schedule                 = "cron(0 12 * * ? *)"
    target_vault_name        = "game-v1beta3-alpha-apse2-v1"
    start_window             = 120
    completion_window        = 360
    enable_continuous_backup = true
    lifecycle = {
      cold_storage_after = 0
      delete_after       = 30
    }
    copy_actions = {}
    recovery_point_tags = {}
  }
]

selections = [
  {
    name          = "backup-dynamodb-section"
    resources     = ["arn:aws:dynamodb:ap-southeast-2:568431661506:table/game-v1beta3-alpha-apse2-v1"]
  }
]