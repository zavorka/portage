# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit cmake-multilib eutils fortran-2 flag-o-matic toolchain-funcs prefix

MY_P=${PN}-${PV/_p/-patch}
MAJOR_P=${PN}-$(ver_cut 1-2)

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="http://www.hdfgroup.org/HDF5/"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/releases/${MAJOR_P}/${MY_P}/src/${MY_P}.tar.bz2"

LICENSE="NCSA-HDF"
SLOT="0/${PV%%_p*}"
KEYWORDS="alpha amd64 ~arm arm64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cxx fortran +hl mpi szip threads zlib"

REQUIRED_USE="
	cxx? ( !mpi ) mpi? ( !cxx )
	threads? ( !cxx !mpi !fortran !hl )"

RDEPEND="
	mpi? ( virtual/mpi[romio] )
	szip? ( virtual/szip )
	zlib? ( sys-libs/zlib:0= )"

DEPEND="${RDEPEND}
	sys-devel/libtool:2
	>=sys-devel/autoconf-2.69"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.9-static_libgfortran.patch
	"${FILESDIR}"/${PN}-1.8.9-mpicxx.patch
	"${FILESDIR}"/${PN}-1.8.13-no-messing-ldpath.patch
	"${FILESDIR}"/${P}-h5cxprivate.patch
)

pkg_setup() {
	tc-export CXX CC AR # workaround for bug 285148
	use fortran && fortran-2_pkg_setup

	if use mpi; then
		if has_version 'sci-libs/hdf5[-mpi]'; then
			ewarn "Installing hdf5 with mpi enabled with a previous hdf5 with mpi disabled may fail."
			ewarn "Try to uninstall the current hdf5 prior to enabling mpi support."
		fi
		export CC=mpicc
		use fortran && export FC=mpif90
	elif has_version 'sci-libs/hdf5[mpi]'; then
		ewarn "Installing hdf5 with mpi disabled while having hdf5 installed with mpi enabled may fail."
		ewarn "Try to uninstall the current hdf5 prior to disabling mpi support."
	fi
}

multilib_src_configure() {
        local mycmakeargs=(
                -DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=OFF
		-DHDF5_INSTALL_LIB_DIR=$(get_libdir)
		-DHDF5_NO_PACKAGES:BOOL=ON
		-DHDF5_PACKAGE_EXTLIBS:BOOL=OFF
		-DHDF5_ALLOW_EXTERNAL_SUPPORT:STRING=NO
		-DHDF5_BUILD_CPP_LIB:BOOL=$(usex cxx)
		-DHDF5_BUILD_FORTRAN:BOOL=$(usex fortran)
		-DHDF5_BUILD_HL_LIB:BOOL=$(usex hl)
		-DHDF5_ENABLE_SZIP_SUPPORT:BOOL=$(usex szip)
		-DHDF5_ENABLE_SZIP_ENCODING:BOOL=$(usex szip)
		-DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=$(usex zlib)
		-DHDF5_ENABLE_THREADSAFE:BOOL=$(usex threads)
		-DHDF5_ENABLE_PARALLEL:BOOL=$(usex mpi)
        )

        cmake-utils_src_configure
}
