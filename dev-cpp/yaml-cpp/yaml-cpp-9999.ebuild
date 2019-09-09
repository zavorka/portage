# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
case ${PV} in
	*9999)
		EGIT_REPO_URI="git://github.com/jbeder/${PN}"
		EGIT_BRANCH="master"
		inherit git-r3
		S="${WORKDIR}/${PN}-${PV}"
		;;
	*)
		SRC_URI="https://github.com/jbeder/${PN}/archive/release-${PV}.tar.gz"
		S="${WORKDIR}/${PN}-release-${PV}"
		;;
esac

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"


src_prepare() {
	sed -i \
		-e 's:INCLUDE_INSTALL_ROOT_DIR:INCLUDE_INSTALL_DIR:g' \
		yaml-cpp.pc.cmake || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON -DYAML_CPP_BUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
