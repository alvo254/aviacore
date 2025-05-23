variable "cidr_block" {
  default = "172.16.0.0/20"
}

variable "project" {
  default = "aviacore"
}

variable "env" {
  default = "Production"
}

variable "public_subnet1" {
  default = "172.16.0.0/22"
}

variable "public_subnet2" {
  default = "172.16.4.0/22"
}

variable "private_subnet" {
  default = "172.16.8.0/22"
}

variable "private_subnet2" {
  default = "172.16.12.0/22"
}

