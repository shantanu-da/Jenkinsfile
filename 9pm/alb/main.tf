resource "aws_lb" "test" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id  # Here's the modified line

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

# resource "aws_lb_target_group" "test" {
#   name     = var.target_group_name
#   port     = var.target_group_port
#   protocol = var.target_group_protocol
#   vpc_id   = aws_vpc.main.id
# }
resource "aws_lb_target_group" "test" {
  name        = var.target_group_name
  target_type = "instance"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}
resource "aws_subnet" "public" {
  count     = length(var.public_subnet_cidr_block)  # Set the count based on the length of the CIDR block list
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_block[count.index]
  #availability_zone = var.public_subnet_availability_zone

  tags = {
    Name = "tf-example"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count            = length(var.public_subnet_cidr_block)
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.test[count.index].id
  port             = 80
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_instance" "test" {
  count     = length(var.public_subnet_cidr_block)  # Set the count based on the length of the CIDR block list
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id       = aws_subnet.public[count.index].id  
  
  tags = {
    Name        = "test-instance"  
    Environment = "production"     
  }
}
resource "aws_instance" "test1" {
  count     = length(var.public_subnet_cidr_block)  # Set the count based on the length of the CIDR block list
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id       = aws_subnet.public[count.index].id  
  
  tags = {
    Name        = "test-instance2"  
    Environment = "production2"     
  }
}

# resource "aws_s3_bucket" "lb_logs" {
#   bucket = var.s3_bucket_name

#   tags = {
#     Name        = "lb_logs_buckets"
#     Environment = "Dev"
#   }
# }
# Apply the IAM policy to the S3 bucket
# resource "aws_s3_bucket_policy" "lb_logs_bucket_policy" {
#   bucket = var.s3_bucket_name
#   policy = data.aws_iam_policy_document.s3_bucket_policy.json
# }
data "aws_elb_service_account" "main" {}

# Creating policy on S3, for lb to write
resource "aws_s3_bucket_policy" "lb-bucket-policy" {
  bucket = "${aws_s3_bucket.lb_logs.id}"

  policy = <<POLICY
{
  "Id": "testPolicy1561031527701",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "testStmt1561031516716",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-tf-test-bucket-lb-logs/test-lb/*",
      "Principal": {
        "AWS": [
           "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = var.s3_bucket_name
  #acl    = "private"
  #region = "ap-southeast-2"

  versioning {
    enabled = false
  }
  force_destroy = true


}

resource "aws_security_group" "lb_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "lb_sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}






