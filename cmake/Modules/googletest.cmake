if(__googletest)
	return()
endif()
set(__googletest INCLUDED)

# adding googlemock/googletest to our build
include(AddGoogletest)

# emulate GNU Autotools 'make check'
set(googletest_ctest_CMD check)

add_custom_target(${googletest_ctest_CMD} COMMAND
  ${CMAKE_CTEST_COMMAND} WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

option(RUN_UNIT_TESTS_AFTER_BUILD
	"Run unit-tests after they are built. Build stops after a test failure" OFF)

#
# add_gmock_test(<target> <sources>...)
#
#  Adds a Google Mock based test executable, <target>, built from <sources> and
#  adds the test so that CTest will run it. Both the executable and the test
#  will be named <target>.
#
function(add_gmock_test target)
	add_executable(${target} ${ARGN})
  set_gmock_target_properties(${target})
endfunction()

#
# cuda_add_gmock_test(<target> <sources>...)
#
#  Adds a Google Mock based test executable, <target>, built from <sources> and
#  adds the test so that CTest will run it. Both the executable and the test
#  will be named <target>.
#
function(cuda_add_gmock_test target)
	cuda_add_executable(${target} ${ARGN})
  set_gmock_target_properties(${target})
endfunction()

function(set_gmock_target_properties target)
	set_target_properties(${target} PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/test"
		LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/test"
		RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/test")
  target_link_libraries(${target} googletest_LIB)
	add_test(NAME ${target} COMMAND ${target})
  add_dependencies(${googletest_ctest_CMD} ${target})

	if(${RUN_UNIT_TESTS_AFTER_BUILD})
		# run each tests after each time it is built
		# if the test fails, the build stops. Test is not run if
		# we immediately build again
		add_custom_command(TARGET ${target}
			POST_BUILD
			COMMAND ${target}
			COMMENT "Running ${target}" VERBATIM)
	endif()
endfunction()
