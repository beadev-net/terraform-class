import sys
import os
from azure.storage.queue import QueueClient
from azure.identity import DefaultAzureCredential
import time
import logging

queue_name = os.getenv("QUEUE_NAME", "myfirstqueue")
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING", None)
account_url = os.getenv("AZURE_STORAGE_ACCOUNT_URL", None)

if not connection_string:
    credential = DefaultAzureCredential()
    queue_client = QueueClient(account_url=account_url, queue_name=queue_name, credential=credential)
else:
    queue_client = QueueClient.from_connection_string(connection_string, queue_name)

log = logging.getLogger(__name__)
log.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)

while True:
    messages = queue_client.receive_messages(messages_per_page=5)
    for msg in messages:
        log.info(f"Received: {msg.content}")
        queue_client.delete_message(msg)
    time.sleep(5)