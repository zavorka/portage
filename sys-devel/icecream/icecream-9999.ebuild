# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7


inherit user

DESCRIPTION="Distributed compiling of C(++) code across several machines; based on distcc"
HOMEPAGE="https://github.com/icecc/icecream"

if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/icecc/${PN}"
else
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"
	MY_P="${P/icecream/icecc}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="ftp://ftp.suse.com/pub/projects/${PN}/${MY_P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	sys-libs/libcap-ng
"
RDEPEND="
	${DEPEND}
	dev-util/shadowman
"

PATCHES=(
)

pkg_setup() {
	enewgroup icecream
	enewuser icecream -1 -1 /var/cache/icecream icecream
}


src_prepare() {
	default

	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		--enable-shared --disable-static \
		--enable-clang-wrappers \
		--enable-clang-rewrite-includes \
		--disable-gcc-fdirectives-only
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	newconfd suse/sysconfig.icecream icecream
	newinitd "${FILESDIR}"/icecream-r2 icecream

	insinto /etc/logrotate.d
	newins suse/logrotate icecream

	insinto /usr/share/shadowman/tools
	newins - icecc <<<'/usr/libexec/icecc/bin'
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT} == / ]]; then
		eselect compiler-shadow remove icecc
	fi
}

pkg_postinst() {
	if [[ ${ROOT} == / ]]; then
		eselect compiler-shadow update icecc
	fi
}
