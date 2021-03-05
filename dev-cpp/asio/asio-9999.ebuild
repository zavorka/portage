# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit autotools

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="http://asio.sourceforge.net/"
case ${PV} in
        *9999)
                EGIT_REPO_URI="git://github.com/chriskohlhoff/${PN}"
                EGIT_BRANCH="master"
                inherit git-r3
                ;;
        *)
                SRC_URI="https://github.com/chriskohlhoff/${PN}/archive/release-${PV}.tar.gz"
                ;;
esac

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ppc64 sparc x86"
IUSE="doc examples libressl ssl test"

RDEPEND="ssl? (
	!libressl? ( >=dev-libs/openssl-1.0.2g:0=[-bindist] )
	libressl? ( >=dev-libs/libressl-2.5.0 )
)"
DEPEND="${RDEPEND}"
S="${S}/asio"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-boost=no

	if ! use test; then
		# Don't build nor install any examples or unittests
		# since we don't have a script to run them
		cat > src/Makefile.in <<-EOF || die
			all:

			install:

			clean:
		EOF
	fi
}

src_install() {
	use doc && local HTML_DOCS=( src/doc/. )
	default

	if use examples; then
		# Get rid of the object files
		emake clean
		dodoc -r src/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
