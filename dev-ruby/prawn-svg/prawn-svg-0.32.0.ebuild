# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Provides support for SVGs in Prawn"
HOMEPAGE="http://prawn.majesticseacreature.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "
	>=dev-ruby/prawn-0.11.1
	>=dev-ruby/css_parser-1.6
	>=dev-ruby/rexml-3.2
"
