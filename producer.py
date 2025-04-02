import os
from azure.storage.queue import QueueClient
import time

queue_name = os.environ.get("QUEUE_NAME")
connection_string = os.environ.get("AZURE_STORAGE_CONNECTION_STRING")

queue_client = QueueClient.from_connection_string(connection_string, queue_name)

count = 0
while True:
    message = f"Message {count}"
    queue_client.send_message(message)
    print(f"Sent: {message}")
    count += 1
    time.sleep(10)