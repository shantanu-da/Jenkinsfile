variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "ap-southeast-2"  # Replace with your desired AWS region
}

variable "lb_name" {
  description = "Name of the load balancer"
  default     = "test-lb-tf"
}

variable "lb_internal" {
  description = "Boolean flag indicating if the load balancer is internal"
  default     = false
}

variable "lb_type" {
  description = "Type of the load balancer"
  default     = "application"
}

# variable "lb_sg_id" {
#   description = "Security group ID for the load balancer"
#   default     = "sg-123456789"  # Replace with the actual security group ID
# }

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "target_group_name" {
  description = "Name of the target group"
  default     = "tf-example-lb-tg"
}

variable "target_group_port" {
  description = "Port for the target group"
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  default     = "HTTP"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0d6f74b9139d26bf1"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for access logs"
  default     = "my-tf-test-bucket-lb-logs"
}

variable "public_subnet_cidr_block" {
  type    = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24"]  # Add more CIDR blocks as needed
}


variable "public_subnet_availability_zone" {
  type = list(string)
  default = ["ap-southeast-2a"]
}

variable "aws_account_id" {
  type = string 
  default = "784392299717"
}
variable "elb_account_ids" {
  type    = list(string)
  default = ["your-elb-account-id-1", "your-elb-account-id-2"]
}
variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for access logs"
  default     = "arn:aws:s3:::my-tf-test-bucket-lb-logs"
}