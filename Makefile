all: teste
teste: main.o mat.o
	gcc -no-pie main.o mat.o -o teste
mat.o: mat.asm
	nasm -f elf64 mat.asm
main.o: main.c
	gcc -c main.c -o main.o
clean:
	rm -rf *.o
mrproper: clean
	rm -rf teste
