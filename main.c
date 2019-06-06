#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>

typedef struct {
    uint64_t l, c;
    double *v;
} matrix;

void	strInv(char*);
double * alloc(uint64_t, uint64_t);
matrix alloc_matrix(uint64_t, uint64_t);
matrix* alloc_matrix_ptr(uint64_t, uint64_t);
matrix mat_mul(const matrix*, const matrix*);

void print_mat(matrix m){
        int i=0, j=0;
        for(i=0; i<m.l; i++){
                for(j=0; j<m.c; j++){
                        printf("%.2f\t",m.v[j+i*m.c]);
                }
                printf("\n");
        }
}


int main() {
	char msg[]="Banana";
	printf("%s\n", msg);
	strInv(msg);
	printf("%s\n\n", msg);


	matrix a = alloc_matrix(3, 3);
	matrix b = alloc_matrix(3, 2);

	a.v[0] = 1;
	a.v[1] = 2;
	a.v[2] = 3;
	a.v[3] = 4;
	a.v[4] = 4;
	a.v[5] = 4;
	a.v[6] = 4;
	a.v[7] = 4;
	a.v[8] = 4;

	b.v[0] = 1;
	b.v[1] = 2;
	b.v[2] = 3;
	b.v[3] = 4;
	b.v[4] = 4;
	b.v[5] = 3;
;	b.v[6] = 4;
;	b.v[7] = 3;
;	b.v[8] = 3;

	matrix c = mat_mul(&a, &b);

	printf("Imprimindo matriz a:\n");
	print_mat(a);

	printf("\nImprimindo matriz b:\n");
	print_mat(b);

	printf("\nImprimindo matriz a*b:\n");
	print_mat(c);
	printf("\n");

	for (unsigned i = 0; i < c.l; ++i) {
		for (unsigned j = 0; j < c.c; ++j) {
			printf("c[%u, %u]: %f\t", i, j, c.v[i*c.c + j]);
		}
		printf("\n");
	}

//	if (c.v == NULL) {
//		printf("Impossível realizar multiplicação: %llu != %llu\n", a.c, b.l);
//	} else {
////		c.v[c.l*c.c-1] = 10;
//	}

//	matrix d = alloc_matrix(1200, 100000);
////	matrix* e = alloc_matrix_ptr(1000, 10000);
//
//	printf("%llu, %llu\n", a.l, a.c);
//	printf("%llu, %llu\n", d.l, d.c);
////	printf("%llu, %llu, %p\n", e->l, e->c, e->v);
//
////	e->v[e->c*e->l-1] = 40;
//
//	c = mat_mul(&a, &d);
//
//	if (c.v == NULL) {
//		printf("Impossível realizar multiplicação: %llu != %llu\n", a.c, d.l);
//	} else {
//		printf("Multiplicação realizada!\n");
//	}
//
////	free(d->v);
//	free(a.v);
//	free(e->v);
	return 0;
}
