# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

WX_GTK_VER="3.0-gtk3"

inherit check-reqs cmake eutils python-single-r1 toolchain-funcs xdg-utils wxwidgets

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/code/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/kicad/code/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="https://www.kicad-pcb.org"

LICENSE="GPL-2+ GPL-3+ Boost-1.0"
SLOT="0"
IUSE="doc examples github +ngspice occ oce openmp +python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	?? ( occ oce )
"

COMMON_DEPEND="
	>=dev-libs/boost-1.61:=[context,nls]
	media-libs/freeglut
	media-libs/glew:0=
	>=media-libs/glm-0.9.9.1
	media-libs/mesa[X(+)]
	>=x11-libs/cairo-1.8.8:=
	>=x11-libs/pixman-0.30
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	github? ( net-misc/curl:=[ssl] )
	ngspice? (
		>sci-electronics/ngspice-27[shared]
	)
	occ? ( >=sci-libs/opencascade-6.8.0:=[vtk(+)] )
	python? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.61:=[context,nls,python,${PYTHON_MULTI_USEDEP}]
			dev-python/wxpython:4.0[${PYTHON_MULTI_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"
DEPEND="${COMMON_DEPEND}
	python? ( >=dev-lang/swig-3.0:0 )"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
BDEPEND="doc? ( app-doc/doxygen )"
CHECKREQS_DISK_BUILD="800M"

PATCHES=( "${FILESDIR}/${P}-pybind11-python-version.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use openmp && tc-check-openmp
	setup-wxwidgets
	check-reqs_pkg_setup
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DKICAD_DOCS="${EPREFIX}/usr/share/doc/${PF}"
		-DKICAD_HELP="${EPREFIX}/usr/share/doc/${PN}-doc-${PV}"
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON_PHOENIX="$(usex python)"
		-DKICAD_SCRIPTING_PYTHON3="$(usex python)"
		-DKICAD_SCRIPTING_ACTION_MENU="$(usex python)"
		-DKICAD_SPICE="$(usex ngspice)"
		-DKICAD_USE_OCC="$(usex occ)"
		-DKICAD_USE_OCE="$(usex oce)"
		-DKICAD_INSTALL_DEMOS="$(usex examples)"
		-DCMAKE_SKIP_RPATH="ON"
	)
	use python && mycmakeargs+=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_SITE_PACKAGE_PATH="$(python_get_sitedir)"
	)
	use occ && mycmakeargs+=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/lib
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_src_compile dev-docs doxygen-docs
	fi
}

src_install() {
	cmake_src_install
	use python && python_optimize
	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r *.txt kicad_doxygen_logo.png notes_about_pcbnew_new_file_format.odt doxygen/. development/doxygen/.
	fi
}

pkg_postinst() {
	optfeature "Component symbols library" sci-electronics/kicad-symbols
	optfeature "Component footprints library" sci-electronics/kicad-footprints
	optfeature "3D models of components " sci-electronics/kicad-packages3d
	optfeature "Project templates" sci-electronics/kicad-templates
	optfeature "Different languages for GUI" sci-electronics/kicad-i18n
	optfeature "Extended documentation" app-doc/kicad-doc
	optfeature "Creating 3D models of components" media-gfx/wings

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
