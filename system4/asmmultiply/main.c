/**
 * @file main.c
 * Simple program to test the assembly multiplication functions.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned int dumb_multiply(unsigned int a, unsigned int b);
unsigned int multiply(unsigned int a, unsigned int b);
int signed_multiply(int a, int b);

void test_dumb(unsigned int a, unsigned int b);
void test_multiply(unsigned int a, unsigned int b);
void test_signed(int a, int b);

int main()
{
	test_dumb(23, 37);
	test_dumb(0, 0);
	test_dumb(1000, 0);
	test_dumb(0, 1000);
	test_dumb(1000, 5);
	test_dumb(5, 1000);	
	
	printf("\n");
	
	test_multiply(5, 7);
	test_multiply(23, 37);
	test_multiply(0, 0);
	test_multiply(1000, 0);
	test_multiply(0, 1000);
	test_multiply(1000, 5);
	test_multiply(5, 1000);	
	
	printf("\n");
	
	test_signed(-3, -2);
	test_signed(3, 2);	
	test_signed(3, -2);	
	test_signed(-3, 2);	
	test_signed(-5, 7);
	test_signed(23, -37);
	test_signed(0, 0);
	test_signed(-1000, 0);
	test_signed(0, -1000);
	test_signed(-1000, 5);
	test_signed(-5, 1000);	
	test_signed(1000, -5);
	test_signed(5, -1000);	
	
	return 0;
}

void test_dumb(unsigned int a, unsigned int b)
{
	unsigned int product = dumb_multiply(a, b);
	printf("Dumb: %u x %u = %u / should be %u\n", a, b, product, a * b);
}


void test_multiply(unsigned int a, unsigned int b)
{
	unsigned int product = multiply(a, b);
	printf("Multiply: %u x %u = %u / should be %u\n", a, b, product, a * b);
}



void test_signed(int a, int b)
{
	int product = signed_multiply(a, b);
	printf("Signed Multiply: %d x %d = %d / should be %d\n", a, b, product, a * b);
}
