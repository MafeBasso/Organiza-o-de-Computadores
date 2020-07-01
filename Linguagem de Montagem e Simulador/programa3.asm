	.data
programa3:	.asciiz "Ordenador de Numeros Inteiros Com o Arquivo Texto \n"
nomeArquivo:	.asciiz "entrada.txt"
formatotxt:	.asciiz "Numeros no arquivo texto: "
ordenados:	.asciiz "Numeros Ordenados: \n"
espaco:		.asciiz " "
quebradelinha:	.asciiz "\n"
buffer:		.word 1024
vetor:		.word 4
	.text
main:
	li	$v0, 4
	la	$a0, programa3
	syscall	#imprime "Ordenador de Numeros Inteiros Com o Arquivo Texto \n"
	
	li	$v0, 13	#chamada para abrir arquivo
	li	$a1, 0
	la	$a0, nomeArquivo	#carrega o nome do arquivo
	li	$a2, 0
  	syscall	#um indicador abstrato para acessar o arquivo (file descriptor) fica salvo em $v0
  	move	$s6, $v0	#agora ele foi salvo em $s6
  	
  	li	$v0, 14	#chamada para ler o arquivo
  	move 	$a0, $s6	#file descriptor
 	la  	$a1, buffer	#endereco do buffer para leitura
 	li   	$a2, 1024	#tamanho do buffer
 	move	$t0, $a1	#guardando o endereco em $t0 para utilizar na conversao de string de inteiros
 	syscall	#le
 	
	li  	$v0, 16	#chamada para fechar o arquivo
	move	$a0, $s6	#file descriptor para fechar
	syscall	#fecha
	
	li	$v0, 4
	la	$a0, formatotxt
	syscall	#imprime "Numeros no arquivo texto: "
	
	la	$a0, buffer
	li	$v0, 4
	syscall	#imprime todo buffer
	
	li	$v0, 4
	la	$a0, quebradelinha
	syscall	#imprime a quebra de linha
	
	addi	$t3, $0, 4	#$t3 sera utilizado para realizar as contas para inserir os numeros corretamente no vetor, t3 recebe 4
forConversao:
	slti  	$t2, $t1, 4	#se t1 < 4 entao t2 recebe 1 senao, t2 recebe 0
	beq	$t2, $0, doneConversao	#se t2 igual a 0, "pula" para doneConversao
	
	lb 	$a0, ($t0)	#$a0 recebe os bytes em $t0
	subi 	$a0, $a0, 48	#subtraindo 48 de $a0, temos um numero inteiro
	
	mul	$t4, $t1, $t3	#$t4 sera o indice do vetor, t4 recebe t1 multiplicado por t3
	sb	$a0, vetor($t4)	#inserimos os bytes na posicao t4 do vetor
	
	addi	$t0, $t0, 1	#soma-se 1 a t0, vamos para a proxima posicao da string lida
	addi	$t1, $t1, 1	#soma-se 1 a t1, o contador
	j	forConversao	#retorno ao forConversao
doneConversao:
	
	#codigo de ordenacao:
	
	addi 	$t0, $0, 0	#$t0 sera um contador, t0 recebe 0
	addi	$t1, $0, 4	#sera utilizado para realizar as contas para "trocar" (ordenar) os numeros corretamente no vetor, t1 recebe 4
whileExterno:
	slti  	$t2, $t0, 4	#se t0 < 4 entao t2 recebe 1 senao, t2 recebe 0
	beq	$t2, $0, doneExterno	#se t2 igual a 0, "pula" para doneExterno
	addi	$t3, $t0, 1 	#esse sera outro contador, para o whileInterno, t3 recebe t0 mais 1
whileInterno:
	slti	$t4, $t3, 4	#se t3 < 4 entao t4 recebe 1 senao, t4 recebe 0
	beq	$t4, $0, doneInterno	#se t4 igaul a 0, "pula" para doneInterno
	mul	$t5, $t1, $t0	#$t5 sera um indice do vetor, t5 recebe t1 multiplicado por t0
	mul	$t6, $t1, $t3	#$t6 sera outro indice do vetor, t6 recebe t1 multiplicado por t3
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
	
	#codigo para imprimir os numeros do vetor:
	
	addi 	$t0, $0, 0	#$t0 sera o contador, t0 recebe 0
	addi 	$t1, $0, 4	#$t1 sera utilizado para realizar as contas para ler os numeros corretamente no vetor, t1 recebe 4
	
whileImpressao:
	slti	$t2, $t0, 4	#se t0 < 4 entao t2 recebe 1, senao t2 recebe 0
	beq	$t2, $0, doneImpressao	#se t2 igual 0, "pula" para doneImpressao
	mul	$t3, $t0, $t1	#t3 recebe a multiplicacao de t0 com t1, aqui ocorre o calculo do indice do buffer
	
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
