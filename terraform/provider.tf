terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.97.0"
    }

    datadog = {
      source = "DataDog/datadog"
    }

    ansiblevault = {
      source  = "MeilleursAgents/ansiblevault"
      version = "~> 2.3.0"
    }
  }
}

data "ansiblevault_path" "yc_token" {
  path = var.ansible_vault_path
  key  = "secret_yc_token"
}
data "ansiblevault_path" "yc_cloud_id" {
  path = var.ansible_vault_path
  key  = "secret_yc_cloud_id"
}
data "ansiblevault_path" "yc_folder_id" {
  path = var.ansible_vault_path
  key  = "secret_yc_folder_id"
}
provider "yandex" {
  token     = data.ansiblevault_path.yc_token.value
  cloud_id  = data.ansiblevault_path.yc_cloud_id
  folder_id = data.ansiblevault_path.yc_folder_id
  zone      = var.yc_zone
}

data "ansiblevault_path" "datadog_api_key" {
  path = var.ansible_vault_path
  key  = "secret_datadog_api_key"
}
data "ansiblevault_path" "datadog_app_key" {
  path = var.ansible_vault_path
  key  = "secret_datadog_app_key"
}
provider "datadog" {
  api_key = data.ansiblevault_path.datadog_api_key.value
  app_key = data.ansiblevault_path.datadog_app_key.value
  api_url = "https://api.${var.datadog_host}/"
}
provider "ansiblevault" {
  vault_path  = "../.vaultpassword"
  root_folder = "../ansible"
}
