terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
      version = "~> 0.7.4"
    }
  }
}

provider "vkcs" {
  username   = var.provider_username
  password   = var.provider_password
  project_id = var.provider_project
  region     = "RegionOne"
  auth_url   = var.provider_auth_url
}
