terraform {
  backend "s3" {
    key = "elastic_beanstalk/dev"
  }
}

module "dev_elastic_beanstalk" {
  source = "../"

  region = "eu-west-2"

  bucket_name = "hardishwilkhu"

  application = {
    path                = "sample.war"
    name                = "tomcat-test"
    description         = "test application"
    version             = "1"
    version_description = "this is an example"
    nexus_url           = ""
  }

  environment = {
    name        = "tomcat-env"
    stack       = "64bit Amazon Linux 2018.03 v3.3.0 running Tomcat 8.5 Java 8"
    vpc_id      = "vpc-8b05abee"
    ssl_cert_id = ""
    #eg "subnet-11111111,subnet-22222222"
    instance_subnets = ""
    elb_subnets      = ""
  }

  env_vars = {
    name = "dev"
  }

  tags = {
    Environment = "dev"
    Team        = "devops"
    Owner       = "hardish"
  }

}