# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-pda/usbmuxd/usbmuxd-9999.ebuild,v 1.0 2013/10/31 17:05:12 srcs Exp $

EAPI=7
inherit autotools git-r3 udev user

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/libimobiledevice/usbmuxd.git"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

RDEPEND=">=app-pda/libplist-2.0.0
	virtual/libusb:1"
DEPEND="${RDEPEND}
	>=app-pda/libusbmuxd-1.0.9
	>=app-pda/libimobiledevice-1.2.1
	virtual/pkgconfig"

DOCS=( AUTHORS README.md )

pkg_setup() {
	enewgroup plugdev
	enewuser usbmux -1 -1 -1 "usb,plugdev"
}

src_prepare() {
	eapply_user
	eautoreconf
}
