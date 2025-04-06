import sys
import os
from azure.storage.queue import QueueClient
import time
import logging

queue_name = os.getenv("QUEUE_NAME", "myfirstqueue")
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING", "")

queue_client = QueueClient.from_connection_string(connection_string, queue_name)

log = logging.getLogger(__name__)
log.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)

queue_client = QueueClient.from_connection_string(connection_string, queue_name)

count = 0
while True:
    message = f"Message {count}"
    queue_client.send_message(message)
    log.info(f"Sent: {message}")
    count += 1
    time.sleep(5)