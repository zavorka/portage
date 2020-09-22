# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.16.9

EAPI=5

MODULE_AUTHOR="PERLANCAR"
MODULE_VERSION="0.006"


inherit perl-module

DESCRIPTION="Test Regexp::Pattern patterns"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=perl-gcpan/Regexp-Pattern-0.2.13
	>=perl-gcpan/Hash-DefHash-0.071
	dev-lang/perl"