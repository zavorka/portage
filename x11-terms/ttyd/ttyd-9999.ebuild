# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PV="$(ver_rs 3 '-')"

DESCRIPTION="ttyd, a simple command-line tool for sharing terminal over the web"
HOMEPAGE="https://github.com/tsl0922/ttyd"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/tsl0922/ttyd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tsl0922/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="dev-util/cmake"

DEPEND="
	dev-libs/json-c
	net-libs/libwebsockets
	dev-vcs/git
	"

RDEPEND="!net-misc/termpkg"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	dobin ../${P}_build/${PN}
	doman man/*.1
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
