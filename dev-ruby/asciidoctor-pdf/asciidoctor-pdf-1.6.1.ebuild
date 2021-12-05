# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="A native PDF converter for AsciiDoc based on Asciidoctor and Prawn"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-pdf"
SRC_URI="https://rubygems.org/downloads/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Should be rake-13.0.0, but is not stable in Gentoo yet. Still works with
# 12.3.3, though
ruby_add_bdepend "
	>=dev-ruby/chunky_png-1.3.0
	>=dev-ruby/coderay-1.1.0
	>=dev-ruby/pdf-inspector-1.3.0
	>=dev-ruby/rake-12.3.3
	>=dev-ruby/rouge-3.0
	>=dev-ruby/rspec-3.9.0
"

# Should be concurrent-ruby-1.1.0, but is not released by Gentoo yet. Still
# works with 1.0.5, though
ruby_add_rdepend "
	>=dev-ruby/asciidoctor-2.0
	>=dev-ruby/concurrent-ruby-1.1
	>=dev-ruby/prawn-2.2.0
	>=dev-ruby/prawn-icon-3.0.0
	>=dev-ruby/prawn-svg-0.30.0
	>=dev-ruby/prawn-table-0.2.0
	>=dev-ruby/prawn-templates-0.1.0
	>=dev-ruby/safe_yaml-1.0.0
	>=dev-ruby/thread_safe-0.3.0
	>=dev-ruby/treetop-1.5.0
	>=dev-ruby/ttfunk-1.5.1
"
