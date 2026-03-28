<div align="center">

![Icon](/.github/assets/icon.svg)

# Contributing to Runtime Node

**Secure, Distroless, Multi-Arch Node.js Runtime. Built from Scratch.**

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Docker Hub](https://img.shields.io/docker/pulls/runtimenode/runtime-node?label=Docker%20Hub)](https://hub.docker.com/r/runtimenode/runtime-node)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2FRuntimes--Node%2Fruntime--node-blue)](https://github.com/Runtimes-Node/Runtime-Node/pkgs/container/runtime-node)
[![Platforms](https://img.shields.io/badge/platforms-linux%2Famd64%20%7C%20linux%2Farm64-lightgrey)](https://hub.docker.com/r/runtimenode/runtime-node)
[![Size](https://img.shields.io/badge/size-%7E45MB-green)](https://hub.docker.com/r/runtimenode/runtime-node)
[![Vulnerabilities](https://img.shields.io/badge/vulnerabilities-0-brightgreen)](https://hub.docker.com/r/runtimenode/runtime-node)

</div>

Thanks for your interest in Runtime Node. This project exists to ship a production-grade, distroless Node.js runtime image. Contributions are welcome when they strengthen security, reliability, or operator clarity without expanding the runtime surface area.

## Project Principles

Every change must preserve these constraints:
- Distroless runtime: no shell, no package manager, no OS utilities in the final image.
- Minimal runtime surface: only components required for Node.js to run in production.
- Predictable behavior: explicit versions and deterministic outputs.

If a change adds convenience but is not strictly required for runtime correctness, it will not be accepted.

## Ways to Contribute

- Report a bug in the published image.
- Improve documentation or examples.
- Propose a platform or architecture expansion.
- Request a Node.js version upgrade.

Use the issue templates in [`.github/ISSUE_TEMPLATE/`](/.github/ISSUE_TEMPLATE/) to keep requests consistent.

## Security Issues

Do not open public issues for security vulnerabilities. Follow the process in [`SECURITY.md`](/SECURITY.md).

## Local Build

Prerequisites:
- Docker
- Git

Build the image locally:
```
docker build -t runtimenode/runtime-node:local .
```

Smoke test the runtime:
```
docker run --rm --entrypoint /usr/local/bin/node \
  runtimenode/runtime-node:local --version
```

## Change Workflow

1. Create a feature branch from `develop` (or a branch for backport version support like `develop/v1+node24` or etc.).
2. Make changes with the smallest possible surface area.
3. Update documentation when behavior or defaults change.
4. Open a pull request using the required PR template.

## Pull Request Requirements

All pull requests must:
- Use the provided PR template ([`.github/PULL_REQUEST_TEMPLATE.md`](/.github/PULL_REQUEST_TEMPLATE.md)).
- Use a conventional commit style title (`feat:`, `fix:`, `docs:`, `chore:`, `ci:`).
- Clearly describe why the change is necessary for the runtime image.

## Image Content Rules

- Dependencies are installed in the builder stage via [`dependencies/requirements.txt`](/dependencies/requirements.txt) and [`script.sh`](/script.sh).
- Runtime additions must be justified as strictly required for Node.js operation.
- The final image must remain `scratch`-based and distroless.

## Node.js Version Bumps

Node.js version upgrades are tracked as versioned releases. Requests must include the official Alpine Node image tag (for example, `node:25.8.2-alpine3.23`) and are expected to trigger a semver release bump for the image.

## Documentation Standards

Documentation updates should be marketing and product focused first, with engineering and operations details second. Keep examples runnable and avoid hardcoding stale version numbers unless the update is tied to a release.
