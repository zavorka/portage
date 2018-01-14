# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="http://meetangee.atlassian.com/"
SRC_URI=""
EGIT_REPO_URI="git+ssh://git@gitlab.meetangee.com/angee-device/ang-stator-connector"

LICENSE="ISC"
KEYWORDS=""
IUSE=""
SLOT="0"
RDEPEND="
	angee/ang-common
	angee/ang-messages-proto
	"
DEPEND="
        angee/ang-cmake
	angee/ang-messages
	dev-util/cmake
        ${RDEPEND}"



