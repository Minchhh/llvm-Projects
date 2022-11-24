#include <stdio.h>
#include<stdlib.h>
int __ctt_error(int a, int b){
    if(a!=b){
        fprintf(stderr,"Signatures are not matching");
        exit(0);
    }
}

int main() {
for(int i=0; i < 5; i++) 
    printf("Hi\n");
  return 0;
}