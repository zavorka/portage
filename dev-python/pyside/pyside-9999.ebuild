# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils llvm python-r1 virtualx git-r3

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"
EGIT_REPO_URI="https://code.qt.io/pyside/pyside-setup.git"
EGIT_BRANCH="5.15"
EGIT_SUBMODULES=()

# See "sources/pyside2/PySide2/licensecomment.txt" for licensing details.
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="2"
KEYWORDS=""

IUSE="
	3d charts concurrent datavis designer gles2-only gui help location
	multimedia network positioning printsupport qml quick script scripttools
	scxml sensors speech sql svg test testlib webchannel webengine websockets
	widgets x11extras xml xmlpatterns
"

# The requirements below were extracted from the output of
# 'grep "set(.*_deps" "${S}"/PySide2/Qt*/CMakeLists.txt'
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	3d? ( gui network )
	charts? ( widgets )
	datavis? ( gui )
	designer? ( widgets xml )
	gles2-only? ( gui )
	help? ( widgets )
	location? ( positioning )
	multimedia? ( gui network )
	printsupport? ( widgets )
	qml? ( gui network )
	quick? ( qml )
	scripttools? ( gui script widgets )
	speech? ( multimedia )
	sql? ( widgets )
	svg? ( widgets )
	testlib? ( widgets )
	webengine? (
		location quick
		widgets? ( gui network printsupport webchannel )
	)
	websockets? ( network )
	widgets? ( gui )
	x11extras? ( gui )
"

# Minimum version of Qt required, derived from the CMakeLists.txt line:
#   find_package(Qt5 ${QT_PV} REQUIRED COMPONENTS Core)
QT_PV="5.12.0:5"

RDEPEND="
	${PYTHON_DEPS}
	3d? ( >=dev-qt/qt3d-${QT_PV}[qml?] )
	charts? ( >=dev-qt/qtcharts-${QT_PV}[qml?] )
	concurrent? ( >=dev-qt/qtconcurrent-${QT_PV} )
	datavis? ( >=dev-qt/qtdatavis3d-${QT_PV}[qml?] )
	designer? ( >=dev-qt/designer-${QT_PV} )
	gui? ( >=dev-qt/qtgui-${QT_PV}[gles2-only?] )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	location? ( >=dev-qt/qtlocation-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV}[qml?,widgets?] )
	network? ( >=dev-qt/qtnetwork-${QT_PV} )
	positioning? ( >=dev-qt/qtpositioning-${QT_PV}[qml?] )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_PV} )
	qml? ( >=dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	script? ( >=dev-qt/qtscript-${QT_PV} )
	scxml? ( >=dev-qt/qtscxml-${QT_PV} )
	sensors? ( >=dev-qt/qtsensors-${QT_PV}[qml?] )
	speech? ( >=dev-qt/qtspeech-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	testlib? ( >=dev-qt/qttest-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV}[qml?] )
	webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets?] )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV}[qml?] )
	widgets? ( >=dev-qt/qtwidgets-${QT_PV} )
	x11extras? ( >=dev-qt/qtx11extras-${QT_PV} )
	xml? ( >=dev-qt/qtxml-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV}[qml?] )
	$(python_gen_cond_dep '
		dev-python/shiboken:2[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	test? ( x11-misc/xvfb-run )
	>=sys-devel/clang-3.9.1:=
"

S=${WORKDIR}/${P}/sources/pyside2

# Ensure the path returned by get_llvm_prefix() contains clang as well.
llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# See COLLECT_MODULE_IF_FOUND macros in CMakeLists.txt
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DAnimation=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DCore=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DExtras=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DInput=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DLogic=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DRender=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Charts=$(usex !charts)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DataVisualization=$(usex !datavis)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Location=$(usex !location)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Positioning=$(usex !positioning)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !quick yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5RemoteObjects=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=$(usex !scripttools)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Scxml=$(usex !scxml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sensors=$(usex !sensors)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5TextToSpeech=$(usex !speech)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngine=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineCore=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebSockets=$(usex !websockets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=$(usex !widgets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5X11Extras=$(usex !x11extras)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Xml=$(usex !xml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5XmlPatterns=$(usex !xmlpatterns)
	)

	configuration() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
                        -DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DSHIBOKEN_PYTHON_SHARED_LIBRARY_SUFFIX="-${EPYTHON}"
		)
		LLVM_INSTALL_DIR="$(get_llvm_prefix)" cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	LLVM_INSTALL_DIR="$(get_llvm_prefix)" python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE
	python_foreach_impl virtx cmake-utils_src_test
}

src_install() {
	pyside2_install() {
		cmake-utils_src_install
		python_optimize

		# Uniquify the shiboken2 pkgconfig dependency in the PySide2 pkgconfig
		# file for the current Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		sed -i -e 's~^Requires: shiboken2$~&-'${EPYTHON}'~' \
			"${ED}/usr/$(get_libdir)"/pkgconfig/${PN}${SLOT}.pc || die

		# Uniquify the PySide2 pkgconfig file for the current Python target,
		# preserving an unversioned "pyside2.pc" file arbitrarily associated
		# with the last Python target. (See the previously linked issue.)
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}${SLOT}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl pyside2_install

	# CMakeLists.txt installs a "PySide2Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., pyside2-tools) to target one
	# "libpyside2-*.so" library linked to one Python interpreter. See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i -e 's~pyside2-python[[:digit:]]\+\.[[:digit:]]\+~pyside2${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)/cmake/PySide2-5.15.0/PySide2Targets-gentoo.cmake" || die
}
