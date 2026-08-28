# Security policy

Do not report credentials or other sensitive values in an issue, workflow log,
or pull request. Use GitHub's private vulnerability reporting for this
repository when available, or contact the repository owner privately.

The build intentionally pins its upstream image by digest, installs only
hash-pinned wheels, and grants package write permission only to the publishing
job. No cloud, cluster, S3, or long-lived registry credentials belong here.

This image inherits the security posture and runtime user of the official
Omnigent server image. Consumers must supply an appropriate container security
context, network policy, and narrowly scoped S3-compatible credentials.
