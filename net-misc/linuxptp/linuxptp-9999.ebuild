# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs git-r3

DESCRIPTION="The Linux Precision Time Protocol (PTP) implementation"
HOMEPAGE="http://linuxptp.sourceforge.net/"
EGIT_REPO_URI="git://git.code.sf.net/p/linuxptp/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

CONFIG_CHECK="~PPS ~NETWORK_PHY_TIMESTAMPING ~PTP_1588_CLOCK"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0_nettstamp-systypes.patch
)

pkg_setup() {
	linux-info_pkg_setup
}

src_compile() {
	# parse needed additional CFLAGS
	export MY_FLAGS=$(./incdefs.sh)
	export EXTRA_CFLAGS="${CFLAGS} ${MY_FLAGS}"
	emake CC="$(tc-getCC)" prefix=/usr mandir=/usr/share/man
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		libdir="${D}"/usr/$(get_libdir) \
		install

	install -d ${D}/etc/ptp
	install -m 0444 ${S}/configs/*.cfg ${D}/etc/ptp/

	systemd_dounit "${FILESDIR}"/timemaster.service

	dodoc README.org
}
