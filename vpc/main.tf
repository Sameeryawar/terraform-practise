   terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
        random = {
        source = "hashicorp/random"
        version = "3.6.3"
        }
    }
    }

    # Configure the AWS Provider
    provider "aws" {
    region = "us-east-1"
    }


#    data "aws_ami" "name" {
 #     most_recent = true 
  #    owners = ["amazon"]
  #  }

    data "aws_security_group" "sg" {
      tags = {

        Name = "K8s"

      }
    }

    output "security_group" {
      value = data.aws_security_group.sg
    }
   # output "nam2" {
    #  value = data.aws_ami.name.name
    #}
    #VPC CREATION
    resource "aws_vpc" "my-vpc" {
      cidr_block = "10.0.0.0/16"
      tags = {
        Name = "My-vpc" 
      }
    }

    #SUBNET 
    resource "aws_subnet" "private_subnet" {
      vpc_id = aws_vpc.my-vpc.id
      cidr_block = "10.0.1.0/24"
      tags = {
        Name = "private-subent"
      }
    }

    resource "aws_subnet" "public_subnet" {
      cidr_block = "10.0.2.0/24"
      vpc_id = aws_vpc.my-vpc.id
      tags = {
        Name = "public_subent"
      }
    }
    resource "aws_internet_gateway" "int_gateway" {
        vpc_id = aws_vpc.my-vpc.id
        tags = {
          Name = "my-igw"
        }
    }

    resource "aws_route_table" "myroutetable" {
      vpc_id = aws_vpc.my-vpc.id
      tags = {
        Name = "my-route-table"
      }
      route { 
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.int_gateway.id
    }
    }

    resource "aws_route_table_association" "route_associate" {
      route_table_id = aws_route_table.myroutetable.id
      subnet_id = aws_subnet.public_subnet.id
    }