terraform {
  required_version = "~> 1.4.4"
  backend "s3" {
    key = "dynamodb/alpha-apse2-v1/game-v1beta3-alpha-apse2-v1.tfstate"
    bucket  = "ops-kube-dynamodb-568431661506-alpha-apse2-v1"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  alias  = "apse2"
  region = "ap-southeast-2"
  default_tags {
    tags = local.default_tags
  }
}

