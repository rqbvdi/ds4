#include <stdint.h>
#include <string.h>
#include "printf.h"


void print_line() {
    for (int i = 0; i < 20; ++i) {
        if (i & 0x1)
            printf("*");
        else
            printf("-");
    }
    printf("\n");
}


void step(int* count, int ws, const char* BACK) {
    for (int i = 0; i < ws; ++i)
        printf(" ");
    printf("###");
    for (int i = 0; i < (8 - 3 - ws); ++i)
        printf(" ");
    printf(" (%3d%%)", *count);
    printf("%s", BACK);
    *count = (*count) + 2;
}


void main(void)
{
    print_line();
    printf("It works!\n");
    print_line();
    printf("The following output is computed by code running on your CPU   :-)\n");

    int count = 0;
    //const char* BACK = "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b";
    const char* BACK = "\n";
    const int js[] = {0, 1, 2, 3, 4, 5, 4, 3, 2, 1};
    const int n = sizeof(js) / sizeof(int);
    for (int i = 0; i < 5; ++i)
        for (int j = 0; j < n; ++j)
            step(&count, js[j], BACK);
    step(&count, 1, "");
    printf("\n");
}
