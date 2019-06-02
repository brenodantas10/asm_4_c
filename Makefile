all: teste
teste: mat_mul.o mult.o main.o
	gcc -o teste mat_mul.o mult.o main.o
mult.o: mult.asm
	nasm -f elf64 mult.asm
mat_mul.o: mat_mul.asm
	nasm -f elf64 mat_mul.asm
main.o: main.c
	gcc -o main.o -c main.c
clean:
	rm -rf *.o
mrproper: clean
	rm -rf teste
