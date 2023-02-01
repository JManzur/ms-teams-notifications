# ms-teams-notifications

Create a `.env` file with the following content:

```bash
#MS Teams Webhook URL
export TF_VAR_teams_webhook_url="your-ms-teams-webhook-url"
``` 

Source the file with:

```bash
source .env
```

Create a `terraform.tfvars` file with the following content:

```bash
aws_profile = "your-aws-profile"
aws_region  = "your-aws-region"

vpc_id           = "your-vpc-id"
public_subnet_id = "your-subnet-id"
ssh_key_name     = "your-ssh-key
```