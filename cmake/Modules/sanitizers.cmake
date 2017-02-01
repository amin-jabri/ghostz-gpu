if(__sanitizers)
	return()
endif()
set(__sanitizers INCLUDED)

option(USE_TSAN "Using thread sanitizer" off)
option(USE_ASAN "Using address sanitizer. Conatains Leak sanitizer." off)
option(USE_UBSAN "Using undefined behaviour sanitizer" off)
option(USE_LSAN "Using Leak sanitizer as standalone" off)

set(Sanitizers_ROOT_DIR "" CACHE PATH "Folder containing Sanitizers")

#
# add_sanitizers(<target>)
#
# adds compile and link flags needed to build an instrumented version of <target>
# using the enabled sanitizers through the options:
# USE_TSAN, USE_ASAN, USE_UBSAN, USE_LSAN
#
function(add_sanitizers target)
	#use thread sanitizer
	if(USE_TSAN)
		set(_sanitizers ${_sanitizers} "tsan")
	endif()
	#use address sanitizer or leak sanitizer in standalone
	if(USE_ASAN)
		set(_sanitizers ${_sanitizers} "asan")
	elseif(USE_LSAN)
		set(_sanitizers ${_sanitizers} "lsan")
	endif()
	#use undefined behavior sanitizer
	if(USE_UBSAN)
		set(_sanitizers ${_sanitizers} "ubsan")
	endif()

	if(USE_TSAN OR USE_ASAN OR USE_UBSAN OR USE_LSAN)
		find_package(Sanitizers REQUIRED
			COMPONENTS ${_sanitizers})
		set_target_properties(${target} PROPERTIES
			COMPILE_FLAGS ${Sanitizers_COMPILE_FLAGS}
			LINK_FLAGS ${Sanitizers_LINK_FLAGS})
		target_link_libraries(${target} ${Sanitizers_LIBRARIES})
	endif()
endfunction()
