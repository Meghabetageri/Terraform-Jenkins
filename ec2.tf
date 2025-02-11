provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-00bb6a80f01f03502"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"  # Instance type
  
  tags = {
    Name = "MyTerraformEC2"
  }
}