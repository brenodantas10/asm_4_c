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
