/* C program to print hollow full pyramid pattern using numbers */
#include <stdio.h>
#include<stdlib.h>
int __ctt_error(int a, int b){
    if(a!=b){
        fprintf(stderr,"Signatures are not matching");
        exit(0);
    }
}

int main()
{
int i, j, n;
printf("Enter value of n : ");
scanf("%d", &n);
for(i = 1; i <= n; i++)
{
for(j = i; j < n; j++)
{
printf(" ");
}
for(j = 1; j <= i; j++)
{
if(j == 1 || i == n)
{
printf("%d ", j);
}
else
{
printf(" ");
}
}
for(j = 1; j < i; j++)
{
if(j == i-1 && j < n-1)
{
printf("%d", j+1);
}
else
{
printf(" ");
}
}
printf("\n");
}
return 0;
}