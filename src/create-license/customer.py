import logging

import requests

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel('DEBUG')

class Customer:

  def __init__(self, api_token, app_id=None, id=None):
    self.api_token = api_token
    if ( app_id is not None ) and ( id is not None ): 
      self.load(app_id,id)

  @classmethod
  def create(cls,api_token, name, email, app_id, expires_at, license_type, channel, customId=""):
    logger.debug(f'creating new customer instance for {name}')
    instance = cls(api_token)
    instance.id = None
    instance.api_token = api_token
    instance.name = name
    instance.email = email
    instance.appId = app_id
    instance.type = license_type
    instance.expiresAt = expires_at
    instance.channelId = instance.__get_channel_id(channel)
    instance.customId = customId

    instance.isKotsInstallEnabled = True
    instance.isHelmVmDownloadEnabled = True
    instance.isSupportBundleUploadEnabled = True

    instance.isAirgapEnabled = False
    instance.isGeoaxisSupported = False
    instance.isGitOpsSupported = False
    instance.isIdentityServiceSupported = False
    instance.isSnapshotSupported = False

    logger.debug(f'saving new customer instance for {name}')
    instance.save()
    return instance

  def load(self,app_id,id):
    logger.debug("loading customer {id}".format(id=id))
    get_customer_url = "https://api.replicated.com/vendor/v3/app/{app}/customer/{id}".format(app=app_id,id=id)

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": self.api_token
    } 

    # Sending the payload to the Vendor Portal API
    response = requests.get(get_customer_url, headers=headers)
    response.raise_for_status()
    customer_response = response.json()
    self.__dict__ = self.__dict__ | customer_response['customer']
    self.appId = self.channels[0]['appId']
    self.channelId = self.channels[0]['id']
    logger.debug("loaded customer {name} with id {id}".format(name=self.name,id=self.id))

  def save(self):
    logger.debug('Saving customer with id ${id}'.format(id=self.id))
    save_customer_url = "https://api.replicated.com/vendor/v3/customer"

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": self.api_token
    } 

    # Sending the payload to the Vendor Portal API
    request = self.__save_request()
    if ( self.id is None ):
      logger.debug('saving new customer')
      response = requests.post(save_customer_url, headers=headers, json=request)
    else:
      logger.debug('updating existing customer')
      response = requests.put("{prefix}/{id}".format(prefix=save_customer_url, id=self.id), headers=headers, json=request)

    logger.debug(response.raise_for_status())
    customer_response = response.json()
    self.__dict__ = self.__dict__ | customer_response['customer']
    self.appId = self.channels[0]['appId']
    self.channelId = self.channels[0]['id']

  def remove(self):
    archive_customer_url = "https://api.replicated.com/vendor/v3/customer/{id}/archive".format(id=self.id)

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": self.api_token
    } 

    # Sending the payload to the external API
    response = requests.post(archive_customer_url, headers=headers, json=self.__dict__)
    logger.debug(response.raise_for_status())
    logger.debug('%s', self.__dict__)
    logger.debug('%s', response)

  def license(self):
    get_license_url = "https://api.replicated.com/vendor/v3/app/{app}/customer/{customer}/license-download".format(
        app=self.appId, customer=self.id )

    headers = {
        "accept": "application/json",
        "authorization": self.api_token
    } 
    # any processing of the event data here

    # Sending the payload to the external API
    response = requests.get(get_license_url, headers=headers)
    response.raise_for_status()
    return response.text

  def __save_request(self):
    request = {}
    request['name'] = self.name
    request['custom_id'] = self.customId
    request['app_id'] = self.appId
    request['channel_id'] = self.channelId
    request['email'] = self.email
    request['expires_at'] = str(self.expiresAt)
    request['is_airgap_enabled'] = self.isAirgapEnabled
    request['is_geoaxis_supported'] = self.isGeoaxisSupported
    request['is_gitops_supported'] = self.isGitOpsSupported
    request['is_helmvm_download_enabled'] = self.isHelmVmDownloadEnabled
    request['is_identity_service_supported'] = self.isIdentityServiceSupported
    request['is_kots_install_enabled'] = self.isKotsInstallEnabled
    request['is_snapshot_supported'] = self.isSnapshotSupported
    request['is_support_bundle_upload_enabled'] = self.isSupportBundleUploadEnabled

    request['type'] = self.type
    return request

  def __get_channel_id(self, channel):
    channel_ids = {}
    channel_ids['Stable'] = '2Ukd6ZSK5i9We0m9WznyBI19RtM'
    channel_ids['Beta']   = '2Ukd6X4aR3o1ZCHGPbhYXU26haw'
    return channel_ids[channel]
