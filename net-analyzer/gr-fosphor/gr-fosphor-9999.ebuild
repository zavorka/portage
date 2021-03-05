# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake-utils python-single-r1

DESCRIPTION="gnuradio fosphor block (GPU spectrum display)"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/fosphor"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	#EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
	EGIT_REPO_URI="https://github.com/osmocom/${PN}.git"
	EGIT_BRANCH="gr38-qt5"
	KEYWORDS=""
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+glfw"

RDEPEND="
	>=net-wireless/gnuradio-3.8_rc:0=[${PYTHON_USEDEP}]
	media-libs/freetype
	dev-libs/boost:=
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtopengl:5=
	glfw? ( >=media-libs/glfw-3 )
	virtual/opencl
	virtual/opengl
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	dev-lang/swig:0
	dev-util/cppunit
"

src_prepare() {
	cmake-utils_src_prepare
	default
}

src_configure() {
	# tries to run OpenCL test program, but failing doesn't hurt
	addpredict /dev/dri

	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DENABLE_GLFW="$(usex glfw)"
		-DENABLE_QT=ON
		-DENABLE_PYTHON=ON
	)
	# re-enable Qt if port to Qt5 is ever finished
	cmake-utils_src_configure
}
