locals {
  project_tags = {
    contact      = "ddevops@jjtech.com"
    application = "payment"
    project      = "jjtech"
    environment  = "${terraform.workspace}" #interpolation
    creationTime = timestamp()              # serach terraform function timestamp or date
  }
}
# project_tags( or tags)
#go to your vpc.tf and call the locals at the level of tags to make tags dynamic