#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int max(int a, int b) {
    if (a >= b) return a;
    else return b;
}

long Greatest_Common_Divisor(int a, int b, int c) {
    int max_num=0;

    max_num = max(a, max(b, c));
    for(long i=max_num; i>1; i--) { // while(remainder != 0)
        if((a%i == 0) && (b%i == 0) && (c%i == 0)) 
        {
            return i;
            break;
        }
    }
}

long Lowest_Common_Multiple(int x, int y, int z) {
    long max,lcom, count, flag=0;
        if(x>=y && x>=z)
                max=x;
        else if(y>=x&&y>=z)
                max=y;
        else if(z>=x&&z>=y)
                max=z;
        for(count=1;flag==0;count++)
        {
                lcom=max*count;
                if(lcom%x==0 && lcom%y==0 && lcom%z==0)
                {
                        flag=1;
                }
        }
        return lcom;
}


int main(void)
{
    //srand(time(NULL));
    int array[198] = {30, 59, 84, 43, 57, 8, 92, 18, 84, 15, 90, 97, 48, 97, 91, 61, 60, 15, 71, 84, 9, 51, 91, 98, 72, 24, 1, 41, 5, 53, 59, 82, 94, 61, 38, 57, 55, 78, 56, 2, 69, 64, 91, 85, 98, 15, 11, 70, 20, 67, 66, 38, 10, 67, 27, 86, 81, 24, 49, 57, 86, 68, 32, 48, 3, 10, 84, 0, 64, 95, 53, 80, 76, 65, 15, 67, 24, 23, 56, 64, 28, 66, 82, 12, 36, 95, 36, 92, 36, 17, 28, 63, 51, 55, 70, 23, 16, 81, 16, 59, 78, 59, 45, 63, 98, 3, 35, 96, 98, 57, 8, 13, 32, 59, 95, 15, 96, 30, 24, 3, 66, 42, 5, 13, 3, 36, 47, 5, 1, 98, 89, 59, 86, 99, 75, 17, 30, 73, 81, 24, 19, 47, 68, 74, 53, 11, 9, 86, 57, 64, 38, 29, 38, 87, 82, 61, 67, 19, 57, 75, 68, 30, 90, 92, 67, 2, 66, 24, 80, 52, 90, 42, 76, 51, 21, 91, 87, 60, 97, 7, 44, 18, 78, 96, 97, 80, 58, 32, 31, 42, 70, 5, 95, 88, 41, 22, 58, 52};
    if(array == NULL) {
        printf("Memory not allocated\n");
        exit(0);
    }

    // for(int i=0; i<198; i++) {
    //     array[i] = rand() % 100;
    // }

    int j=0 , counter=0;
    long *gcd, *lcm;
    gcd = malloc(66 * sizeof(int));
    lcm = malloc(66 * sizeof(int));
    // Calculate gcd and lcm
    // for(int i=0; i<196; i=i+3) {
    //     // printf("i: %d\n", i);
    //     // printf("counter: %d \n", counter);
    //     gcd[counter] = Greatest_Common_Divisor(array[i],array[i+1],array[i+2]);
    //     counter++;
    // }

    counter = 0;
    for(int i=0; i<196; i=i+3) {
        lcm[counter] = Lowest_Common_Multiple(array[i],array[i+1],array[i+2]);
        counter++;
    }
    
    // printf("GCD array:  ");
    // for(int i=0; i<66; i++)
    //     printf("%ld ",gcd[i]);
    // printf("\n\n\n");

    printf("LCM array:  ");
    for(int i=0; i<66; i++)
        printf("%ld ",lcm[i]);
    printf("\n");

    //free(array);
    free(gcd);
    free(lcm);
    return 0;
}