if(__add_googletest)
  return()
endif()
set(__add_googletest INCLUDED)

# Enable ExternalProject module
include(ExternalProject)

set(GoogleTest_PREFIX "${CMAKE_BINARY_DIR}/third-party")
set(GoogleTest_URL_DIR "${CMAKE_SOURCE_DIR}/third-party/googletest")
set(GoogleTest_CMAKE_ARGS)
# building gmock automatically builds gtest!
list(APPEND GoogleTest_CMAKE_ARGS
	"-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
  "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
  "-DCMAKE_BUILD_TYPE=Release"
  "-DBUILD_GTEST=off"
  "-DBUILD_GMOCK=on")

# Check whether the library was fetched as 3rd party git submodule
IF(NOT EXISTS "${GoogleTest_URL_DIR}/CMakeLists.txt")
  MESSAGE(FATAL_ERROR "third-party/googletest/CMakeLists.txt missing. "
                      "Try updating your submodule with:
rm -r third-party
git submodule update --init --recursive
")
ENDIF()

# set(GoogleTest_GIT_REPOSITORY "https://github.com/google/googletest.git")
# set(GoogleTest_GIT_TAG "release-1.7.0")

# Download and Install googletest
ExternalProject_Add(Googletest
  PREFIX "${GoogleTest_PREFIX}"
  # GIT_REPOSITORY "${GoogleTest_GIT_REPOSITORY}"
  # GIT_TAG "${GoogleTest_GIT_TAG}"
  URL "${GoogleTest_URL_DIR}"
  # disable updating source code
  UPDATE_COMMAND ""
  # configure googletest
  CONFIGURE_COMMAND "${CMAKE_COMMAND}" "${CMAKE_ARGS}"
  "${GoogleTest_CMAKE_ARGS}"
  "${GoogleTest_URL_DIR}"
  # Disable install
  INSTALL_COMMAND "")

# Set googletest-build properties
ExternalProject_Get_Property(Googletest source_dir binary_dir)

add_library(googletest_LIB STATIC IMPORTED GLOBAL)
add_dependencies(googletest_LIB Googletest)

# add threads
find_package(Threads REQUIRED)

set_target_properties(googletest_LIB PROPERTIES
  IMPORTED_LOCATION "${binary_dir}/googlemock/libgmock_main.a"
  INTERFACE_LINK_LIBRARIES "${CMAKE_THREAD_LIBS_INIT}")


include_directories(SYSTEM "${source_dir}/googletest/include"
  "${source_dir}/googlemock/include")
include_directories("${source_dir}/googletest"
  "${source_dir}/googlemock")
