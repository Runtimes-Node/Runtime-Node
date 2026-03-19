<div align="center">

![Icon](/.github/assets/icon.svg)

# Runtime Node

**Secure, Distroless, Multi-Arch Node.js Runtime. Built from Scratch.**

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Docker Hub](https://img.shields.io/docker/pulls/runtimenode/runtime-node?label=Docker%20Hub)](https://hub.docker.com/r/runtimenode/runtime-node)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2FRuntimes--Node%2Fruntime--node-blue)](https://github.com/Runtimes-Node/Runtime-Node/pkgs/container/runtime-node)
[![Platforms](https://img.shields.io/badge/platforms-linux%2Famd64%20%7C%20linux%2Farm64-lightgrey)](https://hub.docker.com/r/runtimenode/runtime-node)
[![Size](https://img.shields.io/badge/size-%7E45MB-green)](https://hub.docker.com/r/runtimenode/runtime-node)
[![Vulnerabilities](https://img.shields.io/badge/vulnerabilities-0-brightgreen)](https://hub.docker.com/r/runtimenode/runtime-node)

</div>

## Product Overview

Runtime Node is a production-grade Node.js runtime image designed for teams that care about security, consistency, and fast deployments. It removes everything that is not required to run Node.js and ships only the minimal runtime surface you need in production.

Use it when you want:
- A smaller, safer runtime image with a reduced attack surface.
- Deterministic production behavior with no unexpected system tools.
- A clean separation between build-time and runtime concerns.

## Why Runtime Node

Modern Node.js services do not need a full OS. Runtime Node keeps the runtime lean while preserving the essentials that real production workloads rely on.

Highlights:
- Distroless and built from `scratch` for minimal attack surface.
- Includes Node.js, CA certificates, and timezone data for real-world workloads.
- Multi-architecture ready for `linux/amd64` and `linux/arm64` deployments.
- Clear, explicit runtime contract: no shell, no package manager, no OS utilities.

## Value Snapshot

| Outcome | Runtime Node delivers | Why it matters |
| --- | --- | --- |
| Smaller runtime surface | Distroless `scratch` runtime with only Node, certs, tzdata, and minimal libs | Less to patch, scan, and maintain in production. |
| Predictable production defaults | `NODE_ENV=production` and `TZ=UTC` are baked into the image | Fewer environment surprises across fleets. |
| Clear build/runtime split | Build elsewhere, ship only runtime artifacts | Faster deploys and simpler rollbacks. |
| Multi-arch readiness | `linux/amd64` and `linux/arm64` | Consistent rollout across heterogeneous fleets. |

## Use-Case Fit

| Use case | Best-fit image | Rationale |
| --- | --- | --- |
| Production runtime for Node apps | Runtime Node | Distroless runtime, minimal surface, explicit defaults. |
| General-purpose Node base | Official `node:<version>` | Default image designed for broad use, based on `buildpack-deps` with common Debian packages. |
| Smallest official footprint | Official `node:<version>-alpine` | Alpine-based variant optimized for size. |
| Minimal Debian userland | Official `node:<version>-slim` | Slim variant with only minimal packages needed to run Node. |

## Comparison With Official Images

These are the two primary size-focused official variants documented by the Node Docker Official Image: `node:<version>-alpine` and `node:<version>-slim`.

| Image | Base | Distroless | OS userland present | Primary intent |
| --- | --- | --- | --- | --- |
| Runtime Node | `scratch` | Yes | No | Production runtime only. |
| `node:<version>-alpine` | Alpine Linux | No | Yes | Smallest official base; add only what you need. |
| `node:<version>-slim` | Debian-based (slim) | No | Yes | Minimal packages required to run Node. |

## Quickstart

### Docker Hub

- Versioned (Recommended for Production):

```bash
# Pull the versioned published tag
docker pull runtimenode/runtime-node:v<image_semver>+node<node_version>
```

- Latest (Not Recommended for Production):

```bash
# Pull the latest published tag
docker pull runtimenode/runtime-node:latest
```

### GitHub Container Registry (GHCR)

- Versioned (Recommended for Production):

```bash
# Pull the versioned published tag
docker pull ghcr.io/runtimes-node/runtime-node:v<image_semver>+node<node_version>
```

- Latest (Not Recommended for Production):

```bash
# Pull the latest published tag
docker pull ghcr.io/runtimes-node/runtime-node:latest
```

### Dockerfile Usage

- Versioned (Recommended for Production):

```Dockerfile
# Use the same Node.js version as your final runtime stage base image
FROM node:<node_version>-alpine AS builder

WORKDIR /dist

COPY ./ ./

RUN npm ci --omit=dev --no-cache
  
# Use the same Node.js version as your builder stage base image
FROM runtimenode/runtime-node:v<image_semver>+node<node_version>

# Copy your production build artifacts only
COPY --from=builder --chmod=555 dist/ /app/

# No shell is available, so invoke Node directly
ENTRYPOINT ["/usr/local/bin/node", "/app/server.js"]
```

- Latest (Not Recommended for Production):

```Dockerfile
FROM node:alpine AS builder

WORKDIR /dist

COPY ./ ./

RUN npm ci --omit=dev --no-cache
  
FROM runtimenode/runtime-node:latest

# Copy your production build artifacts only
COPY --from=builder --chmod=555 dist/ /app/

# No shell is available, so invoke Node directly
ENTRYPOINT ["/usr/local/bin/node", "/app/server.js"]
```

## What Is Inside

Runtime Node is assembled in a builder stage and copied into a `scratch` runtime. The final image includes:
- Node.js binary at `/usr/local/bin/node`.
- CA certificates for outbound TLS in `/etc/ssl/certs`.
- Timezone database in `/usr/share/zoneinfo` with `TZ=UTC` by default.
- Minimal runtime libraries for the Node.js binary (`ld-musl`, `libstdc++`, `libgcc`).
- A writable `/tmp` mount point with sticky bit permissions (`1777`).
- Minimal DNS config in `/etc/nsswitch.conf`.

## What Is Not Inside

By design, the runtime image does not include:
- A shell (`/bin/sh`, `/bin/bash`).
- A package manager (`apk`, `apt`, `yum`).
- Common OS utilities (`curl`, `wget`, `ps`, `ls`).

If you need build tools or debugging utilities, use a separate build stage or a dedicated debug image.

## Runtime Defaults

Runtime Node sets sensible production defaults:
- `NODE_ENV=production`
- `TZ=UTC`

Applications that need a different timezone can set `TZ` at runtime (timezone data is included).

## Platforms and Registries

- Supported platforms: `linux/amd64`, `linux/arm64`.
- Registries: Docker Hub and GitHub Container Registry (GHCR).

## Versioning and Tags

Tags follow the pattern:
- `v<image_semver>+node<node_version>` (example: `v2.0.0+node25.8.1`)
- `latest` tracks the most recent release.

Check the GitHub Releases page for the current tag and Node.js version.

## Security Posture

Runtime Node is built to minimize the attack surface:
- The runtime is `scratch`-based and distroless.
- Only the runtime components required for Node.js are included.
- No shell or package manager exists in the final image.

Report security issues privately. See [`SECURITY.md`](/SECURITY.md) for the disclosure process.

## Code Of Conduct

We are committed to a respectful, inclusive community. Please read and follow [`CODE_OF_CONDUCT.md`](/CODE_OF_CONDUCT.md).

## Contributing

We welcome contributions that keep the runtime secure, minimal, and production-focused. See [`CONTRIBUTING.md`](/CONTRIBUTING.md) for guidelines and workflow details.

## Acknowledgements

Runtime Node exists because of a small set of outstanding open-source projects that power the runtime and the delivery pipeline.

### Runtime Dependencies

[**Node.js**](https://nodejs.org/) — The JavaScript runtime this image is built to ship. The Node.js binary and its required shared libraries (`libstdc++`, `libgcc`, `musl libc`) are extracted from the official [`node`](https://hub.docker.com/_/node) Docker image, maintained by the Docker community and the Node.js project.

[**Alpine Linux**](https://alpinelinux.org/) — Minimal base distribution that underpins the official `node:<version>-alpine` builder image.

[**musl libc**](https://musl.libc.org/) — C standard library required by the Node.js binary in the Alpine-based builder image and copied into the runtime.

[**libstdc++**](https://gcc.gnu.org/onlinedocs/libstdc++/) and [**libgcc**](https://gcc.gnu.org/onlinedocs/gccint/Libgcc.html) — GCC runtime libraries required by the Node.js binary and copied from the official `node` image.

[**tzdata**](https://www.iana.org/time-zones) — IANA timezone database, installed to ensure production timezones resolve correctly.

[**ca-certificates**](https://wiki.mozilla.org/CA) — Trusted certificate bundle required for outbound TLS connections.

### Build & Release Infrastructure

[**GitHub Actions**](https://github.com/features/actions) — Automation platform that runs the CI/CD workflows for linting, build, and release.

[**Docker Engine / BuildKit**](https://github.com/moby/buildkit) — Build backend used by Docker Buildx to assemble multi-platform images.

[**Docker Buildx**](https://github.com/docker/buildx) — CLI plugin used to drive multi-platform builds.

[**QEMU**](https://www.qemu.org/) — Emulator used to enable cross-platform builds for non-native architectures.

[**Docker Hub**](https://hub.docker.com/r/runtimenode/runtime-node) and [**GitHub Container Registry**](https://github.com/Runtimes-Node/Runtime-Node/pkgs/container/runtime-node) — Registries used to publish and distribute images.

### CI/CD & Build Tooling

[**Hadolint**](https://github.com/hadolint/hadolint) — Dockerfile linter used in the PR pipeline to enforce best practices and catch issues before they reach the image.

[**docker/build-push-action**](https://github.com/docker/build-push-action) — GitHub Action used to build and push multi-platform images with provenance and SBOM support.

[**docker/metadata-action**](https://github.com/docker/metadata-action) — GitHub Action used to extract and generate OCI-compliant image tags and labels from Git references.

[**docker/login-action**](https://github.com/docker/login-action) — GitHub Action used to authenticate with Docker Hub and the GitHub Container Registry during the deployment workflow.

[**docker/setup-qemu-action**](https://github.com/docker/setup-qemu-action) — GitHub Action used to enable QEMU emulation for multi-platform builds.

[**docker/setup-buildx-action**](https://github.com/docker/setup-buildx-action) — GitHub Action used to configure Docker Buildx for advanced multi-platform build capabilities.

[**actions/checkout**](https://github.com/actions/checkout) — GitHub Action used to check out the repository code in every workflow job.

### Contributors

| | Name | GitHub | Role |
|---|---|---|---|
| <img src="https://avatars.githubusercontent.com/u/164869161?v=4" width="32" height="32" style="border-radius:50%"> | **Amnoor Brar** | [@Amnoor](https://github.com/Amnoor) | Creator & Maintainer |

Want to see your name here? Check out [CONTRIBUTING.md](/CONTRIBUTING.md).

## License

Runtime Node is licensed under the Apache-2.0 License. See [`LICENSE`](/LICENSE).
