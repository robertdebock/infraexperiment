resource "digitalocean_droplet" "ams3-web" {
  image    = "centos-7-0-x64"
  name     = "ams3-web-${count.index}"
  region   = "ams3"
  size     = "512mb"
  ssh_keys = [914738]
  count    = 2
}

resource "digitalocean_loadbalancer" "ams3-lb" {
  name                   = "ams3-lb"
  region                 = "ams3"
  redirect_http_to_https = true

  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "http"
    target_port     = 80
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port      = 443
    entry_protocol  = "https"
    target_port     = 443
    target_protocol = "https"
    tls_passthrough = true
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  droplet_ids = ["${digitalocean_droplet.ams3-web.*.id}"]
}

resource "cloudflare_record" "ams3" {
  domain = "meinit.nl"
  name   = "ams3"
  value  = "${digitalocean_loadbalancer.ams3-lb.ip}"
  type   = "A"
}
