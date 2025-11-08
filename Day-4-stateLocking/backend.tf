terraform {
  backend "s3" {
    bucket = "tfbkt77"
    key    = "terraform.tfstate"
    use_lockfile = true
    region = "ap-south-1"
  }
}