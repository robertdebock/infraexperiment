variable "do_api_token" {}

provider "digitalocean" {
  token = "${var.do_api_token}"
}
