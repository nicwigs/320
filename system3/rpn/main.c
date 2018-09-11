#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "binarymath.h"
#include "stack.h"

int main(int argc, char *argv[])
{
	if (argc < 2){									//make sure reading correctly
        printf("Usage: rpn file\n");
        return 1;
    }
    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL){
        printf("Unable to open input file\n");
        return 1;
    }
    
    Stack s;										//create stack
	initialize_stack(&s);

	char buffer[200];								

	while(fgets(buffer,sizeof(buffer),fp) != NULL){	//snag each line
		
		size_t len = strlen(buffer);
        if (buffer[len - 1] == '\n'){				//get rid of those pesky /n
        	buffer[len - 1] = '\0';
        }
		if(buffer[0] == '0' || buffer[0] == '1'){	//0 or 1
			push(&s,buffer);
		}else if(!strcmp(buffer,"print")){			//print
			print_top(&s);
		}else if(!strcmp(buffer,"pop")){			//pop
			char* a = pop(&s);
			free(a);
		}else if(!strcmp(buffer,"stack")){			//print stack
			print_stack(&s);
		}else if(!strcmp(buffer,"exit")){			//exit
			break;
		}else if(buffer[0] == '+'){					//add
			char* a = pop(&s);
			char* b = pop(&s);
			char* c = add(a,b);
			push(&s,c);
			free(a);	
			free(b);	
			free(c);			
		}else if(buffer[0] == '-'){					//subtract
			char* a = pop(&s);
			char* b = pop(&s);
			char* c = sub(b,a);
			push(&s,c);
			free(a);	
			free(b);	
			free(c);			
		}else if(buffer[0] == 'n'){					//negate
			char* a = pop(&s);
			char* b = negate(a);
			push(&s,b);
			free(a);	
			free(b);	
		}
	}

	free_stack(&s);							//free stack
	printf("** goodbye **\n");
	fclose(fp);
	return 0;	
}