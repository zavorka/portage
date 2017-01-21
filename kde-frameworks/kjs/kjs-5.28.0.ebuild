# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-libs/libpcre
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
	dev-lang/perl
"

DOCS=( src/README )

src_configure() {
	local mycmakeargs=(
		-DHAVE_IEEEFP_H=NO
		-DHAVE_PTHREAD_NP_H=NO
		-DHAVE_PTHREAD_ATTR_GET_NP=NO
		-DHAVE_PTHREAD_GETATTR_NP=NO
		-DCMAKE_EXE_LINKER_FLAGS="-pthread"
		-DCMAKE_SHARED_LINKER_FLAGS="-pthread"
		-DCMAKE_STATIC_LINKER_FLAGS="-pthread"
	)
	kde5_src_configure
}
