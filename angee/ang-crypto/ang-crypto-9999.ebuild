# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="http://meetangee.atlassian.com/"
SRC_URI=""
EGIT_REPO_URI="git+ssh://git@gitlab.meetangee.com/angee-device/ang-crypto"

LICENSE="ISC"
KEYWORDS=""
IUSE="libressl +openssl"
REQUIRED_USE="^^ ( libressl openssl )"
SLOT="0"
RDEPEND="
	angee/ang-common
	libressl? ( >=dev-libs/libressl-2.5.0 )
	openssl? ( >=dev-libs/openssl-1.0.2j )
	dev-db/sqlite:3
	"
DEPEND="
        angee/ang-cmake
	dev-util/cmake
        ${RDEPEND}"



