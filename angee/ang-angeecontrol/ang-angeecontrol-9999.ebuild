# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="http://meetangee.atlassian.com/"
SRC_URI=""
EGIT_REPO_URI="git+ssh://git@gitlab.meetangee.com/angee-device/ang-angeecontrol"

LICENSE="ISC"
KEYWORDS=""
IUSE=""
SLOT="0"
RDEPEND="
	angee/ang-common
	angee/ang-messages-proto
	>=dev-libs/protobuf-3.1.0
	dev-qt/qtcore:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5
	"
DEPEND="
        angee/ang-cmake
	angee/ang-messages
	dev-libs/flatbuffers
	dev-util/cmake
        ${RDEPEND}"



