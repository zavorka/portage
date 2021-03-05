# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit git-r3 distutils-r1

DESCRIPTION="Coin3d binding for Python"
HOMEPAGE="http://pivy.coin3d.org/"
EGIT_REPO_URI="https://github.com/coin3d/pivy"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/coin
	>=media-libs/SoQt-1.5.0"
DEPEND="${RDEPEND}
	dev-lang/swig"

PATCHES=(
	"${FILESDIR}"/${P}-coin.patch
#	"${FILESDIR}"/${P}-swig.patch
)
