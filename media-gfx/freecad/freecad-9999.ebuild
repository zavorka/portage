# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This is in currently WIP! It should work though.

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit check-reqs cmake-utils desktop python-single-r1 xdg

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="https://www.freecadweb.org/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeCAD/FreeCAD.git"
	KEYWORDS=""
else
	MY_PV=$(ver_cut 1-2)
	MY_PV=$(ver_rs 1 '_' ${MY_PV})
	SRC_URI="https://github.com/FreeCAD/FreeCAD/archive/${PV}.tar.gz -> ${P}.tar.gz
		doc? ( https://github.com/FreeCAD/FreeCAD/releases/download/0.18.1/FreeCAD.${MY_PV}.Quick.Reference.Guide.7z -> ${P}.Quick.Reference.Guide.7z )"
	KEYWORDS="~amd64"
fi

# code is licensed LGPL-2
# examples are licensed CC-BY-SA (without note of specific version)
LICENSE="LGPL-2 CC-BY-SA-4.0"
SLOT="0"

# FIXME:
#   vr: needs a rift package: does this make sense? Currently they don't have
#		support for linux. The last linux package dates back to 2015!
#	smesh: needs a salome-platform package
#	zipio++: FreeCAD uses quite outdated zipio and doesn't compile against.
#		new versions. Ebuild is available in overlay.
# Possible candidates for mpi: hdf5 libmed vtk flann (netcdf, simage)

IUSE="debug doc mpi netgen pcl"

FREECAD_EXPERIMENTAL_MODULES="assembly"
#FREECAD_DEBUG_MODULES="sandbox template"
FREECAD_STABLE_MODULES="addonmgr arch complete drawing fem idf
	image inspection material mesh openscad
	part_design path points raytracing reverseengineering robot
	ship show spreadsheet surface techdraw
	tux"
FREECAD_DISABLED_MODULES="vr"
FREECAD_ALL_MODULES="${FREECAD_STABLE_MODULES}
	${FREECAD_EXPERIMENTAL_MODULES} ${FREECAD_DISABLED_MODULES}"

for module in ${FREECAD_STABLE_MODULES}; do
	IUSE="${IUSE} +${module}"
done
for module in ${FREECAD_EXPERIMENTAL_MODULES}; do
	IUSE="${IUSE} -${module}"
done
unset module

# eigen is needed by sketcher which we enable by default, so remove USE flag and
# unconditionally depend on it
RDEPEND="
	${PYTHON_DEPS}
	>=dev-cpp/eigen-3.3.1:3
	dev-libs/OpenNI2[opengl(+)]
	dev-libs/libspnav
	dev-libs/xerces-c
	$(python_gen_cond_dep '
		dev-libs/boost:=[mpi?,python,threads,${PYTHON_MULTI_USEDEP}]
		dev-python/matplotlib[${PYTHON_MULTI_USEDEP}]
		dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		dev-python/pivy[${PYTHON_MULTI_USEDEP}]
		dev-python/pyside:2[gui,svg,${PYTHON_MULTI_USEDEP}]
		dev-python/shiboken:2[${PYTHON_MULTI_USEDEP}]
		>=sci-libs/libmed-4.0.0[fortran,mpi?,python,${PYTHON_MULTI_USEDEP}]
		mesh? (
			netgen? ( >=sci-mathematics/netgen-6.2.1810[mpi?,python,opencascade,${PYTHON_MULTI_USEDEP}] )
			dev-python/pybind11[${PYTHON_MULTI_USEDEP}]
		)
	')
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/coin[draggers(+),manipulators(+),nodekits(+),simage]
	media-libs/freetype
	media-libs/qhull
	sci-libs/flann[mpi?,openmp]
	sci-libs/orocos_kdl:=
	sci-libs/opencascade:7.3.0[vtk(+)]
	sys-libs/zlib
	virtual/glu
	virtual/libusb:1
	virtual/opengl
	mesh? (
		sci-libs/hdf5:=[fortran,mpi?,zlib]
	)
	mpi? (
		virtual/mpi[cxx,fortran,threads]
	)
	openscad? ( media-gfx/openscad )
	pcl? ( >=sci-libs/pcl-1.8.1:=[opengl,openni2(+),qt5(+),vtk(+)] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyside-tools:2[${PYTHON_MULTI_USEDEP}]
	')
	dev-lang/swig
"

# To get required dependencies: 'grep REQUIRES_MODS CMakeLists.txt'
# We set the following requirements by default:
# draft, import, part, plot, qt5, sketcher, start, web.
#
# Additionally if mesh is set, we auto-enable mesh_part, flat_mesh and smesh
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	arch? ( mesh )
	debug? ( mesh )
	drawing? ( spreadsheet )
	inspection? ( mesh points )
	netgen? ( fem )
	path? ( robot )
	reverseengineering? ( mesh )
	ship? ( image )
	techdraw? ( spreadsheet drawing )
"

CMAKE_BUILD_TYPE=Release

DOCS=( README.md ChangeLog.txt )

# FIXME: Check the find-Coin.tag patch after updates of media-libs/coin
#	"${FILESDIR}/smesh-pthread.patch"
#	"${FILESDIR}/${P}-find-Coin.tag.patch"
PATCHES=(
	"${FILESDIR}/${PN}-0.18.2-Fix-to-find-boost_python.patch"
	"${FILESDIR}/${P}-shiboken.patch"
)

CHECKREQS_DISK_BUILD="6G"

[[ ${PV} == *9999 ]] && S="${WORKDIR}/freecad-${PV}" || S="${WORKDIR}/FreeCAD-${PV}"

pkg_setup() {
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# the upstream provided file doesn't find coin, but cmake ships
	# a working one, so we use this.
	rm -f "${S}/cMake/FindCoin3D.cmake"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ADDONMGR=$(usex addonmgr)
		-DBUILD_ARCH=$(usex arch)
		-DBUILD_ASSEMBLY=$(usex assembly)
		-DBUILD_COMPLETE=$(usex complete)
		-DBUILD_DRAFT=ON # basic workspace, enable it by default
		-DBUILD_DRAWING=$(usex drawing)
		-DBUILD_FEM=$(usex fem)
		-DBUILD_FEM_NETGEN=$(usex netgen)
		-DBUILD_FLAT_MESH=$(usex mesh)
		-DBUILD_FREETYPE=ON # automagic dep
		-DBUILD_GUI=ON
		-DBUILD_IDF=$(usex idf)
		-DBUILD_IMAGE=$(usex image)
		-DBUILD_IMPORT=ON # import module for various file formats
		-DBUILD_INSPECTION=$(usex inspection)
		-DBUILD_JTREADER=OFF # code has been removed upstream, but option is still there
		-DBUILD_MATERIAL=$(usex material)
		-DBUILD_MESH=$(usex mesh)
		-DBUILD_MESH_PART=$(usex mesh)
		-DBUILD_OPENSCAD=$(usex openscad)
		-DBUILD_PART=ON # basic workspace, enable it by default
		-DBUILD_PART_DESIGN=$(usex part_design)
		-DBUILD_PATH=$(usex path)
		-DBUILD_PLOT=ON # automagic dep
		-DBUILD_POINTS=$(usex points)
		-DBUILD_QT5=ON # OFF means to use Qt4
		-DBUILD_RAYTRACING=$(usex raytracing)
		-DBUILD_REVERSEENGINEERING=$(usex reverseengineering)
		-DBUILD_ROBOT=$(usex robot)
		-DBUILD_SHIP=$(usex ship)
		-DBUILD_SHOW=$(usex show)
		-DBUILD_SKETCHER=ON # needed by draft workspace
		-DBUILD_SMESH=$(usex mesh)
		-DBUILD_SPREADSHEET=$(usex spreadsheet)
		-DBUILD_START=ON # basic workspace, enable it by default
		-DBUILD_SURFACE=$(usex surface)
		-DBUILD_TECHDRAW=$(usex techdraw)
		-DBUILD_TUX=$(usex tux)
		-DBUILD_VR=OFF
		-DBUILD_WEB=ON # needed by start workspace
		-DCMAKE_INSTALL_DATADIR=/usr/share/${PN}/data
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/${PN}
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}
		-DFREECAD_USE_EXTERNAL_SMESH=OFF
		-DFREECAD_USE_EXTERNAL_KDL=ON
		-DFREECAD_USE_EXTERNAL_ZIPIOS=OFF # doesn't work yet, also no package in gentoo tree
		-DFREECAD_USE_FREETYPE=ON
		-DFREECAD_USE_PCL=$(usex pcl)
		-DFREECAD_USE_PYBIND11=$(usex mesh)
		# opencascade-7.3.0 sets CASROOT in /etc/env.d/51opencascade
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)
		-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		-DPYTHON_SUFFIX="-${EPYTHON}"
	)

	if use debug; then
		mycmakeargs+=(
			-DBUILD_SANDBOX=$(usex mesh)	# sandbox needs mesh support
			-DBUILD_TEMPLATE=ON
			-DBUILD_TEST=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_SANDBOX=OFF
			-DBUILD_TEMPLATE=OFF
			-DBUILD_TEST=OFF
		)
	fi

# NOTE: using mpi wrappers currently produces insecure runpaths in smesh
#		libraries.
	if use mpi; then
		mycmakeargs+=(
			-DOPENMPI_INCLUDE_DIRS=/usr/include/
		)
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif77
		export F77=mpif77
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dosym ../$(get_libdir)/${PN}/bin/FreeCAD /usr/bin/freecad
	dosym ../$(get_libdir)/${PN}/bin/FreeCADCmd /usr/bin/freecadcmd

	make_desktop_entry freecad "FreeCAD" "" "" "MimeType=application/x-extension-fcstd;"

	# install mimetype for FreeCAD files
	insinto /usr/share/mime/packages
	newins "${FILESDIR}"/${PN}.sharedmimeinfo "${PN}.xml"

	insinto /usr/share/pixmaps
	newins "${S}"/src/Gui/Icons/${PN}.xpm "${PN}.xpm"

	# install icons to correct place rather than /usr/share/freecad
	local size
	for size in 16 32 48 64; do
		newicon -s ${size} "${S}"/src/Gui/Icons/${PN}-icon-${size}.png ${PN}.png
	done
	doicon -s scalable "${S}"/src/Gui/Icons/${PN}.svg
	newicon -s 64 -c mimetypes "${S}"/src/Gui/Icons/${PN}-doc.png application-x-extension-fcstd.png

	if use doc; then
		[[ ${PV} == *9999 ]] && einfo "Docs are not downloaded for ${PV}" \
			|| (cp -r "${WORKDIR}/FreeCAD 0_18 Quick Reference Guide" "${ED}/usr/share/doc/${PF}" || die)
	fi

	python_optimize "${ED}"/usr/share/${PN}/data/Mod/ "${ED}"/usr/$(get_libdir)/${PN}{/Ext,/Mod}/
}

#pkg_postinst() {
#	xdg_icon_cache_update
#	xdg_desktop_database_update
#	xdg_mimeinfo_database_update
#}

#pkg_postrm() {
#	xdg_mimeinfo_database_update
#	xdg_desktop_database_update
#	xdg_icon_cache_update
#}
