# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{4,5,6,7,8} )

inherit cmake-utils git-r3 multilib python-r1

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://qt-project.org/wiki/PySide"
EGIT_REPO_URI="git://code.qt.io/pyside/pyside-setup.git"
EGIT_BRANCH="5.12"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2
	dev-libs/libxslt
	dev-qt/qtcore:5
	dev-qt/qtxmlpatterns:5
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui:5
		dev-qt/qttest:5
	)"

DOCS=( AUTHORS )

S="${S}/sources/${PN}${SLOT}"

src_configure() {
	configuration() {
		local mycmakeargs=(
			$(cmake-utils_use_build test TESTS)
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
			-DPYTHON_SUFFIX="-${EPYTHON}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		)

		if [[ ${EPYTHON} == python3* ]]; then
			mycmakeargs+=(
				-DUSE_PYTHON3=ON
				-DPYTHON3_EXECUTABLE="${PYTHON}"
				-DPYTHON3_INCLUDE_DIR="$(python_get_includedir)"
				-DPYTHON3_LIBRARY="$(python_get_library_path)"
			)
		fi

		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}${SLOT}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
