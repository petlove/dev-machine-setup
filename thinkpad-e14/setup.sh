#!/bin/bash

# Run as root

echo ">> Setting sources.list"
cat << EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src http://deb.debian.org/debian/ bookworm-backports main non-free non-free-firmware contrib

deb http://deb.debian.org/debian/ bookworm main non-free non-free-firmware contrib
deb-src http://deb.debian.org/debian/ bookworm main non-free non-free-firmware contrib

deb http://security.debian.org/debian-security bookworm-security main non-free non-free-firmware contrib
deb-src http://security.debian.org/debian-security bookworm-security main non-free non-free-firmware contrib

deb http://deb.debian.org/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free non-free-firmware contrib
EOF

echo ">> Updating system"
apt update && apt upgrade -y

echo ">> Removing packages"
apt remove -y firmware-iwlwifi

echo ">> Installing firmware-iwlwifi from backports"
apt install -y -t bookworm-backports firmware-iwlwifi

echo ">> Installing kernel from backports"
apt install -y -t bookworm-backports linux-image-amd64 linux-headers-amd64

echo ">> Installing network-manager"
apt install -y \
  adduser \
  apt \
  apt-listchanges \
  apt-utils \
  base-files \
  base-passwd \
  bash \
  bash-completion \
  bind9-dnsutils \
  bind9-host \
  bsdutils \
  build-essential \
  busybox \
  bzip2 \
  ca-certificates \
  cmake \
  console-setup \
  coreutils \
  cpio \
  cron \
  cron-daemon-common \
  dash \
  dbus \
  debconf \
  debconf-i18n \
  debian-archive-keyring \
  debian-faq \
  debianutils \
  diffutils \
  discover \
  dmidecode \
  dmsetup \
  doc-debian \
  dosfstools \
  dpkg \
  e2fsprogs \
  fdisk \
  file \
  findutils \
  firmware-misc-nonfree \
  firmware-sof-signed \
  gcc-12-base \
  gettext-base \
  git \
  gpgv \
  grep \
  groff-base \
  grub-common \
  grub-efi-amd64 \
  gzip \
  hostname \
  htop \
  ifupdown \
  inetutils-telnet \
  init \
  init-system-helpers \
  initramfs-tools \
  installation-report \
  intel-microcode \
  iproute2 \
  iputils-ping \
  isc-dhcp-client \
  isc-dhcp-common \
  keyboard-configuration \
  kmod \
  krb5-locales \
  laptop-detect \
  less \
  libacl1 \
  libapparmor1 \
  libapt-pkg6.0 \
  libargon2-1 \
  libattr1 \
  libaudit-common \
  libaudit1 \
  libblkid1 \
  libbpf1 \
  libbsd0 \
  libbz2-1.0 \
  libc-bin \
  libc6 \
  libcap-ng0 \
  libcap2 \
  libcap2-bin \
  libcom-err2 \
  libcrypt1 \
  libcryptsetup12 \
  libdb5.3 \
  libdebconfclient0 \
  libdevmapper1.02.1 \
  libedit2 \
  libelf1 \
  libext2fs2 \
  libfdisk1 \
  libffi8 \
  libgcc-s1 \
  libgcrypt20 \
  libgmp10 \
  libgnutls30 \
  libgpg-error0 \
  libgssapi-krb5-2 \
  libhogweed6 \
  libidn2-0 \
  libip4tc2 \
  libjansson4 \
  libjson-c5 \
  libk5crypto3 \
  libkeyutils1 \
  libkmod2 \
  libkrb5-3 \
  libkrb5support0 \
  liblocale-gettext-perl \
  liblockfile-bin \
  liblz4-1 \
  liblzma5 \
  libmd0 \
  libmnl0 \
  libmount1 \
  libncursesw6 \
  libnettle8 \
  libnewt0.52 \
  libnftables1 \
  libnftnl11 \
  libnss-systemd \
  libp11-kit0 \
  libpam-modules \
  libpam-modules-bin \
  libpam-runtime \
  libpam-systemd \
  libpam0g \
  libpcre2-8-0 \
  libpopt0 \
  libproc2-0 \
  libreadline8 \
  libseccomp2 \
  libselinux1 \
  libsemanage-common \
  libsemanage2 \
  libsepol2 \
  libslang2 \
  libsmartcols1 \
  libss2 \
  libssl3 \
  libstdc++6 \
  libsystemd-shared \
  libsystemd0 \
  libtasn1-6 \
  libtext-charwidth-perl \
  libtext-iconv-perl \
  libtext-wrapi18n-perl \
  libtinfo6 \
  libtirpc-common \
  libtirpc3 \
  libudev1 \
  libunistring2 \
  libuuid1 \
  libxtables12 \
  libxxhash0 \
  libzstd1 \
  locales \
  login \
  logrotate \
  logsave \
  lsof \
  man-db \
  manpages \
  mawk \
  media-types \
  mime-support \
  mount \
  nano \
  ncurses-base \
  ncurses-bin \
  ncurses-term \
  net-tools \
  netbase \
  netcat-traditional \
  network-manager \
  network-manager-openvpn \
  nftables \
  openssh-client \
  os-prober \
  passwd \
  pciutils \
  perl \
  perl-base \
  procps \
  python3-reportbug \
  readline-common \
  reportbug \
  sed \
  sensible-utils \
  shim-signed \
  sudo \
  systemd \
  systemd-sysv \
  systemd-timesyncd \
  sysvinit-utils \
  tar \
  task-english \
  task-laptop \
  traceroute \
  tzdata \
  ucf \
  udev \
  usbutils \
  usr-is-merged \
  util-linux \
  util-linux-extra \
  wamerican \
  wget \
  whiptail \
  xz-utils \
  zlib1g \
  zstd

echo ">> Installing packages related to intel"
apt install -y \
  intel-gpu-tools \
  intel-media-va-driver \
  intel-microcode

echo ">> Cleaning up"
apt autoremove -y

echo ">> Disabling ipv6"
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable=1"/g' /etc/default/grub

