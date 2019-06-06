
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Darwin)
	OPT := macho64
else
	OPT := elf64
endif

all: programa
programa: main.o mat.o strInv.o
	gcc -no-pie main.o mat.o strInv.o -o programa
mat.o:
	nasm -f $(OPT) assembly/$(UNAME_S)/mat.asm -o ./mat.o
strInv.o:
	nasm -f $(OPT) assembly/$(UNAME_S)/strInv.asm -o ./strInv.o
main.o: main.c
	gcc -c main.c -o main.o
clean:
	rm -rf *.o programa
mrproper: clean
	rm -rf programa
