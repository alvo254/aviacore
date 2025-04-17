terraform {
  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "3.1.4"
    }
  }
}

# resource "aviatrix_transit_gateway" "transit_gateway_1" {
#     cloud_type = 1
#     account_name = "aws-account"
#     gw_name = "aviacore"
#     vpc_id = "vpc-03883fa8c6d0a12f3~~immersion-day-vpc"
#     vpc_reg = "us-east-1 (N. Virginia)"
#     gw_size = "t3.medium"
#     subnet = "10.8.0.0/24"
# }



//This spoke gateway manages the aviacore-prod-vpc 
resource "aviatrix_spoke_gateway" "spoke_gateway_1" {
    cloud_type = 1
    account_name = "aws-account"
    gw_name = "aws-us-east-1-spoke-1"
    vpc_id = var.vpc_id
    vpc_reg = "us-east-1 (N. Virginia)"
    gw_size = "t3.medium"
    subnet = var.pub_sub1_cidr
    manage_ha_gateway = false
}

# For HA
resource "aviatrix_spoke_ha_gateway" "spoke_ha_gateway_1" {
    primary_gw_name = aviatrix_spoke_gateway.spoke_gateway_1.gw_name
    subnet = "172.16.4.0/22"
    depends_on = [ 
        aviatrix_spoke_gateway.spoke_gateway_1
    ]
}


resource "aviatrix_spoke_transit_attachment" "spoke_transit_attachment_1" {
    spoke_gw_name = aviatrix_spoke_gateway.spoke_gateway_1.gw_name
    transit_gw_name = "aws-us-west-2-transit"
    depends_on = [ 
        aviatrix_spoke_gateway.spoke_gateway_1
    ]
}



