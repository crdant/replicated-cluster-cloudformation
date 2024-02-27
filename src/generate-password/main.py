from crhelper import CfnResource
import logging

from password import Password

logging.basicConfig()
logger = logging.getLogger(__name__)

helper = CfnResource(
    json_logging=False,
    log_level='DEBUG',
    boto_level='CRITICAL'
)

def handler(event, context):
    helper(event, context)

@helper.create
def create(event, context):
    logger.info("generating admin console password")
    secret_name = event.get('ResourceProperties').get("SecretName")
    logger.info(f'creating secret {secret_name}')
    password = Password(name=secret_name)
    helper.Data.update({'SecretArn': password.arn})
    helper.Data.update({'Password': password.value})
    return password.arn

@helper.delete
def delete(event, context):
    passwordArn = event['PhysicalResourceId']
    logger.info(f'deleting password: {passwordArn}')
    password = Password(arn=passwordArn)
    password.delete()

