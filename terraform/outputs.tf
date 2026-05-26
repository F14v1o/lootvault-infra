output "ec2_public_ip" {
  description = "The public IP address of our game server"
  value       = aws_instance.game_server.public_ip
}

output "rds_endpoint" {
  description = "The connection endpoint for our PostgreSQL database"
  value       = aws_db_instance.postgres_db.endpoint
}

output "s3_bucket_name" {
  description = "The generated name of our unique S3 asset bucket"
  value       = aws_s3_bucket.lootvault_assets.id
}
