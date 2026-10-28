# SECURITY GROUP WE NEED ONLY THE OUTBOUND ACCESS

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}_tf_sg"
  description = "ec2 security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-security_group_tf"
    Environment = "dev"
    ManagedBy   = "Terraform"

  }
}

# AWS EC2 INSTANCE


resource "aws_instance" "example" {
  ami           =  var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  

  user_data = <<-EOT
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    # We even use the Terraform variable inside the server!
    echo "<h1>Hello from Terraform Locals Demo  environment)</h1>" > /var/www/html/index.html
EOT

  tags = {
    Name = "${var.project_name}-tf_instance"
    AutoSchedule = "true"
  }
}