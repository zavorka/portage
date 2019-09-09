# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake-utils flag-o-matic fortran-2 python-single-r1

#DESCRIPTION="A library to store and exchange meshed data or computation results"
DESCRIPTION="Modeling and Exchange of Data library"
HOMEPAGE="https://www.salome-platform.org/user-section/about/med"
SRC_URI="https://files.salome-platform.org/Salome/other/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran hdf5_16_api mpi python static-libs test"

# fails to run parallel tests
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# dev-lang/tk is needed for wish-based xmdump utility
RDEPEND="
	!sci-libs/libmed
	dev-lang/tk:0=
	>=sci-libs/hdf5-1.10.2:=[fortran=,mpi=]
	mpi? ( virtual/mpi[fortran=] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="python? ( >=dev-lang/swig-3.0.8 )"

PATCHES=(
	"${FILESDIR}/${P}-0001-doc-html.doc-Makefile.am-install-into-htmldir.patch"
	"${FILESDIR}"/${P}-0002-cmake.patch
)

DOCS=( AUTHORS ChangeLog README )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	use hdf5_16_api && append-cppflags -DH5_USE_16_API
	cmake-utils_src_prepare
}

src_configure() {
	if use mpi; then
		export MPICC=mpicc
		export MPICXX=mpicxx
	        export MPIFC=mpif90
		export MPIF77=mpif77
		export FC=mpif90
		export F77=mpif77
	fi
	local mycmakeargs=(
		-DMEDFILE_BUILD_SHARED_LIBS:BOOL=ON
		-DMEDFILE_BUILD_STATIC_LIBS:BOOL=$(usex static-libs)
		-DMEDFILE_INSTALL_DOC:BOOL=$(usex doc)
		-DMEDFILE_BUILD_PYTHON:BOOL=$(usex python)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize

	rm -r "${ED}"/usr/include/2.3.6 || die "failed to delete obsolete include dir"
}
