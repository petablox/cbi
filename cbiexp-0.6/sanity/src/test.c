#include <stdlib.h>
#include <stdio.h>
void main () {
	int i;
	int * ptr = 0;
	int k;
	scanf("%d", &k);
	if (k == 0) *ptr = 0;
	for (i = 0; i < 100; i++) { 
		if (i % 50 == 0) printf("%d\n", i);
	}
exit(0);
}
