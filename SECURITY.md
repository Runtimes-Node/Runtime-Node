<div align="center">

![Icon](/.github/assets/icon.svg)

# Security Policy

**Secure, Distroless, Multi-Arch Node.js Runtime. Built from Scratch.**

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Docker Hub](https://img.shields.io/docker/pulls/runtimenode/runtime-node?label=Docker%20Hub)](https://hub.docker.com/r/runtimenode/runtime-node)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2FRuntimes--Node%2Fruntime--node-blue)](https://github.com/Runtimes-Node/Runtime-Node/pkgs/container/runtime-node)
[![Platforms](https://img.shields.io/badge/platforms-linux%2Famd64%20%7C%20linux%2Farm64-lightgrey)](https://hub.docker.com/r/runtimenode/runtime-node)
[![Size](https://img.shields.io/badge/size-%7E45MB-green)](https://hub.docker.com/r/runtimenode/runtime-node)
[![Vulnerabilities](https://img.shields.io/badge/vulnerabilities-0-brightgreen)](https://hub.docker.com/r/runtimenode/runtime-node)

</div>

Runtime Node is a production runtime image, and security is a core product requirement. This document explains what we support, how to report issues, and what is in scope.

## Supported Versions

All published image tags are actively supported, including older versions. When a security issue is confirmed, fixes are provided for affected supported tags; if a fix cannot be backported, we will document the constraint and provide upgrade guidance.

## Reporting a Vulnerability

Please do not open public GitHub issues for security vulnerabilities.

Preferred channel:
- GitHub Security Advisories: https://github.com/Runtimes-Node/Runtime-Node/security/advisories/new

If you cannot use GitHub Security Advisories, email the maintainer:
- runtimenodes@gmail.com

Include the following:
- A clear description of the vulnerability.
- The affected image tag and platform.
- Steps to reproduce or a minimal proof of concept.
- Any relevant logs or scan output.

## Response Expectations

We will acknowledge reports as soon as possible and aim to respond within 5 business days. Fix timelines depend on severity and availability of upstream patches.

## Scope

In scope:
- Inclusion of a shell, package manager, or OS utilities in the final runtime image.
- Missing or outdated CA certificates that break TLS security guarantees.
- Incorrect file permissions that weaken runtime isolation (for example, insecure `/tmp`).
- Supply-chain issues tied to the builder base image or dependencies.
- Packaging mistakes that expose unexpected binaries or files.

Out of scope:
- Vulnerabilities in your application code or dependencies.
- Issues that only affect the builder stage and are not shipped in the final image.
- Upstream Node.js vulnerabilities already fixed by upgrading the Node.js version.

## Coordinated Disclosure

Please allow time for verification and remediation before any public disclosure. We will coordinate a fix release and a public advisory when appropriate.
