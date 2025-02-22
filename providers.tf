terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIAYWBJYJX2APKPKQ5Z"
  secret_key = "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"
}
