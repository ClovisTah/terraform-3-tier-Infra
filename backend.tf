terraform {
  backend "s3" {
    bucket = "c-bucket-20"
    key    = "state/terraform.tfstate" # means tf.tfstate is stre in a file called state
    region = "us-east-1"
    workspace_key_prefix = "env" # if you change workspace, state file will be store in without overiding the existing
  }
}

# to store state files in a center location, and secured as well
#means terraform.tfsate will be store here so it can be reachable by other team members