/**
 * @file
 * Simple main function designed to exercise and test bin2dec
 */

#include <stdio.h>
#include "bin2dec.h"

/*
 * Forward references
 */
void test_binary(const char *binary);

/**
 * Program main entry point 
 */
int main()
{
//    test_binary("0");
  //  test_binary("1");
 //   test_binary("1 1");
 //   test_binary("1 0 0 1");
 //   test_binary("1");
    test_binary("111111111111111111111111111111111");
 //   test_binary("11111111111111111111111111111111");
   // test_binary("01111111111111111111111111111111");
  //  test_binary("01111111111101111110111111111111");
   // test_binary("10");
  //  test_binary("100");
 //   test_binary("1000");
 //   test_binary("10000");
    test_binary("1000");
//
 //   test_binary("1abc1");
    test_binary("000001");
    return 0;
}

/**
 * A simple function that converts a binary number and displays the result
 */
void test_binary(const char *binary)
{
    printf("'%s' converts to %u\n", binary, bin2dec(binary));
}
