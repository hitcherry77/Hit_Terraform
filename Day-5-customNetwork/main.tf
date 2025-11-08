# Create VPC
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Pav_vpc"
    }
  
}
# Create subnets
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "pav-subnet"
    }
}

resource "aws_subnet" "name-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "hit-private"
    }
  
}
# Create IG and attach to VPC

resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
  
}
# Create Route table and eit routes

resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id

   route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id

   }
}
# Create subnet association

resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.name.id
  
}
# Create SG
resource "aws_security_group" "hitsg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "hit-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
  

# Create sevrers  

resource "aws_instance" "public" {
    ami = "ami-0305d3d91b9f22e84"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [ aws_security_group.hitsg.id ]
    associate_public_ip_address = true
    tags = {
      Name = "pub-ec2"
    }
  
}
resource "aws_instance" "pvt" {
    ami = "ami-0305d3d91b9f22e84"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name-2.id
    vpc_security_group_ids = [ aws_security_group.hitsg.id]
    
    tags = {
      Name = "pvt-ec2"
    }
}

#create EIP 
resource "aws_eip" "name" {
    domain = "vpc"
    tags = {
      Name = "my-eip"
    }
}

#create nat
resource "aws_nat_gateway" "My_nat" {
  allocation_id = aws_eip.name.id
  subnet_id     = aws_subnet.name.id
  tags = {
    Name = "Mynat"
  }
}
#create RT and edit routes
resource "aws_route_table" "name-2" {
    vpc_id = aws_vpc.name.id

   route {

    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.My_nat.id

   }
}
#Route table asscoiation 
resource "aws_route_table_association" "name-2" {
    subnet_id = aws_subnet.name-2.id
    route_table_id = aws_route_table.name-2.id
}