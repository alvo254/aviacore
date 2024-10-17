module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "aviatrix-controller" {
  source = "./modules/aviatrix-controller"

}

module "ec2" {
  source = "./modules/ec2"
  pub_subnet = module.vpc.pub_sub1
  security_group = module.sg.security_group
}