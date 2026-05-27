# 1. Look up the latest stable Ubuntu 22.04 AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (The creators of Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Deploy the EC2 instance for the Game Server
resource "aws_instance" "game_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_web_a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  # The automation startup payload script
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io awscli
sudo systemctl start docker
sudo usermod -aG docker ubuntu
        
# Log the server's local Docker engine into our ECR registry
aws ecr get-login-password --region eu-central-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.lootvault_repo.repository_url}
              
# Pull and run our app container in the background
docker run -d --name lootvault-running-app \
-e DB_HOST="${aws_db_instance.postgres_db.endpoint}" \
-e S3_BUCKET="${aws_s3_bucket.lootvault_assets.id}" \
${aws_ecr_repository.lootvault_repo.repository_url}:latest
EOF
  tags = {
    Name = "lootvault-game-server"
  }
}

# 3. Create a Subnet Group for the RDS database
resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "lootvault-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_b.id]

  tags = {
    Name = "lootvault-db-subnet-group"
  }
}

# 4. Deploy the PostgreSQL Database Instance
resource "aws_db_instance" "postgres_db" {
  allocated_storage      = 20
  max_allocated_storage  = 50
  engine                 = "postgres"
  engine_version         = "16.14"
  instance_class         = "db.t3.micro"
  db_name                = "lootvault"
  username               = "vaultadmin"
  password               = "LootVaultSecurePass123!" # Dev placeholder
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.name
  skip_final_snapshot    = true
  apply_immediately      = true
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "lootvault-postgres"
  }
}
