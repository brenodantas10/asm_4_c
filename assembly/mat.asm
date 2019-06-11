extern  malloc
extern  free
global  alloc_matrix
global  mat_mul
global  alloc_ptr_matrix
global  alloc
global  free_matrix
global  free_ptr_matrix
section .text

; Função para alocar um ponteiro (matriz) dinamicamente (utilizar o malloc)
; Toda matriz, vetor, etc. seram representados como um vetor
alloc:
	push	rbp
	mov	rbp, rsp
	imul	rdi, rsi		; Obtém o tamanho total do vetor
	shl	rdi, 3			; Como o vetor é do tipo float, cada elemento deve ocupar 8 bytes.
	call	malloc
	pop	rbp
	ret

; Aloca um objeto matrix
alloc_matrix:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16			; Posicionar rsp para que possa utilizar até 16 bits da pilha
	mov	qword [rdi], rsi	; Aloca o primeiro argumento (num_linhas) na primeira posição (l) do objeto matrix
	mov	qword [rdi+8], rdx	; Aloca o segundo argumento (num_colunas) na segunda posição (c) do objeto matrix
	mov	qword [rbp-8], rdi	; Aloca a posição do objeto matrix à ser retornado para uso futuro
	mov	rdi, qword rsi		; Realoca argumentos para chamar a função _alloc
	mov	rsi, qword rdx		; Realoca argumentos para chamar a função _alloc
	call	alloc
	mov	rdx, qword [rbp-8]	; Obtém de volta a posição do objeto matrix que será usado
	mov	qword [rdx+16], rax	; Aloca o ponteiro (vetor) na terceira posição (v) do objeto matrix
	add	rsp, 16			; Retorna rsp para a posição na qual este chegou na chamada dessa função
	pop	rbp
	ret

; Aloca um ponteiro do objeto matrix
alloc_ptr_matrix:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	qword [rbp-24], rsi	; Aloca o segundo argumento (num_colunas) para uso futuro
	mov	qword [rbp-16], rdi	; Aloca o primeiro argumento (num_linhas) para uso futuro
	mov	rdi, 24			; O objeto matrix ocupa 24 bytes na memória (8 bytes para cada um dos 3
					; objetos dentro dele)
	call	malloc
	mov	rdi, rax		; O ponteiro alocado pelo malloc é de um objeto matrix. Será utilizado pela
					; função _alloc_matrix como primeiro argumento
	mov	qword [rbp-8], rdi	; Aloca o ponteiro do objeto matrix para uso futuro
	mov	rsi, [rbp-16]		; Obtém novamente o num_linhas. Esse será o segundo argumento da função alloc_matrix
	mov	rdx, qword [rbp-24]	; Obtém novamente o num_colunas. Esse será o terceiro argumento da função alloc_matrix
	call	alloc_matrix
	mov	rax, qword [rbp-8]	; Aloca o ponteiro do objeto matrix consolidado para ser o retorno da função
	add	rsp, 32
	pop	rbp
	ret

mat_mul:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	rax, qword [rsi+8]	; Aloca o segundo objeto (c) contido no primeiro objeto matrix passado como
					; argumento para operações matemáticas futuras
	mov	qword [rbp-8], rdi	; Aloca o ponteiro do objeto matrix a ser retornado para uso futuro
	mov	qword [rbp-16], rsi	; Aloca o ponteiro do primeiro objeto matrix para uso futuro
	mov	qword [rbp-24], rdx	; Aloca o ponteiro do segundo objeto matrix para uso futuro
	cmp	qword [rdx], rax	; Testa se a multiplicação é possível. Se não for, retorna um ponteiro vazio
	jne	.error
	mov	rsi, qword [rsi]	; Aloca o número de colunas da primeira matriz para o segundo argumetno que
					; será passado para alloc_matrix
	mov	rdx, qword [rdx+8]	; Aloca o número de linhas da segunda matriz para o terceiro argumetno que será
					; passado para alloc_matrix
	call	alloc_matrix		; O primeiro elemento já é o rdi passado para mat_mul (ponteiro para objeto matrix
					; de retorno)
	mov	rdi, qword [rbp-8]	; Obtém novamente o ponteiro do objeto matrix que será retornado
	mov	rsi, qword [rbp-16]	; Obtém novamente o ponteiro do primeiro objeto matrix que fará a multiplicação
	mov	rdx, qword [rbp-24]	; Obtém novamente o ponteiro do segundo objeto matrix que fará a multiplicação
	mov	rcx, qword [rdi]	; O número de linhas da matriz de retorno é colocado em rcx para que seja feito o
					; loop nas linhas
.iter_rows:
	mov	qword [rbp-32], rcx	; rcx será usado em loops futuros. Portanto, seu valor atul é armazenado na pilha e
					; retornado ao final para dar continuação a esse loop
	mov	rcx, [rdi+8]		; O número de colunas da matriz de retorno é alocado em rcx para o loop das colunas
