resource "aws_elastic_beanstalk_application" "application" {
  name        = var.application["path"]
  description = var.application["description"]
}

resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = var.environment["name"]
  application         = aws_elastic_beanstalk_application.tomcat.name
  solution_stack_name = var.environment["stack"]

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elb-profile.name
  }

  tags = var.tags
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.application["version_name"]
  application = aws_elastic_beanstalk_application.tomcat.name
  description = var.application["version_description"]
  bucket      = aws_s3_bucket.application_code.id
  key         = data.aws_s3_bucket_object.application.key

  depends_on = [null_resource.upload_to_s3]
}

resource "aws_s3_bucket" "application_code" {
  bucket = var.bucket_name

  tags = merge({
    Name = var.bucket_name
  }, var.tags)
}

resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/s3 s3://${aws_s3_bucket.application_code.id}/"
  }
}

data "aws_s3_bucket_object" "application" {
  bucket = aws_s3_bucket.application_code.id
  key    = var.app_path
}

