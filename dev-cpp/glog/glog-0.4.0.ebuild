# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-multilib

DESCRIPTION="Google's C++ logging library"
HOMEPAGE="https://github.com/google/glog"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+gflags static-libs test unwind"

RDEPEND="
	gflags? ( >=dev-cpp/gflags-2.0-r1[${MULTILIB_USEDEP}] )
	sys-libs/libunwind[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/0002-Find-Libunwind-during-configure.patch
)

src_configure() {
	local mycmakeargs=(
                -DBUILD_SHARED_LIBS=$(usex static-libs)
		-DBUILD_TESTING=$(usex test)
                -DWITH_GFLAGS=$(usex gflags)
        )
	cmake-multilib_src_configure
}
