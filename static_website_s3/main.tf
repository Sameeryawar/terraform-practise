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

    resource "random_id" "random_name" {
        byte_length = 8
    }
    resource "aws_s3_bucket" "mywebapp-bucket" {
       bucket = "mywebappbucket-${random_id.random_name.hex}"
    }

    resource "aws_s3_bucket_public_access_block" "public_block" {
        bucket = aws_s3_bucket.mywebapp-bucket.id
        block_public_acls       = false
        block_public_policy     = false
        ignore_public_acls      = false
        restrict_public_buckets = false
    }

    resource "aws_s3_bucket_policy" "permission_policy" {
      bucket = aws_s3_bucket.mywebapp-bucket.id
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "PublicReadGetObject",
                Effect = "Allow",
                Principal = "*",
                Action = "s3:GetObject",
                Resource = "arn:aws:s3:::${aws_s3_bucket.mywebapp-bucket.id}/*"
                
            }
        ]
        
      }
      )
    }

    resource "aws_s3_object" "indexpage" {
        bucket = aws_s3_bucket.mywebapp-bucket.id
        source = "./index.html"
        key = "index.html"
        content_type = "text/html"
    }

    resource "aws_s3_bucket_website_configuration" "enable_static_site" {
      bucket = aws_s3_bucket.mywebapp-bucket.id
        index_document {
            suffix = "index.html"
        }
    }

    output "objecturl" {
      value = aws_s3_bucket_website_configuration.enable_static_site.website_endpoint
    }