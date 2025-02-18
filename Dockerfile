FROM python:3.9-slim

# Install pandoc and dependencies
RUN apt-get update && \
    apt-get install -y pandoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create pandoc config directory
RUN mkdir -p /root/.pandoc/defaults

# Copy application files
COPY . .
COPY docx-equation-fix.yaml /root/.pandoc/defaults/

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 4