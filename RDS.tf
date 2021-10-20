
resource "aws_db_instance" "redmine_rds_db" {
  db_subnet_group_name = aws_db_subnet_group.postgresql_subnet_group.name
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "10"
  instance_class         = "db.t3.micro"
  availability_zone      = var.zone
  name                   = var.db_name
  username               = var.db_user_name
  password               = var.db_password
  identifier             = "redmine-db"
  multi_az               = false
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.main_firewall.id]
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "postgresql_subnet_group" {
  name       = "postgresubgroup"
  subnet_ids = [module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]]

  tags = {
    Name = "PostgreSQL subnet group"
  }
}

