# resource "aws_security_group" "alb-sg" {
#   name = "ALB-security-group-pb"
#   vpc_id = data.aws_vpc.default.id
#   tags = {
#     Name = "TF-ALB-sg-pb"
#   }
# }

# resource "aws_security_group" "server-sg" {
#     name = "WebServer-security-group-pb"
#     vpc_id = data.aws_vpc.default.id
#     tags = {
#         Name = "TF-Web-Server-sg-pb"
#     }
# }

# resource "aws_security_group" "db-sg" {
#     name = "RDS-security-group-pb"
#     vpc_id = data.aws_vpc.default.id
#     tags = {
#         Name = "TF-RDS-sg-pb"
#     }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_http_anywhere" {
#     for_each = {for id in [aws_security_group.alb-sg.id, aws_security_group.server-sg.id]: tostring(id) => id }
#     security_group_id = each.key
#     from_port = 80
#     ip_protocol = "tcp"
#     to_port = 80
#     cidr_ipv4 = "0.0.0.0/0"
# }


# resource "aws_vpc_security_group_egress_rule" "allow_anywhere" {
#     for_each = {for id in [aws_security_group.alb-sg.id, aws_security_group.server-sg.id, aws_security_group.db-sg.id]: tostring(id) => id }
#     security_group_id = each.key

#     from_port = 0
#     ip_protocol = -1
#     to_port = 0
#     cidr_ipv4 = "0.0.0.0/0"
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_anywhere" {
#     security_group_id = aws_security_group.server-sg.id
#     from_port = 22
#     to_port = 22
#     cidr_ipv4 = "0.0.0.0/0"
#     ip_protocol = "tcp"
#     description = "allows ssh traffic from anywhere"
# }

# resource "aws_security_group_rule" "private_mysql" {
#     security_group_id = aws_security_group.db-sg.id
#     source_security_group_id = aws_security_group.server-sg.id
#     type = "ingress"
#     from_port = 3306
#     to_port = 3306
#     protocol = "tcp"
#     description = "allows web server to connect with RDS"
# }


resource "aws_security_group" "alb-sg" {
  name   = "ALBSecurityGroup-p"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "TF_ALBSecurityGroup"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "server-sg" {
  name   = "WebServerSecurityGroup-p"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "TF_WebServerSecurityGroup"
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-sg" {
  name   = "RDSSecurityGroup-p"
  vpc_id = data.aws_vpc.default.id
  tags = {
    "Name" = "TF_RDSSecurityGroup"
  }
  ingress {
    security_groups = [aws_security_group.server-sg.id]
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = -1
    to_port     = 0
  }
}