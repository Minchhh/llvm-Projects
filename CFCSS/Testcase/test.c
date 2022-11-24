#include<stdio.h>
#include<stdlib.h>
int __ctt_error(int a, int b){
    if(a!=b){
        fprintf(stderr,"Signatures are not matching");
        exit(0);
    }
}
#include<stdio.h>
int main()
{
	int num=1;
	if(num<10)
	{
		if(num==1)
		{
			printf("The value is:%d\n",num);
		}
		else
		{
			printf("The value is greater than 1");
		}
	}
	else
	{
		printf("The value is greater than 10");
	}
	return 0;
}

