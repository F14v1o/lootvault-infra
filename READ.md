# LootVault: Secure Multi-Tier RPG Inventory Architecture

An automated, least-privilege AWS backend infrastructure built using Terraform for an RPG video game tracking inventory and assets.

## Architecture Highlights
- **Public Web Tier:** An Ubuntu 22.04 EC2 instance representing the game server.
- **Isolated Database Tier:** A private, multi-AZ PostgreSQL RDS engine completely walled off from the open internet.
- **Asset Storage:** A secure, globally unique Amazon S3 bucket for graphic drops.
- **Security Protocols:** Explicitly linked Security Groups allowing ingress solely on target ports (22 for SSH, 5432 for Postgres) and an IAM Instance Profile granting scoped Read-Only access via AWS STS to the EC2 runtime engine.

## Deployment Steps
1. `terraform init` to gather provider plugins.
2. `terraform apply` to generate the global layout graphs.
3. Use `apply_immediately` parameter controls or direct CLI modification scopes to reconcile cloud asynchronous resource updates.
