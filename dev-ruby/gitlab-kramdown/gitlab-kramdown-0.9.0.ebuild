# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md CODEOWNERS"

RUBY_FAKEGEM_GEMSPEC="gitlab_kramdown.gemspec"

inherit ruby-fakegem

DESCRIPTION="An official gem that implements GitLab flavored Markdown extensions on top of Kramdown."
HOMEPAGE="https://docs.gitlab.com/ee/user/markdown.html"
SRC_URI="https://gitlab.com/gitlab-org/gitlab_kramdown/-/archive/v${PV}/gitlab_kramdown-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"

IUSE=""

RUBY_S="gitlab_kramdown-v${PV}"

ruby_add_rdepend ">=dev-ruby/kramdown-1.16.2
	>=dev-ruby/rouge-3.0.0
	>=dev-ruby/nokogiri-1.10.4
	>=dev-ruby/asciidoctor-plantuml-0.0.9"

ruby_add_bdepend "test? ( dev-ruby/simplecov dev-ruby/rspec )
	doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	# Avoid dependency on git and bundler.
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}
