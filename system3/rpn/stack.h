#pragma once
#include <stdlib.h>  
#include <stdio.h>
#include <string.h>

/**
   * Actual nodes in struct
*/
typedef struct Node{
	char *val;
	struct Node *next;
} Node;
/**
   * A structure that represents a stack
*/
typedef struct{
	Node *top;
} Stack;

void initialize_stack(Stack *stack);
void push(Stack *s, const char *str);
char* pop(Stack *s);
void free_stack(Stack *s);
void print_stack(Stack *s);
void print_top(Stack *s);
