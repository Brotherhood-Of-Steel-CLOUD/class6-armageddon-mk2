resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks.private_zone1
  availability_zone = local.zone1

  tags = {
    Name                              = "private-${local.zone1}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks.private_zone2
  availability_zone = local.zone2

  tags = {
    Name                              = "private-${local.zone2}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_blocks.public_zone1
  availability_zone       = local.zone2
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-${local.zone1}"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_blocks.public_zone2
  availability_zone       = local.zone2
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-${local.zone2}"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}