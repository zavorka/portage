# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit cmake-utils
DESCRIPTION="Fast, modern C++ DSP framework, FFT, Sample Rate Conversion, FIR/IIR/Biquad Filters"
HOMEPAGE="https://www.kfrlib.com/"
case ${PV} in
        *9999)
                EGIT_REPO_URI="git://github.com/kfrlib/${PN}"
                EGIT_BRANCH="master"
                inherit git-r3
                ;;
        *)
                SRC_URI="https://github.com/kfrlib/${PN}/archive/v${PV}.tar.gz"
		KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
                ;;
esac

LICENSE="MIT"
SLOT="0"
IUSE="examples test"
DEPEND=""
RDEPEND="${DEPEND}"

# S="${WORKDIR}/${PN}-release-${PV}"

src_prepare() {
	use examples || sed -ie 's/add_subdirectory(examples)//' CMakeLists.txt || die
	use test || sed -ie 's/add_subdirectory(tests)//' CMakeLists.txt || die

	cat <<EOF >> CMakeLists.txt
add_library(kfr INTERFACE)
target_include_directories(kfr INTERFACE
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>)
target_compile_features(kfr INTERFACE cxx_relaxed_constexpr)
install(TARGETS kfr EXPORT kfrExport)
install(EXPORT kfrExport NAMESPACE kfrlib::
	DESTINATION lib/cmake/kfr)
install(DIRECTORY
	include/kfr
	DESTINATION include)
EOF

        cmake-utils_src_prepare
}
