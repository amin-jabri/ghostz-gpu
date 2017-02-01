# - Try to find gflags
#
# The following variables are optionally searched for defaults
#  gflags_ROOT_DIR:  Base directory where all gflags components are found
#
# Once done this will define
#  gflags_FOUND - System has gflags
#  gflags_INCLUDE_DIRS - The gflags include directories
#  gflags_LIBRARIES - The libraries needed to use gflags

if(__find_gflags)
	return()
endif()
set(__find_gflags INCLUDED)

set(gflags_ROOT_DIR "" CACHE PATH "Folder containing gflags")

find_path(gflags_INCLUDE_DIR "gflags/gflags.h"
	PATHS ${gflags_ROOT_DIR}
	PATH_SUFFIXES include
	NO_DEFAULT_PATH)
find_path(gflags_INCLUDE_DIR "gflags/gflags.h")

find_library(gflags_LIBRARY NAMES "gflags"
	PATHS ${gflags_ROOT_DIR}
	PATH_SUFFIXES lib lib64
	NO_DEFAULT_PATH)
find_library(gflags_LIBRARY NAMES "gflags")

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set gflags_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(gflags FOUND_VAR gflags_FOUND
	REQUIRED_VARS gflags_LIBRARY gflags_INCLUDE_DIR)

if(gflags_FOUND)
	set(gflags_LIBRARIES ${gflags_LIBRARY})
	set(gflags_INCLUDE_DIRS ${gflags_INCLUDE_DIR})
endif()

mark_as_advanced(gflags_INCLUDE_DIR gflags_LIBRARY)
