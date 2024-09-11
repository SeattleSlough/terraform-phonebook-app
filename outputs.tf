output "website-url" {
  value = "http://${aws_route53_record.app-url.name}"
}

output "dns-name" {
    value = "http://${aws_alb.app-lb.dns_name}"
}

output "db-address" {
  value = aws_db_instance.app-rds-mysql.address
}

output "db_endpoint" {
    value = aws_db_instance.app-rds-mysql.endpoint
}