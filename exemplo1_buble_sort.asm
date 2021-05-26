	# Implementação bubble sort (Capitulo 2)
	# void sort (int v[], int n)
	# {
	#    int i, j;
	#    for (i = 0; i < n; i += 1) {
	#       for (j = i – 1; j >= 0 && v[j] > v[j + 1]; j -= 1) {
	#          swap(v,j);
	#       }
	#    }
	# }

			.data
array: 	.word 	46, 38, 50, 27, 19
n:			.word	5
			.globl main # Declara que o rótulo main é global e pode ser referênciado a partir de outros arquivos
        	.text

main:   	  	
    		la	$a0, array	
    		li	$a1, 5
    		jal	print
    	
    		li $v0, 11		# imprime a quebra de linha '\n'.
			li $a0, 10		# print_char é syscall 11 e '\n' is ASCII 10.
			syscall 
    	
    		la	$a0, array	# ponteiro array, v
    		li	$a1, 5		# tamanho array, n
    		jal 	sort
        	
    		la	$a0, array
    		li	$a1, 5
    		jal 	print
	
			li 	$v0, 10
			syscall
	
########################## IMPRIME ##########################
# imprime array de inteiros
# endereço em $a0
# tamanho n $a1
print:	li	$t0, 0		# contador
			add	$t1, $zero, $a0	# ponteiro para palavras
loop:		beq	$t0, $a1, done
			li	$v0, 1		# print_int é system call 1
			lw	$a0, ($t1)	# carraga o próximo inteiro
			syscall			# imprime
			li	$v0, 11		# print_char é system call 11
			li	$a0, 0x20
			syscall			# imprime um espaço
			addi	$t1, $t1, 4	# ponteior para a proxima palavra
			addi	$t0, $t0, 1	# adiciona 1 ao contador
			j	loop
done:		jr	$ra

######################### SWAP ########################
swap:   	sll $t1, $a1, 2 	# $t1 = k * 4 
        	add $t1, $a0, $t1 	# $t1 = v + (k * 4) (endereço de v[k])
    		lw $t0, 0($t1) 		# $t0 (temp) = v[k]
    		lw $t2, 4($t1) 		# $t2 = v[k+1}
    		sw $t2, 0($t1) 		# v[k] = $t2 (v[k+1])
    		sw $t0, 4($t1) 		# v[k+1] = $t0 (temp)
    		jr $ra 			# retorna à rotina que chamou

######################### SORT ########################
sort:   addi $sp, $sp, -20 	# cria espaço na pilha para 5 reg.
    		sw $ra, 16($sp) 	# salva $ra na pilha
    		sw $s3, 12($sp) 	# salva $s3 na pilha
    		sw $s2, 8($sp) 		# salva $s2 na pilha
    		sw $s1, 4($sp) 		# salva $s1 na pilha
    		sw $s0, 0($sp) 		# salva $s0 na pilha
    		# move parametros
    		move $s2, $a0 		# salva $a0 em $s2 
    		move $s3, $a1 		# salva $a1 em $s3
    		# loop externo
    		move $s0, $zero 	# i = 0
for1tst: slt $t0, $s0, $s3 	# $t0 = 0 if $s0 >= $s3 (i >= n)
   		beq $t0, $zero, exit1 	# vai para exit1 se $s0 ≥ $s3 (i ≥ n)
    		# loop interno
    		addi $s1, $s0, -1 	# j = i - 1
for2tst: slti $t0, $s1, 0 	# $t0 = 1 if $s1 < 0 (j < 0) 
    		bne $t0, $zero, exit2 	# vai para exit2 se $s1 < 0 (j < 0)
    		sll $t1, $s1, 2 	# $t1 = j * 4 (shift 2 bits)
    		add $t2, $s2, $t1 	# $t2 = v + (j*4) 
    		lw $t3, 0($t2) 		# $t3 = v[j]
    		lw $t4, 4($t2) 		# $t4 = v[j+1]
    		slt $t0, $t4, $t3 	# $t0 = 0 if $t4 >= $t3
    		beq $t0, $zero, exit2 	# vai par exit2 se $t4 ≥ $t3
    		# swap
    		move $a0, $s2 		# 1º param de swap é v (antigo $a0)
    		move $a1, $s1 		# 2º param de swap é j
    		jal swap 		# chama prodedimento swap
    		addi $s1, $s1, -1     	# j -= 1
    		j for2tst 		# desvia para teste do loop interno
    		# loop interno - fim
exit2: 
    		addi $s0, $s0, 1 	# i += 1
    		j for1tst 		# desvia para teste do loop externo

exit1: 
    		lw $s0, 0($sp) 		# restaura $s0 da pilha
    		lw $s1, 4($sp) 		# restaura $s1 da pilha
    		lw $s2, 8($sp) 		# restaura $s2 da pilha
    		lw $s3, 12($sp) 		# restaura $s3 da pilha
    		lw $ra, 16($sp) 		# restaura $ra da pilha
    		addi $sp, $sp, 20 		# restaura stack pointer 
    		jr $ra			# retorna à rotina que chamou
