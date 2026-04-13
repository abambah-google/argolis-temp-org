# output "vpc_name1" {
#   value = module.vpc.subnets[0].subnet_name
# }

# output "vpc_name2" {
#   value = module.vpc.subnets[1].subnet_name
# }

output "network_01_name" {
  value = module.vpc.network_name
}



