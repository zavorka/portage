# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# WARNING: copyright and license above in header are only for quality assurance software!
# Original ebuild by eroen <eroen-overlay@occam.eroen.eu>, 2013
# Distributed under the terms of the ISC license

EAPI=7
inherit eutils toolchain-funcs versionator git-r3

DESCRIPTION="A keyboard-centric VTE-based terminal"
HOMEPAGE="https://github.com/thestinger/termite"

EGIT_REPO_URI="https://github.com/thestinger/termite.git"
if [[ ${PV} != 999? ]]; then
	EGIT_COMMIT=v${PV}
fi

LICENSE="LGPL-2+ MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
HDEPEND=""
LIBDEPEND="
	>=x11-libs/gtk+-3.0
	>=x11-libs/vte-ng-0.44.1.9999
"

DEPEND="${LIBDEPEND}"
RDEPEND="${LIBDEPEND}"

[[ ${EAPI} == *-hdepend ]] || DEPEND+=" ${HDEPEND}"

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
