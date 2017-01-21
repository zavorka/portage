# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="http://meetangee.atlassian.com/"
SRC_URI=""
EGIT_REPO_URI="git+ssh://git@gitlab.meetangee.com/angee-device/ang-vbox-soap"

LICENSE="ISC"
KEYWORDS=""
IUSE=""
SLOT="0"
RDEPEND="
	angee/ang-common
	>=net-libs/gsoap-2.8.36
	net-misc/curl
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	"
DEPEND="
        angee/ang-cmake
	dev-util/cmake
        ${RDEPEND}"



