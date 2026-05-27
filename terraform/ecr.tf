resource "aws_ecr_repository" "lootvault_repo" {
  name                 = "lootvault-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  description = "The absolute endpoint URL registry path for our container repository"
  value       = aws_ecr_repository.lootvault_repo.repository_url
}
