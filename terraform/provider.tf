terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.97.0"
    }

    datadog = {
      source = "DataDog/datadog"
    }
  }
}

variable "datadog_api_key" { sensitive = true }
variable "datadog_app_key" { sensitive = true }
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.us5.datadoghq.com/"
}

variable "yc_token" { sensitive = true }
provider "yandex" {
  token  = var.yc_token
  cloud_id = "b1gtk8bi8ed21l2l3aui"
  folder_id = "b1gv4ctc2qlvoraa4gig"
  zone = "ru-central1-a"
}