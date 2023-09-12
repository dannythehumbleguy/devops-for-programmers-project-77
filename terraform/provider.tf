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
variable "yc_token" { sensitive = true }
provider "yandex" {
  token     = data.ansiblevault_path.yc_token
  cloud_id  = "b1gtk8bi8ed21l2l3aui"
  folder_id = "b1gv4ctc2qlvoraa4gig"
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
variable "datadog_api_key" { sensitive = true }
variable "datadog_app_key" { sensitive = true }
provider "datadog" {
  api_key = data.ansiblevault_path.datadog_api_key
  app_key = data.ansiblevault_path.datadog_app_key
  api_url = "https://api.us5.datadoghq.com/"
}

provider "ansiblevault" {
  vault_path = ".vaultpassword"
  root_folder = "../ansible"
}