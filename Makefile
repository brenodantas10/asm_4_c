all: teste
teste: mat_mul.o mult.o main.o alloc_mat.o
	gcc -no-pie main.o alloc_mat.o mat_mul.o mult.o -o teste
mult.o: mult.asm
	nasm -f elf64 mult.asm
mat_mul.o: mat_mul.asm
	nasm -f elf64 mat_mul.asm
alloc_mat.o: alloc_mat.asm
	nasm -f elf64 alloc_mat.asm
main.o: main.c
	gcc -c main.c -o main.o
clean:
	rm -rf *.o
mrproper: clean
	rm -rf teste
