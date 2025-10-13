# Use official Python 3.13 slim image as base
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for uv, gunicorn, gevent, and kuzu
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    gcc \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install uv to /root/.local/bin and move to /usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | bash \
    && mv /root/.local/bin/uv /usr/local/bin/uv \
    && uv --version

# Copy pyproject.toml to install dependencies
COPY pyproject.toml .
COPY uv.lock .

# Generate uv.lock and install dependencies
RUN uv sync --frozen --no-dev

# Copy the rest of the application
COPY .env .
COPY app.py .
COPY templates/ templates/
COPY static/ static/

# Set environment variables for Flask and KuzuDB (force local extensions)
ENV FLASK_APP=app.py
ENV FLASK_ENV=production


# Expose port 5000
EXPOSE 5000

# Run the app with gunicorn using gevent workers
CMD ["uv", "run", "gunicorn", "--workers=2", "--worker-class=uvicorn.workers.UvicornWorker", "--bind=0.0.0.0:5000", "app:app"]