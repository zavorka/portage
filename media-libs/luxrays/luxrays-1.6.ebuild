# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="LuxCoreRender is a physically correct, unbiased rendering engine. It is built on physically based equations that model the transportation of light."
HOMEPAGE="http://www.luxcorerender.net"

if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/LuxCoreRender/LuxCore.git"
else
	SRC_URI="https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/luxrender_v${PV} -> ${P}.tar.gz"

	einfo "$SRC_URI"
fi


LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64"
IUSE="+opencl shared"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="media-libs/openimageio
	media-libs/embree
	virtual/opengl
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.43:=[context,nls,threads,python,${PYTHON_MULTI_USEDEP}]
	')
	${PYTHON_DEPS}
	opencl? (
		dev-libs/clhpp
		virtual/opencl )
"

DEPEND="${RDEPEND}"
S="${WORKDIR}/LuxCore-luxrender_v${PV}"

PATCHES=(
	${FILESDIR}/${P}-boost-python.patch
)

CMAKE_MAKEFILE_GENERATOR="emake"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {

	rm "${S}/cmake/Packages/FindOpenCL.cmake"
	rm "${S}/cmake/Packages/FindEmbree.cmake"
	rm "${S}/cmake/Packages/FindGLEW.cmake"
	rm "${S}/cmake/Packages/FindGLUT.cmake"
	rm "${S}/cmake/Packages/FindOpenEXR.cmake"
	if use shared ; then
		epatch "${FILESDIR}/${PN}-shared_libs.patch"
	fi
	epatch "${FILESDIR}/${PN}-${SLOT}_cmake_python.patch"
	epatch "${FILESDIR}/${PN}-${SLOT}_cl2hpp.patch"
	epatch "${FILESDIR}/${P}_up_to_date_cpp.patch"
	epatch "${FILESDIR}/${P}_embree3.patch"
	cmake-utils_src_prepare
}


src_configure() {
	append-flags -fPIC
        use opencl || append-flags -DLUXRAYS_DISABLE_OPENCL
	mycmakeargs=(
		-DLUXRAYS_DISABLE_OPENCL=$(usex opencl OFF ON)
		-DEPYTHON=${EPYTHON}
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make luxcore
	cmake-utils_src_make smallluxgpu
	cmake-utils_src_make luxrays
}

src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include/luxrays
	doins -r include/luxcore
	doins -r include/slg
	doins -r include/luxrays
	if use shared ; then
		newlib.so ${BUILD_DIR}/lib/libluxcore.so libluxcore-${SLOT}.so
		newlib.so ${BUILD_DIR}/lib/libsmallluxgpu.so libsmallluxgpu-${SLOT}.so
		newlib.so ${BUILD_DIR}/lib/libluxrays.so libluxrays-${SLOT}.so
	else
		newlib.a ${BUILD_DIR}/lib/libluxcore.a libluxcore-${SLOT}.a
		newlib.a ${BUILD_DIR}/lib/libsmallluxgpu.a libsmallluxgpu-${SLOT}.a
		newlib.a ${BUILD_DIR}/lib/libluxrays.a libluxrays-${SLOT}.a
	fi
}

