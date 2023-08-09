terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.65.0"
    }
  }
  /*
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tf-state-bucket-mentor"
    region     = zone_a
    key        = "pgoject1/lemp.tfstate"
    access_key = "<access_key>"
    secret_key = "<secret_key>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  */
}


provider "yandex" {
  service_account_key_file = file("~/yandex-cloud/key.json")
  cloud_id                 = "yandex_cloud_id"
  folder_id                = "yandex_folder_id"
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 1
}
