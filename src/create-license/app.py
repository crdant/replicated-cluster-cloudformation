import logging

import requests

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel('DEBUG')

class App:

  def __init__(self, api_token, id=None):
    self.api_token = api_token
    if ( id is not None ): 
      self.load(id)

  def load(self,id):
    logger.debug("loading app {id}".format(id=id))
    get_app_url = "https://api.replicated.com/vendor/v3/app/{id}".format(id=id)

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": self.api_token
    } 

    # Sending the payload to the external API
    response = requests.get(get_app_url, headers=headers)
    response.raise_for_status()
    app_response = response.json()
    self.__dict__ = self.__dict__ | app_response['app']
    self.__dict__['api_host'] = self.__api_host()

    logger.debug("loaded app {name} with id {id}".format(name=self.name,id=self.id))

  def __api_host(self):
    get_hostnames = "https://api.replicated.com/vendor/v3/app/{id}/custom-hostnames".format(id=self.id)

    headers = {
        "accept": "application/json",
        "authorization": self.api_token
    } 
    # any processing of the event data here

    # Sending the payload to the external API
    response = requests.get(get_hostnames, headers=headers)
    response.raise_for_status()

    hostnames = response.json()['Body']
    if not hostnames.get('replicatedApp'):
      return 'replicated.app'
    
    return next(item for item in hostnames['replicatedApp'] if item['is_default'])['hostname']
