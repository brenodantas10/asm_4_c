; -----------------------------------------------------------------------------
; A 64-bit function that returns the multiplication of two matrix
;
;   Matriz* mult_mul(const Matriz* m1, const Matriz* m2)
; -----------------------------------------------------------------------------

extern malloc, printf

struc Matriz
.l:	resq	1
.c:	resq	1
.v:	resq	1 					; Isso tem que apontar pra um endereço de memória
endstruc

SECTION	.data
msg	db	'AKI',0xA,0x0
len	dq	$-msg


SECTION	.text
global	mat_mul

mat_mul:
	push	rbx
	push	rcx
	push	rdx
	push	r8
	push	r9
	
	;Checando matriz nula
	cmp	qword[rdi+Matriz.c], 0
	jz	.erro
	cmp	qword[rdi+Matriz.l], 0
	jz	.erro
	cmp	qword[esi+Matriz.l], 0
	jz	.erro
	cmp	qword[esi+Matriz.c], 0
	jz	.erro
	
	;Checando dimensão incompatível
	mov	r8, qword[rdi+Matriz.c]
	cmp	r8, qword[rsi+Matriz.l]
	jne	.erro

	;Calcular Nº de elementos da matriz
	mov	rax, qword[rdi+Matriz.l]
	mov	rbx, qword[rsi+Matriz.c]
	imul	rax, rbx
	imul	rax, 8					;Numero de bytes pelos elementos
	add	rax, Matriz_size			;Espaço total alocado pela Matriz

	;Allocando Matriz
	push	rdi
	mov	rdi, rax

	push	rbp
	mov	rbp, rsp
	call	malloc
	pop	rbp

	pop	rdi
	mov	r8, rax					;Pondo Matriz em R8	

	;Inicializando Matriz
	mov	rax, qword[rdi+Matriz.l]
	;Debug--------------------------------------------------------------------------------------------
        push    rdi
	push	rsi
        push    rax
        mov     rdi, msg
        mov     rax, 0
	mov	rsi, 0

        push    rbp
        call    printf
        pop     rbp

        pop     rax
	pop	rsi
        pop     rdi
        ;---------------------------------------------------------------------------------------------------

	mov	qword[r8+Matriz.l], rax			;Põe linhas de m1 no resultado
	mov	qword[r8+Matriz.c], rbx			;Põe colunas de m2 no resultado

	;Debug--------------------------------------------------------------------------------------------
        push    rdi
	push	rsi
        push    rax
        mov     rdi, msg
        mov     rax, 0
	mov	rsi, 0

        push    rbp
        call    printf
        pop     rbp

        pop     rax
	pop	rsi
        pop     rdi
        ;---------------------------------------------------------------------------------------------------


	push	r8

	;Debug--------------------------------------------------------------------------------------------
        push    rdi
        push    rax
        mov     rdi, msg
        mov     rax, 0

        push    rbp
        call    printf
        pop     rbp

        pop     rax
        pop     rdi
        ;---------------------------------------------------------------------------------------------------


	add	r8, Matriz_size

        ;Debug--------------------------------------------------------------------------------------------
        push    rdi
        push    rax
        mov     rdi, msg
        mov     rax, 0

        push    rbp
        call    printf
        pop     rbp

        pop     rax
        pop     rdi
	;---------------------------------------------------------------------------------------------------

	mov	qword[r8+Matriz.v -Matriz_size], r8
	pop	r8


        ;Debug--------------------------------------------------------------------------------------------
        push    rdi
        push    rax
        mov     rdi, msg
        mov     rax, 0

        push    rbp
        call    printf
        pop     rbp

        pop     rax
        pop     rdi
	
	;Inicializando contadores
	mov	rcx, 0					;Contador Zerado
	mov	r9, 0
	mov	rdx, [rdi+Matriz.c]			;Nº Multiplicações por elemento
							;Obs: 	rax=m1.l |Valores Dimensionais
							;	rbx=m2.c |da Matriz Resultante
	push	rdi
	push	rsi
	push	r8
	
	mov	rdi, [rdi+Matriz.v]
	mov	rsi, [rsi+Matriz.v]			;Aproveitando pra pegar ponteiros de elementos
	mov	r8,  [r8+Matriz.v]
	
	push	rcx
	
        ;Debug--------------------------------------------------------------------------------------------
        push    rdi
        push    rax
        mov     rdi, msg
        mov     rax, 0

        push    rbp
        call    printf
        pop     rbp

        pop     rax
        pop     rdi


	jmp	.mat_mul_line
	
.mat_mul_el:
	movsd	xmm1, qword[rdi+8*rcx]

	push	r9
	mov	r9, rcx
	imul	r9, rbx
	mulsd	xmm1, [rsi+8*r9]
	pop	r9

	addsd	xmm0, xmm1
	movsd	qword[r8+r9], xmm0
	add	r9, 8
	inc	rcx
	cmp	rcx, rbx
	jne	.mat_mul_el
.mat_mul_col:
	pop	rcx
	inc	rcx
	cmp	rcx, rbx
	je	.mat_mul_line
	push	rcx
	mov	rcx, 0
	jmp	.mat_mul_el
.mat_mul_line:
	pop	rcx
	inc	rcx
	cmp	rcx, rax
	je	.done
	push	rcx
	mov	rcx, 0
	push	rcx
	jmp	.mat_mul_line

.done:
	pop	r8
	mov	rax, r8
	pop	rsi
	pop	rdi

	pop	r9
	pop	r8
	pop	rdx
	pop	rcx
	pop	rbx
        ret
.erro:
        mov	rax, 1
        jmp	.done
