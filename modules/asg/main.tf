locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "al2023-ami-2023.*-x86_64"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }

  filter {
    name = "root-device-type"
    values = [
      "ebs"
    ]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = "ACS730-${var.environment}-Bastion"
  })
}

resource "aws_launch_template" "web" {
  name = "ACS730-${var.environment}-Web-LT"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.web_security_group_id
  ]

user_data = base64encode(<<-USERDATA
#!/bin/bash

dnf install -y httpd awscli

systemctl enable httpd
systemctl start httpd

aws s3 cp s3://${var.bucket_name}/images/daniel_linkedin.png /var/www/html/daniel_linkedin.png

TOKEN=$(curl -X PUT -s \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
http://169.254.169.254/latest/api/token)

INSTANCE_ID=$(curl -s \
-H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<HTML
<html>
<body>

<h1>ACS730 Final Project</h1>

<p>Student: Daniel Araujo</p>

<p>EC2 Instance ID: $INSTANCE_ID</p>

<h2>Image Loaded From S3</h2>

<img src="/daniel_linkedin.png" width="500">

</body>
</html>
HTML

systemctl restart httpd
USERDATA
)

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "ACS730-${var.environment}-Web"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(local.common_tags, {
      Name = "ACS730-${var.environment}-Web-Volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "ACS730-${var.environment}-LaunchTemplate"
  })
}

resource "aws_autoscaling_group" "web" {
  name = "ACS730-${var.environment}-ASG"

  desired_capacity = var.desired_capacity
  min_size         = var.minimum_capacity
  max_size         = var.maximum_capacity

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"

  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ACS730-${var.environment}-Web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.owner
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "ACS730-${var.environment}-ScaleOut"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "ACS730-${var.environment}-HighCPU"
  alarm_description   = "Scale out when average CPU is above 10 percent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
  ]

  tags = local.common_tags
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "ACS730-${var.environment}-ScaleIn"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "ACS730-${var.environment}-LowCPU"
  alarm_description   = "Scale in when average CPU is below 5 percent"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]

  tags = local.common_tags
}
