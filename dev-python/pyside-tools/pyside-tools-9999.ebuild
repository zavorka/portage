# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD="1"
CMAKE_MAKEFILE_GENERATOR="emake" # bug 558248

PYTHON_COMPAT=( python{3_4,3_5,3_6,3_7,3_8} )

inherit cmake-utils git-r3 python-r1 virtualx

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="http://wiki.qt.io/PySide"
EGIT_REPO_URI="git://code.qt.io/pyside/pyside-tools.git"
EGIT_BRANCH="5.12"
LICENSE="BSD GPL-2"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyside:2[${PYTHON_USEDEP}]
		dev-python/shiboken:2[${PYTHON_USEDEP}]
	')
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"
DEPEND="${RDEPEND}
	test? ( virtual/pkgconfig )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	cmake-utils_src_prepare

	python_copy_sources

	preparation() {
		pushd "${BUILD_DIR}" >/dev/null || die

		if python_is_python3; then
			rm -fr pysideuic/port_v2 || die

			# need to run with -py3 to generate proper python 3 interfaces
			sed -i -e 's:${PYSIDERCC_EXECUTABLE}:"${PYSIDERCC_EXECUTABLE} -py3":' \
				tests/rcc/CMakeLists.txt || die
		else
			rm -fr pysideuic/port_v3 || die
		fi

		sed -i -e "/pkg-config/ s:shiboken2:&-${EPYTHON}:" \
			tests/rcc/run_test.sh || die

		popd >/dev/null || die
	}
	python_foreach_impl preparation
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DPYTHON_BASENAME="-${EPYTHON}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_SUFFIX="-${EPYTHON}"
			-DBUILD_TESTS=$(usex test)
		)
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_make
	}
	python_foreach_impl compilation
}

src_test() {
	testing() {
		CMAKE_USE_DIR="${BUILD_DIR}" virtx cmake-utils_src_test
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install DESTDIR="${D}"
	}
	python_foreach_impl installation
}
