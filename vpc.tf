
resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  enable_classiclink = "false"
  instance_tenancy = "default"

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "test-public-subnet" {
  vpc_id = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"  //it makes this a public subnet
  availability_zone = "ap-south-1a"
  tags = {
        Name = "test-public-subnet"
    }
}

resource "aws_key_pair" "sshkeypair" {
    key_name = "sudha"
    public_key = file("sudha.pub")
}

resource "aws_instance" "webserver" {
    ami = var.ami
    instance_type = var.vm_type
    key_name = aws_key_pair.sshkeypair.key_name

    //VPC
    subnet_id = aws_subnet.test-public-subnet.id

    //Security Group
    vpc_security_group_ids = [aws_security_group.ssh-allowed.id]

    connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("sudha")
    }

    provisioner "file" {
        source = "web.sh"
        destination = "/tmp/web.sh"
    }

    provisioner "remote-exec" {
      inline = [
          "sudo chmod +x /tmp/web.sh",
          "sudo /tmp/web.sh"
      ]
    }

    provisioner "local-exec" {
        command = "echo ${self.public_ip}"
    }
}
