resource "aws_db_subnet_group" "db_subnet_group" {   # we need subnetgroup for availability reason
  name       = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db_subnet_group"
  #name above is diff from Name in tags. its an argument
  subnet_ids = [var.private_subnet1, var.private_subnet2]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db_subnet_group"
  }) 

  }

# rds sg is to allow traffic into db instance from within the vpc

  resource "aws_security_group" "rds_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  description = "allow db traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "db port"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] # you can delete ipv6
  }

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  })
}

#naming convention in rds module has nothing to do with outher modules.

resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = "jjtech" 
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id # db subnet id esp if when u enable multi AZs
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # to allow taffic into rds server. you can add/attach more one sg group to rds server, reason its a list[]

}