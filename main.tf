provider "google" {
    credentials = "${file("~/.gce/gce-key.json")}"
    project     = "${var.project}"
    region      = "${var.region}"
    version     = "~> 1.12"
}

provider "random" {
    version = "~> 1.3"
}

provider "template" {
    version = "~> 1.0"
}

resource "random_id" "instance-prefix" {
    byte_length = 6
    keepers = {
        instance_basename = "test"
    }
}

data "google_compute_zones" "available" {}

resource "google_compute_address" "test-address" {
    count = "${var.create_static_ip == "true" ? 1 : 0}"
    name = "${random_id.instance-prefix.keepers.instance_basename}-${random_id.instance-prefix.hex}"
}

data "template_file" "metadata_startup_script" {
    template = "${file("${path.module}/files/bootstrap.sh")}"

    vars {
        jfrog_cli_version = "${var.jfrog_cli_version}"
        tf_download_script = "${data.template_file.download_terraform_script.rendered}"
    }
}

data "template_file" "download_terraform_script" {
    template = "${file("${path.module}/files/download_terraform.sh")}"

    vars {
        tf_version = "${var.tf_version}"
    }
}

resource "google_compute_instance" "test" {
    name = "${random_id.instance-prefix.keepers.instance_basename}-${random_id.instance-prefix.hex}"
    machine_type = "${var.gce_type}"
    zone         = "${var.gce_zone}"

    metadata {
        startup-script = "${data.template_file.metadata_startup_script.rendered}"
    }

    labels = {
        environment = "test"
    }

    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-1804-lts"
            size  = 10
            type  = "pd-standard"
        }
    }

    network_interface {
        subnetwork = "${var.gce_subnetwork}"
        access_config {
            nat_ip = "${var.create_static_ip == false ? "" : "${join("", google_compute_address.test-address.*.address)}" }"
        }
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}
