# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit dune

DESCRIPTION="Cram like framework for OCaml"
HOMEPAGE="https://github.com/ocaml-ppx/ppxlib"
SRC_URI="https://github.com/ocaml-ppx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/base:=
	dev-ml/findlib:=
	dev-ml/ocaml-compiler-libs:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_derivers:=
	dev-ml/stdio:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/dune"
