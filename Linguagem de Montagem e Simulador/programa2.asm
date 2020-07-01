	.data
programa2:	.asciiz "Ordenador de Numeros Inteiros Com o Terminal \n"
ordenados:	.asciiz "Numeros Ordenados: \n"
pedirNumeros:	.asciiz "Digite um numero inteiro: \n"
espaco:		.asciiz " "
vetor:	.word 10	#tamanho do vetor

	.text
main:
	li	$v0, 4
	la	$a0, programa2
	syscall		#imprime "Ordenador de Numeros Inteiros Com o Terminal \n"
	
	#codigo de leitura dos numeros:
	
	addi	$t0, $0, 0	#$t0 sera um contador, t0 recebe 0
	addi	$t1, $0, 4	#$t1 sera utilizado para realizar as contas para inserir os numeros corretamente no vetor, t1 recebe 4
	
whileLeitura:
	slti	$t2, $t0, 10	#se t0 < 4 entao t2 recebe 1, senao t2 recebe 0
	beq	$t2, $0, doneLeitura	#se t2 igual 0, "pula" para doneLeitura
	
	li 	$v0, 4
	la	$a0, pedirNumeros
	syscall		#imprime "Digite um numero inteiro: \n"
	
	li 	$v0, 5
	syscall		#chamada para ler o numero
	mul	$t3, $t0, $t1	#t3 recebe a multiplicacao de t0 com t1, aqui ocorre o calculo do indice do vetor
	sw	$v0, vetor($t3)	#o vetor recebe o numero lido no indice t3
	addi	$t0, $t0, 1	#soma-se 1 a t0, o contador
	j	whileLeitura	#retorno ao whileLeitura
doneLeitura:

	#codigo de ordenacao:
	
	addi 	$t0, $0, 0	#$t0 sera um contador, t0 recebe 0
	addi	$t1, $0, 4	#sera utilizado para realizar as contas para "trocar" (ordenar) os numeros corretamente no vetor, t1 recebe 4
	
whileExterno:
	slti	$t2, $t0, 10	#se t0 < 10 entao t2 recebe 1 senao, t2 recebe 0
	beq	$t2, $0, doneExterno	#se t2 igual a 0, "pula" para doneExterno
	addi	$t3, $t0, 1 	#esse sera outro contador, para o whileInterno, t3 recebe t0 mais 1
whileInterno:
	slti	$t4, $t3, 10	#se t3 < 10 entao t4 recebe 1 senao, t4 recebe 0
	beq	$t4, $0, doneInterno	#se t4 igaul a 0, "pula" para doneInterno
	mul	$t5, $t1, $t0	#$t5 sera um indice do vetor, t5 recebe t1 multiplicado por t0
	mul	$t6, $t1, $t3	#$t6 sera outro indice do vetor, t5 recebe t1 multiplicado por t3
	lw	$s1, vetor($t5)	#s1 recebe o numero do vetor na posicao t5
	lw	$s2, vetor($t6)	#s2 recebe o numero do vetor na posicao t6
if:
	sgt	$t7, $s1, $s2	#se s1 > s2 entao t7 recebe 1, senao t7 recebe 0
	beq	$t7, $0, doneIf	#se t7 igual a 0, "pula" para doneIf, ou seja, a troca nao sera realizada
	sw	$s2, vetor($t5)	#aqui s2 sera colocado na posicao t5, que anteriormente era s1
	sw	$s1, vetor($t6)	#aqui s1 sera colocado na posicao t6, que anteriormente era s2
doneIf:
	addi	$t3, $t3, 1	#soma-se 1 a t3, o contador interno
	j	whileInterno	#retorno ao whileInterno
doneInterno:
	addi 	$t0, $t0, 1	#soma-se 1 a t0, o contador externo
	j 	whileExterno	#retorno ao whileExterno
doneExterno:
	
	li	$v0, 4
	la	$a0, ordenados
	syscall	#imprime "Numeros Ordenados: \n"
	
	#codigo para imprimir os numeros do vetor:
	
	addi 	$t0, $0, 0	#$t0 sera o contador, t0 recebe 0
	addi 	$t1, $0, 4	#$t1 sera utilizado para realizar as contas para inserir os numeros corretamente no vetor, t1 recebe 4
	
whileImpressao:
	slti	$t2, $t0, 10	#se t0 < 10 entao t2 recebe 1, senao t2 recebe 0
	beq	$t2, $0, doneImpressao	#se t2 igual 0, "pula" para doneImpressao
	mul	$t3, $t0, $t1	#t3 recebe a multiplicacao de t0 com t1, aqui ocorre o calculo do indice do vetor
	
	lw	$a0, vetor($t3)
	li	$v0, 1
	syscall	#imprime o numero na posicao t3 do vetor
	
	li 	$v0, 4
	la	$a0, espaco
	syscall	#Imprime " "
	
	addi 	$t0, $t0, 1	#some-se 1 a t0, o contador
	j	whileImpressao	#retorno ao whileImpressao
doneImpressao:

      	li $v0, 10
      	syscall #imprime a chamada de fim de programa