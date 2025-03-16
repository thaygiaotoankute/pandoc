FROM python:3.9-alpine

# Cài đặt pandoc từ nguồn cài đặt có sẵn thay vì qua apt-get
RUN apk add --no-cache pandoc

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY docx-equation-fix.yaml .

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 2
