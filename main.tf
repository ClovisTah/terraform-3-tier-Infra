
#You want resource names to be in the format 
# key(Nmae) = jjtech-payment-dev-vpc. This will ease identification of each resource type and its envi
#As per tags in locals.tf project_tags = tags

module "vpc" {
  source = "./vpc"                  # best practice is    to call vpc as seen not using full path from c drvive cus in linux or jerkins ecosystem u might access the c drive
  tags   = local.project_tags 
}
module "rds" {
  source = "./rds"
  tags = local.project_tags
  private_subnet1 = module.vpc.private_subnet1_id #here we callx variables from var.tf and calling ids from vpc module output
  private_subnet2 = module.vpc.private_subnet2_id # go to vpc module and crab private subnet1 and 2 ids
  vpc_id = module.vpc.vpc_id
  vpc_cidr = "0.0.0.0/16" # harded coded bc rds has not cidr block as attribute from tf aws rds documtation
}
module "ec2" {
  source = "./ec2"
  subnet_id = module.vpc.public_subnet1_id
  vpc_id = module.vpc.vpc_id
  tags = local.project_tags
  
}
# subnet id, tags,vpc.id are reference in var.tf in ec2 module
#No need to mentioned variables with defualt value unless you to overide them e.g instance_type
# NB in every module any orgument you mentioned in var.tf without a deault value must be mentioned in main.tf
# those with default value can only be mentioned if you want to overide them
#but if you wish to use the defalt value you can ignore it.
#you chanage workspace using code, test, dev, stage,prod. 








# main.tf calling local.tf for local.project_tags
# vpc module in main.tf calling var.tf in( as shown) in vpc.tf {
# NB: values in variables can alsways be overide with another name in main.tf 