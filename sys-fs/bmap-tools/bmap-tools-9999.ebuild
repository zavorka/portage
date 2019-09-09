# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 python3_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Create and apply sparse images of block devices"
HOMEPAGE="https://github.com/intel/bmap-tools"

LICENSE="GPL-2"
SLOT="0"

RDEPENDS="dev-python/pygpgme"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/bmap-tools.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/intel/${PN}/releases/download/v${PV}/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi
