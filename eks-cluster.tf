module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.public_subnets

  tags = {
    Project = "redmine"
    Environment = "training"
  }

  write_kubeconfig = true
  kubeconfig_name = "config"
  kubeconfig_file_permission = "600"
  kubeconfig_output_path = "/home/romario/.kube/"

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }


  worker_groups = [
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.main_firewall.id]
      asg_desired_capacity          = 2
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
