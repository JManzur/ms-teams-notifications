module "ec2" {
  source = "./modules/ec2"

  vpc_id           = var.vpc_id
  public_subnet_id = var.public_subnet_id
  ssh_key_name     = var.ssh_key_name
}

module "ms-teams-notifications" {
  source = "./modules/ms-teams-notifications"

  instance_id       = module.ec2.instance_id
  teams_webhook_url = var.teams_webhook_url

  depends_on = [
    module.ec2
  ]
}