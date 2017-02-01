# - Try to find Sanitizers
#
# The following variables are optionally searched for defaults
#  Sanitizers_ROOT_DIR:  Base directory where all Sanitizers components are found
#
# Once done this will define
#  Sanitizers_FOUND - System has Sanitizers
#  Sanitizers_LIBRARIES - The libraries needed to use Sanitizers
#  Sanitizers_COMPILE_FLAGS - The compile flags needed to use Sanitizers
#  Sanitizers_LINK_FLAGS - The link flags needed to use Sanitizers

if(__find_sanitizers)
	return()
endif()
set(__find_sanitizers INCLUDED)

include(FindPackageHandleStandardArgs)

set(Sanitizers_ROOT_DIR "" CACHE PATH "Folder containing Sanitizers")

# Some important  compile and link flags
set(Sanitizers_tsan_COMPILE_FLAG ${Sanitizers_tsan_COMPILE_FLAG}
	"-fsanitize=thread -fPIE -O1 -g")
set(Sanitizers_tsan_LINK_FLAG ${Sanitizers_tsan_LINK_FLAG}
	"-fsanitize=thread -pie")
set(Sanitizers_asan_COMPILE_FLAG ${Sanitizers_asan_COMPILE_FLAG}
	"-fsanitize=address -fno-omit-frame-pointer")
set(Sanitizers_asan_LINK_FLAG ${Sanitizers_asan_LINK_FLAG}
	"-fsanitize=address -fno-omit-frame-pointer")
set(Sanitizers_lsan_COMPILE_FLAG ${Sanitizers_lsan_COMPILE_FLAG}
	"-fsanitize=leak")
set(Sanitizers_lsan_LINK_FLAG ${Sanitizers_lsan_LINK_FLAG}
	"-fsanitize=leak")
set(Sanitizers_ubsan_COMPILE_FLAG ${Sanitizers_ubsan_COMPILE_FLAG}
	"-fsanitize=undefined")
set(Sanitizers_ubsan_LINK_FLAG ${Sanitizers_ubsan_LINK_FLAG}
	"-fsanitize=undefined")

function(SET_SANITIZER_VARS _sanitizer)
	if(Sanitizers_${_sanitizer}_FOUND)
		set("Sanitizers_${_sanitizer}_LIBRARIES"
			${Sanitizers_${_sanitizer}_LIBRARY} PARENT_SCOPE)
		set("Sanitizers_${_sanitizer}_COMPILE_FLAGS"
			${Sanitizers_${sanitizer}_COMPILE_FLAG} PARENT_SCOPE)
		set("Sanitizers_${_sanitizer}_LINK_FLAGS"
			${Sanitizers_${_sanitizer}_LINK_FLAG} PARENT_SCOPE)
	endif()
	mark_as_advanced(Sanitizers_${_sanitizer}_LIBRARY
		Sanitizers_${_sanitizer}_COMPILE_FLAG
		Sanitizers_${_sanitizer}_LINK_FLAG)
endfunction()

foreach(component ${Sanitizers_FIND_COMPONENTS})
	# find the component library
	if(${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang" AND
			${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
		find_library(Sanitizers_${component}_LIBRARY
			NAMES clang_rt.${component}_osx clang_rt.${component}_osx_dynamic
			PATHS ${Sanitizers_ROOT_DIR}
			PATH_SUFFIXES lib lib64 lib/darwin
			NO_DEFAULT_PATH)
		find_library(Sanitizers_${component}_LIBRARY
			NAMES clang_rt.${component}_osx clang_rt.${component}_osx_dynamic)
	else()
		# LIST(APPEND CMAKE_FIND_LIBRARY_SUFFIXES ".so.0.0.0" ".so.1.0.0")
		find_library(Sanitizers_${component}_LIBRARY
			NAMES ${component}
			PATHS ${Sanitizers_ROOT_DIR}
			PATH_SUFFIXES lib lib64
			NO_DEFAULT_PATH)
		find_library(Sanitizers_${component}_LIBRARY NAMES ${component})
		# LIST(REMOVE_ITEM CMAKE_FIND_LIBRARY_SUFFIXES ".so.0.0.0" ".so.1.0.0")
	endif()

	# handle find package args
	find_package_handle_standard_args(Sanitizers_${component}
		FOUND_VAR Sanitizers_${component}_FOUND
		REQUIRED_VARS Sanitizers_${component}_LIBRARY)

	SET_SANITIZER_VARS(${component})
	if(Sanitizers_FIND_REQUIRED_${component})
		set(_Required_sanitizer_LIBS ${_Required_sanitizer_LIBS}
			Sanitizers_${component}_LIBRARY)
	endif()
endforeach()

# handle the QUIETLY and REQUIRED arguments and set Sanitizers_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(Sanitizers FOUND_VAR Sanitizers_FOUND
	REQUIRED_VARS ${_Required_sanitizer_LIBS}
	HANDLE_COMPONENTS)

if(Sanitizers_FOUND)
	foreach(component ${Sanitizers_FIND_COMPONENTS})
		if(Sanitizers_${component}_FOUND)
			set(Sanitizers_LIBRARIES ${Sanitizers_LIBRARIES}
				${Sanitizers_${component}_LIBRARY})
			set(Sanitizers_COMPILE_FLAGS
				"${Sanitizers_COMPILE_FLAGS} ${Sanitizers_${component}_COMPILE_FLAG}")
			set(Sanitizers_LINK_FLAGS
				"${Sanitizers_LINK_FLAGS} ${Sanitizers_${component}_LINK_FLAG}")
		endif()
	endforeach()
endif()
