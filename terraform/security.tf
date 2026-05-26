# 1. Web Tier Security Group Shell
resource "aws_security_group" "web_sg" {
  name        = "lootvault-web-sg"
  description = "Security group for LootVault Game Server"
  vpc_id      = aws_vpc.lootvault_vpc.id

  tags = {
    Name = "lootvault-web-sg"
  }
}

# Inbound Rule: Allow SSH from the public internet
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH admin management"
}

# Outbound Rule: Allow Web Server to talk to the outer internet
resource "aws_vpc_security_group_egress_rule" "web_allow_all" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # -1 indicates all protocols
}

# 2. Database Tier Security Group Shell
resource "aws_security_group" "db_sg" {
  name        = "lootvault-db-sg"
  description = "Security group for LootVault PostgreSQL"
  vpc_id      = aws_vpc.lootvault_vpc.id

  tags = {
    Name = "lootvault-db-sg"
  }
}

# Inbound Rule: ONLY accept connections originating from the Web Security Group
resource "aws_vpc_security_group_ingress_rule" "allow_postgres" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.web_sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
  description                  = "Allow PostgreSQL traffic only from the web tier"
}
