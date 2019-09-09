# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy )

inherit distutils-r1

DESCRIPTION="Seamless operability between C++11 and Python"
HOMEPAGE="https://github.com/pybind/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz"
#https://github.com/pybind/${PN}/archive/v${PV}.tar.gz"

LICENSE=" MIT"
KEYWORDS="amd64 ~arm ~arm64 x86"
SLOT="0"
RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
#S="${WORKDIR}"/${MY_PN}-${PV}
