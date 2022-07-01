locals {
  percona_server_80_name = "percona-server-80"
  count                  = 2 # source and replica
}


module "percona_server_80" {
  source        = "./modules/ec2"
  count         = local.count
  server_name   = "${local.percona_server_80_name}-${count.index}"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.pmmdemo_private.id
  route53_id    = aws_route53_zone.demo_local.id

  security_groups = [
    aws_security_group.default_access.id
  ]
  user_data = element(data.template_file.percona_server_80_user_data.*.rendered, count.index)
}

resource "random_password" "mysql80_root_password" {
  length  = 30
  special = true
  upper   = true
  number  = true
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}

resource "random_password" "mysql80_replica_password" {
  length  = 30
  special = true
  upper   = true
  number  = true
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}

resource "random_password" "mysql80_sysbench_password" {
  length  = 30
  special = true
  upper   = true
  number  = true
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
}

data "template_file" "percona_server_80_user_data" {
  count    = local.count
  template = file("provision_scripts/percona_server_80.yml")
  vars = {
    name                      = "${local.percona_server_80_name}-${count.index}"
    fqdn                      = "${local.percona_server_80_name}-${count.index}.${aws_route53_zone.demo_local.name}"
    index                     = "${count.index}"
    pmm_password              = "Percona1!"
    mysql_root_password       = "Percona1!"
    mysql_replica_password    = "Percona1!"
    mysql_sysbench_password   = "Percona1!"
    pmm_server_endpoint       = local.pmm_server_endpoint
    proxysql_monitor_password = "Percona1!"
  }
}

module "percona_server_80_disk" {
  source      = "./modules/ebs"
  count       = local.count
  disk_name   = "percona-server-80"
  disk_size   = "256"
  instance_id = module.percona_server_80[count.index].instance_id
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}
