# - Try to find glog
#
# The following variables are optionally searched for defaults
#  glog_ROOT_DIR:  Base directory where all glog components are found
#
# Once done this will define
#  glog_FOUND - System has glog
#  glog_INCLUDE_DIRS - The glog include directories
#  glog_LIBRARIES - The libraries needed to use glog

if(__find_glog)
	return()
endif()
set(__find_glog INCLUDED)

set(glog_ROOT_DIR "" CACHE PATH "Folder containing glog")

find_path(glog_INCLUDE_DIR "glog/logging.h"
	PATHS ${glog_ROOT_DIR}
	PATH_SUFFIXES include
	NO_DEFAULT_PATH)
find_path(glog_INCLUDE_DIR "glog/logging.h")

find_library(glog_LIBRARY NAMES "glog"
	PATHS ${glog_ROOT_DIR}
	PATH_SUFFIXES lib lib64
	NO_DEFAULT_PATH)
find_library(glog_LIBRARY NAMES "glog")

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set glog_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(glog FOUND_VAR glog_FOUND REQUIRED_VARS
	glog_LIBRARY glog_INCLUDE_DIR)

if(glog_FOUND)
	set(glog_LIBRARIES ${glog_LIBRARY})
	set(glog_INCLUDE_DIRS ${glog_INCLUDE_DIR})
endif()

mark_as_advanced(glog_INCLUDE_DIR glog_LIBRARY)
