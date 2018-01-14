# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build golang-vcs-snapshot eutils

EGO_PN="github.com/mitchellh/gox/..."
EGIT_COMMIT="c9740af9c6574448fd48eb30a71f964014c7a837"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A dead simple, no frills Go cross compile tool"
HOMEPAGE="https://github.com/mitchellh/gox"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MPL-2.0"
SLOT="0/${PVR}"
IUSE=""

DEPEND="dev-go/iochan"

src_install() {
	mkdir pkg || die
	golang-build_src_install
	dobin bin/*
}

