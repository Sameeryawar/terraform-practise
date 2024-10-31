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

      user_data = yamldecode(file("./users.yaml")).users

      user_role_pair = flatten([ for user in local.user_data : [for roles in user.roles : {
        username = user.username
        role = roles
      }]] )

    }

    output "user_roles" {

        value = local.user_role_pair
      
    }

    output "data_out" {
      
      value = local.user_data
    }

    resource "aws_iam_user" "users" {
      for_each = toset(local.user_data[*].username)
      name = each.value
    }

    resource "aws_iam_user_login_profile" "profile" {
      
        for_each = aws_iam_user.users
        user = each.value.name
        password_length = 12

         lifecycle {
            ignore_changes = [
            password_length,
            password_reset_required,
            pgp_key,
            ]
        }
    }


