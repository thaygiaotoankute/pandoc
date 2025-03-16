FROM python:3.9-slim

# Cài đặt pandoc với cấu hình tối ưu để giảm kích thước và thời gian cài đặt
RUN apt-get update && \
    apt-get install -y --no-install-recommends pandoc=2.* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Sao chép requirements trước để tận dụng Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép mã nguồn
COPY app.py .
COPY docx-equation-fix.yaml .

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# Giảm số lượng workers để giảm tài nguyên cần thiết
CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 2
