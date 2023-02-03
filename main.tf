module "ec2" {
  source = "./modules/ec2"

  vpc_id           = var.vpc_id
  public_subnet_id = var.public_subnet_id
  ssh_key_name     = var.ssh_key_name
}

module "ms-teams-notifications" {
  count = var.deploy_ms_teams_notifications ? 1 : 0

  source      = "./modules/ms-teams-notifications"
  name_prefix = "MS-Teams"
  instance_id = module.ec2.instance_id
  webhook_url = var.teams_webhook_url

  depends_on = [module.ec2]
}

module "slack-notifications" {
  count = var.deploy_slack_notifications ? 1 : 0

  source      = "./modules/slack-notifications"
  name_prefix = "Slack"
  instance_id = module.ec2.instance_id
  webhook_url = var.slack_webhook_url

  depends_on = [module.ec2]
}

# module "telegram-notifications" {
#   count = var.deploy_telegram_notifications ? 1 : 0

#   source            = "./modules/telegram-notifications"
#   name_prefix       = "Telegram"
#   instance_id       = module.ec2.instance_id
#   slack_webhook_url = var.slack_webhook_url

#   depends_on = [module.ec2]
# }

