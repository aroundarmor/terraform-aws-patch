terraform {
  backend "s3" {
    bucket = "ollion-patching-terraform-state-in-${var.aws_region}-and-${var.aws_account_id}"
    key    = "tf_state/terraform.tfstate"
    region = var.aws_region
    #dynamodb_table = "terraform-lock"
    encrypt = true
  }
}
