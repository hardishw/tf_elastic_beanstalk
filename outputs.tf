output "beanstalk_URL" {
  description = "elastic beanstalk endpoint url"
  value       = aws_elastic_beanstalk_environment.environment.endpoint_url
}
