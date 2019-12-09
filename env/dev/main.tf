terraform {
  backend "s3" {
    key = "elastic_beanstalk/dev"
  }
}

module "dev_elastic_beanstalk" {
  source = "../"

  variable "region" {
    description = "region to deploy infrastructure to"
    type        = "string"
    default     = "eu-west-2"
  }

  variable "bucket_name" {
    description = "bucket to deploy artifacts to"
    type        = "string"
    default     = "hardishwilkhu"
  }

  variable "application" {
    description = "beanstalk application details"
    type        = "map"
    default = {
      path                = "sample.war"
      name                = "tomcat-test"
      description         = "test application"
      version             = "1"
      version_description = "this is an example"
      nexus_url           = ""
    }
  }

  variable "environment" {
    description = "beanstalk environment configuration"
    type        = "map"
    default = {
      name        = "tomcat-env"
      stack       = "64bit Amazon Linux 2018.03 v3.3.0 running Tomcat 8.5 Java 8"
      vpc_id      = "vpc-8b05abee"
      ssl_cert_id = ""
      #eg "subnet-11111111,subnet-22222222"
      instance_subnets = ""
      elb_subnets      = ""
    }
  }

  variable "env_vars" {
    description = "beanstalk environment variables"
    type        = "map"
    default = {
      name = "dev"
    }
  }

  variable "tags" {
    description = "infrastructure tags"
    type        = "map"
    default = {
      Environment = "dev"
      Team        = "devops"
      Owner       = "hardish"
    }
  }

}