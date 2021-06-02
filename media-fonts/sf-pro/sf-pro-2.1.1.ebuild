# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="System font for iOS, macOS, and tvOS, and includes a rounded variant"
HOMEPAGE="https://developer.apple.com/fonts/"
SRC_URI="https://github.com/reBass/gentoo-prefix-overlay/raw/master/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

FONT_SUFFIX="otf"
