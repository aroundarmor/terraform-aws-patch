provider "aws" {
  region = var.region  # Use the value of the 'region' variable
  default_tags {
    tags = {
      ManagedBy = "Ollion"
    }
  }
}
