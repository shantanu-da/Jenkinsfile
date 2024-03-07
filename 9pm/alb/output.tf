output "aws_instance_private_ip" {
  value = [for instance in aws_instance.test : instance.private_ip]
}
output "lb_dns_name" {
  value = aws_lb.test.dns_name
}

output "target_group_name" {
  description = "The name of the target group"
  value       = aws_lb_target_group.test.name
}

output "vpc_name" {
  value = aws_vpc.main.id
}
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


# output "aws_instance_private_ip" {
#   value = [for instance in aws_instance.test : instance.private_ip]  # Accessing instances with a list comprehension
# }