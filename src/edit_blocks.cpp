/*
 * edit_array.cpp
 *
 *  Created on: 2010/11/28
 *      Author: shu
 */

#include "edit_blocks.h"

#include <algorithm>

void EditBlocks::Clear() { blocks_.clear(); }

void EditBlocks::Add(EditBlocks::EditOpType op_type, int length) {
  if (length == 0) {
    return;
  } else if (!blocks_.empty() && blocks_.rbegin()->op == op_type) {
    blocks_.rbegin()->length += length;
  } else {
    Block b;
    b.op = op_type;
    b.length = length;
    blocks_.push_back(b);
  }
}

void EditBlocks::Add(EditBlocks other) {
  for (std::vector<Block>::iterator it = other.blocks_.begin();
       it != other.blocks_.end(); ++it) {
    Add(it->op, it->length);
  }
}

void EditBlocks::Reverse() { reverse(blocks_.begin(), blocks_.end()); }

std::vector<EditBlocks::EditOpType> EditBlocks::ToVector() {
  std::vector<EditOpType> v;
  for (std::vector<Block>::iterator it = blocks_.begin(); it != blocks_.end();
       ++it) {
    for (int i = 0; i < it->length; ++i) {
      v.push_back(it->op);
    }
  }
  return v;
}
