; -----------------------------------------------------------------------------
; A 64-bit function that returns the multiplication of two matrix
;
;   Matriz* mult_mul(const Matriz* m1, const Matriz* m2)
; -----------------------------------------------------------------------------

extern malloc, free

struc Matriz
.l:	resq	1
.c:	resq	1
.v:	resq	1 ; Isso tem que apontar pra um endereço de memória
endstruc

SECTION	.text
global	mat_mul

mat_mul:
	push	rbx
	push	rcx
	push	rdx
	push	r8
	push	r9
	push	r10
	xor	rax, rax

	push	rdi
	mov	rdi, Matriz_size
	call	malloc
	pop	rdi

;	mov	rbx, qword[rdi+Matriz.c]
;	cmp	rbx, qword[rsi+Matriz.l]
;	jne	.erro
	
;	push	rax
;	mov	rcx, qword[rdi+Matriz.l]
;	mov	rbx, qword[esi+Matriz.c]
;	mov	rax, rcx
;	mul	rbx			;Calcula Nº de el.
;	mov	rdx, rax		;Põe em rdx
;
;	pop	rax
;	mov	qword[rax+Matriz.l], rcx
;	mov	qword[rax+Matriz.c], rbx
;	cmp	rdx, 0
;	jz	.erro
;
;	push	rax
;	push	rdx			;Aloca espaço do array
;	call	malloc
;	add	rsp, 8
;	mov	r8, rax			;xmm0 com ponteiro para array
;	
;	pop	rax			;Recupera Matriz
;	mov	qword[rax+Matriz.v], r8
;	mov	r9, qword[rdi+Matriz.v]
;	mov	r10, qword[rsi+Matriz.v]
;	
;	mov	rcx,0
	
	
.mat_mul_line:
	
	
	
	
	;inc	rcx
	;cmp	rcx, rdx
	;jnl	.mat_mul_line
.done:
	pop	r10
	pop	r9
	pop	r8
	pop	rdx
	pop	rcx
	pop	rbx
        ret
.erro:
	;push	rax
	;call	free
	;add	rax, 8
        ;mov	rax, 1
        jmp	.done


