FROM docker.io/library/python:3.12-slim

WORKDIR /app

# Copy requirements first so this layer is cached
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run as a non-root user (security best practice)
RUN useradd -m appuser
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
