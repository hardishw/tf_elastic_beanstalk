variable "region" {
  default = ""
}

variable "bucket_name" {
  default = ""
}

variable "application" {
  default = {
    app_path        = ""
    app_name        = ""
    app_description = ""
  }
}

variable "tags" {
  default = {
    Environment = ""
    Team        = ""
    Owner       = ""
  }
}