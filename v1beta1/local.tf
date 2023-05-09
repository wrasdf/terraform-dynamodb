locals {

  default_tags = {
    team                  = "Platform Kompute"
    created_by            = "ops-kube-crossplane-terraform"
    managed_by            = "crossplane terraform-provider"
    service_name          = "terraform dynamodb"
    deployment_method     = "Terraform"
    crossplane.io/paused  = "true"
  }
  
}