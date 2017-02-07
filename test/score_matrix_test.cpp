/*
 * score_matrix_test.cpp
 *
 *  Created on: 2010/09/12
 *      Author: shu
 */

#include "score_matrix.h"

#include <stdint.h>

#include <fstream>
#include <string>

#include <gtest/gtest.h>

#include "alphabet_coder.h"
#include "dna_type.h"
#include "protein_type.h"
#include "score_matrix_reader.h"
#include "sequence_type.h"

using namespace std;

TEST(ScoreMatrixTest, ReadingFile) {
  DnaType type;
  ScoreMatrixReader reader;
  ifstream in("./test/DNA");
  vector<int> matrix;
  uint32_t number_letters;
  reader.Read(in, type, matrix, number_letters);
  EXPECT_EQ(5, number_letters);
  for (uint32_t i = 0; i < number_letters - 1; ++i) {
    for (uint32_t j = 0; j < number_letters - 1; ++j) {
      if (i == j) {
        EXPECT_EQ(1, matrix[number_letters * i + j]);
      } else {
        EXPECT_EQ(-3, matrix[number_letters * i + j]);
      }
    }
  }
}
