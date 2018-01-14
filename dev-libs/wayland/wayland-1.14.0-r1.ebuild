# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools libtool ltprune multilib-minimal toolchain-funcs

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/"

SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --enable-shared=yes --enable-static=no \
		--disable-documentation --disable-dtd-validation
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs
}
