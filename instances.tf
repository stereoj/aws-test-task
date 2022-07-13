data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "webserver" {

  depends_on = [
    aws_vpc.awslab-vpc,
    aws_subnet.awslab-subnet-public,
    aws_subnet.awslab-subnet-private,
    aws_security_group.Webserver-SG,
    aws_security_group.MySQL-SG
  ]

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id     = aws_subnet.awslab-subnet-public.id

  vpc_security_group_ids = [aws_security_group.Webserver-SG.id]

  user_data = <<-EOF
    #!/bin/bash
    echo "*** Installing apache2"
    sudo apt update -y
    sudo apt install apache2 -y
    echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = "Webserver_From_Terraform"
  }
}

resource "aws_instance" "MySQL" {
  depends_on = [
    aws_instance.webserver,
  ]

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id     = aws_subnet.awslab-subnet-private.id

  vpc_security_group_ids = [aws_security_group.MySQL-SG.id]

  tags = {
    Name = "MySQL_From_Terraform"
  }

}