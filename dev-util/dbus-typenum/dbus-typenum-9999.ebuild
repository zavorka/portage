# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson
EGIT_REPO_URI="https://github.com/cherry-pick/dbus-typenum.git"

DESCRIPTION="D-Bus Type Enumerator"
HOMEPAGE="https://github.com/cherry-pick/dbus-typenum"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
