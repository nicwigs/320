#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "stack.h"
#include "binarymath.h"

/**
 * Initialize a stack to empty
 * @param stack Pointer to the stack struct
 */
void initialize_stack(Stack *stack)
{
    stack->top = NULL;
}
/**
*push value to front of the stack
*@param stack Pointer to the stack
*@param value Value to add to top of stack
*/
void push(Stack *s, const char *str){

	Node *n = (Node *)calloc(1,sizeof(Node));				//allocate for node 	

	n->val = (char *)calloc(strlen(str)+1,sizeof(char));	//allocate nodes value 
	strncpy(n->val,str,strlen(str));

	n->next = s->top;
	s->top = n;
}
/**
*pop value from front of the stack
*@param stack Pointer to the stack
*@return popped value
*/
char* pop(Stack *s){
	if(s != NULL){
		Node* popNode = s->top;				//dont loose popped node
		s->top = s->top->next;				//move top
		char* popVal = popNode->val;		//grab the value
		free(popNode);						//give node back!
		return popVal;
	}
	return 0;
}
/**
*Free the memory allocated for stack
*@param s Pointer to stack
*/
void free_stack(Stack *s){

	Node* current = s->top;				//will be deleted at end of function call

	while(current != NULL){
		Node * next = current->next;	//will be deleted at end of function call

		free(current->val);
		free(current);

		current = next;
	}
}
/**
*Prints the stack for testing
*@param s Pointer to stack
*/
void print_stack(Stack *s){
	Node * n = s->top;					//will be deleted at end of function call
	printf("Stack: ");
	for(; n!= NULL; n = n->next){
		printf("%s ", n->val);
	}
	printf("\n");
}
/**
*Prints the top of the stack
*@param s Pointer to stack
*/
void print_top(Stack *s){

	if(s->top != NULL){
		printf("%s\n",s->top->val);		
	}else{
		printf("** empty **\n");
	}
}