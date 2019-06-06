#include <stdlib.h>
#include <stdio.h>
#include "mat.h"
#include "strInv.h"

void print_mat(matrix m) {
    if (m.v == NULL) return;

    for (unsigned int i=0; i < m.l; ++i){
        for (unsigned j=0; j < m.c; ++j){
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

	matrix A = alloc_matrix(3, 3);
	matrix B = alloc_matrix(3, 2);
	matrix C = alloc_matrix(1, 2);
	matrix D;

    A.v[0] = 1; A.v[1] = 2; A.v[2] = 3;
    A.v[3] = 4; A.v[4] = 4; A.v[5] = 4;
    A.v[6] = 4; A.v[7] = 4; A.v[8] = 4;

    B.v[0] = 1; B.v[1] = 2;
    B.v[2] = 3; B.v[3] = 4;
    B.v[4] = 4; B.v[5] = 3;

    C.v[0] = 10; C.v[1] = 11;

    printf("Imprimindo matriz A:\n");
    print_mat(A);

    printf("\nImprimindo matriz B:\n");
    print_mat(B);

    printf("\nImprimindo matriz C:\n");
    print_mat(C);

    printf("\nA * B: ");
    D = mat_mul(&A, &B);

    if (D.v == NULL)
        printf("\tMultiplicação inválida: %llu != %llu.", A.c, B.l);
    else {
        printf("\n");
        print_mat(D);
        printf("\n");
    }

    printf("\nA * C: ");
    D = mat_mul(&A, &C);

    if (D.v == NULL)
        printf("Multiplicação inválida: %llu != %llu.\n", A.c, C.l);
    else {
        printf("\n");
        print_mat(D);
        printf("\n");
    }

    // Desalocação
    free_matrix(A);
    free_matrix(B);
    free_matrix(C);
}
