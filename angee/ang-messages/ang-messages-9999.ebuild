EAPI=6

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="http://meetangee.atlassian.com/"
SRC_URI=""
EGIT_REPO_URI="git+ssh://git@gitlab.meetangee.com/angee-device/ang-messages"

LICENSE="ISC"
KEYWORDS=""
IUSE=""
SLOT="0"
DEPEND="
	angee/ang-cmake
	dev-util/cmake
	dev-libs/flatbuffers
	dev-python/setuptools
        dev-lang/python:3.5"


src_prepare() {
	sed -i python/CMakeLists.txt \
        	-e "s/local\/lib/lib64/" \
        	|| die

	cmake-utils_src_prepare
}
