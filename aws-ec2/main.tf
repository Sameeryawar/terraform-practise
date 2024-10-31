terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

resource "aws_instance" "myserver" {

    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"

    tags = {
      "Name" = "Terracreated_server"
    }

}

