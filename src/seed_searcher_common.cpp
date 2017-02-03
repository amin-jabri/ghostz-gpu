/*
 * seed_searcher_common.cpp
 *
 *  Created on: 2014/05/13
 *      Author: shu
 */

#include "seed_searcher_common.h"

#include <stdint.h>

uint32_t SeedSearcherCommon::CalculateSeedPosition(
    uint32_t hashed_sequence_start, uint32_t hashed_sequence_length) {
  return hashed_sequence_start;
}
