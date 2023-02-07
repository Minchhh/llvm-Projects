typedef struct {
  int size;
  int isColomnMajor;
  double sum;
  int arraySize;
  int staticArray[200];
  long lb;
  float *array;
  char arrayName[100];
  long ub;
  int bias;
} ArrayInfo;

void init(ArrayInfo *arrayInfo);

void populate(ArrayInfo *arrayInfo);
