#include "bin2dec.h"
/**
  *Convert a binary number to an unsigned integer
  *
  *Unexpected characters are ignored. Only 1's and 0's are
  *considered to be valid.
  *
  *'a10c1' should convert to 5
  *
  *@param binary Binary number as a string of '1's and '0's.
  *@returns unsigned int result
  */
unsigned int bin2dec(const char *binary)
{
  int dec = 0;
  while(*binary != '\0'){
    if(*binary == '1' || *binary == '0'){
      dec = (dec + *binary - '0')*2;
    }
    binary++;
  }
  dec /= 2;
  return dec;
}
