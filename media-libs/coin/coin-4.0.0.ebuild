# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_P=${P/c/C}

DESCRIPTION="A high-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1"
HOMEPAGE="https://bitbucket.org/Coin3D/coin/wiki/Home"

SRC_URI="https://github.com/coin3d/coin/releases/download/${MY_P}/${P}-src.tar.gz"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+3ds-import debug doc +draggers exceptions +javascript +manipulators
	+nodekits +openal qthelp +simage static-libs test threads +vrml97"

RESTRICT="!test? ( test )"

# avi, guile, jpeg2000, pic, rgb, tga, xwd not added (did not find where the support is)
RDEPEND="
	app-arch/bzip2
	dev-libs/expat:=
	>=dev-libs/boost-1.65.0:=
	media-libs/fontconfig:=
	media-libs/freetype:2=
	sys-libs/zlib:=
	virtual/opengl
	virtual/glu
	x11-libs/libICE:=
	x11-libs/libSM:=
	x11-libs/libX11:=
	x11-libs/libXext:=
	javascript? ( dev-lang/spidermonkey:0= )
	openal? ( media-libs/openal:= )
	simage? ( media-libs/simage:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? (
		 app-doc/doxygen
		 qthelp? ( dev-qt/qthelp:5 )
	)
"

REQUIRED_USE="
	draggers? ( nodekits )
	javascript? ( vrml97 )
	manipulators? ( nodekits )
	qthelp? ( doc )
"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-7.patch
	"${FILESDIR}"/${P}-disable_cpack.patch
)

DOCS=(
	AUTHORS FAQ FAQ.legal NEWS README RELNOTES THANKS
	docs/{HACKING,oiki-launch.txt}
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCOIN_BUILD_DOCUMENTATION=$(usex doc)
		-DCOIN_BUILD_DOCUMENTATION_MAN=$(usex doc ON OFF)
		-DCOIN_BUILD_DOCUMENTATION_QTHELP=$(usex qthelp)
		-DCOIN_BUILD_SHARED_LIBS=ON
		-DCOIN_BUILD_SINGLE_LIB=ON
		-DCOIN_BUILD_TESTS=$(usex test)
		-DCOIN_HAVE_JAVASCRIPT=$(usex javascript ON OFF)
		-DCOIN_THREADSAFE=$(usex threads ON OFF)
		-DCOIN_VERBOSE=$(usex debug)
		-DHAVE_3DS_IMPORT_CAPABILITIES=$(usex 3ds-import ON OFF)
		-DHAVE_DRAGGERS=$(usex draggers ON OFF)
		-DHAVE_MANIPULATORS=$(usex manipulators ON OFF)
		-DHAVE_MULTIPLE_VERSION=OFF # don't use slotting for now
		-DHAVE_NODEKITS=$(usex nodekits ON OFF)
		-DHAVE_SOUND=$(usex openal ON OFF)
		-DHAVE_VRML97=$(usex vrml97 ON OFF)
		-DOPENAL_RUNTIME_LINKING=$(usex openal ON OFF)
		-DSIMAGE_RUNTIME_LINKING=$(usex simage ON OFF)
		-DSPIDERMONKEY_RUNTIME_LINKING=$(usex javascript ON OFF)
		-DUSE_EXCEPTIONS=$(usex exceptions ON OFF)
		-DUSE_EXTERNAL_EXPAT=ON
	)

	cmake-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/bin" > /dev/null || die
	./CoinTests || die "Tests failed."
	popd > /dev/null || die
}
