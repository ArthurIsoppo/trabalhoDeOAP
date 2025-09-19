.data
    introducao: .asciiz "Variante da Funcao de Ackermann - 19/09/2025\n"
    autores:    .asciiz "Autores: Arthur Isoppo, Carlos Eduardo Lopes, Pedro Ferraz\n"
    instrucao:  .asciiz "Digite os parametros m e n para calcular A(m, n) ou numero negativo para abortar a execucao.\n"
    prompt_m:   .asciiz "m: "
    prompt_n:   .asciiz "n: "
    resultado_a: .asciiz "A("
    virgula:    .asciiz ","
    fecha_p:    .asciiz ") = "
    endl:       .asciiz "\n"
    finalizado: .asciiz "Programa finalizado porque algum numero negativo foi inserido\n"


.macro print_string(%label) #macro 1
	li $v0, 4    #carrega o cód 4, print string
	la $a0, %label
	syscall  
.end_macro

.macro ler_inteiro(%register) #macro 2
	li $v0, 5    #carrega o cód 5, read integer
	syscall
	move %register, $v0
.end_macro

.text
.globl main

main:

   print_string(introducao) 

   print_string(autores)

   print_string(instrucao)
loop:
    # pede m
   print_string(prompt_m)

    ler_inteiro($t0)

    # verifica se m é negativo
    bltz $t0, fim

    # pede n
   print_string(prompt_n)

   ler_inteiro($t1)

    # verifica se n é negativo
    bltz $t1, fim

    # prepara para chamar a função A(m, n)
    move $a0, $t0
    move $a1, $t1
    jal A

    # salva o resultado
    move $s0, $v0

  print_string(resultado_a)

    # imprime m
    li $v0, 1
    move $a0, $t0
    syscall

    print_string(virgula)

    # imprime n
    li $v0, 1
    move $a0, $t1
    syscall

    print_string(fecha_p)
    
    # imprime o resultado
    li $v0, 1
    move $a0, $s0
    syscall

	print_string(endl)

    j loop

A:
    # aloca espaço na pilha
    addi $sp, $sp, -12
    sw $ra, 8($sp)   # endereco retorno
    sw $a0, 4($sp)   #  m
    sw $a1, 0($sp)   #  n

    bne $a0, $zero, else_if_1   # if (m == 0)
    addi $v0, $a1, 1            
    j A_return                  # return n + 1

else_if_1:
    bne $a1, $zero, else_2      # else if (n == 0)
    addi $a0, $a0, -1           
    li $a1, 1
    jal A                       # return A(m - 1, 1) + 1;
    
    # adiciona 1 ao resultado de A(m-1, 1)
    addi $v0, $v0, 1
    j A_return

else_2:
    # return A(m - 1, A(m, n - 1))

    addi $a1, $a1, -1
    jal A
    
    lw $a0, 4($sp)
    addi $a0, $a0, -1
    move $a1, $v0
    jal A
    
A_return:
    #restaura a pilha
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

fim:
 	print_string(finalizado)

    li $v0, 10
    syscall