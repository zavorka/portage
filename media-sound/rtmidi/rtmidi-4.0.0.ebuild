# Copyright 2019 Robin Degen
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="RtMidi provides a common C++ API for realtime MIDI input output"
HOMEPAGE="http://www.music.mcgill.ca/~gary/rtmidi/"
SRC_URI="https://dl.bintray.com/aeon-engine/aeon_dependencies/rtmidi/src/rtmidi-4.0.0.tar.gz"

LICENSE="Gary P. Scavone"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

DEPEND="
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}

