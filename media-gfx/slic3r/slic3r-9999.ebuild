# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake

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
	media-gfx/openvdb
	gui? (	>=media-libs/freeglut-3
		x11-libs/libXmu
		x11-libs/wxGTK:3.1-gtk3
	)"
DEPEND="${RDEPEND}"


CMAKE_MAKEFILE_GENERATOR=ninja

src_configure() {
	local mycmakeargs=(
		-DSLIC3R_FHS=ON
		-DSLIC3R_GTK=3
		-DSLIC3R_WX_STABLE=1
	)
	cmake_src_configure
}
