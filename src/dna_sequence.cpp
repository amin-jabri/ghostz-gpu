/*
 * DnaSequence.cpp
 *
 *  Created on: 2011/04/11
 *      Author: shu
 */

#include "dna_sequence.h"

#include <stdint.h>

#include <algorithm>
#include <map>
#include <sstream>
#include <string>

using namespace std;

string DnaSequence::GetComplementaryStrand(const string &dna) {
  string new_sequence(dna);
  reverse(new_sequence.begin(), new_sequence.end());
  transform(new_sequence.begin(), new_sequence.end(), new_sequence.begin(),
            ToComplementaryLetter());
  return new_sequence;
}

string DnaSequence::GetComplementaryStrand() const {
  return DnaSequence::GetComplementaryStrand(GetSequenceData());
}
