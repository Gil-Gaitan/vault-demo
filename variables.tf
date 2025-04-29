variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Name of AWS SSH Key Pair"
}

variable "ami_id" {
  default = "ami-02029c87fa31fb148"
}
