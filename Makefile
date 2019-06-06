UNAME_S := $(shell uname -s)

all: programa
programa: main.o mat.o strInv.o
	gcc main.o mat.o strInv.o -o programa
mat.o:
	nasm -f macho64 assembly/$(UNAME_S)/mat.asm -o ./mat.o
strInv.o:
	nasm -f macho64 assembly/$(UNAME_S)/strInv.asm -o ./strInv.o
main.o: main.c
	gcc -c main.c -o main.o
clean:
	rm -rf *.o programa
mrproper: clean
	rm -rf programa
