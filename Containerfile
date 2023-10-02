ARG SOURCE_IMAGE="${SOURCE_IMAGE}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"
ARG KERNEL_VERSION="${KERNEL_VERSION}"

# remove default firefox install & others
RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks \
	fedora-repos-modular \
	fedora-repos-archive \
	fedora-workstation-repositories

# fixes discover app not launching
# see: https://github.com/ublue-os/main/pull/282 & https://invent.kde.org/plasma/discover/-/issues/24
RUN rpm-ostree override remove plasma-discover-rpm-ostree

RUN rpm-ostree install \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm

# install nvidia driver
COPY --from=ghcr.io/kth8/kmod-nvidia:${KERNEL_VERSION} /rpms /var/tmp/nvidia
RUN rpm-ostree install xorg-x11-drv-nvidia-cuda nvidia-vaapi-driver /var/tmp/nvidia/kmod-nvidia-${KERNEL_VERSION}*.rpm

# install zfs
COPY --from=ghcr.io/kth8/kmod-zfs:${KERNEL_VERSION} /rpms /var/tmp
RUN rpm-ostree install /var/tmp/*.rpm

COPY etc /etc

RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN install -d -m 1777 /var/tmp
