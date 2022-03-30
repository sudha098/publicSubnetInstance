variable "region_aws" {
  default = "ap-south-1"
  description = "EC2 instance region"
}

variable "a_key" {}

variable "s_key" {}

variable "ami" {
    default = "ami-0851b76e8b1bce90b"
    description = "Image file for virtual machine"
}

variable "vm_type" {
    default = "t2.micro"
    description = "VM Configuration"
}
