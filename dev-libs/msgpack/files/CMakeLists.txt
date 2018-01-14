CMAKE_MINIMUM_REQUIRED (VERSION 3.9)
PROJECT (msgpack)

FILE (READ ${CMAKE_CURRENT_SOURCE_DIR}/include/msgpack/version_master.h contents)
STRING (REGEX MATCH "#define MSGPACK_VERSION_MAJOR *([0-9a-zA-Z_]*)" NULL_OUT ${contents})
SET (VERSION_MAJOR ${CMAKE_MATCH_1})
STRING (REGEX MATCH "#define MSGPACK_VERSION_MINOR *([0-9a-zA-Z_]*)" NULL_OUT ${contents})
SET (VERSION_MINOR ${CMAKE_MATCH_1})
STRING (REGEX MATCH "#define MSGPACK_VERSION_REVISION *([0-9a-zA-Z_]*)" NULL_OUT ${contents})
SET (VERSION_REVISION ${CMAKE_MATCH_1})
SET (VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_REVISION})

SET (prefix ${CMAKE_INSTALL_PREFIX})
SET (exec_prefix "\${prefix}")
SET (libdir "\${exec_prefix}/lib")
SET (includedir "\${prefix}/include")
SET (GNUCXX_STD_SUPPORT_VERSION "4.3")

OPTION (MSGPACK_CXX11 "Using c++11 compiler" ON)
OPTION (MSGPACK_32BIT "32bit compile" OFF)
OPTION (MSGPACK_BOOST "Using boost libraries" ON)

SET (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
SET (CMAKE_CXX_FLAGS "-DMSGPACK_USE_BOOST ${CMAKE_CXX_FLAGS}")
SET (Boost_USE_STATIC_LIBS        ON) # only find static libs
SET (Boost_USE_MULTITHREADED      ON)
SET (Boost_USE_STATIC_RUNTIME    OFF)
FIND_PACKAGE (Boost COMPONENTS chrono timer system)
INCLUDE_DIRECTORIES (${MSGPACK_BOOST_DIR})

IF (MSGPACK_CHAR_SIGN)
   SET (CMAKE_C_FLAGS "-f${MSGPACK_CHAR_SIGN}-char ${CMAKE_C_FLAGS}")
   SET (CMAKE_CXX_FLAGS "-f${MSGPACK_CHAR_SIGN}-char ${CMAKE_CXX_FLAGS}")
ENDIF ()

IF (MSGPACK_DEFAULT_API_VERSION)
   SET (CMAKE_CXX_FLAGS "-DMSGPACK_DEFAULT_API_VERSION=${MSGPACK_DEFAULT_API_VERSION} ${CMAKE_CXX_FLAGS}")
ELSE ()
   SET (CMAKE_CXX_FLAGS "-DMSGPACK_DEFAULT_API_VERSION=2 ${CMAKE_CXX_FLAGS}")
ENDIF ()

FILE (GLOB_RECURSE PREDEF_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/external/boost/predef/include/boost ${CMAKE_CURRENT_SOURCE_DIR}/external/boost/predef/include/boost/*.h)
FOREACH (F ${PREDEF_FILES})
   SET(M "Converting ${F}")
   MESSAGE(STATUS ${M})
   FILE (READ ${CMAKE_CURRENT_SOURCE_DIR}/external/boost/predef/include/boost/${F} CONTENT)
   STRING(REPLACE "BOOST_" "MSGPACK_" CONTENT ${CONTENT})
   STRING(REPLACE "boost/" "msgpack/" CONTENT ${CONTENT})
   FILE (WRITE ${CMAKE_CURRENT_SOURCE_DIR}/include/msgpack/${F} ${CONTENT})
ENDFOREACH ()

FILE (GLOB_RECURSE PREPROCESSOR_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/external/boost/preprocessor/include/boost ${CMAKE_CURRENT_SOURCE_DIR}/external/boost/preprocessor/include/boost/*.hpp)
FOREACH (F ${PREPROCESSOR_FILES})
   SET(M "Converting ${F}")
   MESSAGE(STATUS ${M})
   FILE (READ ${CMAKE_CURRENT_SOURCE_DIR}/external/boost/preprocessor/include/boost/${F} CONTENT)
   STRING(REPLACE "BOOST_" "MSGPACK_" CONTENT ${CONTENT})
   STRING(REPLACE "boost/" "msgpack/" CONTENT ${CONTENT})
   FILE (WRITE ${CMAKE_CURRENT_SOURCE_DIR}/include/msgpack/${F} ${CONTENT})
ENDFOREACH ()

FIND_PACKAGE (GTest)
FIND_PACKAGE (ZLIB)
FIND_PACKAGE (Threads)
OPTION (MSGPACK_BUILD_TESTS "Build msgpack tests." OFF)
OPTION (MSGPACK_BUILD_EXAMPLES "Build msgpack examples." OFF)
OPTION (MSGPACK_ENABLE_CXX "Enable C++ interface." ON)
OPTION (MSGPACK_ENABLE_SHARED "Build shared libaries in addition to static libraries." ON)

INCLUDE (CheckCXXSourceCompiles)
CHECK_CXX_SOURCE_COMPILES ("
#include <bits/atomicity.h>
int atomic_sub(int i) { return __gnu_cxx::__exchange_and_add(&i, -1) - 1; }
int atomic_add(int i) { return __gnu_cxx::__exchange_and_add(&i, 1) + 1; }
int main(int argc, char * argv[])
{
    atomic_sub(1);
    atomic_add(1);
}
" MSGPACK_ENABLE_GCC_CXX_ATOMIC)

INCLUDE (Files.cmake)

EXECUTE_PROCESS (
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/src/msgpack
)

CONFIGURE_FILE (
    msgpack.pc.in
    msgpack.pc
    @ONLY
)

INCLUDE_DIRECTORIES (
    ./
    include/
    ${CMAKE_CURRENT_BINARY_DIR}/include/
)

ADD_LIBRARY (msgpackc SHARED
        ${msgpackc_SOURCES}
        ${msgpackc_HEADERS})
ADD_LIBRARY (msgpackc-static STATIC
    ${msgpackc_SOURCES}
    ${msgpackc_HEADERS}
)

SET_TARGET_PROPERTIES (msgpackc-static PROPERTIES OUTPUT_NAME "msgpackc")
SET_TARGET_PROPERTIES (msgpackc PROPERTIES SOVERSION 2 VERSION 2.0.0)
SET (MSGPACK_INSTALLTARGETS msgpackc msgpackc-static)
include(GNUInstallDirs)
INSTALL (TARGETS ${MSGPACK_INSTALLTARGETS} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                                           LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                                           ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
INSTALL (DIRECTORY include DESTINATION ${CMAKE_INSTALL_PREFIX})
INSTALL (FILES ${CMAKE_CURRENT_BINARY_DIR}/msgpack.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

MESSAGE(STATUS "<<< Gentoo configuration >>>
Build type      ${CMAKE_BUILD_TYPE}
Install path    ${CMAKE_INSTALL_PREFIX}
Compiler flags:
C               ${CMAKE_C_FLAGS}
C++             ${CMAKE_CXX_FLAGS}
Linker flags:
Executable      ${CMAKE_EXE_LINKER_FLAGS}
Module          ${CMAKE_MODULE_LINKER_FLAGS}
Shared          ${CMAKE_SHARED_LINKER_FLAGS}\n")
