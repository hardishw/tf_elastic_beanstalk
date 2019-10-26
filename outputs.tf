output "beanstalk_URL" {
  value = aws_elastic_beanstalk_environment.environment.endpoint_url
}
