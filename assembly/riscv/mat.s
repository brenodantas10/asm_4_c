	.text
	.align	1
	.globl	alloc_matrix, free_matrix, alloc_ptr_matrix, free_ptr_matrix, matrix_from_ptr, mat_mul, mat_trans, mat_exp, mat_s_add, mat_s_div, mat_div_s, mat_s_mul, mat_pow_s, mat_s_pow, mat_div, mat_sigmoid
	.type	alloc_matrix, @function
	.type	free_matrix, @function
	.type	alloc_ptr_matrix, @function
	.type	matrix_from_ptr, @function
	.type	mat_mul, @function
	.type   mat_trans, @function
	.type	mat_exp, @function
	.type	mat_s_add, @function
	.type	mat_s_div, @function
	.type	mat_div_s, @function
	.type	mat_s_mul, @function
	.type	mat_pow_s, @function
	.type	mat_s_pow, @function
	.type	mat_div, @function
	.type	mat_sigmoid, @function

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
	.size	mat_mul, .-mat_mul

mat_trans:
	addi	sp,sp,-40
	sd	s0,32(sp)
	sd	ra,24(sp)
	addi	s0,sp,40
	
	sd	a0,-24(s0)
	sd	a1,-32(s0)
	sd	a2,-40(s0)

	ld	a0,-32(s0)
	ld	a2,0(a0)
	ld	a1,8(a1)
	ld	a0,-24(s0)
	call	alloc_matrix

	ld	a0,-32(s0)
	ld	a1,16(a0)
	ld	a0,-24(s0)
	ld	a2,16(a0)

	ld	s5,0(a0)
	ld	s6,8(a0)
	
	li	s1,0
	li	s2,0
.Loop_el:
	fld	fa0,0(a1)
	fsd	fa0,0(a2)
	addi	a2,a2,1
	
	addi	s2,s2,1
	slli	s5,s5,3
	add	a1,a1,s5
	srli	s5,s5,3
	bne	s2,s6,.Loop_el
	
	addi	s2,s6,-1
	mul	s2,s2,s5
	slli	s2,s2,3
	sub	a1,a1,s2
	addi	a1,a1,8
	li	s2,0
	addi	s1,s1,1
	bne	s1,s5,.Loop_el
.end:
	ld	a0,-24(s0)
	ld	s0,32(sp)
	ld	ra,24(sp)
	addi	sp,sp,40
	jr	ra
	.size	mat_trans, .-mat_trans

mat_exp:
	addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
	mv	s1,a0
	mv	s3,a1
	ld	a3,0(a1)
	ld	a2,8(a1)
	mv	a1,a3
	mul	a3,a1,a2
	slli	s2,a3,3
	call	alloc_matrix
	ld	s1,16(s1)
	ld	s3,16(s3)
	add	s2,s2,s1
mat_exp_op:
	fld	fa0,0(s3)
	call	exp
	fsd	fa0,0(s1)
	addi	s1,s1,8
	addi	s3,s3,8
	sub     a0,s2,s1
        bge     a0,zero,mat_exp_op
	ld      s3,8(sp)
        ld      s2,16(sp)
        ld      s1,24(sp)
        ld      ra,32(sp)
        ld      s0,40(sp)
        addi    sp,sp,48
        jr      ra

mat_s_add:
	addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
        mv      s1,a0
        mv      s3,a1
	fsd	fa0,-48(s0)
        ld      a3,0(a1)
        ld      a2,8(a1)
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
        add     s2,s2,s1
mat_s_add_op:
        fld     fa0,0(s3)
	fld	fa1,-48(s0)
	fadd.d	fa0,fa0,fa1
        fsd     fa0,0(s1)
        addi    s1,s1,8
        addi    s3,s3,8
        sub     a0,s2,s1
        bge     a0,zero,mat_s_add_op
	ld      s3,8(sp)
        ld      s2,16(sp)
        ld      s1,24(sp)
        ld      ra,32(sp)
        ld      s0,40(sp)
        addi    sp,sp,48
        jr      ra

mat_s_div:
        addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
	mv      s1,a0
        mv      s3,a1
        fsd     fa0,-48(s0)
        ld      a3,0(a1)
        ld      a2,8(a1)
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
        add     s2,s2,s1
mat_s_div_op:
        fld     fa0,0(s3)
        fld     fa1,-48(s0)
        fdiv.d  fa0,fa1,fa0
        fsd     fa0,0(s1)
        addi    s1,s1,8
        addi    s3,s3,8
        sub     a0,s2,s1
        bge     a0,zero,mat_s_div_op
	ld      s3,8(sp)
        ld      s2,16(sp)
        ld      s1,24(sp)
        ld      ra,32(sp)
        ld      s0,40(sp)
        addi    sp,sp,48
        jr      ra

mat_div_s:
        addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
	mv      s1,a0
        mv      s3,a1
        fsd     fa0,-48(s0)
        ld      a3,0(a1)
        ld      a2,8(a1)
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
        add     s2,s2,s1
