terraform {
  source = "git::https://github.com/DTG-cisco/devops-team-green-2.git//terraform/modules/gcp_helm"
}

dependencies {
  paths = ["../vpc", "../kubernetes", "../helm_backend", "../helm_front"]
}

dependency "cluster_ip" {
  config_path                             = "../kubernetes"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs = {
    cluster_endpoint       = "10.10.10.10"
    cluster_ca_certificate = "mock"
    client_certificate     = "mock"
    client_key             = "mock"
  }
}

dependency "cluster_namespaces" {
  config_path  = "../kuber_namespaces"
  skip_outputs = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  app              = local.environment_vars.locals.app_api_gw
  namespace        = local.environment_vars.locals.namespace
  chart_n          = local.environment_vars.locals.chart_api_gw
  repository       = local.environment_vars.locals.repo_api_gw
}

inputs = {
  app                    = "${local.app}"
  cluster_ca_certificate = dependency.cluster_ip.outputs.cluster_ca_certificate
  client_certificate     = dependency.cluster_ip.outputs.client_certificate
  client_key             = dependency.cluster_ip.outputs.client_key

  env        = "${local.env}"
  namespace  = "${local.namespace}"
  chart_name = "${local.chart_n}"
  repository = "${local.repository}"
  kuber_host = "https://${dependency.cluster_ip.outputs.cluster_endpoint}"
}