variable "provider_username" {
  type = string
}

variable "provider_password" {
  type = string
}

variable "provider_project" {
  type = string
}

variable "provider_auth_url" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "back_flavor" {
  type = string  
}

variable "front_flavor" {
  type = string  
}

variable "dns_wd_flavor" {
  type = string  
}

variable "zones" {
  type = map(any)
}

variable "db_flavor" {
  type = string
}

