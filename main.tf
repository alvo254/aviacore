module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  pub_subnet = module.vpc.pub_sub1
  security_group = module.sg.security_group
  pub_subnet2 = module.vpc.pub_sub2
  private_subnet = module.vpc.private_subnet
  private_subnet2 = module.vpc.private_subnet2

}


module "aviatrix-spoke-gw" {
  source = "./modules/aviatrix-spoke-gw"
  vpc_id = module.vpc.vpc_id
  pub_sub1_cidr = module.vpc.pub_sub1_cidr
}


module "aviatrix-smart-grp" {
  source = "./modules/aviatrix-smart-grp"

}

module "aviatrix-web-group" {
  source = "./modules/aviatrix-web-grp"
}