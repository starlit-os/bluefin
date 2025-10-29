# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bluefin:latest@sha256:6e049fceea913dccb69ffa0702361b56fcb7bdfb719377a26a9fbde5c7f3d0ff

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
