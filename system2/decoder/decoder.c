#include "decoder.h"
/**
  *Right shift bit into byte of decoded string.
  *@param decoded The output string we produce
  *@param bit The total bit count thus far
  */
void setBit(char * decoded, int* bit){
    decoded[*bit/8] |= 0x80 >> (*bit%8);
    (*bit)++; //update bit value
}
/**
 * Decode an encoded string into a character stream.
 * @param encoded The input string we are decoding
 * @param decoded The output string we produce
 * @param maxLen The maximum size for decoded
 */
void decoder(const char *encoded, char *decoded, int maxLen)
{
    //set inital to all 0's
    int i;
    for (i = 0; i < maxLen; i++){
        decoded[i] = 0;
    }
    decoded[maxLen] = '\0';

    int bit = 0; 

    while(*encoded && (bit+1)/8 < maxLen){
      if(bit/8 == maxLen - 1 && bit%8 == 6 && (*encoded != 'q' && *encoded !=
            'S' && *encoded != 'O' && *encoded != '9')){
          break;   //last possible bit in last possible character
          }
        switch(*encoded){
          case 'f':
            bit+=3;
            break;
          case '@':
            bit+=2;
            setBit(decoded,&bit);
            break;
          case '1':
            bit++;
            setBit(decoded,&bit);
            bit++; 
            break;
          case 'H':
            bit++; 
            setBit(decoded,&bit);
            setBit(decoded,&bit);
            break;
          case 'D':
            setBit(decoded,&bit);
            bit+=2;
            break;
          case 'l':
            setBit(decoded,&bit);
            bit++;
            setBit(decoded,&bit);
            break;
          case 'R':
            setBit(decoded,&bit);
            setBit(decoded,&bit);
            bit++;
            break;
          case 'T':
            setBit(decoded,&bit);
            setBit(decoded,&bit);
            setBit(decoded,&bit);
            break;
          case 'q':
            bit+=2;
            break;
          case 'S':
            bit++;
            setBit(decoded,&bit);
            break;
          case 'O':
            setBit(decoded,&bit);
            bit++;
            break;
          case '9':
            setBit(decoded,&bit);
            setBit(decoded,&bit);
            break;
        }
        encoded++;
    }
    if(bit%8){
       decoded[bit/8] = 0; //if final byte was not complete, set equal to 0.
    }
}

