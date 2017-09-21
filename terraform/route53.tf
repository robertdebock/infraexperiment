# Define a zone.
resource "aws_route53_zone" "meinitnl" {
  name = "meinit.nl"
}

# Define a health-check.
resource "aws_route53_health_check" "allloadbalancers" {
  fqdn = "web.meinit.nl"
  port = "80"
  type = "HTTP"
  resource_path = "/"
  failure_threshold = "3"
  request_interval = "30"
}

# Define a record.
resource "aws_route53_record" "web" {
  zone_id = "${aws_route53_zone.meinitnl.zone_id}"
  name = "web"
  type = "A"
  ttl = "60"
  records = ["${digitalocean_loadbalancer.ams3-lb.ip}","${digitalocean_loadbalancer.sgp1-lb.ip}"]
  health_check_id = "aws_route53_health_check.allloadbalancers.id"
}
