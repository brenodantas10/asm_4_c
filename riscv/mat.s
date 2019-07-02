.text
.align 1
.globl alloc_matrix, free_matrix, alloc_ptr_matrix, free_ptr_matrix, matrix_from_ptr
.type alloc_matrix, @function
.type free_matrix, @function
.type alloc_ptr_matrix, @function
.type matrix_from_ptr, @function

alloc_matrix:
	addi	sp, sp, -32
	sd	s0, 24(sp)
	sd	ra, 16(sp)
	addi	s0, sp, 32
	sd	a0, -24(s0)
	sd	a1, 0(a0)
	sd	a2, 8(a0)
	mul	a0, a1, a2
	li	a1, 8
	call	calloc
	mv	a1, a0
	ld	a0, -24(s0)
	sd	a1, 16(a0)
	ld	s0, 24(sp)
	ld	ra, 16(sp)
	addi	sp, sp, 32
	jr	ra

alloc_ptr_matrix:
	addi	sp, sp, -48
	sd	s0, 40(sp)
	sd	ra, 32(sp)
	addi	s0, sp, 48
	sd	a0, -24(s0)
	sd	a1, -32(s0)
	li	a0, 24
call malloc
	ld	a1, -24(s0)
	ld	a2, -32(s0)
	sd	a0, -40(s0)
	call	alloc_matrix
	ld	a0, -40(s0)
	ld	s0, 40(sp)
	ld	ra, 32(sp)
	addi	sp, sp, 48
	jr	ra

matrix_from_ptr:
	addi	sp, sp, -16
	sd	s0, 8(sp)
	sd	ra, 0(sp)
	sd	a1, 16(a0)
	sd	a2, (a0)
	sd	a3, 8(a0)
	ld	ra, 0(sp)
	ld	s0, 8(sp)
	addi	sp, sp, 16
	jr	ra

free_ptr_matrix:
	addi	sp, sp, -24
	sd	s0, 16(sp)
	sd	ra, 8(sp)
	sd	a0, -24(s0)
	ld	a0, 16(a0)
	call	free
	ld	a0, -24(s0)
	call	free
	ld	ra, 8(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 24
	jr	ra

free_matrix:
	addi	sp, sp, -16
	sd	s0, 8(sp)
	sd	ra, 0(sp)
	ld	a0, 16(a0)
	call	free
	ld	ra, 0(sp)
	ld	s0, 8(sp)
	addi	sp, sp, 16
	jr	ra
