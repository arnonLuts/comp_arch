.extern pstrlen

.section .rodata
choice_31_fmt: .string "first pstring length: %d, second pstring length: %d\n"
choice_33_fmt: .string "length: %d, string: %s\n"
choice_34_fmt: .string "length: %d, string: %s\n"
default_fmt: .string "invalid option!\n"
debug: .string "choice is %d\n"
scanf_fmt: .string "%d %d"


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
    


    movq $31, %rdi
    cmp -8(%rbp), %rdi
    je .choice_31

    movq $33, %rdi
    cmp -8(%rbp), %rdi
    je .choice_33

    movq $34, %rdi
    cmp -8(%rbp), %rdi
    je .choice_34
    # Else (didn't match the functions) invalid format -  exit.
    jmp .default

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

    # Call swapCase on pstr1
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call swapCase
    # Get the length of pstr1
    movq -16(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %rsi

    # Print the result for pstr1
    movq $choice_33_fmt, %rdi
    movq -16(%rbp), %rdx
    xorq %rax, %rax
    call printf

    # Call swapCase on pstr2
    movq -24(%rbp), %rdi
    xorq %rax, %rax
    call swapCase
    # Get the length of pstr2
    movq -24(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %rsi

    # Print the result for pstr2
    movq $choice_33_fmt, %rdi
    movq -24(%rbp), %rdx
    xorq %rax, %rax
    call printf    



    jmp .exit

.choice_34:

    # Get the two indexes
    movq $scanf_fmt, %rdi
    leaq -32(%rbp), %rsi
    leaq -8(%rbp), %rdx
    xorq %rax, %rax
    call scanf

    # Call pstrlen on pstr1
    movq -16(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r8
    # Call pstrlen on pstr2
    movq -24(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r9

    # Check for edge cases: j<i, iVj<0, iVj> string size
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq -32(%rbp), %rdx
    movq -8(%rbp), %rcx

    // cmp $0, %rdx 
    // jl .default_34
    cmp %rdx, %rcx 
    jb .default_34
    cmp %r8, %rdx
    jae .default_34
    cmp %r8, %rcx
    jae .default_34
    cmp %r9, %rdx
    jae .default_34
    cmp %r9, %rcx
    jae .default_34

    xorq %rax, %rax
    call pstrijcpy

    # Call pstrlen on pstr1
    movq -16(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r8

    # Print the result for pstr1
    movq $choice_33_fmt, %rdi
    movq -16(%rbp), %rdx
    movq %r8, %rsi
    xorq %rax, %rax
    call printf    

    # Call pstrlen on pstr2
    movq -24(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r9

    # Print the result for pstr2
    movq $choice_33_fmt, %rdi
    movq -24(%rbp), %rdx
    movq %r9, %rsi
    xorq %rax, %rax
    call printf  


    jmp .exit

.default_34:

    movq $default_fmt, %rdi 
    xorq %rax, %rax           
    call printf

    # Call pstrlen on pstr1
    movq -16(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r8

    # Print the result for pstr1
    movq $choice_33_fmt, %rdi
    movq -16(%rbp), %rdx
    movq %r8, %rsi
    xorq %rax, %rax
    call printf    

    # Call pstrlen on pstr2
    movq -24(%rbp), %rdi      
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r9

    # Print the result for pstr2
    movq $choice_33_fmt, %rdi
    movq -24(%rbp), %rdx
    movq %r9, %rsi
    xorq %rax, %rax
    call printf  
    
    jmp .exit

.default:
    movq $default_fmt, %rdi 
    xorq %rax, %rax           
    call printf
    jmp .exit

.exit:
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax

    ret
