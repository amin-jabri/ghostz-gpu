/*
 * reduced_alphabet_file_reader.cpp
 *
 *  Created on: 2012/11/28
 *      Author: shu
 */

#include "reduced_alphabet_file_reader.h"

#include <limits.h>

#include <string>
#include <vector>

bool ReducedAlphabetFileReader::Read(std::istream &in,
                                     std::vector<std::string> &alphabet_sets) {
  alphabet_sets.resize(0);
  std::string::size_type index;
  std::string line;
  std::getline(in, line);
  std::string delim = " ";
  std::string alphabet_set = "";
  index = line.find_first_of(delim);
  while (index != std::string::npos) {
    if (index > 0) {
      alphabet_set = line.substr(0, index);
      alphabet_sets.push_back(alphabet_set);
    }
    line = line.substr(index + 1);
    index = line.find_first_of(delim);
  }
  if (line.length() > 0) {
    alphabet_set = line;
    alphabet_sets.push_back(alphabet_set);
  }
  return true;
}
