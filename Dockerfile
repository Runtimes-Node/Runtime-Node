# Stage 1: Builder
# Extract binaries, libraries, and generate configuration files.
FROM node:24.14.1-alpine3.23 AS builder

COPY --chmod=550 script.sh /
COPY --chmod=550 dependencies/requirements.txt /dependencies/

# Install dependencies
RUN ./script.sh

# Create the mount point directory for /tmp.
# We set 1777 (Sticky Bit) so multiple users can write to it, 
# but only the owner of a file can delete it.
RUN mkdir -p /target/tmp && chmod 1777 /target/tmp

# Create a minimal nsswitch.conf for DNS resolution.
RUN echo 'hosts: files dns' > /target/nsswitch.conf

# Stage 2: Runtime
# Assemble the "Distroless" runtime image.
FROM scratch

# OCI Standard Metadata
LABEL org.opencontainers.image.title="Runtime Node" \
      org.opencontainers.image.description="Secure, Distroless, Multi-Arch Node.js Runtime. Built from Scratch." \
      org.opencontainers.image.authors="Amnoor <TechMan1810@gmail.com>" \
      org.opencontainers.image.vendor="Runtime Node" \
      org.opencontainers.image.url="https://github.com/Runtimes-Node/Runtime-Node" \
      org.opencontainers.image.source="https://github.com/Runtimes-Node/Runtime-Node" \
      org.opencontainers.image.documentation="https://github.com/Runtimes-Node/Runtime-Node/blob/main/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.base.name="scratch"

# Set the NODE_ENV environment to production
ENV NODE_ENV=production
ENV TZ=UTC

# 1. System Configuration
# Copy the empty /tmp directory. This acts as the mount point for the RAM disk.
COPY --from=builder --chmod=1777 /target/tmp /tmp
# Copy DNS configuration.
COPY --from=builder --chmod=555 /target/nsswitch.conf /etc/nsswitch.conf

# 2. Timezone Support
COPY --from=builder --chmod=555 /usr/share/zoneinfo /usr/share/zoneinfo

# 3. Security: CA Certificates
COPY --from=builder --chmod=555 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder --chmod=555 /etc/ssl/cert.pem /etc/ssl/cert.pem

# 4. Dependencies: Runtime Shared Libraries
COPY --from=builder --chmod=555 /lib/ld-musl-*.so.1 /lib/
COPY --from=builder --chmod=555 /usr/lib/libstdc++.so.6 /usr/lib/
COPY --from=builder --chmod=555 /usr/lib/libgcc_s.so.1 /usr/lib/

# 5. Core: Node.js Binary
COPY --from=builder --chmod=555 /usr/local/bin/node /usr/local/bin/