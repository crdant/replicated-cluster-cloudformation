import os
import logging
import json

import requests

import boto3
secrets_manager = boto3.client('secretsmanager')

from customer import Customer
from app import App
from response import Response

import datetime
from dateutil.relativedelta import relativedelta

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel('DEBUG')

def get_api_token():
  secret_arn = os.environ["SECRET_ARN"]
  response = secrets_manager.get_secret_value(SecretId=secret_arn)
  return response['SecretString']

def handler(event, context):
  # Extract the CloudFormation request from the SNS message
  message = json.loads(event['Records'][0]['Sns']['Message'])
  stack = message['StackId']
  logger.debug(f'processing message from ${stack}')
  response = dispatch(message)
  send_response(response)
  return response.body()

def dispatch(message):
  logger.debug("dispatching message")
  try:
    if message['RequestType'] == 'Create':
      response = create(message)
    elif message['RequestType'] == 'Delete':
      response = delete(message)
    else:
      response = Response(None, 'FAILED', 'Operation not supported', message)
  except Exception as e:
    logging.error(str(e))
    response = Response(None, 'FAILED', str(e), message)
  return response

def send_response(response):
  response_json = json.dumps(response.body())
  
  headers = {
    'content-type': '',
    'content-length': str(len(response_json))
  }

  result = requests.put(response.url,
                        data=response_json,
                        headers=headers)
  result.raise_for_status()

def create(message):
    logger.info("creating resoource")

    api_token = get_api_token()
    properties = message.get('ResourceProperties')
    logger.debug("Loading application")
    app = App(api_token, properties.get('AppId'))

    expiration_date = datetime.date.today() + relativedelta(years=1)
    logger.debug("creating customer")
    customer = Customer.create(api_token, properties.get('Name'), properties.get('Email'),
                               app.id, expiration_date, properties.get('Type'),
                               properties.get('Channel'), properties.get('ExternalId'))  

    response = Response(customer.id, 'SUCCESS', '', message)
    license_id = customer.installationId
    response.addData('DownloadToken', license_id)

    app_domain = app.api_host
    slug = app.slug
    channel = properties.get('Channel').lower()

    response.addData('InstallerUri', f'https://{app_domain}/embedded/{slug}/{channel}')

    return response

def delete(message):
    customerId = message['PhysicalResourceId']
    logger.info("deleting customer: {customer}".format(customer=customerId))
    api_token = get_api_token()
    properties = message.get('ResourceProperties')

    customer = Customer(api_token, properties.get('AppId'), customerId)
    customer.remove()

    return Response(customer.id, 'SUCCESS', '', message)

