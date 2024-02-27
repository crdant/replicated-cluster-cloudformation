import logging

import boto3
secrets_manager = boto3.client('secretsmanager')

import petname
import base64
import uuid

logging.basicConfig()
logger = logging.getLogger(__name__)

class Password:

  def __init__(self, name=None, arn=None):
    if arn is not None:
      self.arn = arn
      self.__load(arn)
    else: 
      self.name = name
      self.__generate_password()
      self.arn = None
      logger.debug(f'created password {name}, now saving it')
      self.save()

  def __generate_password(self):
    base   = petname.Generate(3, "-", 10)
    random = uuid.uuid4().hex[0:6]

    self.value = base + "-" + random

  def __load(self,secret_arn):
    logger.debug(f'loading password {secret_arn}')
    response = secrets_manager.get_secret_value(SecretId=secret_arn)
    self.name = response['Name']
    self.value = response['SecretString']

  def save(self):
    logger.debug('saving password {name}'.format(name=self.name))
    if self.arn is None:
      response = secrets_manager.create_secret( Name=self.name, SecretString=self.value )
      self.arn = response['ARN']
    else:
      response = secrets_manager.update_secret( SecretId=self.arn, SecretString=self.value )

  def delete(self):
    logger.debug('deleteing password {name} ({arn})'.format(name=self.name, arn=self.arn))
    secrets_manager.delete_secret( SecretId=self.arn )
