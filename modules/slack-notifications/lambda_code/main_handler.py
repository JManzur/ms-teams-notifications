import boto3
import urllib3, json, os, logging
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Event: {}".format(event))
    try:
        Message = json.loads(event["Records"][0]["Sns"]["Message"])
        NewStateValue = Message["NewStateValue"]
        AlarmName = Message["AlarmName"]
        AlarmDescription = Message["AlarmDescription"]
        NewStateReason = Message["NewStateReason"]
        AWSAccountId = Message["AWSAccountId"]
        Region = Message["Region"]
        StateChangeTime = Message["StateChangeTime"]
        AlarmArn = Message["AlarmArn"]

        message = [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": "{} {}: {}".format(get_emoji(NewStateValue), NewStateValue, AlarmName),
                    "emoji": True
                }
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": "*Account*\n{}".format(AWSAccountId)
                    },
                    {
                        "type": "mrkdwn",
                        "text": "*Region*\n{}".format(Region)
                    },
                    {
                        "type": "mrkdwn",
                        "text": "*UTC Time*\n{}".format(get_date(StateChangeTime))
                    }
                ]
            },
            {
                "type": "actions",
                "elements": [
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "text": "View in CloudWatch"
                        },
                        "url": "{}".format(get_alarm_url(AlarmName, AlarmArn)),
                        "style": "primary"
                    }
                ]
            },
            {
                "type": "context",
                "elements": [
                    {
                        "type": "plain_text",
                        "text": ":information_source: Alarm Description:",
                        "emoji": True
                    },
                    {
                        "type": "mrkdwn",
                        "text": "{}".format(AlarmDescription)
                    }
                ]
            },
            {
                "type": "context",
                "elements": [
                    {
                        "type": "plain_text",
                        "text": ":information_source: Alarm Details:",
                        "emoji": True
                    },
                    {
                        "type": "mrkdwn",
                        "text": "{}".format(NewStateReason)
                    }
                ]
            },
            {
                "type": "divider"
            }
        ]
            
        post_message(message)

    except Exception as error:
        #Log the Error:
        logger.error(error)

        #Lambda error response:
        return {
            'statusCode': 400,
            'message': 'An error has occurred',
            'moreInfo': {
                'Lambda Request ID': '{}'.format(context.aws_request_id),
                'CloudWatch log stream name': '{}'.format(context.log_stream_name),
                'CloudWatch log group name': '{}'.format(context.log_group_name)
                }
            }

def get_emoji(NewStateValue):
    checkmarkbutton = ":white_check_mark:"
    policecarsrevolvinglight = ":rotating_light:"
    warning = ":warning:"

    if NewStateValue == "OK":
        return checkmarkbutton
    elif NewStateValue == "ALARM":
        return policecarsrevolvinglight
    elif NewStateValue == "INSUFFICIENT_DATA":
        return warning

def get_alarm_url(AlarmName, AlarmArn):
    RegionCode = AlarmArn.split(":")[3]
    alarm_url = "https://{0}.console.aws.amazon.com/cloudwatch/home?region={0}#alarmsV2:alarm/{1}?".format(RegionCode, AlarmName)
    
    return alarm_url

def get_date(StateChangeTime):
    time_aws = StateChangeTime.split(".")[0]
    utc_time = datetime.strptime(time_aws, "%Y-%m-%dT%H:%M:%S")
    formated_date = utc_time.strftime("%m/%d/%Y %H:%M:%S")

    return formated_date

def post_message(message):
    http = urllib3.PoolManager()
    url = get_parameter()

    payload = {
        "blocks": message
    }

    headers = {
        'Content-Type': 'application/json'
    }

    response = http.request(
        'POST',
        url,
        body=json.dumps(payload),
        headers=headers
    )

    if response.status != 200:
        raise ValueError("Failed to send Slack message")

def get_parameter():
    client = boto3.client('ssm')
    response = client.get_parameter(
        Name='{}'.format(os.environ.get("secret_ssm_parameter")),
        WithDecryption=True
        )

    return response['Parameter']['Value']