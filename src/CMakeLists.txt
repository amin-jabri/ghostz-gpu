set(GHOSTZ_CORE_LIB_CPU ghostz-core-cpu)

set(GHOSTZ_CORE_LIB_GPU ghostz-core-gpu)

# Extra lib: libm libkarlin libseg and boost
set(${PROJECT_NAME}_EXTRA_LIBRARY
  m
  karlin
  seg
  boost-system
  boost-thread
  )

cuda_add_executable(${${PROJECT_NAME}_EXECUTABLE_NAME}
  main.cpp
  align_main.cpp
  database_build_main.cpp
  )

set_target_properties(${${PROJECT_NAME}_EXECUTABLE_NAME} PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

if(${${PROJECT_NAME}_USE_GPU})
  target_compile_definitions(${${PROJECT_NAME}_EXECUTABLE_NAME} PRIVATE GPU)
endif()

add_library(${GHOSTZ_CORE_LIB_CPU}
  aligner.cpp
  aligner_build_results_thread.cpp
  aligner_common.cpp
  aligner_gpu.cpp
  aligner_gpu_presearch_thread.cpp
  aligner_presearch_thread.cpp
  alphabet_coder.cpp
  chain_filter.cpp
  database.cpp
  database_chunk.cpp
  distance_calculation_seed_list.cpp
  distance_calculator.cpp
  dna_sequence.cpp
  dna_type.cpp
  edit_blocks.cpp
  extension_seed_list.cpp
  fasta_sequence_reader.cpp
  gapped_extender.cpp
  gpu_stream_controller.cpp
  gpu_stream_runner.cpp
  host_seeds_memory.cpp
  k_mer_sequences_index.cpp
  one_mismatch_hash_generator.cpp
  protein_query.cpp
  protein_sequence.cpp
  protein_type.cpp
  queries.cpp
  query.cpp
  reduced_alphabet_coder.cpp
  reduced_alphabet_file_reader.cpp
  reduced_alphabet_k_mer_hash_function.cpp
  reduced_alphabet_variable_hash_function.cpp
  score_matrix.cpp
  score_matrix_reader.cpp
  seed_searcher.cpp
  seed_searcher_common.cpp
  seed_searcher_database_parameters.cpp
  seed_searcher_gpu.cpp
  seed_searcher_gpu_query_parameters.cpp
  seed_searcher_query_parameters.cpp
  sequence.cpp
  sequence_no_filter.cpp
  sequence_seg_filter.cpp
  sequence_type.cpp
  statistics.cpp
  translated_dna_query.cpp
  translator.cpp
  ungapped_extender.cpp
  ungapped_extension_with_trigger_seed_list.cpp
  variable_hash_clustering_seuences_index.cpp
  variable_hash_sequences_index.cpp
  )
add_library(ghostz::core-cpu ALIAS ${GHOSTZ_CORE_LIB_CPU})

set_target_properties(${GHOSTZ_CORE_LIB_CPU} PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

if(${${PROJECT_NAME}_USE_GPU})
  target_compile_definitions(${GHOSTZ_CORE_LIB_CPU} PUBLIC GPU)
endif()

target_link_libraries(${GHOSTZ_CORE_LIB_CPU}
  INTERFACE ${${PROJECT_NAME}_EXTRA_LIBRARY}
  )

# Include cub-1.3.2
cuda_include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../ext/cub-1.3.2)

cuda_compile(GHOSTZ_GPU_OBJ
  aligner_gpu_data.cu
  device_seeds_memory.cu
  distance_calculator_gpu.cu
  distance_calculator_gpu_ref_kernel.cu
  gapped_extender_gpu.cu
  gapped_extender_gpu_ref_kernel.cu
  packed_alphabet_code.cu
  ungapped_extender_gpu.cu
  ungapped_extender_gpu_kernel.cu
  )

cuda_add_library(${GHOSTZ_CORE_LIB_GPU} ${GHOSTZ_GPU_OBJ})
add_library(ghostz::core-gpu ALIAS ${GHOSTZ_CORE_LIB_GPU})

set_target_properties(${GHOSTZ_CORE_LIB_GPU} PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

target_link_libraries(${${PROJECT_NAME}_EXECUTABLE_NAME}
  ghostz::core-cpu
  ghostz::core-gpu
  )
