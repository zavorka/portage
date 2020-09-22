# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="https://curl.haxx.se/"
SRC_URI="https://curl.haxx.se/download/curl-${PV}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#lead to lots of false negatives, bug #285669
RESTRICT="test"

RDEPEND="
	net-libs/gnutls:0=
	dev-libs/nettle:0=
	app-misc/ca-certificates
	sys-libs/zlib"

DEPEND="${RDEPEND}"
BDEPEND=">=virtual/pkgconfig-0-r1"

S="${WORKDIR}/curl-${PV}"

PATCHES=(
	"${FILESDIR}"/curl-7.30.0-prefix.patch
	"${FILESDIR}"/curl-respect-cflags-3.patch
	"${FILESDIR}"/curl-fix-gnutls-nettle.patch
	"${FILESDIR}"/curl-symbol-version.patch
)

src_prepare() {
	sed -i '/LD_LIBRARY_PATH=/d' configure.ac || die #382241
	sed -i '/CURL_MAC_CFLAGS/d' configure.ac || die #637252

	default
	eautoreconf
}

src_configure() {
	# We make use of the fact that later flags override earlier ones
	# So start with all ssl providers off until proven otherwise
	# TODO: in the future, we may want to add wolfssl (https://www.wolfssl.com/)
	local myconf=()
	myconf+=( --without-gnutls --without-mbedtls --without-nss --without-polarssl --without-ssl --without-winssl )
	myconf+=( --without-ca-fallback --with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt  )
	einfo "SSL provided by gnutls"
	myconf+=( --with-gnutls --with-nettle )

	# These configuration options are organized alphabetically
	# within each category.  This should make it easier if we
	# ever decide to make any of them contingent on USE flags:
	# 1) protocols first.  To see them all do
	# 'grep SUPPORT_PROTOCOLS configure.ac'
	# 2) --enable/disable options second.
	# 'grep -- --enable configure | grep Check | awk '{ print $4 }' | sort
	# 3) --with/without options third.
	# grep -- --with configure | grep Check | awk '{ print $4 }' | sort

	ECONF_SOURCE="${S}" \
	econf \
		--disable-alt-svc \
		--enable-crypto-auth \
		--enable-dict \
		--disable-esni \
		--enable-file \
		--disable-ftp \
		--disable-gopher \
		--enable-http \
		--disable-imap \
		--disable-ldap \
		--disable-ldaps \
		--disable-mqtt \
		--disable-ntlm-wb \
		--disable-pop3 \
		--enable-rt  \
		--enable-rtsp \
		--disable-smb \
		--disable-libssh2 \
		--disable-smtp \
		--disable-telnet \
		--disable-tftp \
		--enable-tls-srp \
		--disable-ares \
		--enable-cookies \
		--enable-dateparse \
		--enable-dnsshuffle \
		--enable-doh \
		--enable-hidden-symbols \
		--enable-http-auth \
		--disable-ipv6 \
		--enable-largefile \
		--enable-manual \
		--enable-mime \
		--enable-netrc \
		--enable-progress-meter \
		--enable-proxy \
		--disable-sspi \
		--disable-static \
		--enable-threaded-resolver \
		--enable-pthreads \
		--enable-versioned-symbols \
		--without-amissl \
		--without-bearssl \
		--without-cyassl \
		--without-darwinssl \
		--without-fish-functions-dir \
		--without-libidn2 \
		--without-gssapi \
		--without-libmetalink \
		--without-nghttp2 \
		--without-libpsl \
		--without-nghttp3 \
		--without-ngtcp2 \
		--without-quiche \
		--without-librtmp \
		--without-brotli \
		--without-schannel \
		--without-secure-transport \
		--without-spnego \
		--without-winidn \
		--without-wolfssl \
		--with-zlib \
		"${myconf[@]}"

	sed -i -e '/SUBDIRS/s:src::' Makefile || die
	sed -i -e '/SUBDIRS/s:scripts::' Makefile || die
}

src_install() {
	default
	mkdir -p "${ED}"/opt/spotify/spotify-client/
	find "${ED}" -name 'libcurl.so*' | while read f
	do
		mv ${f} "${ED}"/opt/spotify/spotify-client/
	done
	rm -rf "${ED}"/etc/
	rm -rf "${ED}"/usr/
}
