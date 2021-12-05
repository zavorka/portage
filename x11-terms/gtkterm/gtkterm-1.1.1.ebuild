EAPI=7
PLOCALES="de fr hu nl_NL ru zh_CN"
inherit eutils meson xdg-utils

DESCRIPTION="A serial port terminal written in GTK+, similar to Windows' HyperTerminal"
HOMEPAGE="https://github.com/Jeija/gtkterm"
SRC_URI="https://github.com/Jeija/gtkterm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-3.12
	>=x11-libs/vte-0.40"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-libs/libgudev
	dev-util/meson
	dev-util/ninja"

src_prepare() {
	default
	l10n_find_plocales_changes po '' '.po'
}

src_install() {
	meson_src_install

	rm_locale() {
		rm -rf ${D}/usr/share/locale/${1}
	}

	l10n_for_each_disabled_locale_do rm_locale
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
