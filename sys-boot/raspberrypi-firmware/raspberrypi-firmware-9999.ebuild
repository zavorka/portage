# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 readme.gentoo

DESCRIPTION="Raspberry PI boot loader and firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI=""

LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="!sys-boot/raspberrypi-loader"

EGIT_REPO_URI="https://github.com/raspberrypi/firmware"
EGIT_BRANCH="stable"

RESTRICT="binchecks strip"[[:Template:PATH]]

src_install() {
        insinto /boot
        cd boot
        doins bootcode.bin fixup*.dat start*.elf
        readme.gentoo_create_doc
}

DOC_CONTENTS="Please configure your ram setup by editing /boot/config.txt"
