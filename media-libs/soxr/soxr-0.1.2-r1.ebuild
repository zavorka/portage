# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_P=${P}-Source
DESCRIPTION="The SoX Resampler library"
HOMEPAGE="https://sourceforge.net/p/soxr/wiki/Home/"
SRC_URI="mirror://sourceforge/soxr/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE="openmp"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
DOCS=( "README" "TODO" "NEWS" "AUTHORS" )
PATCHES=(
	"${FILESDIR}/nodoc.patch"
	"${FILESDIR}/noexamples.patch"
	)

src_configure() {
	local mycmakeargs=(
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_LSR_BINDINGS=OFF
	)
	cmake-utils_src_configure
}
