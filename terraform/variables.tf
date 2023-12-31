variable "db_name" {
  default = "BookDB"
  type    = string
}
variable "db_user" {
  default = "web"
  type    = string
}
variable "ssh_key" {
  sensitive = true
  type      = string
}
variable "domain" {
  default = "dannycw.xyz."
  type    = string
}
variable "dns_zone_id" {
  default = "dnsca41e6el7euirf3ud"
  type    = string
}
variable "certificate_name" {
  default = "webcert"
  type    = string
}
variable "folder_id" {
  default = "b1gv4ctc2qlvoraa4gig"
  type    = string
}
variable "vm_image_id" {
  default = "fd8g5aftj139tv8u2mo1" // ubuntu 22.04
  type    = string
}
variable "yc_zone" {
  default = "ru-central1-a"
  type    = string
}
variable "ansible_vault_path" {
  default = "../ansible/group_vars/all/vault.yml"
  type    = string
}
variable "datadog_host" {
  default = "us5.datadoghq.com"
  type    = string
}
variable "external_book_api_port" {
  default = 3000
  type    = number
}
variable "internal_book_api_port" {
  default = 3000
  type    = number
}