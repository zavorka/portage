# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_OPTIONAL=1
inherit autotools git-r3 distutils-r1

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
EGIT_REPO_URI="https://github.com/libimobiledevice/${PN}.git"

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/6" # based on SONAME of libimobiledevice.so

KEYWORDS="~amd64"
IUSE="gnutls libressl python static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	virtual/libusb:1
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

BUILD_DIR="${S}_build"

src_prepare() {
	default
	eautoreconf
}
