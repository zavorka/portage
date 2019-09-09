# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="High-level C Binding for ZeroMQ"
HOMEPAGE="http://czmq.zeromq.org"
SRC_URI="https://github.com/zeromq/czmq/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa x86"
IUSE="doc drafts curl +lz4 systemd test webserver"

RDEPEND="
	lz4? ( app-arch/lz4 )
	webserver? ( net-libs/libmicrohttpd )
	dev-libs/libsodium
	net-libs/zeromq
	curl? ( net-misc/curl )
	systemd? ( sys-apps/systemd )
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
"

DOCS=( NEWS AUTHORS )

src_configure() {
        local mycmakeargs=(
		-DENABLE_DRAFTS=$(usex drafts)
        )

        cmake-utils_src_configure
}

# Network access
RESTRICT=test
