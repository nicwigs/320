/**
 * @file main.c
 * Simple program to test the binary math functions.
 *
 * Notice: This file currently has memory leaks. You should
 * fix those leaks or you will find it hard to fix the memory
 * leaks in your functions.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "binarymath.h"

void test_inc(const char *a);
void test_negate(const char *a);
void test_add(const char *a, const char *b);
void test_sub(const char *a, const char *b);

int main()
{
    test_inc("0000000000");
    test_inc("10101111");
    test_inc("01");
    test_inc("11111");
    test_inc("00000000000011011010001111101010111111000110101111");
    test_inc("111");

    test_negate("000000000");
    test_negate("1110001");
    test_negate("0110101110111010101");
    test_negate("101");

    test_add("010001", "101");
    test_add("101010", "101");
    test_sub("010001", "101");
    return 0;
}

void test_inc(const char *a)
{
    char *b = inc(a);
    printf("inc(%s) = %s\n", a, b);
    free(b);
}


void test_negate(const char *a)
{
    char *b = negate(a);
    printf("negate(%s) = %s\n", a, b);
    free(b);
}

void test_add(const char *a, const char *b)
{
    char *c = add(a, b);
    printf("add(%s, %s) = %s\n", a, b, c);
    free(c);
}

void test_sub(const char *a, const char *b)
{
    char *c = sub(a, b);
    printf("sub(%s, %s) = %s\n", a, b, c);
    free(c);
}

