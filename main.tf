provider "aws" {
  region     = "us-west-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}


resource "aws_key_pair" "key" {
  key_name   = "Bastion2565333"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

data "template_file" "init" {
  template = "${file("${path.module}/httpd.sh")}"
}

resource "aws_launch_template" "example" {
 name_prefix   = "example"
  image_id      = "ami-0d6621c01e8c2de2c"
  instance_type = "t2.micro"
  user_data       = "${base64encode(data.template_file.init.rendered)}"
  vpc_security_group_ids = ["${aws_security_group.allow.id}"]
  key_name = "${aws_key_pair.key.key_name}"
}

resource "aws_autoscaling_group" "example" {
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
  ]

  desired_capacity = "2"
  max_size         = "3"
  min_size         = "1"
 
  
launch_template  {
    id = "${aws_launch_template.example.id}"
    
    }
  }


resource "aws_security_group" "allow" {
  name        = "allowsitshds"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "TLS from VPC"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


variable "access_key" {}
variable "secret_key" {}