.iter_cols:
	xorpd	xmm0, xmm0		; Garantir que esse registrador (contendo a primeira variável auxiliar/provisória)
					; aterá 0 no início do loop de elementos
	mov	qword [rbp-40], rcx	; rcx será usado em loops futuros. Portanto, seu valor atul é armazenado na pilha e
					; retornado ao final para dar continuação a esse loop
	mov	rcx, [rsi+8]		; Número de colunas da primeira matriz é alocado em rcx para o loop dos elementos.
					; Lembrete: este número é igual ao de linhas da segunda matriz.
.iter_elms:
	mov	rax, qword [rbp-32]	; Obtém o índice da linha atual
	dec	rax			; Decremento necessário pois as posições vão de 0 até #posições-1
	imul	rax, qword [rsi+8]	; Multiplica pela quantidade de colunas da primeira matriz
	add	rax, rcx		; Soma este valor com o índice do elemento atual
	dec	rax			; Faz o decremento que seria aplicado a rcx aqui para não intereferir no valor de rcx
					; durante o loop
	shl	rax, 3			; Multiplica por 8, uma vez que cada elemento ocupa 8 bytes
	mov	rbx, qword [rsi+16]	; Aloca a posição do ponteiro com o vetor contendo os elementos da primeira matriz
	add	rax, rbx		; Desloca este vetor para a posição que deve ser acessada no momento
	movsd	xmm1, qword [rax]	; Atribui o valor que está nessa posição a segunda variável auxiliar / provisória
	mov	rax, rcx		; Obtém o índice do elemento atual
	dec	rax			; Decremento necessário pois as posições vão de 0 até #posições-1
	imul	rax, qword [rdx+8]	; Multiplica pela quantidade de colunas da segunda matriz
	add	rax, qword [rbp-40]	; Soma este valor com o índice da coluna atual
	dec	rax			; Faz o decremento que seria aplicado ao índice da coluna atual
	shl	rax, 3			; Multiplica por 8, uma vez que cada elemento ocupa 8 bytes
	mov	rbx, qword [rdx+16]	; Aloca a posição do ponteiro com o vetor contendo os elementos da segunda matriz
	add	rax, rbx		; Desloca este vetor para a posição que deve ser acessada no momento
	mulsd	xmm1, [rax]		; Multiplica o valor que está nessa posição com o contido na segunda variável
					; auxiliar / provisória. Isso é justamente a multiplicação de elementos
	addsd	xmm0, xmm1		; Soma o valor contido na primeira variável provisória com o da segunda
					; variável auxiliar
	loop	.iter_elms
	mov	rcx, qword [rbp-40]	; Recuperar o valor da coluna atual para rcx. Continuação do loop de colunas
	mov	rax, qword [rbp-32]	; Obtém o valor da linha atual
	dec	rax			; Decremento necessário pois as posições vão de 0 até #posições-1
	imul	rax, qword [rdi+8]	; Multiplica o valor da linha atual pela quantidade de colunas da matriz de retorno
	add	rax, rcx		; Soma este valor com o da coluna atual
	dec	rax			; Decremento necessário pois as posições vão de 0 até #posições-1
	shl	rax, 3			; Multiplica por 8, uma vez que cada elemento ocupa 8 bytes
	mov	rbx, qword [rdi+16]	; Aloca a posição do ponteiro com o vetor contendo os elementos da matriz de retorno
	add	rax, rbx		; Desloca este vetor para a posição que deve ser acessada no momento
	movsd	qword [rax], xmm0	; Aloca na posição definida o valor contido na primeira variável auxiliar / provisória
	loop	.iter_cols
	mov	rcx, qword [rbp-32]	; Recuperar o valor da linha atual para rcx. Continuação do loop de linhas
	dec	rcx			; loop      .iter_rows
	jnz	.iter_rows		; loop      .iter_rows     Instrução loop não pode ser utilizada aqui
.end:
	add	rsp, 48
	pop	rbp
	ret
.error:
	mov	qword [rdi+16], 0
	jmp	.end

matrix_from_ptr:
	push	rbp
	mov	rbp, rsp
	mov	qword [rdi], rdx
	mov	qword [rdi+8], rcx
	mov	qword [rdi+16], rsi
	pop	rbp
	ret

free_matrix:
	push	rbp
	mov	rbp, rsp
	lea	rax, [rbp+16]
	mov	rdi, qword [rax+16]
	call	free
	pop	rbp
	ret

free_ptr_matrix:
	push	rbp
	mov	rbp, rsp
	mov	qword [rbp-8], rdi
	sub	rsp, 16
	mov	rdi, qword [rdi+16]
	call	free
	mov	rdi, qword [rbp-8]
	call	free
	add	rsp, 16
	pop	rbp
	ret
