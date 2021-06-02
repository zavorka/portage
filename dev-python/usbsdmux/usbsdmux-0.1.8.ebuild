# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 systemd udev

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

DESCRIPTION="Tool to control an usb-sd-mux from the command line"
HOMEPAGE="https://github.com/linux-automation/usbsdmux"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

PATCHES=(
	"${FILESDIR}/usbsdmux-0.1.8-.service-ExecStart-fix.patch"
)

src_install() {
	distutils-r1_src_install
	systemd_dounit "${S}/contrib/systemd/usbsdmux.service"
	systemd_dounit "${S}/contrib/systemd/usbsdmux.socket"
	udev_dorules "${S}/contrib/udev/99-usbsdmux.rules"
	udev_reload
}
