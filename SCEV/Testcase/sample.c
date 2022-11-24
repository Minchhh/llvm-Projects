#include <stdio.h>
int main()
{
    int n = 4;
    int A[n];
    int c = 10;
    for (int i = 0; i < n; i += 4)
    {

        A[i + 2] = c + i + 2; 
        A[i + 1] = c + i + 1;
        A[i + 3] = c + i + 3;
        A[i] = c + i;
    }
    for (int i = 0; i < n; i++)
    {
        printf("%d\n", A[i]);
    }
    return 0;
}
