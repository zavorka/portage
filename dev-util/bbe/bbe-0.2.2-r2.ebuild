# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="sed-like editor for binary files"
HOMEPAGE="https://sourceforge.net/projects/bbe-/"
SRC_URI="mirror://sourceforge/${PN}-/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE=""

DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=(
	"${FILESDIR}"/${P}-added-k-command.patch
	"${FILESDIR}"/${P}-merged-doc-changes.patch
)

src_prepare() {
	default

	sed -i -e '/^htmldir/d' doc/Makefile.am || die
	eaclocal
	eautoreconf
}

src_configure() {
	# Avoid linking problems, bug #750545.
	replace-flags -Os -O2

	default
}
