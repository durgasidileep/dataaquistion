terraform {
  backend "s3" {
    bucket         = "575066535343-ode-foundation-tfstate"
    key            = "dataacquisition-stage/dev.tfstate"
    dynamodb_table = "tfstate-lock"
    encrypt        = "true"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "ode_foundation_persistent" {
  backend = "s3"

  config = {
    bucket = "575066535343-ode-foundation-tfstate"
    key    = "ode-foundation/nonprod-shared.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "dataacquisition_stage_persistent" {
  backend = "s3"

  config = {
    bucket = "575066535343-ode-foundation-tfstate"
    key    = "dataacquisition-stage/nonprod-shared.tfstate"
    region = "us-east-1"
  }
}

