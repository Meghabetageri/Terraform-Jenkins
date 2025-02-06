# VPC Configuration
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

# Public Subnets Configuration
resource "aws_subnet" "eks_subnet_public_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-public-a"
  }
}

resource "aws_subnet" "eks_subnet_public_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-public-b"
  }
}

# Private Subnets Configuration
resource "aws_subnet" "eks_subnet_private_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "eks-subnet-private-a"
  }
}

resource "aws_subnet" "eks_subnet_private_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "eks-subnet-private-b"   
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the necessary policy for the EKS Cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Security Group for EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Allow EKS communication"
  vpc_id      = aws_vpc.eks_vpc.id
}

resource "aws_security_group_rule" "allow_eks_inbound" {
  type               = "ingress"
  from_port          = 0
  to_port            = 65535
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.eks_cluster_sg.id
}

# EKS Cluster Configuration
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_subnet_public_a.id,
      aws_subnet.eks_subnet_public_b.id,
      aws_subnet.eks_subnet_private_a.id,
      aws_subnet.eks_subnet_private_b.id
    ]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  tags = {
    Name = "MyEKSCluster"
  }
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_worker_role" {
  name = "eks-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the necessary policy for Worker Nodes
resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_attach" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Security Group for Worker Nodes
resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"
  description = "Allow communication between EKS worker nodes"
  vpc_id      = aws_vpc.eks_vpc.id
}

# EKS Node Group Configuration (Optional)
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-node-group"
  node_role_arn       = aws_iam_role.eks_worker_role.arn
  subnet_ids      = [
    aws_subnet.eks_subnet_public_a.id,
    aws_subnet.eks_subnet_public_b.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]
}
