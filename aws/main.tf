# ---------------------------------------------------------------------------
# AWS EC2 Instance — Bitnami Tomcat Web Server
# Equivalent Azure resource: azurerm_linux_virtual_machine (see ../azure/main.tf)
# ---------------------------------------------------------------------------
data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  tags = {
    Name        = "HelloWorld"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------------------
# AWS S3 Bucket
# Equivalent Azure resource: azurerm_storage_account (see ../azure/main.tf)
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "App Bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_acl" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
