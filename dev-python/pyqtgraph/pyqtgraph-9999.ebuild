# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	S=${WORKDIR}/${PN}-${P}
	KEYWORDS="amd64 x86"
	SRC_URI="http://www.pyqtgraph.org/downloads/${PV}/${P}.tar.gz"
fi

DESCRIPTION="A pure-python graphics and GUI library built on PyQt and numpy"
HOMEPAGE="http://www.pyqtgraph.org/ https://pypi.org/project/pyqtgraph/"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples opengl svg"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}]
	dev-python/pyside:2[${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

#PATCHES=( "${FILESDIR}"/${P}-qt5.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all

	# fix distutils warning
	sed -i 's/install_requires/requires/' setup.py || die

	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
