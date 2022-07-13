resource "aws_security_group" "Webserver-SG" {

  depends_on = [
    aws_vpc.awslab-vpc,
    aws_subnet.awslab-subnet-public,
    aws_subnet.awslab-subnet-private
  ]

  description = "HTTP, HTTPS, PING, SSH"

  name = "webserver-sg"

  vpc_id = aws_vpc.awslab-vpc.id

  ingress {
    description = "HTTP for webserver"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS for webserver"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "MySQL-SG" {

  depends_on = [
    aws_vpc.awslab-vpc,
    aws_subnet.awslab-subnet-public,
    aws_subnet.awslab-subnet-private,
    aws_security_group.Webserver-SG
  ]

  description = "MySQL Access only from the Webserver Instances!"
  name        = "mysql-sg"
  vpc_id      = aws_vpc.awslab-vpc.id

  # Created an inbound rule for MySQL on custom 3110 port
  ingress {
    description     = "MySQL Access"
    from_port       = 3110
    to_port         = 3110
    protocol        = "tcp"
    cidr_blocks     = ["172.16.1.0/24"]
    security_groups = [aws_security_group.Webserver-SG.id]
  }

  ingress {
    description = "Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.1.0/24"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.1.0/24"]
  }

  egress {
    description = "output from MySQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}