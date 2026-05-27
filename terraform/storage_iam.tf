# 1. Create a secure S3 Bucket for LootVault game images
resource "aws_s3_bucket" "lootvault_assets" {
  bucket_prefix = "lootvault-assets-"
  force_destroy = true

  tags = {
    Name = "lootvault-assets"
  }
}

# 2. Create the IAM Role that EC2 will assume
resource "aws_iam_role" "ec2_lootvault_role" {
  name = "ec2-lootvault-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 3. Define the Least-Privilege permissions policy (Read-Only)
resource "aws_iam_policy" "s3_read_policy" {
  name        = "lootvault-s3-read-policy"
  description = "Allows game server to read game assets from S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.lootvault_assets.arn,
          "${aws_s3_bucket.lootvault_assets.arn}/*"
        ]
      }
    ]
  })
}

# 4. Bind the Policy directly to the Role
resource "aws_iam_role_policy_attachment" "attach_s3_read" {
  role       = aws_iam_role.ec2_lootvault_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# 5. Create an Instance Profile (The physical holster for the badge)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "lootvault-ec2-instance-profile"
  role = aws_iam_role.ec2_lootvault_role.name
}
resource "aws_iam_role_policy_attachment" "attach_ecr_read" {
  role       = aws_iam_role.ec2_lootvault_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
