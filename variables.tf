variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.0.1.0/24"
}


variable "instance_type" {
  description = "Type of instance to launch"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of AWS SSH Key Pair"
}

variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for EC2 instance"
  type        = string
  default     = "us-east-1b" # default to what you want
}
