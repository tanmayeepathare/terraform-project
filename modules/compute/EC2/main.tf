resource "aws_instance" "example" {
  ami           = var.instance_ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  # count = var.instance_count
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = "${var.environment}-web-server"
    Environment = var.environment
  }
}
