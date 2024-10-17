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


resource "aviatrix_spoke_gateway" "spoke_gateway_1" {
    cloud_type = 1
    account_name = "aws-account"
    gw_name = "avaicore-gw"
    vpc_id = "vpc-0b5162623c6f0470d~~aviacore-prod-vpc"
    vpc_reg = "us-east-1 (N. Virginia)"
    gw_size = "t3.medium"
    subnet = "172.16.0.0/22"
    manage_ha_gateway = false
}

resource "aviatrix_spoke_transit_attachment" "spoke_transit_attachment_1" {
    spoke_gw_name = "avaicore-gw"
    transit_gw_name = "aws-us-west-2-transit"
    depends_on = [ 
        aviatrix_spoke_gateway.spoke_gateway_1
    ]
}

resource "aviatrix_spoke_ha_gateway" "spoke_ha_gateway_1" {
    primary_gw_name = "avaicore-gw"
    subnet = "172.16.8.0/22"
    depends_on = [ 
        aviatrix_spoke_gateway.spoke_gateway_1
    ]
}