mat_div_s_op:
        fld     fa0,0(s3)
        fld     fa1,-48(s0)
        fdiv.d  fa0,fa0,fa1
        fsd     fa0,0(s1)
        addi    s1,s1,8
        addi    s3,s3,8
        sub     a0,s2,s1
        bge     a0,zero,mat_div_s_op
	ld      s3,8(sp)
        ld      s2,16(sp)
        ld      s1,24(sp)
        ld      ra,32(sp)
        ld      s0,40(sp)
        addi    sp,sp,48
        jr      ra

mat_s_mul:
        addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
        mv      s1,a0
        mv      s3,a1
        fsd     fa0,-48(s0)
        ld      a3,0(a1)
        ld      a2,8(a1)
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
        add     s2,s2,s1
mat_s_mul_op:
        fld     fa0,0(s3)
        fld     fa1,-48(s0)
        fmul.d  fa0,fa0,fa1
        fsd     fa0,0(s1)
        addi    s1,s1,8
        addi    s3,s3,8
        sub     a0,s2,s1
        bge     a0,zero,mat_s_mul_op
        Ld      s0,40(sp)
        Ld      ra,32(sp)
        Ld      s1,24(sp)
        Ld      s2,16(sp)
        Ld      s3,8(sp)
        addi    sp,sp,48
        jr      ra

mat_pow_s:
        addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
	mv      s1,a0
        mv      s3,a1
        fsd     fa0,-48(s0)
        ld      a3,0(a1)
        ld      a2,8(a1)
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
        add     s2,s2,s1
mat_pow_s_op:
        fld     fa0,0(s3)
        fld     fa1,-48(s0)
        call	pow
        fsd     fa0,0(s1)
        addi    s1,s1,8
        addi    s3,s3,8
        sub     a0,s2,s1
        bge     a0,zero,mat_pow_s_op
	ld      s3,8(sp)
        ld      s2,16(sp)
        ld      s1,24(sp)
        ld      ra,32(sp)
        ld      s0,40(sp)
        addi    sp,sp,48
        jr      ra

mat_s_pow:
	addi    sp,sp,-48
        sd      s0,40(sp)
        sd      ra,32(sp)
        sd      s1,24(sp)
        sd      s2,16(sp)
        sd      s3,8(sp)
        addi    s0,sp,48
        mv      s1,a0
        mv      s3,a1
        fsd     fa0,-48(s0)
        ld      a3,0(a1)
        ld      a2,8(a1)
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
        add     s2,s2,s1
mat_s_pow_op:
        fld     fa1,0(s3)
        fld     fa0,-48(s0)
        call    pow
        fsd     fa0,0(s1)
        addi    s1,s1,8
        addi    s3,s3,8
        sub     a0,s2,s1
        bge     a0,zero,mat_s_pow_op
	ld      s3,8(sp)
        ld      s2,16(sp)
        ld      s1,24(sp)
        ld      ra,32(sp)
        ld      s0,40(sp)
        addi    sp,sp,48
        jr      ra

mat_div:
        addi    sp,sp,-32
        sd      s0,16(sp)
        sd      ra,8(sp)
        addi    s0,sp,32
        mv      s1,a0
        mv      s3,a1
	mv	s4,a2
        fsd     fa0,-24(s0)
	ld	a4,0(a2)
        ld      a3,0(a1)
	bne	a4,a3,mat_div_error
	ld	a4,8(a2)
        ld      a2,8(a1)
	bne     a4,a2,mat_div_error
        mv      a1,a3
        mul     a3,a1,a2
        slli    s2,a3,3
        call    alloc_matrix
        ld      s1,16(s1)
        ld      s3,16(s3)
	ld	s4,16(s4)
        add     s2,s2,s1
mat_div_op:
        fld     fa0,0(s3)
        fld     fa1,0(s4)
	fdiv.d	fa0,fa0,fa1
        fsd     fa0,0(s1)
        addi    s1,s1,8
	addi    s3,s3,8
	addi	s4,s4,8
        sub     a0,s2,s1
        bge     a0,zero,mat_div_op
mat_div_end:
	ld      ra,8(sp)
        ld      s0,16(sp)
        addi    sp,sp,32
        jr      ra
mat_div_error:
        sd      zero,16(s1)
        jal     x0,mat_div_end

mat_sigmoid:
        addi    sp,sp,-88
        sd      s0,80(sp)
        sd      ra,72(sp)
	add	s0,sp,88
        mv      s1,a0
	lui	s2,%hi(.LC0)
	fld	fa0,%lo(.LC0)(s2)
	addi	a0,s0,-88
	call	mat_s_mul
	addi	a0,s0,-64
	addi	a1,s0,-88
	call	mat_exp
	lui	a3,%hi(.LC1)
	fld	fa0,%lo(.LC1)(a3)
	addi	a0,s0,-40
	addi	a1,s0,-64
	call	mat_s_add
	lui	a3,%hi(.LC1)
	fld	fa0,%lo(.LC1)(a3)
	mv	a0,s1
	addi	a1,s0,-40
	call	mat_s_div
	ld      ra,72(sp)
        ld      s0,80(sp)
        addi    sp,sp,88
        jr      ra
.LC0:
	.word	0
	.word	-1074790400
.LC1:
	.word	0
	.word	1072693248
