
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Darwin)
	OPT := macho64
	AsmFlag := --prefix _
else
	OPT := elf64
	AsmFlag :=
endif

all: programa
programa: main.o mat.o strInv.o
	gcc -no-pie main.o mat.o strInv.o -o programa
mat.o:
	nasm $(AsmFlag) -f $(OPT) assembly/mat.asm -o ./mat.o
strInv.o:
	nasm $(AsmFlag) -f $(OPT) assembly/strInv.asm -o ./strInv.o
main.o: main.c
	gcc -c main.c -o main.o
clean:
	rm -rf *.o programa
mrproper: clean
	rm -rf programa
