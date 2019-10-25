variable "region" {
  default = ""
}

variable "bucket_name" {
  default = ""
}

variable "application" {
  default = {
    path                = ""
    name                = ""
    description         = ""
    version_name        = ""
    version_description = ""
  }
}

variable "environment" {
  default = {
    name  = ""
    stack = "64bit Amazon Linux 2018.03 v3.2.2 running Tomcat 8.5 Java 8"
  }
}

variable "tags" {
  default = {
    Environment = ""
    Team        = ""
    Owner       = ""
  }
}