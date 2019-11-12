terraform {
  backend "s3" {
    bucket         = ""
    key            = "elastic_beanstalk/remote"
    region         = ""
    dynamodb_table = ""
  }
}