# resource "aws_default_vpc" "default" {
#     tags = {
#       Name = "Default-VPC"
#     }
# }


data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
    filter {
      name = "tag:Name"
      values = ["default*"]
    }
}

data "aws_ami" "al2023" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    filter {
      name = "architecture"
      values = ["x86_64"]
    }

    filter {
      name = "name"
      values = ["al2023-ami-*"]
    }
}

resource "aws_alb_target_group" "app-lb-tg" {
    name = "phonebook-app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    target_type = "instance"

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 3
  }
}

variable "lb-tg-name" {
    type = string
    default = ""
}

resource "aws_launch_template" "app-asg-lt" {
    name = "phonebook-app-lt"
    image_id = data.aws_ami.al2023.id
    instance_type = "t2.micro"
    key_name = var.key-name
    vpc_security_group_ids = [aws_security_group.server-sg.id]
    user_data = base64encode(templatefile("user-data.sh", {user-data-git-token = var.git-token, user-data-git-user = var.git-name }))
    # depends_on = [ github_repository_file.dbendpoint ]
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "Phonebook Web Server"
      }
    }
}

resource "aws_alb" "app-lb" {
    name = "phoebook-alb"
    ip_address_type = "ipv4"
    internal = false
    load_balancer_type = "application"
    security_groups = [ aws_security_group.alb-sg.id ]
    subnets = data.aws_subnets.default.ids
}

resource "aws_alb_listener" "app-lb-listener" {
    load_balancer_arn = aws_alb.app-lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_alb_target_group.app-lb-tg.arn
    }
}

resource "aws_autoscaling_group" "app-asg" {
    min_size = 1
    max_size = 2
    desired_capacity = 2
    name = "phonebook-asg"
    health_check_grace_period = 300
    health_check_type = "ELB"
    target_group_arns = [aws_alb_target_group.app-lb-tg.arn]
    vpc_zone_identifier = aws_alb.app-lb.subnets
    launch_template {
      id = aws_launch_template.app-asg-lt.id
      version = "$Latest"
    }
}


resource "aws_db_instance" "app-rds-mysql" {
    db_name = "phonebook"
    instance_class = "db.t3.micro"
    allocated_storage = 20
    vpc_security_group_ids = [ aws_security_group.db-sg.id ]
    engine = "mysql"
    engine_version = "8.0.35"
    multi_az = false
    port = 3306
    allow_major_version_upgrade = false
    auto_minor_version_upgrade = true
    monitoring_interval = 0
    backup_retention_period = 0
    publicly_accessible = false
    skip_final_snapshot = true
    username = "admin"
    password = "Oliver_1"
    identifier = "phonebook-rds-mysql"
}

resource "github_repository_file" "dbendpoint" {
    content = aws_db_instance.app-rds-mysql.address
    file = "dbserver.endpoint"
    repository = "phonebook-app"
    overwrite_on_create = true
    commit_author = "Michael Maggs"
    commit_email = "seattleslew@runawayserver.com"
    branch = "main" #ensure this is the branch you are using
}

data "aws_route53_zone" "public" {
    name = var.hosted-zone
}

resource "aws_route53_record" "app-url" {
    zone_id = data.aws_route53_zone.public.id
    name = "phonebook.${var.hosted-zone}"
    type = "A"

    alias {
      name = aws_alb.app-lb.dns_name
      zone_id = aws_alb.app-lb.zone_id
      evaluate_target_health = true
    }
}