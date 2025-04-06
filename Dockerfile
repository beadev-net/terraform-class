FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
COPY producer.py .
COPY consumer.py .

RUN pip install --no-cache-dir -r requirements.txt

ARG APP_MODE=producer
ENV APP_MODE=${APP_MODE}

CMD ["sh", "-c", "exec python ${APP_MODE}.py"]
