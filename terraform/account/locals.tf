locals {
  account     = local.sandbox
  environment = lower(terraform.workspace)

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "github-workflow-example"
    environment-name = local.environment
    owner            = "WebOps: opg-webops-community@digital.justice.gov.uk"
    is-production    = false
  }

  optional_tags = {
    infrastructure-support = "OPG Webops: opg-webops-community@digital.justice.gov.uk"
  }

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)

  web_server_port  = 8000
  web_cluster_name = "sandbox-web"
  app_cluster_name = "sandbox-app"

  app_server_port = 8080
}
