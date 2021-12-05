# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Provides support for various icon fonts in Prawn"
HOMEPAGE="http://prawn.majesticseacreature.com/"

LICENSE="|| ( GPL-2 GPL-3 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/pdf-inspector-1.2.1
	>=dev-ruby/pdf-reader-1.4
	>=dev-ruby/prawn-1.1.0
"

#all_ruby_prepare() {
#	sed -i -e "/[Bb]undler/d" Rakefile spec/spec_helper.rb || die
#
#	# Remove test that needs unpackaged dependency
#	rm -f spec/manual_spec.rb || die
#}
