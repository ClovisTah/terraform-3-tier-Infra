variable "ami" {
    type = string
    description = "ami id"
    default = "ami-05c13eab67c5d8861"
}
variable "instance_type" {
    type = string
    description = "type of the instance"
    default = "t2.micro"
}

variable "subnet_id" {
    type = string
    description = "subnet id to lauch the instance" # no default value for subnet id bc it will be inputed from vpc in main.tf
}
#will be availabe after the vpc resource is created.
#the created subnet id from vpc module will be passed as input to variable from vpc output.tf. hence no default value

variable "tags" {
    type = map(string)
    description = "tags"
}
variable "vpc_id" {
    type = string
    description = "vpc id you lauched sg"
}