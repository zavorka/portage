# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json https://nlohmann.github.io/json/"
SRC_URI="https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=""
DOCS=( ChangeLog.md README.md )

S=${WORKDIR}/json-${PV}

src_configure() {
	local mycmakeargs=(
		-DJSON_BuildTests=OFF -DJSON_Install=ON
        )
	cmake-utils_src_configure
}