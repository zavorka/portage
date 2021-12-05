# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/andreacorbellini/waitpid"
inherit autotools git-r3

DESCRIPTION="A program that attaches to a process and then hangs till the process exits"
HOMEPAGE="https://github.com/andreacorbellini/waitpid"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	default
	eautoreconf
}
