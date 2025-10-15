# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bluefin-dx:stable-daily@sha256:27697cf83527f2faddb4a49baa20a76023149d1b2cc8ac8741465e1708a4153f

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