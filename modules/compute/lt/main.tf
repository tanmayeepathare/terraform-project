
#################################################
# LOCAL TAGS
#################################################

locals {

  common_tags = {

    Environment = var.environment

    ManagedBy = "Terraform"

    Project = var.project_name
  }
}

#################################################
# AMAZON LINUX 2023 AMI
#################################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["al2023-ami-*-x86_64"]
  }

  filter {

    name = "virtualization-type"

    values = ["hvm"]
  }
}

#################################################
# LAUNCH TEMPLATE
#################################################

resource "aws_launch_template" "web_template" {

  name_prefix = "${var.environment}-web-template-"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  key_name = var.key_name

  #################################################
  # SECURITY GROUP
  #################################################

  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  #################################################
  # EBS VOLUME
  #################################################

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = var.root_volume_size

      volume_type = var.root_volume_type

      encrypted = true

      delete_on_termination = true
    }
  }

  #################################################
  # MONITORING
  #################################################

  monitoring {

    enabled = false
  }

  #################################################
  # INSTANCE METADATA OPTIONS
  #################################################

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"

    http_put_response_hop_limit = 2
  }

  #################################################
  # USER DATA
  #################################################

user_data = base64encode(<<-EOF
#!/bin/bash

set -euxo pipefail

dnf update -y

dnf install -y httpd

systemctl enable httpd

systemctl start httpd

sleep 15

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
-s http://169.254.169.254/latest/meta-data/instance-id)

HOSTNAME=$(hostname)

echo "<h1>Production Web Server</h1>" > /var/www/html/index.html

echo "<h2>Hostname: $HOSTNAME</h2>" >> /var/www/html/index.html

echo "<h3>Instance ID: $INSTANCE_ID</h3>" >> /var/www/html/index.html

curl localhost
EOF
)
  #################################################
  # TAG SPECIFICATIONS
  #################################################

  tag_specifications {

    resource_type = "instance"

    tags = merge(

      local.common_tags,

      {

        Name = "${var.environment}-web-server"

        Type = "application-server"
      }
    )
  }

  #################################################
  # EBS TAGS
  #################################################

  tag_specifications {

    resource_type = "volume"

    tags = merge(

      local.common_tags,

      {

        Name = "${var.environment}-web-volume"
      }
    )
  }

  #################################################
  # LAUNCH TEMPLATE TAGS
  #################################################

  tags = merge(

    local.common_tags,

    {

      Name = "${var.environment}-launch-template"
    }
  )

  #################################################
  # LIFECYCLE
  #################################################

  lifecycle {

    create_before_destroy = true
  }

  #################################################
  # VERSION MANAGEMENT
  #################################################

  update_default_version = true
}