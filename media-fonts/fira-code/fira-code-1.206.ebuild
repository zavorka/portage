# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font versionator

DESCRIPTION="Default monospaced typeface for FirefoxOS, designed for legibility"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI="https://github.com/tonsky/FiraCode/releases/download/${PV}/FiraCode_${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S="${S}/otf"
FONT_SUFFIX="otf"
