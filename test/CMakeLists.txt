# add googletest
include(googletest)

# Include cub-1.3.2
cuda_include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../ext/cub-1.3.2)
cuda_include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../src)

cuda_compile(GHOSTZ_TEST_GPU_OBJ
  distance_calculator_gpu_test.cu
  gapped_extender_gpu_test.cu
  group_loader_test.cu
  packed_alphabet_code_test.cu # Need to fix warnings.
  ungapped_extender_gpu_test.cu
  )

cuda_add_gmock_test(ghostz-gpu_test
  ${GHOSTZ_TEST_GPU_OBJ}
  chain_filter_test.cpp
  database_test.cpp
  distance_calculation_seed_list_test.cpp
  distance_calculator_test.cpp
  dna_sequence_test.cpp
  gapped_extender_test.cpp
  one_mismatch_hash_generator_test.cpp
  perfect_hash_inverted_index_test.cpp
  reduced_alphabet_coder_test.cpp
  reduced_alphabet_file_reader_test.cpp
  reduced_alphabet_k_mer_hash_function_test.cpp
  reduced_alphabet_variable_hash_function_test.cpp
  score_matrix_test.cpp
  seed_searcher_common_test.cpp
  sequence_reader_test.cpp
  translated_dna_query_test.cpp
  translator_test.cpp
  ungapped_extender_test.cpp
  )

target_include_directories(ghostz-gpu_test
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../src
  )

target_link_libraries(ghostz-gpu_test
  ghostz::core-cpu
  ghostz::core-gpu
  )
