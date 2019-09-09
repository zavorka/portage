# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-module cmake-utils

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="http://slic3r.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/prusa3d/Slic3r.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/prusa3d/${PN}/archive/version_1.40.1.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Slic3r-version_${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
IUSE="+gui test"

RDEPEND=">=dev-libs/boost-1.55[threads]
	>=sci-libs/nlopt-2.4.2
	gui? (	>=media-libs/freeglut-3
		x11-libs/libXmu
		>=x11-libs/wxGTK-3.0
	)"
DEPEND="${RDEPEND}"


CMAKE_MAKEFILE_GENERATOR=ninja

src_prepare() {
	pushd "${S}" || die
	# sed -i lib/Slic3r.pm -e "s@FindBin::Bin@FindBin::RealBin@g" || die
	# eapply "${FILESDIR}/${P}-no-locallib.patch"
	eapply_user
	popd || die
}

src_configure() {
	# SLIC3R_NO_AUTO=1 perl-module_src_configure
	local mycmakeargs=(
		-DSLIC3R_WX_STABLE=1 -DSLIC3R_FHS=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	# perl-module_src_compile
	cmake-utils_src_compile
}

src_test() {
	# perl-module_src_test
	# pushd .. || die
	# prove -Ixs/blib/arch -Ixs/blib/lib/ t/ || die "Tests failed"
	# popd || die
	true
}

src_install() {
	#perl-module_src_install
	cmake-utils_src_install

        #insinto "${VENDOR_LIB}"
        #doins -r lib/Slic3r.pm lib/Slic3r

        #insinto "${VENDOR_LIB}"/Slic3r
        #doins -r resources

        #exeinto "${VENDOR_LIB}"/Slic3r
        #doexe slic3r.pl

        #dosym "${VENDOR_LIB}"/Slic3r/slic3r.pl /usr/bin/slic3r.pl

        #make_desktop_entry slic3r.pl \
        #        Slic3r \
        #        "${VENDOR_LIB}/Slic3r/var/Slic3r_128px.png" \
        #        "Graphics;3DGraphics;Engineering;Development"
}
