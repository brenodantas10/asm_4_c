
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Darwin)
	OPT := macho64
	AsmFlag := --prefix _
else
	OPT := elf64
	AsmFlag :=
endif

all: riscv
x64: x64_main.o x64_mat.o x64_strInv.o
	gcc -no-pie main.o mat.o strInv.o -o programa
x64_mat.o:
	nasm $(AsmFlag) -f $(OPT) assembly/x86_64/mat.asm -o ./mat.o
x64_strInv.o:
	nasm $(AsmFlag) -f $(OPT) assembly/x86_64/strInv.asm -o ./strInv.o
x64_main.o: main.c
	gcc -c main.c -o main.o


riscv: riscv_main.o riscv_mat.o riscv_strInv.o
	riscv64-unknown-elf-gcc main.o mat.o strInv.o -lm -o programa
riscv_mat.o:
	riscv64-unknown-elf-gcc -c assembly/riscv/mat.s -o mat.o
riscv_strInv.o:
	riscv64-unknown-elf-gcc -c assembly/riscv/strInv.s -o strInv.o
riscv_main.o:
	riscv64-unknown-elf-gcc -c main.c -o main.o
clean:
	rm -rf *.o programa
mrproper: clean
	rm -rf programa
