# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit dune

DESCRIPTION="Convert OCaml parsetrees between different major versions"
HOMEPAGE="https://github.com/ocaml-ppx/ppx_derivers"
SRC_URI="https://github.com/ocaml-ppx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/dune"
