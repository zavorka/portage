# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools git-r3

DESCRIPTION="A tool to interact with the installation_proxy of an Apple's iDevice"
HOMEPAGE="http://www.libimobiledevice.org/"
EGIT_REPO_URI="https://github.com/libimobiledevice/ideviceinstaller.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.1.4:=
	>=app-pda/libplist-1.8:=
	>=dev-libs/libzip-0.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default
	eautoreconf
	sed -i -e 's:-Werror -g::' configure || die
}
