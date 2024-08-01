import os
import logging

import boto3
from botocore.client import Config

region_name = os.environ["AWS_REGION"]
session = boto3.session.Session(region_name=region_name)
s3 = session.client('s3', config=Config(region_name=region_name, signature_version='s3v4'))

import requests

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel('DEBUG')

class License:

  def __init__(self, api_token, customer):
    self.id = customer.installationId
    self.api_token = api_token
    self.customer = customer
    self.bucket_name = os.environ["LICENSE_BUCKET_NAME"]
    self.object_key = "{customer}.yaml".format(customer=self.customer.id)

  def content(self):
    get_license_url = "https://api.replicated.com/vendor/v3/app/{app}/customer/{customer}/license-download".format(
        app=self.customer.appId, customer=self.customer.id )
    logger.debug("getting license for customer {id} from {url}".format(id=self.customer.id, url=get_license_url))

    headers = {
        "accept": "application/json",
        "authorization": self.api_token
    } 
    # any processing of the event data here

    # Sending the payload to the external API
    response = requests.get(get_license_url, headers=headers)
    response.raise_for_status()
    return response.text

  def save(self):
    license_data = self.content()
    logger.debug(f'saving license to file {self.object_key} in bucket {self.bucket_name}')
    s3.put_object(Bucket=self.bucket_name, Key=self.object_key, Body=license_data)

  def uri(self):
    return s3.generate_presigned_url('get_object',
                                     Params={'Bucket': self.bucket_name,
                                             'Key': self.object_key},
                                     ExpiresIn=60*40)
