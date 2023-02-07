#include <stdio.h>
#include <stdlib.h>
#include "define .h"

ArrayInfo arrayInfo;

void allocate(ArrayInfo *info) {
  info->array = (float *) malloc(sizeof(float) * info->size);
}

void printLBUB(ArrayInfo *info) {
  printf ("LB %ld UB %ld\n", info->lb, info->ub);
}

void print(ArrayInfo *info) {
  printf ("Array is \n");
  for (unsigned i = 0; i < info->size; ++i) {
    printf (" %f ", info->array[i]);
  }
  printf ("\n Sum is %lf\n", info->sum);
}

int main() {
  int n;
  scanf("%d", &n);
  arrayInfo.size = n;
  allocate(&arrayInfo);
  init(&arrayInfo);
  populate(&arrayInfo);
  print(&arrayInfo);
  return 0;
}

