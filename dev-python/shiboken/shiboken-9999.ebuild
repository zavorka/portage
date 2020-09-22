# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit cmake-utils git-r3 llvm python-r1

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://qt-project.org/wiki/PySide"
EGIT_REPO_URI="git://code.qt.io/pyside/pyside-setup.git"
EGIT_BRANCH="5.15"
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 ) GPL-3"
SLOT="2"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="+docstrings numpy test vulkan"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Minimum version of Qt required.
QT_PV="5.12.0:5"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qtcore-${QT_PV}
	docstrings? (
		>=dev-libs/libxml2-2.6.32
		>=dev-libs/libxslt-1.1.19
		>=dev-qt/qtxml-${QT_PV}
		>=dev-qt/qtxmlpatterns-${QT_PV}
	)
	>=sys-devel/clang-6:=
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	vulkan? ( dev-util/vulkan-headers )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-${QT_PV} )
"

DOCS=( AUTHORS )

S="${S}/sources/${PN}${SLOT}"

# Ensure the path returned by get_llvm_prefix() contains clang as well.
llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	# TODO: File upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/\bprint(os\.path\.realpath(numpy))/d' \
			libshiboken/CMakeLists.txt || die
	fi

	# Shiboken2 assumes Vulkan headers live under either "$VULKAN_SDK/include"
	# or "$VK_SDK_PATH/include" rather than "${EPREFIX}/usr/include/vulkan".
	if use vulkan; then
		sed -i -e "s~\bdetectVulkan(&headerPaths);~headerPaths.append(HeaderPath{QByteArrayLiteral(\"${EPREFIX}/usr/include/vulkan\"), HeaderType::System});~" \
			ApiExtractor/clangparser/compilersupport.cpp || die
	fi

	#FIXME: Remove on the next bump to Shiboken > 5.14.2.
	# Shiboken2 <= 5.14.2 assumes the first digit of the Clang version in the
	# Clang includes directory identifies the full major Clang version,
	# breaking forward compatibility with Clang >= 10.0.0. See also:
	#     https://github.com/leycec/raiagent/issues/83
	#     https://bugreports.qt.io/browse/PYSIDE-1261
	if [[ ${PV} == '5.14.1' ]]; then
		sed -i -e "s~\b\(QVersionNumber::fromString\)(fileName.at(0));~\1(fileName);~" \
			ApiExtractor/clangparser/compilersupport.cpp || die
	fi

	# Shiboken2 assumes Clang builtin includes live under $LLVM_INSTALL_DIR
	# rather than "${EPREFIX}/usr/lib/cmake/include" on Gentoo. See bug 624682.
	sed -i -e "s~\bfindClangLibDir();~QStringLiteral(\"${EPREFIX}/usr/lib\");~" \
		ApiExtractor/clangparser/compilersupport.cpp || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDISABLE_DOCSTRINGS=$(usex !docstrings)
	)
	configuration() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DUSE_PYTHON_VERSION="${EPYTHON#python}"
		)

		LLVM_INSTALL_DIR="$(get_llvm_prefix)" cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}


src_install() {
	shiboken2_install() {
		cmake-utils_src_install
		python_optimize

		# Uniquify the "shiboken2" executable for the current Python target,
		# preserving an unversioned "shiboken2" file arbitrarily associated
		# with the last Python target.
		cp "${ED}"/usr/bin/${PN}${SLOT}{,-${EPYTHON}} || die

		# Uniquify the Shiboken2 pkgconfig file for the current Python target,
		# preserving an unversioned "shiboken2.pc" file arbitrarily associated
		# with the last Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}${SLOT}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl shiboken2_install

	# CMakeLists.txt installs a "Shiboken2Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., PySide2) to target one "libshiboken2-*.so"
	# library and one "shiboken2" executable linked to one Python interpreter.
	# See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i \
		-e 's~shiboken2-python[[:digit:]]\+\.[[:digit:]]\+~shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		-e 's~/bin/shiboken2~/bin/shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)"/cmake/Shiboken2-5.15.0/Shiboken2Targets-gentoo.cmake || die

	# Remove the broken "shiboken_tool.py" script. By inspection, this script
	# reduces to a noop. Moreover, this script raises the following exception:
	#     FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin/../shiboken_tool.py': '/usr/bin/../shiboken_tool.py'
	rm "${ED}"/usr/bin/shiboken_tool.py
}
