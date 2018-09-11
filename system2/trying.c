#include<stdio.h>

int main(){
  unsigned char m;
  m = 0x69;
  m |= 1 << 2;
  printf(" %02x\n",m);
  printf("the char is %c",m);
  return 0;
}
