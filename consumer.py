import os
from azure.storage.queue import QueueClient
import time

queue_name = os.environ.get("QUEUE_NAME")
connection_string = os.environ.get("AZURE_STORAGE_CONNECTION_STRING")

queue_client = QueueClient.from_connection_string(connection_string, queue_name)

while True:
    messages = queue_client.receive_messages(messages_per_page=5)
    for msg in messages:
        print(f"Received: {msg.content}")
        queue_client.delete_message(msg)
    time.sleep(10)