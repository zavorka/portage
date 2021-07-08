# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="An IGMP querier"
HOMEPAGE="https://github.com/machinekoder/querierd"
EGIT_REPO_URI="https://github.com/machinekoder/querierd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/netifaces
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-2to3.patch"
	"${FILESDIR}/${P}-bytes.patch"
)

src_install() {
	distutils-r1_src_install
	systemd_dounit "${S}/lib/systemd/system/querierd.service"
}
