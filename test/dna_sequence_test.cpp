/*
 * dna_seuqence_test.cpp
 *
 *  Created on: 2010/09/12
 *      Author: shu
 */

#include "dna_sequence.h"

#include <stdint.h>

#include <string>

#include <gtest/gtest.h>

#include "sequence.h"

using namespace std;

TEST(DnaSequneceTest, GetComplementaryStrand) {
  string seq(
      "GCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTATGAAAGGTGCTTATTGTCCTCTGAAT"
      "GAT");
  DnaSequence dna(string("test"), seq);

  string comp_seq(
      "ATCATTCAGAGGACAATAAGCACCTTTCATAGCAGCAGCAGCAGCAGCAGCAGCAGCAGCAGCAGCAGCAGC"
      "AGC");
  EXPECT_EQ(comp_seq, dna.GetComplementaryStrand());
}
