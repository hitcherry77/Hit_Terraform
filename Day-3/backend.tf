terraform {
  backend "s3" {
    bucket = "sfsfsgshsgsg"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}