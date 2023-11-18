resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  user_data = file("scripts/web-server-setup.sh") # file function helps read the content of a file at a given path and return them as a string
  vpc_security_group_ids = [aws_security_group.web_server_sg.id] # vpc_sg_ids instead of sg goups bc sg roups if for ec2 classic and default vpc only

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-server"
  })   
}
# merging tags in local with thier invidual values in the tags( all in prohect tags)

  resource "aws_security_group" "web_server_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-server-sg"

  description = "allow web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http traffic port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }
  
  ingress {
    description      = "https traffic port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] # you can delete ipv6
  }

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-server-sg"
  })
}
#argumment vpc_sg_ids is used now instead of sg goups bc sg roups if for ec2 classic and default vpc only

#vpc_security_group_ids (for VPC only) List of security group IDs to associate with.
#secuity groups is for ec2 classic and default vpc
#Also subnet is prefer over AZ when creatx vpc bc before vpc recently came to existence, it used to be AZ. But now use the argument subnet
#although subnet is also AZ but use subnets when creatx infra