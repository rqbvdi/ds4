#include <stdint.h>
#include <string.h>
#include "printf.h"
#include "sort.h"

void main(void)
{
    printf("----> "); // print stuff below this line, do not remove this line

    // Sortiere das Array "numbers" in aufsteigender Reihenfolge
    sort(numbers, size);

    // Gib die sortierten Zahlen durch Leerzeichen getrennt aus
    for (uint32_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }

    printf("\n"); // print stuff above this line, do not remove this line
}
