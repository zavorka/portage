# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="The glue between Coin3D and Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/soqt"

MY_P="soqt-${PV}"

SOQT_SRC_URI="https://bitbucket.org/Coin3D/soqt"
GENERALMSVCGENERATION_SRC_URI="https://bitbucket.org/Coin3D/generalmsvcgeneration"
SOANYDATA_SRC_URI="https://bitbucket.org/Coin3D/soanydata"
SOGUI_SRC_URI="https://bitbucket.org/Coin3D/sogui"

GENERALMSVCGENERATION_REV="d12bf6cbb77c"
BOOSTHEADERLIBSFULL_REV="25bb7785a024"
SOANYDATA_REV="f429a8af8628"
SOGUI_REV="be5dfc647383"

SRC_URI="${GENERALMSVCGENERATION_SRC_URI}/get/${GENERALMSVCGENERATION_REV}.zip -> soqt-generalmsvcgeneration.zip
	${SOANYDATA_SRC_URI}/get/${SOANYDATA_REV}.zip -> soqt-soanydata.zip
	${SOGUI_SRC_URI}/get/${SOGUI_REV}.zip -> soqt-sogui.zip
	${SOQT_SRC_URI}/downloads/${MY_P}-src.zip -> ${P}.zip"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+coin-iv-extensions doc qthelp spacenav"

RDEPEND="
	>=media-libs/coin-4.0.0:=
	virtual/opengl
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtopengl:5=
	dev-qt/qtwidgets:5=
	qthelp? ( dev-qt/qthelp:5= )
	spacenav? ( >=dev-libs/libspnav-0.2.2:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

REQUIRED_USE="
	qthelp? ( doc )
"

PATCHES=(
	"${FILESDIR}/${P}-disable-packaging.patch"
)

DOCS=( AUTHORS BUGS.txt ChangeLog FAQ HACKING INSTALL NEWS README RELEASE.txt )

src_unpack() {
	default
	pushd "${WORKDIR}" > /dev/null || die
	mv Coin3D-generalmsvcgeneration-${GENERALMSVCGENERATION_REV} generalmsvcgeneration || die
	mv Coin3D-soanydata-${SOANYDATA_REV} soanydata || die
	mv Coin3D-sogui-${SOGUI_REV} sogui || die
	mv soqt ${P} || die
	ln -sf ../soanydata ${P}/data || die
	ln -sf ../../../../sogui ${P}/src/Inventor/Qt/common || die
	popd > /dev/null || die
}

src_prepare() {
	sed -i -e 's|@PROJECT_NAME_LOWER@|'${PF}'|' "${S}/SoQt.pc.cmake.in" || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX%/}/usr/share/doc/${PF}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX%/}/usr/share/man"
		-DCOIN_IV_EXTENSIONS=$(usex coin-iv-extensions ON OFF)
		-DHAVE_SPACENAV_SUPPORT=$(usex spacenav ON OFF)
		-DSOQT_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DSOQT_BUILD_DOC_MAN=$(usex doc ON OFF)
		-DSOQT_BUILD_DOC_QTHELP=$(usex qthelp ON OFF)
		-DSOQT_USE_QT5=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	sed -i -e 's|INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include;/usr/include;/usr/include"|\
		INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"|' \
		"${ED%/}/usr/$(get_libdir)/cmake/SoQt-1.6.0/soqt-export.cmake" || die
}
