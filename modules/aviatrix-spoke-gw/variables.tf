variable "vpc_id" {
  description = "This is the aviacore-vpc-Id for the controller to take manage of"
  type = string
}

variable "pub_sub1_cidr" {
  type        = string
  description = "Public subnet for the spoke gateway to be created in"
}

