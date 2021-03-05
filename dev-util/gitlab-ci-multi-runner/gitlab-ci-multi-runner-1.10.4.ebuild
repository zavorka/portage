# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
EGO_PN=gitlab.com/gitlab-org/gitlab-ci-multi-runner

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm64"
	EGIT_COMMIT=v${PV}
	SRC_URI="https://${EGO_PN}/repository/archive.tar.bz2?ref=${EGIT_COMMIT} -> ${P}.tar.bz2"
	inherit golang-vcs-snapshot
fi
inherit golang-build user

DESCRIPTION="It runs tests and sends the results to GitLab"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
LICENSE="MIT"
SLOT="0"
IUSE="docker"
DEPEND="dev-go/godep
	dev-go/go-bindata
	docker? ( app-emulation/docker )"
RDEPEND="
	dev-go/go-bindata-assetfs:=
	"

src_compile() {
	emake GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" RELEASE=true BUILD_PLATFORMS="-os=linux -arch=amd64" -C src/${EGO_PN} build
}

src_install() {
	newbin src/${EGO_PN}/out/binaries/gitlab-ci-multi-runner-linux-${ARCH} gitlab-ci-multi-runner
	dodoc src/${EGO_PN}/README.md src/${EGO_PN}/CHANGELOG.md
}

pkg_postinst() {
	enewuser gitlab-ci-multirunner -1 /bin/bash /var/lib/gitlab-ci-multi-runner
}
