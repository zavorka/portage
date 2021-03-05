# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit linux-info python-single-r1 git-r3 autotools

DESCRIPTION="Linux control and measurement device interface (userspace libraries)"
HOMEPAGE="http://www.comedi.org/"
EGIT_REPO_URI="https://github.com/Linux-Comedi/comedilib"

S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs python udev firmware pdf scxi"

RDEPEND="udev? ( virtual/udev )
	python? ( ${PYTHON_DEPS} )
	firmware? ( !sys-kernel/linux-firmware[-savedconfig] )"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto )
	python? ( dev-lang/swig )"
REQUIRED_USE="pdf? ( doc )
	python? ( ${PYTHON_REQUIRED_USE} )"

CONFIG_CHECK="COMEDI"

src_configure() {
	eautoreconf
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable firmware) \
		$(use_enable scxi) \
		$(use_enable doc docbook) \
		$(use_with pdf pdf-backend default) \
		$(use_with udev udev-hotplug "${EPREFIX}/lib") \
		$(use_enable python python-binding)
}

src_install() {
	default
	use python && python_optimize
	use doc && dodoc INSTALL AUTHORS ChangeLog NEWS README
}

