resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "cloud_pem" { 
  filename = "${var.key_name}.pem"
  content = tls_private_key.key.private_key_pem
}