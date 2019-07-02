#include <inttypes.h>

typedef struct {
    uint64_t l, c;
    double *v;
} matrix;

double * alloc(uint64_t, uint64_t);
matrix alloc_matrix(uint64_t, uint64_t);
matrix matrix_from_ptr(double*, uint64_t, uint64_t);
matrix* alloc_matrix_ptr(uint64_t, uint64_t);
matrix mat_mul(const matrix*, const matrix*);
void free_matrix(matrix);
void free_ptr_matrix(matrix*);
matrix mat_trans(const matrix*);
matrix mat_exp(const matrix*);
matrix mat_s_add(const matrix*, double);
matrix mat_s_div(const matrix*, double);
matrix mat_div_s(const matrix*, double);
matrix mat_pow_s(const matrix*, double);
matrix mat_s_pow(const matrix*, double);
