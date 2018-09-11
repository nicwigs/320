#include <stdlib.h>
#include <string.h>
#include "binarymath.h"
#include <stdio.h>
/**
  *copy a string safely
  *@param string to be copied
  *@returns pointer to the copied string
  */
char *copy_string(const char *str)
{
      size_t required = strlen(str) + 1;
      char *result = calloc(required,sizeof(char));
      strncpy(result, str, required-1);
      return result;
}
/**
  *Pad the string with '1' or '0' depending on the leading digit 
  *if the first string is smaller, creates a new padded string.
  *If first string is not smaller, returns the orignal pointer to the string
  *@param 2 strings
  *@returns the changed or unchaned first string sent
  */
char *pad(const char *small, const char *big)
{     
      if(strlen(big) > strlen(small)){ //if small is in fact smaller, add buffer

         size_t required =  strlen(big)+1;     //size of string with pading
         char * new= calloc(required,sizeof(char));  
         int i = 0;
         for(;i < strlen(big) - strlen(small);i++){  //buffer
           
            new[i] = small[0]; //buffer with leading digit
         }    
         strncat(new,small,required-strlen(new)-1); //buffer + old string     
         return new;
      }
      else{
            return copy_string(small); //if not the smallest, just return  original
      }    
}
/**
   * Add two arbitrary size binary numbers expressed as
   * a character string. 
   * @param a First number to add
   * @param b Second number to add
   * @return a + b
   */
char *add(const char *a, const char *b)
{
      char * c = pad(a,b); //c is the padded version of a
      char * d = pad(b,a); //d is the padded version of b
         
      int required = strlen(c) + 1;
      char * sum = calloc(required,sizeof(char)); //allocate for sum
      char carry = '0';//carry is the valued carried over after each digit addition
      int i;
      for (i = required-2;i >= 0; i--){
        int add = c[i] + d[i] + carry;//use ascii values to see how many 1's & 0's
        int type = add % '0';
        switch(type){
          case 0: //all '0's
            sum[i] = '0';
            carry = '0';
            break;
          case 1: //One '1'
            sum[i] = '1';
            carry = '0';
            break;
          case 2: //Two '1's
            sum[i] = '0';
            carry = '1';
            break;
          case 3: //Three '1's
            sum[i] = '1';
            carry = '1';
            break;
        }
      }
      free(c);
      free(d);
          return sum;
}
/**
   * Increment an arbitrary size binary number expressed as a 
   * character string.
   * @param number The number we are passed
   * @returns Incremented version of the number
   */
char *inc(const char *number)
{
      const char * increment = "01"; //increment is just adding 1
      return add(increment,number);
}
/**
   * Negate an arbitrary size binary number expressed as a character string
   * @param number The number we are passed
   * @returns Incremented version of the number
   */
char *negate(const char *number)
{
      char *neg = copy_string(number);    //copy string to get negated
      int i = 0;
      for (;i < strlen(neg);i++){ //invert bits
          neg[i] = neg[i] == '1' ? '0' : '1';
      }
      char * final = inc(neg); //add 1 
      free(neg);
      return final;
}
/**
  * Subtract two arbitrary size binary numbers expressed as
  * a character string.
  * @param a First number
  * @param b Second number 
  * @return a - b
  */
char *sub(const char *a, const char *b)
{
      char * bCopy = copy_string(b);//copy string getting negated
      char * bNeg = negate(bCopy);//negate
      free(bCopy); 
      char * subtract = add(a,bNeg);//subtract is just adding negative
      free(bNeg);
      return subtract;
}
