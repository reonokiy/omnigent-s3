# omnigent-s3

Private build repository for a minimal Omnigent server image with the optional
S3 artifact-store dependencies installed.

## Supply-chain boundary

The image is derived from the official multi-platform Omnigent v0.11.0 server
image, pinned by digest:

```text
ghcr.io/omnigent-ai/omnigent-server:v0.11.0@sha256:4e99225823eb7afbfa6159d1425cccf9cf07f2ce130b714a672ecdd15681c2cd
```

`requirements-s3.txt` pins `boto3`, `botocore`, and their transitive
dependencies to the exact versions and wheel hashes recorded in the official
Omnigent v0.11.0 `uv.lock`. Installation uses `--require-hashes` and accepts
binary wheels only.

## Published image

A push to `main` or a manual workflow run publishes both architectures to:

```text
ghcr.io/reonokiy/omnigent-s3:v0.11.0-s3.1
ghcr.io/reonokiy/omnigent-s3:sha-<git-commit>
```

Deployments should pin the resulting manifest digest. Pull requests perform a
build-only check and cannot publish. Publishing uses only the workflow's
short-lived `GITHUB_TOKEN`; no registry credential is stored in this repository.
The package is intended to remain private, so runtime consumers need a separate
read-only GHCR credential delivered by their own secret-management boundary.

## Runtime configuration

Omnigent accepts an S3 artifact URI and the standard AWS SDK configuration,
including S3-compatible endpoints such as Backblaze B2:

```text
OMNIGENT_ARTIFACT_URI=s3://<bucket>/<optional-prefix>
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_ENDPOINT_URL_S3
AWS_REGION
```

Never commit values for these variables. This repository builds an image only;
it does not provision storage or deploy Omnigent.

## Updating

For a new Omnigent release, review the upstream Dockerfile and lock file, update
the base tag and digest, copy the exact S3 dependency versions and hashes, bump
the derived tag, and review the resulting pull-request build before merging.

Omnigent is developed by Databricks and contributors. This derivative is not
an official Databricks image.
