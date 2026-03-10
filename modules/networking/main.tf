# ---------------------------------------------------------------
# VPC
# ---------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# Public Subnets (ALB)
# ---------------------------------------------------------------
resource "aws_subnet" "public" {
  for_each = {
    a = { cidr = "10.0.1.0/24", az = "${var.region}a" }
    b = { cidr = "10.0.2.0/24", az = "${var.region}b" }
  }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-${each.key}"
    Environment = var.environment
    Tier        = "public"
  }
}

# ---------------------------------------------------------------
# Web / App Subnets (ECS tasks — private, egress via NAT)
# ---------------------------------------------------------------
resource "aws_subnet" "web" {
  for_each = {
    a = { cidr = "10.0.3.0/24", az = "${var.region}a" }
    b = { cidr = "10.0.4.0/24", az = "${var.region}b" }
  }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-web-${each.key}"
    Environment = var.environment
    Tier        = "web"
  }
}

# ---------------------------------------------------------------
# Database Subnets (RDS — private, no egress route needed)
# ---------------------------------------------------------------
resource "aws_subnet" "database" {
  for_each = {
    a = { cidr = "10.0.5.0/24", az = "${var.region}a" }
    b = { cidr = "10.0.6.0/24", az = "${var.region}b" }
  }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-database-${each.key}"
    Environment = var.environment
    Tier        = "database"
  }
}

# ---------------------------------------------------------------
# Elastic IPs for NAT Gateways
# ---------------------------------------------------------------
resource "aws_eip" "nat" {
  for_each = { a = {}, b = {} }

  domain = "vpc"

  tags = {
    Name        = "${var.environment}-nat-eip-${each.key}"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# NAT Gateways (one per AZ for HA)
# ---------------------------------------------------------------
resource "aws_nat_gateway" "nat" {
  for_each = { a = aws_subnet.public["a"].id, b = aws_subnet.public["b"].id }

  subnet_id     = each.value
  allocation_id = aws_eip.nat[each.key].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.environment}-nat-${each.key}"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# Route Tables
# ---------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.environment}-rt-public"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "web" {
  for_each = { a = aws_nat_gateway.nat["a"].id, b = aws_nat_gateway.nat["b"].id }

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value
  }

  tags = {
    Name        = "${var.environment}-rt-web-${each.key}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "web" {
  for_each = aws_subnet.web

  subnet_id      = each.value.id
  route_table_id = aws_route_table.web[each.key].id
}
