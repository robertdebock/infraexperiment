resource "digitalocean_droplet" "sgp1-web" {
  image    = "centos-7-0-x64"
  name     = "sgp1-web-${count.index}"
  region   = "sgp1"
  size     = "512mb"
  ssh_keys = [914738]
  count    = 2
}

resource "digitalocean_loadbalancer" "sgp1-lb" {
  name                   = "sgp1-lb"
  region                 = "sgp1"
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

  droplet_ids = ["${digitalocean_droplet.sgp1-web.*.id}"]
}

resource "cloudflare_record" "sgp1" {
  domain = "meinit.nl"
  name   = "sgp1"
  value  = "${digitalocean_loadbalancer.sgp1-lb.ip}"
  type   = "A"
}
