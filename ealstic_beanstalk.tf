####
# upload application to s3 bucket
####

data "aws_s3_bucket" "application_code" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_object" "application" {
  bucket = data.aws_s3_bucket.application_code.id
  key    = var.application["path"]
  source = "s3/${var.application["path"]}"
}

####
# Create beanstalk environment
####

resource "aws_elastic_beanstalk_environment" "environment" {
  name                = var.environment["name"]
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = var.environment["stack"]

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elb-profile.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.environment["vpc_id"]
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.environment["instance_subnets"]
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = var.environment["elb_subnets"]
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = var.environment["ssl_cert_id"]
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:80"
    name      = "ListenerProtocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "ApplicationHealthcheckURL"
    value     = "/docs/index.html"
  }

  tags = var.tags
}

####
# Create beanstalk application
####

resource "aws_elastic_beanstalk_application" "application" {
  name        = var.application["name"]
  description = var.application["description"]
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.application["version"]
  application = aws_elastic_beanstalk_application.application.name
  description = var.application["version_description"]
  bucket      = data.aws_s3_bucket.application_code.id
  key         = aws_s3_bucket_object.application.id
}

####
# deploy beanstalk application
####

resource "null_resource" "deploy_application" {
  provisioner "local-exec" {
    command = "aws --region ${var.region} elasticbeanstalk update-environment --environment-name ${var.environment["name"]} --version-label ${var.application["version"]}"
  }

  triggers = {
    version = var.application["version"]
  }

  depends_on = [aws_elastic_beanstalk_application_version.default, aws_elastic_beanstalk_environment.environment]
}