# Copyright 2008-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# True Authors: Arfrever Frehtes Taifersar Arahesis and others

EAPI="7"

inherit flag-o-matic cmake-multilib toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/19"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="examples static-libs test zlib"
RESTRICT="!test? ( test )"

DEPEND="test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
RDEPEND="
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-3.8.0-disable_no-warning-test.patch"
	"${FILESDIR}/${PN}-3.8.0-system_libraries.patch"
	"${FILESDIR}/${PN}-3.8.0-protoc_input_output_files.patch"
)

DOCS=(CHANGES.txt CONTRIBUTORS.txt README.md)

src_configure() {
	local mycmakeargs=(
		-Dprotobuf_BUILD_TESTS=OFF
	)
	cmake-multilib_src_configure
}

CMAKE_USE_DIR=${S}/cmake
