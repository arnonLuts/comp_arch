.extern pstrlen

.section .rodata
choice_31_fmt: .string "first pstring length: %d, second pstring length: %d\n"
choice_33_fmt: .string "length: %d, string: %s\n "
choice_34_fmt: .string "length: %d, string: %s\n "
default_fmt: .string "invalid option!\n"
debug: .string "choice is %d\n"

.section .text
.global run_func
.type run_func, @function
run_func:
    pushq %rbp
    movq %rsp, %rbp
    # We"ll add the pointers and the function choice to the stack
    subq $32, %rsp
    # Func choice
    leaq -8(%rbp), %r9
    movq %rdi, (%r9) 
    # &pstr1
    leaq -16(%rbp), %r9
    movq %rsi, (%r9) 
    # &pstr2
    leaq -24(%rbp), %r9
    movq %rdx, (%r9) 
    


    // //debug
    // movq -16(%rbp), %rdi      
    // movb 0(%rdi), %al         
    // movq %rax, %rsi           
    // // movq -16(%rbp), %rsi      
    // movq $my_string_fmt, %rdi 
    // xorq %rax, %rax           
    // call printf

    movq $31, %rdi
    cmp -8(%rbp), %rdi
    je .choice_31

    movq $33, %rdi
    cmp -8(%rbp), %rdi
    je .choice_33

    movq $34, %rdi
    cmp -8(%rbp), %rdi
    je .choice_34
    # Else (didn't match the functions) print invalid and exit.
    movq $default_fmt, %rdi 
    xorq %rax, %rax           
    call printf
    jmp .exit

.choice_31:
    # Call pstrlen on pstr1
    movq -16(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %rsi
    # Call pstrlen on pstr2
    movq -24(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %rdx
    # Print the output
    movq $choice_31_fmt, %rdi
    xorq %rax, %rax
    call printf
    
    jmp .exit

.choice_33:

    jmp .exit

.choice_34:

    jmp .exit


.exit:
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax

    ret
