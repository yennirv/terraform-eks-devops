####################################################################
#
#
#
####################################################################

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "kubernetes.io/cluster/demo-eks" = "owned"
    }
  }
}

output "NodeInstanceRole" {
  value = aws_iam_role.node_instance_role.arn
}

output "NodeSecurityGroup" {
  value = aws_security_group.node_security_group.id
}

output "NodeAutoScalingGroup" {
  value = aws_cloudformation_stack.autoscaling_group.outputs["NodeAutoScalingGroup"]
}

# Output the public subnet IDs
output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

/*
resource "aws_subnets" "public" {
  vpc_id = data.aws_vpc.default_vpc.id
 # count  = length(data.aws_subnets.public.ids)
  count  = length(public_subnet_ids)

 # cidr_block = data.aws_subnets.public.cidr_blocks[count.index]
  cidr_block = "172.31.0.0/20"
  172.31.16.0/20
  172.31.64.0/20

  tags = {
    "Name"                   = "My Public Subnet ${count.index + 1}"
    "kubernetes.io/cluster"  = var.cluster_name
    "kubernetes.io/role/elb" = "1"
  }
}
*/

resource "aws_subnet" "subnet1" {
  vpc_id     = data.aws_vpc.default_vpc.id
  cidr_block = "172.31.0.0/20"


   tags = {
    "Name"                   = "subnet1"
    "kubernetes.io/cluster"  = var.cluster_name
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = data.aws_vpc.default_vpc.id
  cidr_block = "172.31.16.0/20"
 

  tags = {
    "Name"                   = "subnet2"
    "kubernetes.io/cluster"  = var.cluster_name
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id     = data.aws_vpc.default_vpc.id
  cidr_block = "172.31.64.0/20"
  # Other subnet configuration settings...

  tags = {
    "Name"                   = "subnet3"
    "kubernetes.io/cluster"  = var.cluster_name
    "kubernetes.io/role/elb" = "1"
  }
}


