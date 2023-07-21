cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

project(wenet VERSION 0.1)

option(GRAPH_TOOLS "whether to build TLG graph tools" OFF)

set(CMAKE_VERBOSE_MAKEFILE OFF)

include(ExternalProject)
include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
get_filename_component(fc_base "fc_base" REALPATH BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
get_filename_component(BUILD "build" REALPATH BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(FETCHCONTENT_BASE_DIR ${fc_base})

# Keep the same with openfst, -fPIC or -fpic
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -pthread -fPIC")

# glog
FetchContent_Declare(glog
  URL      https://github.com/google/glog/archive/v0.5.0.zip
  URL_HASH SHA256=21bc744fb7f2fa701ee8db339ded7dce4f975d0d55837a97be7d46e8382dea5a
)
FetchContent_MakeAvailable(glog)
include_directories(${glog_SOURCE_DIR}/src ${glog_BINARY_DIR})

set(GFLAGS_BUILD_SHARED_LIBS ON CACHE BOOL "Build static libs" FORCE)
# gflags
FetchContent_Declare(gflags
  URL      https://github.com/gflags/gflags/archive/v2.2.2.zip
  URL_HASH SHA256=19713a36c9f32b33df59d1c79b4958434cb005b5b47dc5400a7a4b078111d9b5
)
FetchContent_MakeAvailable(gflags)
include_directories(${gflags_BINARY_DIR}/include)


# The original openfst uses GNU Build System to run configure and build.
# So, we use "OpenFST port for Windows" to build openfst with cmake in Windows.
# Openfst is compiled with glog/gflags to avoid log and flag conflicts with log and flags in wenet/libtorch.
# To build openfst with gflags and glog, we comment out some vars of {flags, log}.h and flags.cc.
set(HAVE_BIN ON CACHE BOOL "Build the fst binaries" FORCE)
set(HAVE_SCRIPT OFF CACHE BOOL "Build the fstscript" FORCE)
set(HAVE_COMPACT OFF CACHE BOOL "Build compact" FORCE)
set(HAVE_CONST OFF CACHE BOOL "Build const" FORCE)
set(HAVE_GRM OFF CACHE BOOL "Build grm" FORCE)
set(HAVE_FAR OFF CACHE BOOL "Build far" FORCE)
set(HAVE_PDT OFF CACHE BOOL "Build pdt" FORCE)
set(HAVE_MPDT OFF CACHE BOOL "Build mpdt" FORCE)
set(HAVE_LINEAR OFF CACHE BOOL "Build linear" FORCE)
set(HAVE_LOOKAHEAD OFF CACHE BOOL "Build lookahead" FORCE)
set(HAVE_NGRAM OFF CACHE BOOL "Build ngram" FORCE)
set(HAVE_SPECIAL OFF CACHE BOOL "Build special" FORCE)


# "OpenFST port for Windows" builds openfst with cmake for multiple platforms.
# Openfst is compiled with glog/gflags to avoid log and flag conflicts with log and flags in wenet/libtorch.
# To build openfst with gflags and glog, we comment out some vars of {flags, log}.h and flags.cc.
set(openfst_SOURCE_DIR ${fc_base}/openfst-src CACHE PATH "OpenFST source directory")
FetchContent_Declare(openfst
  URL           https://github.com/kkm000/openfst/archive/refs/tags/win/1.6.5.1.tar.gz
  URL_HASH      SHA256=02c49b559c3976a536876063369efc0e41ab374be1035918036474343877046e
  PATCH_COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/patch/openfst/CMakeLists.txt ${CMAKE_CURRENT_SOURCE_DIR}/patch/openfst/src ${openfst_SOURCE_DIR}
)
FetchContent_MakeAvailable(openfst)
add_dependencies(fst gflags glog)
target_link_libraries(fst PUBLIC gflags_nothreads_shared glog)
