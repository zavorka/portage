# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson
EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="audit doc +launcher selinux"

DEPEND="
	audit? (
		>=sys-process/audit-2.7
		>=sys-libs/libcap-ng-0.6
	)
	launcher? (
		>=dev-libs/expat-2.2
		>=sys-apps/systemd-230:0=
	)
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}
	launcher? ( sys-apps/dbus )"
BDEPEND="
	doc? ( dev-python/docutils )
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Daudit=$(usex audit true false)
		-Ddocs=$(usex doc true false)
		-Dlauncher=$(usex launcher true false)
		-Dselinux=$(usex selinux true false)
		-Dlinux-4-17=true
	)
	meson_src_configure
}
