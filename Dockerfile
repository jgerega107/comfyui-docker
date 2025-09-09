# Ensure your driver supports this CUDA version
FROM nvidia/cuda:12.8.1-runtime-ubuntu24.04

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,rw \
    apt update && \
    apt install --no-install-recommends -y git rsync python3.12 python3.12-venv && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

# Set up directories and permissions for UID 1000
RUN mkdir -p /usr/src/venv /usr/src/app && \
    chown -R 1000:1000 /usr/src

USER 1000:1000
WORKDIR /usr/src

# Set up entrypoint
ADD --chown=1000:1000 entrypoint.sh /usr/src
ENTRYPOINT ["./entrypoint.sh"]
CMD ["--listen", "0.0.0.0"]

HEALTHCHECK --start-period=5m --timeout=3s \
  CMD curl -f http://localhost:8188 || exit 1
