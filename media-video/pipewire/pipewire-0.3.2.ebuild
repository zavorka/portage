# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/PipeWire/pipewire.git"
	inherit git-r3
else
	SRC_URI="https://github.com/PipeWire/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="LGPL-2.1+"
SLOT="0/0.3"
IUSE="alsa bluetooth doc ffmpeg gstreamer jack libav pulseaudio sdl systemd vaapi vulkan X"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	vulkan? (
		dev-util/vulkan-headers
		media-libs/vulkan-loader
	)
"
DEPEND="
	media-libs/alsa-lib
	sys-apps/dbus
	virtual/libudev
	bluetooth? ( media-libs/sbc )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:= )
		libav? ( media-video/libav:= )
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack? ( >=media-sound/jack-audio-connection-kit-1.9.10 )
	pulseaudio? ( >=media-sound/pulseaudio-11.1 )
	sdl? ( media-libs/libsdl2 )
	systemd? ( sys-apps/systemd )
	vaapi? ( x11-libs/libva )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	spa_use() {
		if ! use ${1}; then
			sed -e "/.*dependency.*'${2-$1}'/s/'${2-$1}'/'${2-$1}-disabled-by-USE-no-${1}'/" \
				-i spa/meson.build || die
		fi
	}

	default
	spa_use bluetooth bluez5
	spa_use bluetooth sbc
	spa_use ffmpeg libavcodec
	spa_use ffmpeg libavformat
	spa_use sdl sdl2
	spa_use X x11
}

src_configure() {
	local emesonargs=(
		-Dman=true
		-Dexamples=false
		-Dtests=false
		$(meson_use bluetooth bluez5)
		$(meson_use doc docs)
		$(meson_use gstreamer)
		$(meson_use ffmpeg)
		$(meson_use jack)
		$(meson_use systemd)
		$(meson_use vulkan)

		# Compatibility layers
		$(meson_use alsa pipewire-alsa)
		$(meson_use jack pipewire-jack)
		$(meson_use pulseaudio pipewire-pulseaudio)
	)
	meson_src_configure
}

pkg_postinst() {
	elog "Package has optional sys-auth/rtkit RUNTIME support that may be"
	elog "disabled by setting DISABLE_RTKIT env var."
}
