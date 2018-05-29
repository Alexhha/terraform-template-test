variable "project" {
    type = "string"
    default = "test"
}

variable "gce_type" {
    type = "string"
    default = "f1-micro"
}

variable "gce_subnetwork" {
    type = "string"
    default = "default"
}

variable "gce_zone" {
    type = "string"
    default = "europe-west1-b"
}

variable "region" {
    type = "string"
    default = "europe-west1"
}

variable "create_static_ip" {
    type = "string"
    default = "false"
}

variable "tf_version" {
    type = "string"
    default = "0.11.7"
}

variable "jfrog_cli_version" {
    type = "string"
    default = "1.15.0"
}
