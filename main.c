#include <stdlib.h>
#include <stdio.h>
#include "mat.h"
#include "strInv.h"

void print_mat(matrix m) {
    if (m.v == NULL) return;

    for (unsigned int i=0; i < m.l; ++i){
        for (unsigned int j=0; j < m.c; ++j){
            printf("%.2f\t", m.v[j + i * m.c]);
        }
        printf("\n");
    }
}


int main() {
	char msg[] = "Banana";

	printf("INVERSÃO DE STRING:\n\n");

	printf("String a ser invertida: %s\n", msg);
	strInv(msg);
	printf("String invertida: %s\n", msg);

        printf("\nMULTIPLICAÇÃO DE MATRIZES: \n\n");
	
	matrix A=alloc_matrix(2,5);
	matrix B=alloc_matrix(5,2);

	for(int i=0; i<5; i++){
		A.v[2*i]=i+1;
		A.v[2*i+1]=i+2;
		B.v[2*i]=i+1;
		B.v[2*i+1]=i+1;
	}
/*
	double v_2[] = {
		1.0, 1.0,
		2.0, 2.0,
		3.0, 0.0,
		4.0, 4.0,
		5.0, 5.0
	}, v_0[] = {
		1.0, 2.0, 3.0, 4.0, 5.0,
		1.0, 0.0, 10.0, 0.0, 0.0
	};

	matrix A = matrix_from_ptr(v_0, 2, 5);
	matrix B = matrix_from_ptr(v_1, 5, 2);
*/
    printf("Imprimindo matriz A:\n");
    print_mat(A);

    printf("\nImprimindo matriz B:\n");
    print_mat(B);

    printf("\nA * C: ");
    
    matrix C = mat_mul(&A, &B);
    C = mat_pow_s(&C, 1/2.0);
    printf("%d, %d\n\n", C.l, C.c);
    if (C.v == NULL)
        printf("Multiplicação inválida: %lu != %lu.\n", A.c, B.l);
    else {
        printf("\n");
        print_mat(C);
        printf("\n");
    }

    // Desalocação
    printf("Desalocando Matrizes\n");
    free_matrix(A);
    printf("Matriz A desalocada\n");
    free_matrix(B);
    printf("Matriz B desalocada\n");
    free_matrix(C);
    printf("Matriz C desalocada\n");

    return 0;
}
