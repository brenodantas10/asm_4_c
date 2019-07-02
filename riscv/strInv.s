.text
.align	1
.globl	strInv
.type	strInv, @function

strInv:
	addi	sp, sp, -40
	sd	s0, 32(sp)
	addi	s0, sp, 40
	sd	a1, -24(s0)
	sd	a2, -16(s0)
	sd	a3, -8(s0)
	
	mv	zero, a2
	addi	sp, sp, -8
	sd	a2, 8(sp)
.strLoop:
	mv	a1, zero

	add	a0, a0, a2
	lb	a1, 0(a0)
	sub	a0, a0, a2

	addi	sp, sp, -8
	sd	a1, 8(sp)
	addi	a2, a2, 1
	beqz	a1, .strLoop

	ld	a1, 8(sp)
	addi	sp, sp, 8

	mv	a3, a2
	mv	a2, zero
.invLoop:
	ld	a1, 8(sp)
	addi	sp, sp, 8

	add	a0, a0, a2
	sb	a1, 0(a0)
	sub	a0, a0, a2
	
	addi	a2, a2, 1
	bne	a2, a3, .invLoop

.finished:
	ld	a3, -8(s0)
	ld	a2, -16(s0)
	ld	a1, -24(s0)
	ld	s0, 32(sp)
	addi	sp, sp, 40
	mv	a0, zero
	jr	ra
