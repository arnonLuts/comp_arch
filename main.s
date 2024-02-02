.extern printf
.extern scanf
.extern rand
.extern srand

.section .data
rand_num:
    .space 8, 0x0
seed:
    .space 8, 0x0
range:
    .long 10
user_guess:
    .space 8, 0x0

.section .rodata
user_greet_fmt:
    .string "Enter configuration seed: "
scanf_fmt:
    .string "%d"
guess_fmt:
    .string "What is your guess? "
incorrect_fmt:
    .string "Incorrect. \n"
lost_fmt:
    .string "Game over, you lost :(. The Correct answer was %d\n"
won_fmt:
    .string "Congratz! You won! \n"
debug:
    .string "debug %d \n"

.section .text
.globl main
.type main, @function 

main:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    xorq %r12, %r12
    xorq %r13, %r13
    xorq %r14, %r14

    # Print the prompt
    movq $user_greet_fmt, %rdi
    xorq %rax, %rax
    call printf

    # Read the seed
    movq $scanf_fmt, %rdi
    movq $seed, %rsi
    xorq %rax, %rax
    call scanf

        //debug print
    movq $debug, %rdi
    movq seed, %rsi
    xorq %rax, %rax
    call printf

    # Seed the rand function
    movq seed, %rdi
    xorq %rax, %rax
    call srand
    
    # Get random number
    xorq %rdi, %rdi
    xorq %rax, %rax
    call rand
    # get the remainder after dividing by 10 (like doing rand_num%10)
    movq $10, %rcx
    // movq $rand_num, %rdx
    xorq %rdx, %rdx
    divq %rcx
    movl %edx, rand_num


        //debug print
    movq $debug, %rdi
    movq rand_num, %rsi
    xorq %rax, %rax
    call printf

    # Loop for the guessing game (up to 5 attempts)
    movq $5, %r12  # Set loop counter to 5

.loop:
    # Print the prompt
    movq $guess_fmt, %rdi
    xorq %rax, %rax
    call printf
    
    # Read the guess
    movq $scanf_fmt, %rdi
    movq $user_guess, %rsi
    xorq %rax, %rax
    call scanf


    //debug print
    movq $debug, %rdi
    movq user_guess, %rsi
    xorq %rax, %rax
    call printf

    # Compare the guess with the random number
    movq rand_num, %rdi
    cmp %rdi, user_guess
    je .won

    # Print incorrect message
    movq $incorrect_fmt, %rdi
    xorq %rax, %rax
    call printf

    decq %r12
    
    jnz .loop  # Jump back to the loop if attempts remaining

.lost:
    # Print the result if the player loses
    movq $lost_fmt, %rdi
    movq $rand_num, %rsi
    xorq %rax, %rax
    call printf

    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

.won:
    # Print the winning message
    movq $won_fmt, %rdi
    xorq %rax, %rax
    call printf

    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
