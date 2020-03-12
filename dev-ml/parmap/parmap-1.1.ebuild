# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit dune

DESCRIPTION="Library to exploit multicore architectures for OCaml programs"
HOMEPAGE="http://www.dicosmo.org/code/parmap/"
SRC_URI="https://github.com/rdicosmo/parmap/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-4.02.3:=[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/dune
	dev-ml/findlib
	dev-ml/ocamlbuild
	dev-ml/ocaml-autoconf"
