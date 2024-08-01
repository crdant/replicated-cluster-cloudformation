import os
import logging
import json
import uuid

import requests

import boto3
secrets_manager = boto3.client('secretsmanager')

from app import App
from customer import Customer
from license import License
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
      # generate a uuid as a resource id since the customer wasn't created
      id = str(uuid.uuid4())
      response = Response(id, 'FAILED', 'Operation not supported', message)
  except Exception as e:
    logging.error(str(e))
    id = str(uuid.uuid4())
    response = Response(id, 'FAILED', str(e), message)
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
    customer = None
    try:
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

      license = License(api_token, customer)
      license.save()
      response.addData('LicenseUri', license.uri())

      logger.debug("returning presigned URI for license: {uri}".format(uri=license.uri()))
      return response
    except Exception as e:
      logging.error(str(e))
      if customer is None or customer.id is None:
        # generate a uuid as a resource id since the customer wasn't created
        id = str(uuid.uuid4()) 
      else:
        id = customer.id
      response = Response(id, 'FAILED', str(e), message)
      return response

def delete(message):
    # return success right away if the physical resource id is a UUID since 
    # that means the customer was never created and there's nothing to do
    if __is_valid_uuid(message['PhysicalResourceId']):
        return Response(message['PhysicalResourceId'], 'SUCCESS', '', message)

    customerId = message['PhysicalResourceId']
    logger.info("deleting customer: {customer}".format(customer=customerId))
    api_token = get_api_token()
    properties = message.get('ResourceProperties')

    customer = Customer(api_token, properties.get('AppId'), customerId)
    customer.remove()

    return Response(customer.id, 'SUCCESS', '', message)

def __is_valid_uuid(value):
    try:
      uuid.UUID(value)
      return True
    except ValueError:
      return False
