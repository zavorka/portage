# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic autotools

PATCHES="${PN}-3.5-patches-01.tar.xz"

DESCRIPTION="A general-purpose (yacc-compatible) parser generator"
HOMEPAGE="https://www.gnu.org/software/bison/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
	mirror://gentoo/${PATCHES}
	https://dev.gentoo.org/~whissi/dist/bison/${PATCHES}
	https://dev.gentoo.org/~polynomial-c/dist/bison/${PATCHES}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples nls static test"
RESTRICT="!test? ( test )"

RDEPEND=">=sys-devel/m4-1.4.16"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	examples? ( dev-lang/perl )
	nls? ( sys-devel/gettext )
	test? ( dev-lang/perl )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO ) # ChangeLog-2012 ChangeLog-1998 PACKAGING README-alpha README-release

PATCHES=(
	"${WORKDIR}"/patches/${PN}-3.5-optional-perl.patch #538300
)

src_configure() {
	eautoreconf
	use static && append-ldflags -static

	local myeconfargs=(
		--docdir='$(datarootdir)'/doc/${PF}
		$(use_enable examples)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# This one is installed by dev-util/yacc
	mv "${ED}"/usr/bin/yacc{,.bison} || die
	mv "${ED}"/usr/share/man/man1/yacc{,.bison}.1 || die

	# We do not need liby.a
	rm -r "${ED}"/usr/lib* || die
}

pkg_postinst() {
	local f="${EROOT}/usr/bin/yacc"
	if [[ ! -e ${f} ]] ; then
		ln -s yacc.bison "${f}"
	fi
}

pkg_postrm() {
	# clean up the dead symlink when we get unmerged #377469
	local f="${EROOT}/usr/bin/yacc"
	if [[ -L ${f} && ! -e ${f} ]] ; then
		rm -f "${f}"
	fi
}
