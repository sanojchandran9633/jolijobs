module "s3_backend_terraform" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  env         = var.env
}

module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "sg" {
  source = "../../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "public_ec2" {
  source         = "../../modules/ec2"
  instance_count = 3
  ami            = var.ami
  instance_type  = var.instance_type
  subnet_id      = module.vpc.public_subnet_id
  sg_id          = module.sg.sg_id
  instance_name  = "Public"
}

module "private_ec2" {
  source         = "../../modules/ec2"
  instance_count = 0
  ami            = var.ami
  instance_type  = var.instance_type
  subnet_id      = module.vpc.private_subnet_id
  sg_id          = module.sg.sg_id
  instance_name  = "Private"
}

