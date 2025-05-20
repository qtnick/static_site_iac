resource "aws_security_group" "web_sg" {
  name = "web-server-sg"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "static_site" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
  }

  user_data = file("${path.module}/nginx_script.sh")

  tags = {
    Name = "My Static Site"
  }
}

resource "aws_eip" "static_site_eip" {
  domain = "vpc"
  tags = {
    Name = "zerocarb-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.static_site.id
  allocation_id = aws_eip.static_site_eip.id
}

resource "aws_route53_zone" "primary" {
  name = "zerocarb.pl"

  tags = {
    Name = "zerocarb-pl-zone"
  }
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "zerocarb.pl"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.static_site_eip.public_ip]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.zerocarb.pl"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.static_site_eip.public_ip]
}

output "nameservers" {
  description = "Nameservers"
  value       = aws_route53_zone.primary.name_servers
}

output "elastic_ip" {
  description = "Elastic IP address assigned to the instance"
  value       = aws_eip.static_site_eip.public_ip
}
