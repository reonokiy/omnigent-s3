# omnigent-s3

Build repository for a minimal Omnigent server image with the optional
S3 artifact-store dependencies installed.

## Supply-chain boundary

The image is derived from the official multi-platform Omnigent server image.
`.upstream-version` records the tracked stable release, while the generated
`Dockerfile` pins that release's base image by manifest digest.

`requirements-s3.txt` pins `boto3`, `botocore`, and their transitive
dependencies to the exact versions and wheel hashes recorded in the tracked
release's official `uv.lock`. Installation uses `--require-hashes` and accepts
binary wheels only.

## Published image

A push to `main` or a manual workflow run publishes both architectures to:

```text
ghcr.io/reonokiy/omnigent-s3:<value from .image-version>
ghcr.io/reonokiy/omnigent-s3:sha-<git-commit>
```

Deployments should pin the resulting manifest digest. Pull requests perform a
build-only check and cannot publish. Publishing uses only the workflow's
short-lived `GITHUB_TOKEN`; no registry credential is stored in this repository.
Repository visibility and GHCR package visibility are independent. If the
package is private, runtime consumers need a separate read-only GHCR credential
delivered by their own secret-management boundary.

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

The `Follow stable Omnigent releases` workflow runs daily at 06:17 UTC. It uses
the official GitHub `releases/latest` endpoint, accepts only a `vX.Y.Z` tag, and
refuses downgrades. Drafts and prereleases are not followed.

For a new stable release, the workflow resolves the official server image to a
manifest digest, reads that tag's `pyproject.toml` and `uv.lock`, computes the
complete dependency closure of the `s3` extra, and regenerates the hash-pinned
requirements and Dockerfile. It publishes the amd64/arm64 image first and only
then pushes the generated source commit to `main`. A failed generation or build
does not advance the tracked version. The workflow uses only its short-lived
`GITHUB_TOKEN` with job-scoped `contents: write` and `packages: write`.

A manual run can force a reproducibility check and rebuild of the current
version. Generated files must not be edited by hand.

Omnigent is developed by Databricks and contributors. This derivative is not
an official Databricks image.
