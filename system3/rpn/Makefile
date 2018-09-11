rpn: main.o stack.o binarymath.o
	gcc -o rpn main.o stack.o binarymath.o

main.o: main.c
	gcc -c -Wall main.c

stack.o: stack.c stack.h
	gcc -c -Wall stack.c

binarymath.o: binarymath.c binarymath.h
	gcc -c -Wall binarymath.c
