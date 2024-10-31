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
    resource "random_id" "random_no" {
        byte_length = 8
    }
    resource "aws_s3_bucket" "mys3bucket" {
    bucket = "myterrau${random_id.random_no.hex}"
    }
    resource "aws_s3_object" "bucket-data" {
        bucket = aws_s3_bucket.mys3bucket.bucket
        source = "./myfile.html"
        key = "index.html"
        content_type  = "text/html"
    }

    resource "aws_s3_object" "data2" {
        bucket = aws_s3_bucket.mys3bucket.bucket
        source = "./new.txt"
        key = "new.txt"
        content_type  = "text/text"
    }
    output "Name" {
      value = aws_s3_bucket.mys3bucket.bucket
    }