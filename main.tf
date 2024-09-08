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
    name = "phonebook-lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    target_type = "instance"

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 3
  }
}

resource "aws_launch_template" "app-asg-lt" {
    name = "phonebook-lt"
    image_id = data.aws_ami.al2023.id
    instance_type = "t2.micro"
    key_name = var.key-name
    vpc_security_group_ids = [aws_security_group.server-sg.id]
    user_data = base64encode(templatefile(user-data.sh, { user-data-git-token = var.git-token, user-data-git-name = var.git-name }))
    depends_on = [ github_repository_file.dbendpoint ]
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "Phonebook Web Server"
      }
    }
}