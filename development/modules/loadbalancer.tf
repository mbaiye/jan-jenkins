resource "aws_security_group" "lb" {
    vpc_id = var.vpc_id
    name = "lb-sg"
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        } 
    
    tags = {
        Application = "jenkins"
    }
}

resource "aws_elb" "jenkins_lb" {
    name = "jenkins-lb"
    security_groups = [aws_security_group.lb.id]
    subnets = [for subnet in aws_subnet.public-subnets : subnet.id]
    cross_zone_load_balancing = true
    instances = [aws_instance.jenkins_master.id]
    listener {
        instance_port = 8080
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    health_check {
        target = "TCP:8080"
        interval = 5
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
    tags = {
        Application = "jenkins"
    }
}
  output "load_balancer_dns_name" {
    value = "aws_elb.jenkins_lb.dns_name"
  }
