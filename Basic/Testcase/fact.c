#include<stdio.h>
#include<stdlib.h>
int __ctt_error(int a, int b){
    printf("%d %d\n", a,b);
    if(a!=b){
        fprintf(stderr,"Signatures are not matching");
        exit(0);
    }
}

int factorial(int n){
    if(n==0 || n == 1) 
    return 1;
    else
    return n*factorial(n-1);
}

int main(){
    printf("%d ",factorial(2));
    return 0;
}