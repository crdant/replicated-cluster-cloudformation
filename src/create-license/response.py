import logging


logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel('DEBUG')

class Response:

  def __init__(self, id, status, reason, message):
    logger.debug(f'creating response with id ${id}')
    self.id = id
    self.status = status
    self.reason = reason
    self.url = message['ResponseURL']
    self.stackId = message['StackId']
    self.requestId = message['RequestId']
    self.logicalResourceId = message['LogicalResourceId']
    self.data = {}

  def addData(self, key, value):
    self.data[key] = value

  def body(self):
    logger.debug("creating the response body for resource ${id}".format(id=self.id))
    return {
      'Status': self.status,
      'Reason': self.reason,
      'PhysicalResourceId': self.id,
      'StackId': self.stackId,
      'RequestId': self.requestId,
      'LogicalResourceId': self.logicalResourceId,
      'Data': self.data
    }
