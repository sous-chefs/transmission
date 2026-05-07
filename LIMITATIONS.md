# Limitations

## Package Availability

Transmission is distributed through operating system package repositories. The upstream project does
not publish a dedicated APT, DNF/YUM, or Zypper repository for Linux server packages.

### APT (Debian/Ubuntu)

* Ubuntu 24.04 provides `transmission-daemon` 4.0.5 for amd64, arm64, armhf, ppc64el, riscv64, and s390x.
* Debian 12 provides Transmission 3.00 packages.
* Debian 13 provides Transmission 4.1.0 packages, with 4.1.1 available from backports.

### DNF/YUM (RHEL family)

* Fedora current releases provide Transmission 4.1.x packages.
* EPEL 9 provides Transmission 4.0.6 packages.
* EPEL 8 provides Transmission 3.00 packages.
* RHEL-compatible platforms require EPEL for package installs; the package install resource enables
  the distribution EPEL repository before installing Transmission packages.
* Amazon Linux 2023 does not provide the default Transmission package set in the base repositories
  used by Dokken CI. Amazon Linux remains in metadata support for source installs, but is excluded
  from the default package-based Dokken matrix.

### Zypper (SUSE)

* openSUSE Leap 16 packages are distribution maintained. Source installation remains available when
  package availability differs by release.
* No `dokken/opensuse-leap-16` container image is available as of this migration, so openSUSE Leap 16
  remains in metadata and non-Dokken Kitchen coverage but is excluded from Dokken CI until an image is
  published.

## Architecture Limitations

* Distribution repositories determine architecture availability for package installs.
* Source installs depend on a working CMake/C++ toolchain and library development packages.

## Source/Compiled Installation

Upstream Transmission 4.x builds with CMake. This cookbook installs build tooling and core library
development packages, then builds from the upstream release tarball.

### Build Dependencies

| Platform Family | Packages |
| --- | --- |
| Debian | `cmake`, `g++`, `gcc`, `make`, `libcurl4-openssl-dev`, `libevent-dev`, `libnatpmp-dev`, `libssl-dev`, `pkg-config`, `xz-utils` |
| RHEL/Amazon/Fedora | `cmake`, `gcc`, `gcc-c++`, `make`, `curl-devel`, `gettext`, `libevent-devel`, `libnatpmp-devel`, `openssl-devel`, `tar`, `xz` |
| SUSE | `cmake`, `gcc`, `gcc-c++`, `make`, `libcurl-devel`, `gettext-tools`, `libevent-devel`, `libopenssl-devel`, `tar`, `xz` |

## Known Issues

* Legacy recipe and node attribute APIs were removed in the custom resource migration.
* Package service names and users are distribution controlled; resource defaults match the legacy
  cookbook behavior for Debian and RHEL-family platforms.

## Sources

* Ubuntu package data: <https://packages.ubuntu.com/noble/transmission-daemon>
* Debian package data: <https://packages.debian.org/transmission>
* Fedora/EPEL package data: <https://packages.fedoraproject.org/pkgs/transmission/transmission/>
* Upstream build guidance: <https://github.com/transmission/transmission>
