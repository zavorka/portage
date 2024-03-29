# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Name Service Switch module for resolving the local hostname"
HOMEPAGE="https://0pointer.de/lennart/projects/nss-myhostname/"
SRC_URI="https://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

COMMON_DEPEND=""
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	# The documentation in doc/ is just the README file in other formats
	sed -e 's:SUBDIRS *= *doc:SUBDIRS =:' -i Makefile.{am,in} ||
		die "sed failed"
	default
}

src_configure() {
	econf --disable-lynx
}

pkg_postinst() {
	sed -e '/^hosts:/s/\s*\<myhostname\>//' \
		-e '/^hosts:/s/\s*myhostname//' \
		-i /etc/nsswitch.conf
}

pkg_prerm() {
	sed -e '/^hosts:/s/\s*\<myhostname\>//' \
		-e 's/\(^hosts:.*\)\(\<files\>\)\(.*\)\(\<dns\>\)\(.*\)/\1\2 myhostname \3\4\5/' \
		-i /etc/nsswitch.conf
}
