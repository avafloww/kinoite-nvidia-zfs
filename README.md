# Inspired by [Universal Blue](https://github.com/ublue-os)

Based on [kth8/silverblue](https://github.com/kth8/silverblue), with modifications for my own use.

# Starts from stock [Kinoite](https://quay.io/repository/fedora-ostree-desktops/kinoite?tab=tags) image and installs:
- [Nvidia driver](https://github.com/kth8/kmod-nvidia)
- [Nvtop](https://github.com/Syllo/nvtop)
- [OpenZFS 2](https://github.com/kth8/kmod-zfs)
### removes:
- Firefox

### To rebase

```shell
rpm-ostree rebase --reboot ostree-unverified-image:docker://ghcr.io/avafloww/kinoite-nvidia-zfs:38
rpm-ostree rebase --reboot ostree-image-signed:docker://ghcr.io/avafloww/kinoite-nvidia-zfs:38
```

### Set kargs after rebasing

Setting kargs to disable nouveau and enabling nvidia early at boot is [currently not supported within container builds](https://github.com/coreos/rpm-ostree/issues/3738). They must be set after rebasing:

```shell
rpm-ostree kargs \
    --append-if-missing=rd.driver.blacklist=nouveau \
    --append-if-missing=modprobe.blacklist=nouveau \
    --append-if-missing=nvidia-drm.modeset=1
```

### To revert back

```shell
rpm-ostree kargs \
    --delete-if-present=rd.driver.blacklist=nouveau \
    --delete-if-present=modprobe.blacklist=nouveau \
    --delete-if-present=nvidia-drm.modeset=1
rpm-ostree rebase --reboot fedora:fedora/38/x86_64/silverblue
```
