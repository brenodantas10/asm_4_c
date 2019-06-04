#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>

typedef struct {
    uint64_t l, c;
    double* v;
} Matriz;

Matriz* mat_mul(const Matriz*, const Matriz*);

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
void print_mat(Matriz *m){
	int i=0, j=0;
	for(i=0; i<m->l; i++){
		for(j=0; j<m->c; j++){
			printf("%.2f\t",m->v[j+i*m->c]);
		}
		printf("\n");
	}
}

int main() {
    Matriz *m1, *m2;
    m1=(Matriz *) malloc( sizeof(Matriz));
    m2=(Matriz *) malloc( sizeof(Matriz));

    printf("Teste de multiplicacao de matriz\n\n");
    alloc_mat(m1, 2, 3);
    alloc_mat(m2, 3, 4);
    int i;
    for(i=0;(i<m1->c*m1->l);i++){
            m1->v[i]=i+1;
    }
    for(i=0;i<(m2->c*m2->l);i++){
            m2->v[i]=i+1;
    }
    
    printf("Primeira Matriz:\n");
    print_mat(m1);

    printf("\nSegunda Matriz:\n");
    print_mat(m2);
    printf("\nMultiplicando Matrizes...\n\n");

    Matriz *m_teste;
    m_teste=mat_mul(m1,m2);
    printf("Resultado:\n");
//    print_mat(m_teste);
    printf("%.2f\n%.2f\n\n",m_teste[1],m_teste->v[2]);
    printf("Tamanho das variaveis:\nInt:\t%d bytes\nInt64:\t%d bytes\nFloat:\t%d bytes\nDouble:\t%d bytes\n\n",sizeof(int),sizeof(uint64_t),sizeof(float),sizeof(double));
    printf("\nTeste de produto interno entre vetores:\n");

    double a[] = {2, 26.7, 21.9, 1.5, -40.5, -23.5};
    double b[] = {3, 26.7, 21.9, 1.5, -40.5, -23.5};

    printf("%20.2f\n", mult_sum(a, b, 3));
    printf("%20.2f\n", mult_sum(a, b, 2));

    free_mat(m1);
    free_mat(m2);
    free_mat(m_teste);
    free(m1);
    free(m2);
    free(m_teste);

    return 0;
}
