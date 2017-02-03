/*
 * score_matrix_reader.cpp
 *
 *  Created on: 2010/06/22
 *      Author: shu
 */

#include "score_matrix_reader.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <fstream>
#include <iostream>
#include <list>
#include <sstream>
#include <stdexcept>
#include <string>

#include "alphabet_coder.h"
#include "score_matrix.h"
#include "sequence.h"
#include "sequence_type.h"

void ScoreMatrixReader::Read(std::istream &in, SequenceType &type,
                             std::vector<int> &matrix,
                             uint32_t &number_letters) {
  AlphabetCoder coder(type);
  int matrix_size = GetMatrixSize(coder);
  matrix.resize(matrix_size);
  Parse(in, coder, &matrix[0]);
  number_letters = GetNumberLetters(coder);
}

std::list<std::string> ScoreMatrixReader::Split(std::string str,
                                                std::string delim) {
  std::list<std::string> result;
  std::string::size_type index;
  index = str.find_first_of(delim);
  while (index != std::string::npos) {
    if (index > 0) {
      result.push_back(str.substr(0, index));
    }
    str = str.substr(index + 1);
    index = str.find_first_of(delim);
  }
  if (str.length() > 0) {
    result.push_back(str);
  }
  return result;
}

int ScoreMatrixReader::GetNumberLetters(const AlphabetCoder &coder) {
  return coder.GetMaxCode() + 1;
}

int ScoreMatrixReader::GetMatrixSize(const AlphabetCoder &coder) {
  int number_letters = GetNumberLetters(coder);
  return number_letters * number_letters;
}

void ScoreMatrixReader::Parse(std::istream &in, const AlphabetCoder &coder,
                              int *matrix) {
  int number_letters = GetNumberLetters(coder);
  int matrix_size = GetMatrixSize(coder);
  std::string line;
  int line_number = 0;
  const unsigned int max_heading_size = 1024;
  char column_headings[max_heading_size];
  char row_headings[max_heading_size];
  for (int i = 0; i < matrix_size; ++i) {
    matrix[i] = 0;
  }

  while (!in.eof()) {
    std::getline(in, line);
    if (line[0] != '\0' && line[0] != '#') {
      assert((unsigned int)line_number <= max_heading_size + 1);
      std::list<std::string> str_list = Split(line, " ");
      assert(str_list.size() <= max_heading_size);
      int i = 0;
      for (std::list<std::string>::iterator it = str_list.begin();
           it != str_list.end(); ++it, ++i) {
        if (line_number == 0) {
          column_headings[i] = it->c_str()[0];
        } else if (i == 0) {
          row_headings[line_number - 1] = it->c_str()[0];
        } else {
          int value = atoi(it->c_str());
          if (!coder.IsUnknown(row_headings[line_number - 1]) &&
              !coder.IsUnknown(column_headings[i - 1])) {
            matrix[coder.Encode(row_headings[line_number - 1]) *
                       number_letters +
                   coder.Encode(column_headings[i - 1])] = value;
          }
        }
      }
      ++line_number;
    }
  }
}
