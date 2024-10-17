variable "vpc_id" {
  description = "The vpc id to associate the sg with"
  type        = string
}

variable "project" {
  default = "aviacore"
}

variable "env" {
  default = "aviacore"
}