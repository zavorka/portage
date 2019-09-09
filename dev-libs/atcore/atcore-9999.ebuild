# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kde5-functions

DESCRIPTION="API to manage the serial connection between the computer and 3D Printers"
HOMEPAGE="https://atelier.kde.org/"

LICENSE="|| ( LGPL-2.1+ LGPL-3 ) gui? ( GPL-3+ )"
SLOT="0"
IUSE="doc gui test"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDE/${PN}.git"
else
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

RDEPEND="
	$(add_qt_dep qtcore)
	$(add_qt_dep qtserialport)
	gui? (
		$(add_qt_dep qtcharts)
		$(add_qt_dep qtgui)
		$(add_qt_dep qtwidgets)
	)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep linguist-tools)
	doc? ( app-doc/doxygen[dot] )
	test? ( $(add_qt_dep qttest) )
"

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s/${PN}/${PF}/" -i doc/CMakeLists.txt || die

	use gui || punt_bogus_dep Qt5 Charts
	if ! use test; then
		cmake_comment_add_subdirectory unittests
		punt_bogus_dep Qt5 Test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_GUI=$(usex gui)
	)

	cmake-utils_src_configure
}
