; -----------------------------------------------------------------------------
; A 64-bit function that returns the summation of elementwise multiplication of the elements in two floating-point
; arrays. The function has prototype:
;
;   double mult_sum(const double[] array, const double[] array, const uint32_t length)
; -----------------------------------------------------------------------------
SECTION	.text
global	mult_sum
mult_sum:
	xorpd	xmm0, xmm0		; initialize the sum to 0
	cmp	rdx, 0			; special case for length = 0
	je	.done
.next:
	movsd	xmm1, [rdi]		; add in the current array element
	mulsd	xmm1, [rsi]
	addsd	xmm0, xmm1
	add	rdi, 8			; move to next array element
	add	rsi, 8			; move to next array element
	dec	rdx			; count down
	jnz	.next			; if not done counting, continue
.done:
	ret
