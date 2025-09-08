terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "dev"
}

# Create VPC 
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "inno-g-bucket-123456"   # must be globally unique

  tags = {
    Name = "inno-bucket"
  }
}

# bucket ownership
resource "aws_s3_bucket_ownership_controls" "bucket-ownership-controls" {
    bucket = aws_s3_bucket.s3_bucket.id 

    rule {
      object_ownership = "BucketOwnerPreferred"
    }
  
}

# Allow public access (disable blocking)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy to make all objects public
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.s3_bucket.arn}/*"
      }
    ]
  })
}

# Upload object (no ACLs)
resource "aws_s3_object" "s3_object" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "myfolder/text.txt"
  source = "text.txt"
  etag   = filemd5("text.txt")
}
