# Giai đoạn 1: Cài đặt pandoc
FROM debian:bullseye-slim AS pandoc
RUN apt-get update && \
    apt-get install -y --no-install-recommends pandoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Giai đoạn 2: Xây dựng ứng dụng Python
FROM python:3.9-slim

# Sao chép pandoc từ giai đoạn 1
COPY --from=pandoc /usr/bin/pandoc /usr/bin/
COPY --from=pandoc /usr/share/pandoc /usr/share/pandoc

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY docx-equation-fix.yaml .

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 2
