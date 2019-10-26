variable "region" {
  default = "eu-west-2"
}

variable "bucket_name" {
  default = "hardishwilkhu"
}

variable "application" {
  default = {
    path                = "sample.war"
    name                = "tomcat-test"
    description         = "test application"
    version             = "1"
    version_description = "this is an example"
  }
}

variable "environment" {
  default = {
    name  = "tomcat-env"
    stack = "64bit Amazon Linux 2018.03 v3.3.0 running Tomcat 8.5 Java 8"
  }
}

variable "tags" {
  default = {
    Environment = "dev"
    Team        = "devops"
    Owner       = "hardish"
  }
}
