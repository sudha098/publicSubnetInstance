resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
      Name = "test-igw"
  }
}

resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.test-igw.id
  }
  tags = {
      Name = "public-crt"
  }
}

resource "aws_route_table_association" "test-crta-public-subnet" {
  subnet_id = aws_subnet.test-public-subnet.id
  route_table_id = aws_route_table.public-crt.id
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.test-vpc.id

  egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    // This means, all ip address are allowed to ssh ! 
    // Do not do it in the production. 
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
        Name = "ssh-allowed"
  }

}   