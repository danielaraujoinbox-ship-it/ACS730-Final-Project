locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role" "ec2" {
  name = "ACS730-${var.environment}-EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "ACS730-${var.environment}-EC2-Role"
  })
}

resource "aws_iam_role_policy" "s3_read" {
  name = "ACS730-${var.environment}-S3-Read-Policy"
  role = aws_iam_role.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "arn:aws:s3:::${var.bucket_name}/images/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::${var.bucket_name}"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ACS730-${var.environment}-EC2-Profile"
  role = aws_iam_role.ec2.name

  tags = local.common_tags
}
