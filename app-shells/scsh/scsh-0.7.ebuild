# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Unix shell embedded in Scheme"
HOMEPAGE="http://www.scsh.net/"
EGIT_REPO_URI="https://github.com/scheme/scsh"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="dev-scheme/scheme48"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-Makefile.in-LDFLAGS.patch"
	"${FILESDIR}/${PV}-install.patch"
)

RESTRICT="test" # some tests don't pass.

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	SCSH_LIB_DIRS="/usr/$(get_libdir)/${PN}"
	econf \
		--libdir=/usr/$(get_libdir) \
		--includedir=/usr/include
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	local ENVD="${T}/50scsh"
	echo "SCSH_LIB_DIRS=\"${SCSH_LIB_DIRS}\"" > "${ENVD}" || die
	doenvd "${ENVD}"
}
