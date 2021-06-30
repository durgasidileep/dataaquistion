#Below block creates the statefile in the S3
terraform {
   backend "s3" {
   bucket = "dataaquisitionbucket" # S3 bucket name 
   key = "dataaquitstion-lock-state" #state file name
   region = "us-east-1"


   dynamodb_table = "dataaquitstion-lock-state"
   encrypt = true

 }
}

#This file will create lock file which will avoid parallel deployments
resource "aws_dynamodb_table" "mercury_statelock" {
  name           = "mercury-lock-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


