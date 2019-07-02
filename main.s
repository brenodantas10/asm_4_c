	.file	"main.c"
	.option nopic
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"%.2f\t"
	.text
	.align	1
	.globl	print_mat
	.type	print_mat, @function
print_mat:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	addi	s0,sp,48
	mv	s1,a0
	ld	a5,16(s1)
	beqz	a5,.L8
	sw	zero,-36(s0)
	j	.L4
.L7:
	sw	zero,-40(s0)
	j	.L5
.L6:
	ld	a4,16(s1)
	lwu	a3,-40(s0)
	lwu	a2,-36(s0)
	ld	a5,8(s1)
	mul	a5,a2,a5
	add	a5,a3,a5
	slli	a5,a5,3
	add	a5,a4,a5
	fld	fa5,0(a5)
	fmv.x.d	a1,fa5
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printf
	lw	a5,-40(s0)
	addiw	a5,a5,1
	sw	a5,-40(s0)
.L5:
	lwu	a4,-40(s0)
	ld	a5,8(s1)
	bltu	a4,a5,.L6
	li	a0,10
	call	putchar
	lw	a5,-36(s0)
	addiw	a5,a5,1
	sw	a5,-36(s0)
.L4:
	lwu	a4,-36(s0)
	ld	a5,0(s1)
	bltu	a4,a5,.L7
	j	.L1
.L8:
	nop
.L1:
	ld	ra,40(sp)
	ld	s0,32(sp)
	ld	s1,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_mat, .-print_mat
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	li	a5,7
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	fcvt.d.w	fa5,a5
	fmv.d	fa0,fa5
	call	exp
	fsd	fa0,-32(s0)
	li	a5,0
	mv	a0,a5
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 8.3.0"
