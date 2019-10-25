resource "aws_elastic_beanstalk_application" "tomcat" {
  name        = var.app_name
  description = var.app_description
}

resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tomcat-env"
  application         = aws_elastic_beanstalk_application.tomcat.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v3.2.2 running Tomcat 8.5 Java 8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elb-profile.name
  }

  tags = var.tags
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "tomcat-sample"
  application = aws_elastic_beanstalk_application.tomcat.name
  description = "test tomcat sample"
  bucket      = aws_s3_bucket.lambda-tomcat-test.id
  key         = data.aws_s3_bucket_object.application.key

  depends_on = [null_resource.upload_to_s3]
}

# data "aws_s3_bucket" "lambda-tomcat-test" {
#   bucket = var.bucket_name
# }

resource "aws_s3_bucket" "lambda-tomcat-test" {
  bucket = var.bucket_name

  tags = merge({
    Name = var.bucket_name
  }, var.tags)
}

resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/s3 s3://${aws_s3_bucket.lambda-tomcat-test.id}/"
  }
}

data "aws_s3_bucket_object" "application" {
  bucket = aws_s3_bucket.lambda-tomcat-test.id
  key    = var.app_path
}

