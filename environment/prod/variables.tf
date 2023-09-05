variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["${var.region}a", "${var.region}b"]
}
