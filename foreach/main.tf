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

    locals {
      project = "project-01"
    }

    resource "aws_vpc" "vpc_main" {
      cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${local.project}-vpc"
    }
    }

    resource "aws_subnet" "main" {
      vpc_id = aws_vpc.vpc_main.id
      cidr_block = "10.0.${count.index}.0/24"
      count = 2
      tags = {
        Name = "${local.project}-subnet-${count.index}"
      }
    }
    
    resource "aws_instance" "main" {

      for_each = var.ec2_map

      ami = each.value.ami
      instance_type = each.value.instance_type

      subnet_id = element(aws_subnet.main[*].id, index(keys(var.ec2_map), each.key)  % length(aws_subnet.main))

      tags = {
        
        Name = "${local.project}-instance-${count.index}"

      }
    }