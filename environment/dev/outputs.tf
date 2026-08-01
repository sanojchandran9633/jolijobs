output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_instances" {
  value = module.public_ec2.instance_ids
}

output "private_instances" {
  value = module.private_ec2.instance_ids
}