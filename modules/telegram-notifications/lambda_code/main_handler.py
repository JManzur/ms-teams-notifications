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

        message = """
        {0}* {1}: {2}*
        
        *AWS Account:* {3}
        *AWS Region:* {4}
        *UTC Time:* {5}

        [View in CloudWatch]({6})
        -----------------------------
        \U00002139 *Alarm Description*:
        {7}

        \U00002139 *Alarm Details*:
        {8}
        """.format(
            get_emoji(NewStateValue),
            NewStateValue,
            AlarmName,
            AWSAccountId,
            Region,
            get_date(StateChangeTime),
            get_alarm_url(AlarmName, AlarmArn),
            AlarmDescription,
            NewStateReason
            )
        
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
    checkmarkbutton = "\U00002705"
    policecarsrevolvinglight = "\U0001F6A8"
    warning = "\U000026A0"

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

def get_parameter(ssm_parameter_name):
    client = boto3.client('ssm')
    response = client.get_parameter(
        Name='{}'.format(os.environ.get(ssm_parameter_name)),
        WithDecryption=True
        )

    return response['Parameter']['Value']

def post_message(message):
    http = urllib3.PoolManager()

    bot_token = get_parameter("telegram_bot_token_ssm_parameter")
    chat_id = get_parameter("telegram_chat_id_ssm_parameter")

    fields = {
        'chat_id': '{}'.format(chat_id),
        'text': '{}'.format(message),
        'parse_mode': 'Markdown' # Markdown, HTML
    }

    api_url = 'https://api.telegram.org/bot{}/sendMessage'.format(bot_token)
    response = json.loads(http.request("POST", api_url, fields=fields).data.decode('utf-8'))

    if response.status == 200:
        return response
    else:
        logger.error(response)
        raise ValueError("Failed to send telegarm message")
