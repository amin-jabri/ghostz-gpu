# - Try to find folly
#
# The following variables are optionally searched for defaults
#  folly_ROOT_DIR:  Base directory where all folly components are found
#
# Once done this will define
#  folly_FOUND - System has folly
#  folly_INCLUDE_DIRS - The folly include directories
#  folly_LIBRARIES - The libraries needed to use folly

if(__find_folly)
	return()
endif()
set(__find_folly INCLUDED)

set(folly_ROOT_DIR "" CACHE PATH "Folder containing folly")

find_path(folly_INCLUDE_DIR "folly/Portability.h"
	PATHS ${folly_ROOT_DIR}
	PATH_SUFFIXES include
	NO_DEFAULT_PATH)
find_path(folly_INCLUDE_DIR "folly/Portability.h")

find_library(folly_LIBRARY NAMES "folly"
	PATHS ${folly_ROOT_DIR}
	PATH_SUFFIXES lib lib64
	NO_DEFAULT_PATH)
find_library(folly_LIBRARY NAMES "folly")

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set folly_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(folly FOUND_VAR folly_FOUND REQUIRED_VARS
	folly_LIBRARY folly_INCLUDE_DIR)

if(folly_FOUND)
	set(folly_LIBRARIES ${folly_LIBRARY})
	set(folly_INCLUDE_DIRS ${folly_INCLUDE_DIR})
endif()

mark_as_advanced(folly_INCLUDE_DIR folly_LIBRARY)
