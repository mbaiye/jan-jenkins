resource "aws_instance" "jenkins_master" {
  ami = "ami-0d2d91520dadfe2e3"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mobann-aws-key-pair.key_name
  subnet_id = element(aws_subnet.private-subnets, 0).id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  tags = {
    Name = "jenkins-master"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    delete_on_termination = false
  }
  
}

resource "aws_security_group" "jenkins_security_group" {
  vpc_id = var.vpc_id
  name = "jenkins-sg"
  
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.lb.id]
    }

    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
    }   

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "jenkins-sg"
    }
}