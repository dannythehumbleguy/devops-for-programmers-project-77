terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.97.0"
    }
  }
}



variable "yc_token" { sensitive = true }
provider "yandex" {
  token  = var.yc_token
  cloud_id = "b1gtk8bi8ed21l2l3aui"
  folder_id = "b1gv4ctc2qlvoraa4gig"
  zone = "ru-central1-a"
}