extern malloc

SECTION .text
global	alloc_mat

alloc_mat:
	push	rdx
	
	mov	qword[rdi], rsi
	mov	qword[rdi+8], rdx

	push	rdi
	mov	rax, rsi
	mul	rdx
	imul	rax, 8
	mov	rdi, rax

	push	rbp
	mov	rbp, rsp
	call	malloc
	pop	rbp

	pop	rdi
	mov	qword[rdi+16], rax
	mov	rax, rdi
	
	pop	rdx
	ret
