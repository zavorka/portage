# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils git-r3 multilib python-r1 virtualx

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://wiki.qt.io/PySide"
EGIT_REPO_URI="git://code.qt.io/pyside/pyside-setup.git"
EGIT_BRANCH="5.9"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="+X +declarative +designer +help +multimedia +opengl +script +scripttools +sql +svg +test +webkit +xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( X )
	designer? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	test? ( X )
	webkit? ( X )
"

# Minimal supported version of Qt.
QT_PV="5.9:5"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}:${SLOT}[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	X? (
		>=dev-qt/qtdatavis3d-${QT_PV}
		>=dev-qt/qtgui-${QT_PV}[accessibility]
		>=dev-qt/qttest-${QT_PV}
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	script? ( >=dev-qt/qtscript-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtgui-${QT_PV}
"

S=${S}/sources/${PN}${SLOT}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
        # Fix generated pkgconfig file to require the shiboken
        # library suffixed with the correct python version.
        sed -i -e '/^Requires:/ s/shiboken2$/&@SHIBOKEN_PYTHON_SUFFIX@/' \
                libpyside/pyside2.pc.in || die

	local mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_disable X QtGui)
		$(cmake-utils_use_disable X QtTest)
		$(cmake-utils_use_disable declarative QtDeclarative)
		$(cmake-utils_use_disable designer QtDesigner)
		$(cmake-utils_use_disable designer QtUiTools)
		$(cmake-utils_use_disable help QtHelp)
		$(cmake-utils_use_disable multimedia QtMultimedia)
		$(cmake-utils_use_disable opengl QtOpenGL)
		$(cmake-utils_use_disable script QtScript)
		$(cmake-utils_use_disable scripttools QtScriptTools)
		$(cmake-utils_use_disable sql QtSql)
		$(cmake-utils_use_disable svg QtSvg)
		$(cmake-utils_use_disable webkit QtWebKit)
		$(cmake-utils_use_disable xmlpatterns QtXmlPatterns)
	)

	configuration() {
		local mycmakeargs=(
			-DPYTHON_SUFFIX="-${EPYTHON}"
			"${mycmakeargs[@]}"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/pyside2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
