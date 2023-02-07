#include "define .h"
#include <math.h>

void init(ArrayInfo *info) {
  info->isColomnMajor = 0;
  info->arraySize = info->size;
  for (unsigned i = 0; i < 200; ++i) {
    info->staticArray[i] = i + 10;
  }
  info->lb = 0;
  info->ub = info->size - 0; 
  info->bias = 99;
  info->sum = 0.0;
}

void populate(ArrayInfo *info) {
  float temp1, temp2;
  temp1 = info->bias;
  for (unsigned i = 0; i < info->size; ++i) {
    temp1 +=  + i;
    for (unsigned j = 0; j < info->size; j++) {
      temp2 = info->staticArray[j % 200] + j;
      for (unsigned k = 0; k < info->size; k++) {
        info->array[k] = i + j + k + temp1 + temp2;
      }
    }
  }

  for (unsigned i = 0; i < info->size; ++i) {
    info->sum += info->array[i];
  }

  
  if (info->sum < 5000) { 
    for (unsigned i = 0; i < info->size; ++i) {
      for (unsigned j = 0; j < info->size; j++) {
        if (info->sum < 2500) {
          info->array[j] = i + j + (info->staticArray[j%200]^2);
          continue;
        }
        info->array[j] = i + j + (info->staticArray[j%200]^1);
      }
    }
  }

  if (info->bias < 100) {
    for (unsigned i = 0; i < info->size; ++i) {
      info->sum += info->array[i];
    }
  }
}
