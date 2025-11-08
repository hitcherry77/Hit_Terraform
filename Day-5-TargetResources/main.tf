
resource "aws_instance" "name" {
    ami = "ami-0305d3d91b9f22e84"
    instance_type = "t3.micro"
    availability_zone = "ap-south-1c"
    tags = {
        Name = "TRec2"
    }

}

resource "aws_s3_bucket" "name" {
    bucket = "aihshsisifsigo"
  

}