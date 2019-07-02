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
	
	double v_1[] = {
		1.0,
		2.0,
		3.0,
		4.0,
		5.0,
	}, v_0[] = {1.0, 2.0, 3.0, 4.0, 5.0};

	matrix A = matrix_from_ptr(v_0, 1, 5);
	matrix B = matrix_from_ptr(v_1, 5, 1);

    printf("Imprimindo matriz A:\n");
    print_mat(A);

    printf("\nImprimindo matriz B:\n");
    print_mat(B);

    printf("\nA * C: ");
    
    matrix C = mat_mul(&A, &B);

    if (C.v == NULL)
        printf("Multiplicação inválida: %lu != %lu.\n", A.c, B.l);
    else {
        printf("\n");
        print_mat(C);
        printf("\n");
    }

    // Desalocação
    // free_matrix(A);
    // free_matrix(B);
    // free_matrix(C);
}
