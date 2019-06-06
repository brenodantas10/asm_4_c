global strInv

section .text


;strInv recebe um ponteiro para a string e inverte a string mantendo no mesmo endereço de memória
strInv:
	push	rbx			;
	push	rcx			;Salva as variáveis pra pilha do ESP
	push	rdx			;

	mov	rcx, 0x0		;Zera contador
	push	rcx			;Põe byte nulo na pilha (pra por no final de RAX)
.strLoop:
	xor	rbx, rbx		;Zera EBX
	mov	bl, [rdi+rcx]		;Copia o valor da memória na posição RSI+RCX (pra pegar o valor do byte em ASCII)
	push	rbx			;Manda o ASCII pro topo do Stock
	inc	rcx
	cmp	bl, 0x0			;Checa fim de string    (vai haver um byte nulo extra)
	jne	.strLoop		;Se não for nulo repete o processo

	pop	rbx			;Retira valor nulo extra
	mov	rdx, rcx		;Copia comprimento da string pra EDX
	mov	rcx, 0			;Zera contador
.invLoop:
	pop	rbx			;Puxa da pilha os valores em ASCII
	mov	byte [rdi+rcx], bl	;Copia o valor do ASCII pra memória que é apontada em EAX
	inc	rcx
	cmp	rcx, rdx		;Checa se não chegou no final da string
	jne	.invLoop		;Se não chegou repete

.finished:
	pop	rdx			;Puxa valores originais das variáveis
	pop	rcx			;da pilha do ESP
	pop	rbx			;
	ret

