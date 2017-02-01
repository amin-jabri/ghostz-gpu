# Add sanitizers support if any
include(sanitizers)

# Extra lib: libm libkarlin libseg
set(EXTRA_LIBRARY m karlin seg)

# Add CU source files
file(GLOB GHOSTZ_CU_SRCS *.cu)

# Add CPP source files
file(GLOB GHOSTZ_CPP_SRCS *.cpp)
set(MAIN_SRCS main.cpp
              align_main.cpp
              database_build_main.cpp)
list(REMOVE_ITEM GHOSTZ_CPP_SRCS
              ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
              ${CMAKE_CURRENT_SOURCE_DIR}/align_main.cpp
              ${CMAKE_CURRENT_SOURCE_DIR}/database_build_main.cpp)

# Add Boost
find_package(Boost 1.55 REQUIRED COMPONENTS system thread)
include_directories(${Boost_INCLUDE_DIRS})
set(EXTRA_LIBRARY ${EXTRA_LIBRARY} ${Boost_LIBRARIES})

add_library(Ghostz_cpu STATIC ${GHOSTZ_CPP_SRCS})
set_target_properties(Ghostz_cpu PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
add_sanitizers(Ghostz_cpu)
target_link_libraries(Ghostz_cpu ${EXTRA_LIBRARY})

# Include cub-1.3.2
cuda_include_directories(${CMAKE_SOURCE_DIR}/ext/cub-1.3.2)

cuda_compile(GHOSTZ_GPU_OBJ ${GHOSTZ_CU_SRCS} STATIC)
cuda_add_library(Ghostz_gpu ${GHOSTZ_GPU_OBJ} STATIC)
set_target_properties(Ghostz_gpu PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
add_sanitizers(Ghostz_gpu)

cuda_add_executable(${${PROJECT_NAME}_EXECUTABLE_NAME} ${MAIN_SRCS})
set_target_properties(${${PROJECT_NAME}_EXECUTABLE_NAME} PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
add_sanitizers(${${PROJECT_NAME}_EXECUTABLE_NAME})

target_link_libraries(${${PROJECT_NAME}_EXECUTABLE_NAME} Ghostz_cpu Ghostz_gpu)
