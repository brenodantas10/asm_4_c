; -----------------------------------------------------------------------------
; A 64-bit function that returns the multiplication of two matrix
;
;   int mult_mul(const Matriz* m1, const Matriz* m2)
; -----------------------------------------------------------------------------

        global  mat_mul
        section .text

mat_mul:
        xor rax, rax
        mov r10, [rdi+8]
        mov r11, [rsi]
        cmp r11, r10
        jne      _erro
_mat_mul_line:

done:
        ret
_erro:
        add rax, 1
        jmp done


