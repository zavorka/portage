# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.16.9

EAPI=5

MODULE_AUTHOR="JONASS"
MODULE_VERSION="0.003006"


inherit perl-module

DESCRIPTION="Representation of text-based copyright statements"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Exporter-Tiny
	>=perl-gcpan/Number-Range-0.12
	dev-lang/perl"