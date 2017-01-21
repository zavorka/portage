# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font versionator

DESCRIPTION="These fonts are designed specifically for legibility in a variety of contexts."
HOMEPAGE="https://developer.apple.com/fonts/"
SRC_URI="https://raw.githubusercontent.com/reBass/gentoo-prefix-overlay/master/SFUI.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/SF\ UI/SF-UI-Text
FONT_SUFFIX="otf"

