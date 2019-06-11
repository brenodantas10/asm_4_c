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

	matrix A = alloc_matrix(5, 10);
	matrix B = alloc_matrix(10, 5);
	matrix C = alloc_matrix(1, 2);
	matrix D;

    unsigned int i = 0, j = 0, k = 0;

    for (i = 0; i < 50; ++i) {
        A.v[i] = (float) (i+1) / 10;
        B.v[i] = 10 / (float) (i + 1);
    }

    C.v[0] = 10; C.v[1] = 11;

    printf("Imprimindo matriz A:\n");
    print_mat(A);

    printf("\nImprimindo matriz B:\n");
    print_mat(B);

    printf("\nImprimindo matriz C:\n");
    print_mat(C);

    printf("\nA * B: ");
    D = mat_mul(&A, &B);

//    double * ma = (double *) malloc(A.l*B.c*8);
//
//    for (i = 0; i < A.l; ++i) {
//        for (j = 0; j < B.c; ++j) {
//            ma[i * B.c + j] = 0;
//            for (k = 0; k < A.c; ++k) {
//                ma[i * B.c + j] += A.v[i * A.c + k] * B.v[k * B.c + j];
//            }
//        }
//    }
//
//    D.l = A.l;
//    D.c = B.c;
//    D.v = ma;

    if (D.v == NULL)
        printf("\tMultiplicação inválida: %lu != %lu.", A.c, B.l);
    else {
        printf("\n");
        print_mat(D);
        printf("\n");
    }

    printf("\nA * C: ");
    D = mat_mul(&A, &C);

    if (D.v == NULL)
        printf("Multiplicação inválida: %lu != %lu.\n", A.c, C.l);

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
