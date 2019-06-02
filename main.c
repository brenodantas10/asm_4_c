#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>

typedef struct {
    uint64_t l, c;
    double* v;
} Matriz;

const int mat_mul(const Matriz*, const Matriz*);

double mult_sum(const double[], const double[], uint64_t);


void alloc_mat(Matriz *m, const uint64_t l, const uint64_t c) {
    m->l = l;
    m->c = c;
    m->v = (double*) malloc (sizeof(double) * m->l * m->c);
}

void free_mat(Matriz *m) {
    m->l = 0;
    m->c = 0;
    free(m->v);
}

int main() {
    Matriz m1, m2;

    alloc_mat(&m1, 10, 31);
    alloc_mat(&m2, 30, 20);

    printf("%d\n", mat_mul(&m1, &m2));

    double a[] = {2, 26.7, 21.9, 1.5, -40.5, -23.5};
    double b[] = {3, 26.7, 21.9, 1.5, -40.5, -23.5};

    printf("%20.7f\n", mult_sum(a, b, 3));
    printf("%20.7f\n", mult_sum(a, b, 2));

    free_mat(&m1);
    free_mat(&m2);

    return 0;
}