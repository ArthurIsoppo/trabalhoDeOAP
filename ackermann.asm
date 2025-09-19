# Variante da Função de Ackermann em Assembly MIPS
# Autores: Arthur Isoppo, Carlos Eduardo Lopes, Pedro Ferraz
# Data de conversão: 19/09/2025

.data
    introducao: .asciiz "Variante da Funcao de Ackermann - 31/01/2025\n"
    autores:    .asciiz "Autores: Arthur Isoppo, Carlos Eduardo Lopes, Pedro Ferraz\n"
    instrucao:  .asciiz "Digite os parametros m e n para calcular A(m, n) ou numero negativo para abortar a execucao.\n"
    prompt_m:   .asciiz "m: "
    prompt_n:   .asciiz "n: "
    resultado_a: .asciiz "A("
    virgula:    .asciiz ","
    fecha_p:    .asciiz ") = "
    endl:       .asciiz "\n"
    finalizado: .asciiz "Programa finalizado porque algum numero negativo foi inserido\n"

.text
.globl main

main:
    # Introdução
    li $v0, 4
    la $a0, introducao
    syscall

    li $v0, 4
    la $a0, autores
    syscall

    # Início do feto
    li $v0, 4
    la $a0, instrucao
    syscall

loop:
    # Solicita m
    li $v0, 4
    la $a0, prompt_m
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # Salva m em $t0

    # Verifica se m é negativo
    bltz $t0, fim

    # Solicita n
    li $v0, 4
    la $a0, prompt_n
    syscall

    li $v0, 5
    syscall
    move $t1, $v0  # Salva n em $t1

    # Verifica se n é negativo
    bltz $t1, fim

    # Prepara para chamar a função A(m, n)
    move $a0, $t0
    move $a1, $t1
    jal A

    # Salva o resultado
    move $s0, $v0

    # Imprime "A("
    li $v0, 4
    la $a0, resultado_a
    syscall

    # Imprime m
    li $v0, 1
    move $a0, $t0
    syscall

    # Imprime ","
    li $v0, 4
    la $a0, virgula
    syscall

    # Imprime n
    li $v0, 1
    move $a0, $t1
    syscall

    # Imprime ") = "
    li $v0, 4
    la $a0, fecha_p
    syscall

    # Imprime o resultado
    li $v0, 1
    move $a0, $s0
    syscall

    # Imprime nova linha
    li $v0, 4
    la $a0, endl
    syscall

    j loop

A:
    # Prólogo da função - aloca espaço na pilha
    addi $sp, $sp, -12
    sw $ra, 8($sp)   # Salva o endereço de retorno
    sw $a0, 4($sp)   # Salva o argumento m
    sw $a1, 0($sp)   # Salva o argumento n

    # if (m == 0)
    bne $a0, $zero, else_if_1
    # return n + 1
    addi $v0, $a1, 1
    j A_return

else_if_1:
    # else if (n == 0)
    bne $a1, $zero, else_2
    # return A(m - 1, 1) + 1;
    addi $a0, $a0, -1
    li $a1, 1
    jal A
    
    # Adiciona 1 ao resultado de A(m-1, 1)
    addi $v0, $v0, 1
    j A_return

else_2:
    # return A(m - 1, A(m, n - 1))

    # Chamada interna: A(m, n - 1)
    addi $a1, $a1, -1
    jal A

    # O resultado de A(m, n - 1) está em $v0.
    # Agora, preparamos para a chamada externa: A(m - 1, resultado_interno)
    
    # Restaura m original de antes da chamada interna
    lw $a0, 4($sp)
    addi $a0, $a0, -1
    move $a1, $v0 # O novo n é o resultado da chamada interna
    jal A
    
A_return:
    # Epílogo da função - restaura a pilha
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

fim:
    # Mensagem de finalização
    li $v0, 4
    la $a0, finalizado
    syscall

    # Finaliza o programa
    li $v0, 10
    syscall
