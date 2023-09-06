variable "db_name" { 
  default = "BookDB" 
  type = string
}
variable "db_user" { 
  default = "web"
  type = string 
}
variable "db_password" { 
  sensitive = true
  type = string
}
variable "ssh_key" { 
  sensitive = true
  type = string
}
variable "domain" { 
  default = "dannycw.xyz."
  type = string
}
variable "lb_ip" { 
  default = "158.160.96.222"
  type = string
}
variable "dns_zone_id" { 
  default = "dnsca41e6el7euirf3ud"
  type = string
}
variable "certificate_name" {
  default = "webcert"
  type = string
}
variable "folder_id" {
  default = "b1gv4ctc2qlvoraa4gig"
  type = string
}


resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network.id}"

  depends_on = [ yandex_vpc_network.network ]
}

resource "yandex_mdb_postgresql_cluster" "pgcluster" {
  name        = "pgcluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 15
    }
    postgresql_config = {
      max_connections    = 100
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet.id
  }
}

resource "yandex_mdb_postgresql_user" "dbuser" {
  cluster_id = yandex_mdb_postgresql_cluster.pgcluster.id
  name       = var.db_user
  password   = var.db_password
  depends_on = [yandex_mdb_postgresql_cluster.pgcluster]
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.pgcluster.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.dbuser.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  depends_on = [yandex_mdb_postgresql_cluster.pgcluster]
}

data "yandex_dns_zone" "dns_zone" {
  dns_zone_id = var.dns_zone_id
}

resource "yandex_dns_recordset" "lb_dns_record" {
  zone_id = data.yandex_dns_zone.dns_zone.id
  name    = "${var.domain}"
  type    = "A"
  ttl     = 600
  data    = ["${var.lb_ip}"]
  depends_on = [ data.yandex_dns_zone.dns_zone ]
}

resource "yandex_compute_instance" "dev1" {
  name                      = "dev1"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g5aftj139tv8u2mo1" // ubuntu 22.04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }
  depends_on = [ yandex_vpc_subnet.subnet ]
}

resource "yandex_compute_instance" "dev2" {

  name                      = "dev2"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g5aftj139tv8u2mo1" // ubuntu 22.04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }

  depends_on = [ yandex_vpc_subnet.subnet ]
}

resource "yandex_alb_target_group" "target-group" {
  name           = "target-group"

  target {
    subnet_id    = yandex_vpc_subnet.subnet.id
    ip_address   = yandex_compute_instance.dev1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.subnet.id
    ip_address   = yandex_compute_instance.dev2.network_interface.0.ip_address
  }

  depends_on = [ yandex_compute_instance.dev1, yandex_compute_instance.dev2 ]
}

resource "yandex_alb_backend_group" "backend-group" {
  name                     = "backend-group"
  session_affinity {
    connection {
      source_ip = false
    }
  }

  http_backend {
    name                   = "backend"
    weight                 = 1
    port                   = 3000 // port by which LB is requesting a VM
    target_group_ids       = [ yandex_alb_target_group.target-group.id ]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }

  depends_on = [ yandex_alb_target_group.target-group ]
}

resource "yandex_alb_http_router" "router" {
  name          = "router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name                    = "virtual-host"
  http_router_id          = yandex_alb_http_router.router.id
  route {
    name                  = "route"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group.id
        timeout           = "60s"
      }
    }
  }

  depends_on = [ yandex_alb_backend_group.backend-group, yandex_alb_http_router.router ]
}   



data "yandex_cm_certificate" "tls_certificate" {
  folder_id = "${var.folder_id}"
  name      = "${var.certificate_name}"
}

resource "yandex_alb_load_balancer" "l7-balancer" {
  name        = "l7-balancer"
  network_id  = yandex_vpc_network.network.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet.id
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
          address = var.lb_ip
        }
      }
      ports = [ 443 ] // port by which will be reachable LB 
    }

    tls {
      default_handler {
        certificate_ids = [ "${data.yandex_cm_certificate.tls_certificate.id}" ]
        http_handler {
          http_router_id = yandex_alb_http_router.router.id
        }
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX", "HTTP_5XX"]
      discard_percent = 75
    }
  }

  depends_on = [ 
    yandex_vpc_network.network, 
    yandex_vpc_subnet.subnet, 
    yandex_alb_http_router.router,
    data.yandex_cm_certificate.tls_certificate  ]
}