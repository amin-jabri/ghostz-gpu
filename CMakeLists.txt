cmake_minimum_required (VERSION 2.8 FATAL_ERROR)

# "C" is required for find_package(Threads)
project("Ghostz" CXX C)

# generate compile flags database to use with YCM
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

# Project Options
option(${PROJECT_NAME}_ENABLE_UNIT_TESTS "Enable unit-tests." OFF)

option(${PROJECT_NAME}_USE_GPU "Use GPU" ON)

# Add cuda package
find_package(CUDA 6.0 REQUIRED)
set(CUDA_PROPAGATE_HOST_FLAGS OFF)
set(CUDA_SEPARABLE_COMPILATION OFF)
set(CUDA_USE_STATIC_CUDA_RUNTIME ON)

if (${${PROJECT_NAME}_USE_GPU})
  set(${PROJECT_NAME}_EXECUTABLE_NAME "ghostz-gpu")
  set(${PROJECT_NAME}_GPU_COMPUTE_CAPABILITY "35"
        CACHE STRING "CUDA Compute Capability of the target GPU.")
  add_definitions(-DGPU)
  set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -gencode
    arch=compute_${${PROJECT_NAME}_GPU_COMPUTE_CAPABILITY},code=sm_${${PROJECT_NAME}_GPU_COMPUTE_CAPABILITY})
else()
  set(${PROJECT_NAME}_EXECUTABLE_NAME "ghostz")
  unset(${PROJECT_NAME}_GPU_COMPUTE_CAPABILITY CACHE)
endif()

# add our modules to the search path of cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

include(CheckCXXCompilerFlag)
# add AddCXXCompilerFlag module (from google's Benchmark)  under cmake/Modules
include(AddCXXCompilerFlag)

# compiler flags used during all build type
add_cxx_compiler_flag(-std=c++11)
if(NOT HAVE_CXX_FLAG_STD_CXX11)
  add_cxx_compiler_flag(-std=c++0x)
endif()
# add_cxx_compiler_flag(-fPIC)
# add_cxx_compiler_flag(-Wall)
# add_cxx_compiler_flag(-Wextra)
# add_cxx_compiler_flag(-pedantic)
# add_cxx_compiler_flag(-pedantic-errors)
# add_cxx_compiler_flag(-Wshadow)
# add_cxx_compiler_flag(-Wconversion)
# add_cxx_compiler_flag(-Wshorten-64-to-32)
# add_cxx_compiler_flag(-Werror RELEASE)
# add_cxx_compiler_flag(-fmessage-length=0)
# add_cxx_compiler_flag(-fstrict-aliasing)
# if(HAVE_CXX_FLAG_FSTRICT_ALIASING)
#   add_cxx_compiler_flag(-Wstrict-aliasing)
# endif()
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  # add_cxx_compiler_flag(-Wabi)
  add_cxx_compiler_flag(-fdiagnostics-color=always)
endif()

if(NOT CONFIGURED_ONCE)
  # Cache all build modes flags
  set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}
    CACHE STRING "Flags used by the compiler during all build types." FORCE)
  set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS}
    CACHE STRING "Flags used by the compiler during all build types." FORCE)
  # Cache debug mode build flags
  set(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG}
    CACHE STRING "Flags used by the compiler during debug builds." FORCE)
  set(CMAKE_C_FLAGS_DEBUG ${CMAKE_C_FLAGS_DEBUG}
    CACHE STRING "Flags used by the compiler during debug builds." FORCE)
  # Cache release mode build flags
  set(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE}
    CACHE STRING "Flags used by the compiler during release builds." FORCE)
  set(CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE}
    CACHE STRING "Flags used by the compiler during release builds." FORCE)
  # Cache all build modes NVCC_FLAGS
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}
  CACHE STRING "Flags used by the compiler during all build types." FORCE)
endif()

# Set build type to debug mode if CMAKE_BUILD_TYPE is not set
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug" CACHE STRING
    "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
    FORCE)
endif()

include(sanitizers)

# ext/karlin
add_library(karlin ${CMAKE_SOURCE_DIR}/ext/karlin/src/karlin.c)
set_target_properties(karlin PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
add_sanitizers(karlin)

# ext/seg
add_library(seg ${CMAKE_SOURCE_DIR}/ext/seg/src/seg.cpp)
set_target_properties(seg PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
add_sanitizers(seg)

# src
add_subdirectory(${CMAKE_SOURCE_DIR}/src)

if(${PROJECT_NAME}_ENABLE_UNIT_TESTS)
  enable_testing()
  # unit tests with googletest/googlemock
  # tests are not built with 'make' or 'make all', use 'make check' instead
  add_subdirectory(${CMAKE_SOURCE_DIR}/test EXCLUDE_FROM_ALL)
endif()

set(CONFIGURED_ONCE TRUE CACHE INTERNAL
  "A flag showing that CMake has configured at least once.")

# Copy data dir to the binary tree to be used when testing the executable
file(COPY ${CMAKE_SOURCE_DIR}/data DESTINATION ${CMAKE_BINARY_DIR})
