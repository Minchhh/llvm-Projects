#include<stdio.h>
#include<stdlib.h>
printf("%d,%d\n"a,b);
int __ctt_error(int a, int b){
    if(a!=b){
        fprintf(stderr,"Signatures are not matching");
        exit(0);
    }
}

int main ()
{
  int num1, num2;
  num1=12,num2=13;

  if (num1 == num2)
    printf("both are equal");
  else if (num1 > num2) 
    printf("%d is greater", num1);
  else
    printf("%d is greater", num2);

  return 0;
}