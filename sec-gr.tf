resource "aws_security_group" "alb-sg" {
  name = "ALB-security-group-pb"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name = "TF-ALB-sg-pb"
  }
}

resource "aws_security_group" "server-sg" {
    name = "WebServer-security-group-pb"
    vpc_id = data.aws_vpc.selected.id
    tags = {
        Name = "TF-Web-Server-sg-pb"
    }
}

resource "aws_security_group" "db-sg" {
    name = "RDS-security-group-pb"
    vpc_id = data.aws_vpc.selected.id
    tags = {
        Name = "TF-RDS-sg-pb"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_anywhere" {
    for_each = toset(var.web_security_groups)
    security_group_id = each.key

    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_anywhere" {
    for_each = toset(var.all_security_groups)
    security_group_id = each.key

    from_port = 0
    ip_protocol = -1
    to_port = 0
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_anywhere" {
    security_group_id = aws_security_group.server-sg
    from_port = 22
    to_port = 22
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    description = "allows ssh traffic from anywhere"
}

resource "aws_security_group_rule" "private_mysql" {
    security_group_id = aws_security_group.db-sg
    source_security_group_id = aws_security_group.server-sg
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    description = "allows web server to connect with RDS"
}