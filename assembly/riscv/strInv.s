.text
.align	1
.globl	strInv
.type	strInv, @function

strInv:
	addi	sp, sp, -32
	sd	s0, 24(sp)
	addi	s0, sp, 32
	sd	a1, -16(s0)
	sd	a2, -24(s0)
	
	li	a2, 0
	addi	sp, sp, -1
	sb	a2, 1(sp)
.strLoop:
	li	a1, 0
	lb	a1, 0(a0)
	addi	sp, sp, -1
	sb	a1, 1(sp)

	addi	a0, a0, 1
	addi	a2, a2, 1
	bnez	a1, .strLoop
	
	addi	sp, sp, 1
	sub	a0, a0, a2
.invLoop:
	lb	a1, 1(sp)
	addi	sp, sp, 1
	sb	a1, 0(a0)
	
	addi	a0, a0, 1
	addi	a2, a2, -1
	bnez	a2, .invLoop

.finished:
	ld	a2, -24(s0)
	ld	a1, -16(s0)
	ld	s0, 24(sp)
	addi	sp, sp, 32
	li	a0, 0
	jr	ra
	.size	strInv, .-strInv
