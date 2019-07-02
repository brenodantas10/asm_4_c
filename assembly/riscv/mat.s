	.text
	.align	1
	.globl	alloc_matrix, free_matrix, alloc_ptr_matrix, free_ptr_matrix, matrix_from_ptr, mat_mul
	.type	alloc_matrix, @function
	.type	free_matrix, @function
	.type	alloc_ptr_matrix, @function
	.type	matrix_from_ptr, @function
	.type	mat_mul, @function	

alloc_matrix:
	addi	sp,sp,-32
	sd	s0,24(sp)
	sd	ra,16(sp)
	addi	s0,sp,32
	sd	a0,-24(s0)
	sd	a1,0(a0)
	sd	a2,8(a0)
	mul	a0,a1,a2
	li	a1,8
	call	calloc
	mv	a1, a0
	ld	a0,-24(s0)
	sd	a1,16(a0)
	ld	s0,24(sp)
	ld	ra,16(sp)
	addi	sp,sp,32	
	jr	ra
	.size	alloc_matrix, .-alloc_matrix

alloc_ptr_matrix:
	addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        addi    s0,sp,48
	sd	a0,-24(s0)
	sd	a1,-32(s0)
	li	a0,24
	call	malloc
	sd	a0,-40(s0)
	ld	a1,-24(s0)
	ld	a2,-32(s0)
	call	alloc_matrix
	ld	a0,-40(s0)	
	ld      s0,40(sp)
        ld      ra,32(sp)
        addi    sp,sp,48
        jr      ra
        .size   alloc_ptr_matrix, .-alloc_ptr_matrix

matrix_from_ptr:
	addi    sp,sp,-16
        sd      s0,8(sp)
        sd      ra,0(sp)
	sd	a1,16(a0)
	sd	a2,(a0)
	sd	a3,8(a0)
	ld      ra,0(sp)
        ld      s0,8(sp)
        addi    sp,sp,16
        jr      ra
        .size   matrix_from_ptr, .-matrix_from_ptr

free_ptr_matrix:
	addi    sp,sp,-24
        sd      s0,16(sp)
        sd      ra,8(sp)
	sd	a0,-24(s0)
	ld	a0,16(a0)
	call	free
	ld	a0,-24(s0)
	call	free
	ld      ra,8(sp)
        ld      s0,16(sp)
        addi    sp,sp,24
        jr      ra
        .size   free_ptr_matrix, .-free_ptr_matrix

free_matrix:
	addi    sp,sp,-16
        sd      s0,8(sp)
        sd      ra,0(sp)
	ld	a0,16(a0)
	call	free
	ld      ra,0(sp)
	ld	s0,8(sp)
        addi    sp,sp,16
        jr      ra

mat_mul:
	addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        addi    s0,sp,48
	ld	a3,8(a1)
	ld	a4,0(a2)
	bne	a3,a4,mat_mul_error
	mv	s1,a0
	mv	s2,a1
	mv	s3,a2
	ld	a1,0(a1)
	ld	a2,8(a2)
	call	alloc_matrix
	li	s9,0
	ld      s7,8(s3)
	ld	s10,0(s3)
	mul	s10,s7,s10
	slli	s10,s10,3
	ld      a0,16(s3)
	add	s10,s10,a0
	slli	s7,s7,3
	ld	a4,16(s1)
	ld	a0,0(s1)
	ld	a1,8(s1)
	mul	a0,a1,a0
	slli	a0,a0,3
	add	s11,a4,a0
        ld      s8,8(s2)
        slli    s8,s8,3
	ld	s4,16(s2)
        mv      s6,s4
mat_mul_col:
	mv	s4,s6
	ld	s5,16(s3)
	add	s5,s5,s9
	sd	zero,-24(s0)
	fld	fa0,-24(s0)
mat_mul_elm:
	fld	fa1,0(s4)
	fld	fa2,0(s5)
	fmadd.d	fa0,fa1,fa2,fa0
	addi	s4,s4,8
	add	s5,s5,s7
	sub	a3,s4,s6
	bne	a3,s8,mat_mul_elm
        fsd     fa0,0(a4)
	addi	s9,s9,8
	addi	a4,a4,8
	sub	a3,s10,s5
	bge	a3,zero,mat_mul_col
	add	s6,s6,s8
	sub	a3,s11,a4
	li	s9,0
	bge	a3,zero,mat_mul_col
mat_mul_end:
	ld      s0,40(sp)
        ld      ra,32(sp)
        addi    sp,sp,48
        jr      ra
mat_mul_error:
	li	a5,0
	sd	a5,16(a0)
	ld      s0,40(sp)
        jal	x0,mat_mul_end
