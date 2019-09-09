# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )

inherit mercurial distutils-r1

DESCRIPTION="Coin3d binding for Python"
HOMEPAGE="http://pivy.coin3d.org/"
EHG_REPO_URI="https://bitbucket.org/Coin3D/pivy"
EHG_CLONE_CMD="hg clone ${EHG_QUIET_CMD_OPT}"
EHG_CHECKOUT_DIR="${WORKDIR}/pivy"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/pivy"

RDEPEND="
	media-libs/coin
	>=media-libs/SoQt-1.5.0"
DEPEND="${RDEPEND}
	dev-lang/swig"

PATCHES=(
	"${FILESDIR}"/${P}-coin.patch
	"${FILESDIR}"/${P}-swig.patch
)
