extern _malloc

global _alloc_matrix
global _mat_mul
global _alloc_matrix_ptr
global _alloc

section .text

_alloc:
	push	rbp
	mov	rbp, rsp
	imul	rdi, rsi
	shl	rdi, 3
	call	_malloc
	pop	rbp
	ret

_alloc_matrix:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	qword [rdi], rsi		;Grava Linhas
	mov	qword [rdi+8], rdx		;Grava Colunas
	mov	qword [rbp-8], rdi
	mov	rdi, qword rsi
	mov	rsi, qword rdx
	call	_alloc
	mov	rdx, qword [rbp-8]
	mov	qword [rdx+16], rax
	add	rsp, 16
	pop	rbp
	ret

_alloc_matrix_ptr:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32			;8B vagos mais 24B da matriz?
	mov	qword [rbp-24], rsi
	mov	qword [rbp-16], rdi
	mov	rdi, 24
	call	_malloc
	mov	rdi, rax
	mov	qword [rbp-8], rdi
	mov	rsi, [rbp-16]
	mov	rdx, qword [rbp-24]
	call	_alloc_matrix
	mov	rax, qword [rbp-8]
	add	rsp, 32
	pop	rbp
	ret

_mat_mul:
	push	rbp
	mov	rbp, rsp
	mov	rax, qword [rsi+8]
	sub	rsp, 48
	mov	qword [rbp-8], rdi
	mov	qword [rbp-16], rsi
	mov	qword [rbp-24], rdx
	cmp	qword [rdx], rax
	jne	.error
	mov	rsi, qword [rsi]
	mov	rdx, qword [rdx+8]
	call	_alloc_matrix
	mov	rdi, qword [rbp-8]
	mov	rsi, qword [rbp-16]
	mov	rdx, qword [rbp-24]
	mov	rcx, qword [rdi]
; add rdi, 16
; add rsi, 16
; add rdx, 16
.iter_rows:
	mov	qword [rbp-32], rcx
	mov	rcx, [rdi+8]
.iter_cols:
	xorpd	xmm0, xmm0
	mov	qword [rbp-40], rcx
	mov	rcx, [rsi+8]
.iter_elms:
	mov	rax, qword [rbp-32]
	dec	rax
	imul	rax, qword [rsi+8]
	add	rax, rcx
	dec	rax
	shl	rax, 3
	mov	rbx, qword [rsi+16]
	add	rax, rbx
	movsd	xmm1, qword [rax]
	mov	rax, rcx
	dec	rax
	imul	rax, qword [rdx+8]
	add	rax, qword [rbp-40]
	dec	rax
	shl	rax, 3
	mov	rbx, qword [rdx+16]
	add	rax, rbx
	mulsd	xmm1, [rax]
	addsd	xmm0, xmm1
	loop	.iter_elms
	mov	rcx, qword [rbp-40]
	mov	rax, qword [rbp-32]
	dec	rax
	imul	rax, qword [rdi+8]
	add	rax, rcx
	dec	rax
	shl	rax, 3
	mov	rbx, qword [rdi+16]
	add	rax, rbx
	movsd	qword [rax], xmm0
	loop	.iter_cols
	mov	rcx, qword [rbp-32]
	dec	rcx ; loop _iter_rows
	jnz	.iter_rows ; loop _iter_rows
.end:
	add	rsp, 48
	pop	rbp
	ret
.error:
	mov	qword [rdi+16], 0
	jmp	.end
