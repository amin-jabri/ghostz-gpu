/*
 * translator_test.cpp
 *
 *  Created on: 2010/10/03
 *      Author: shu
 */

#include "translator.h"

#include <stdint.h>

#include <string>

#include <gtest/gtest.h>

#include "dna_sequence.h"
#include "protein_sequence.h"
#include "protein_type.h"
#include "sequence_type.h"

using namespace std;

TEST(TranslatorTest, translate) {
  DnaSequence seq0(string("test0"), string("GCCCGCCACCT"));
  ProteinType protein;
  Translator t;
  vector<ProteinSequence> proteins;

  t.Translate(seq0, proteins);
  EXPECT_EQ(string("ARH"), proteins[0].GetSequenceData());
  EXPECT_EQ(string("PAT"), proteins[1].GetSequenceData());
  EXPECT_EQ(string("PPP"), proteins[2].GetSequenceData());
  EXPECT_EQ(string("RWR"), proteins[3].GetSequenceData());
  EXPECT_EQ(string("GGG"), proteins[4].GetSequenceData());
  EXPECT_EQ(string("VAG"), proteins[5].GetSequenceData());

  DnaSequence seq1(string("test1"), string("GCCCGCCACC"));

  t.Translate(seq1, proteins);
  EXPECT_EQ(string("ARH"), proteins[0].GetSequenceData());
  EXPECT_EQ(string("PAT"), proteins[1].GetSequenceData());
  EXPECT_EQ(string("PP"), proteins[2].GetSequenceData());
  EXPECT_EQ(string("GGG"), proteins[3].GetSequenceData());
  EXPECT_EQ(string("VAG"), proteins[4].GetSequenceData());
  EXPECT_EQ(string("WR"), proteins[5].GetSequenceData());
}
