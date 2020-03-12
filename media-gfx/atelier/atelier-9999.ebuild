# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit git-r3 kde5

DESCRIPTION="Program that allows you to control your 3D printer"
HOMEPAGE="https://atelier.kde.org"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/KDE/${PN}.git"

DEPEND="
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qt3d)
	$(add_qt_dep qtcharts)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtmultimedia)
	$(add_qt_dep qtserialport)
	$(add_qt_dep qtwidgets)
	dev-libs/atcore[gui]
	>=x11-libs/qwt-6.0.0
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-cmake.patch" )

