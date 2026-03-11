# NOTE: This file was a standalone S3 experiment from the course.
# Its content has been consolidated into main.tf.
# Kept here as a reference artifact.
#
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }
#
# provider "aws" {
#   region = "us-east-1"
# }
#
# resource "aws_s3_bucket" "primeiro_bucket" {
#   bucket = "meu-primeiro-bucket-terraform"
#
#   tags = {
#     Name        = "Meu primeiro bucket"
#     Environment = "Dev"
#   }
# }
