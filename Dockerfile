# Stage 1: Builder & Tester
FROM python:3.12-slim AS builder
WORKDIR /build

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY . .
RUN PYTHONPATH=/install/lib/python3.12/site-packages /install/bin/pytest

# Stage 2: Final Runtime
FROM python:3.12-slim
WORKDIR /app

COPY --from=builder /install /usr/local
COPY app.py .

RUN useradd --create-home --uid 10001 appuser
USER appuser

ENV PORT=8080
ENV APP_ENV=production
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

ENTRYPOINT ["python", "app.py"]
