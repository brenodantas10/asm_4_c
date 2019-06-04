; -----------------------------------------------------------------------------
; A 64-bit function that returns the multiplication of two matrix
;
;   Matriz* mult_mul(const Matriz* m1, const Matriz* m2)
; -----------------------------------------------------------------------------

struc Matriz
.l:	resq	1
.c:	resq	1
.v:	resq	1 ; Isso tem que apontar pra um endereço de memória
endstruc

SECTION .data
prov2:
	istruc	Matriz

	at Matriz.l,	dd	2
	at Matriz.c,	dd	1
	at Matriz.v,	dd	0x0

	iend

SECTION .bss
prov		resb	Matriz_size	
prov2a		resq	2

SECTION	.text
global	mat_mul

mat_mul:
	push	rbx
	push	rcx
	push	rdx
	mov	rax, prov2
	mov	rbx, prov2
	mov	qword [rax+Matriz.v], rbx
	mov	qword[rbx], 0x1111111111111111
	mov	qword[rbx+1], 0x1111111111111111
;	jne	.erro
.mat_mul_line:
	
.done:
	pop	rdx
	pop	rcx
	pop	rbx
        ret
.erro:
        mov	rax, 0x0000000000000001
        jmp	.done


