# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-module cmake-utils git-r3

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="http://slic3r.org"
EGIT_REPO_URI="https://github.com/prusa3d/Slic3r.git"
EGIT_BRANCH="dev_native"
LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=dev-libs/boost-1.55[threads]
	>=dev-libs/expat-2
	>=media-libs/freeglut-3
	>=media-libs/glew-2
	x11-libs/libXmu
	"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	dev-cpp/tbb:0"

CMAKE_MAKEFILE_GENERATOR=ninja

src_configure() {
        local mycmakeargs=(
                -DSLIC3R_PERL_XS=OFF
                -DSLIC3R_BUILD_SANDBOXES=OFF
                -DSLIC3R_BUILD_TESTS=OFF
        )

        cmake-utils_src_configure
}
