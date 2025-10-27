# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bluefin:beta@sha256:ed5849e113468fdcb60e6b9a2971fe36d070ce8087acfd05302243bb450abdb4

### MODIFICATIONS
COPY system_files/ /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=cache,dst=/var/lib/dnf \
    --mount=type=cache,dst=/var/lib/xkb \
    --mount=type=tmpfs,dst=/tmp \
    . /ctx/build.sh
        
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint