terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.61.0"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
