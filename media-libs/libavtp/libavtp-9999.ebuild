EAPI=7

inherit git-r3 meson
EGIT_REPO_URI="https://github.com/Avnu/libavtp.git"

DESCRIPTION="Open source implementation of Audio Video Transport Protocol (AVTP) specified in IEEE 1722-2016 spec"
HOMEPAGE="https://github.com/Avnu/libavtp"

LICENSE="BSD"
IUSE=""
KEYWORDS="~amd64"

SLOT="0"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"
