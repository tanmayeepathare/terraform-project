resource "aws_instance" "httpd_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
  EOF

  tags = {
    Name = "httpd-amazon"
  }
}

output "httpd_public_ip" {
  value = aws_instance.httpd_server.public_ip
}