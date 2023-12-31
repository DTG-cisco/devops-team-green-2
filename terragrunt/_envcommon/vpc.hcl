# -----------  WILL USE OWN (Custom) MODULE -----------

terraform {
  source = "git::https://github.com/DTG-cisco/devops-team-green-2.git//terraform/modules/gcp_network"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  region           = local.environment_vars.locals.region
  project_id       = local.environment_vars.locals.project_id
  cidr_range       = local.environment_vars.locals.cidr_range
}

inputs = {
  cidr_range = "${local.cidr_range}"
  vpc_name   = "vpc-${local.env}"
  region     = "${local.region}"
  env        = "${local.env}"
  project_id = "${local.project_id}"
}
