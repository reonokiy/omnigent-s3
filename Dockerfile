# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/omnigent-ai/omnigent-server:v0.11.0@sha256:4e99225823eb7afbfa6159d1425cccf9cf07f2ce130b714a672ecdd15681c2cd
FROM ${BASE_IMAGE}

USER root
COPY requirements-s3.txt /tmp/requirements-s3.txt
RUN /opt/venv/bin/pip install \
      --disable-pip-version-check \
      --no-cache-dir \
      --only-binary=:all: \
      --require-hashes \
      --requirement /tmp/requirements-s3.txt \
    && /opt/venv/bin/python -c 'import boto3, botocore; assert boto3.__version__ == "1.43.25"; assert botocore.__version__ == "1.43.25"' \
    && rm -f /tmp/requirements-s3.txt

LABEL org.opencontainers.image.title="Omnigent server with S3 support" \
      org.opencontainers.image.description="Thin derivative of Omnigent v0.11.0 with its locked S3 dependencies" \
      org.opencontainers.image.source="https://github.com/reonokiy/omnigent-s3" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="v0.11.0-s3.1" \
      org.opencontainers.image.base.name="ghcr.io/omnigent-ai/omnigent-server:v0.11.0"
