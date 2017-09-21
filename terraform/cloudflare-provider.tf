variable "cf_api_token" {}

provider "cloudflare" {
  email = "robert@meinit.nl"
  token = "${var.cf_api_token}"

}
