.section .text
.global pstrlen
.type pstrlen, @function

pstrlen:
    movb 0(%rdi), %al         
    ret


.global swapCase
.type swapCase, @function
swapCase:
    # Save the dst pointer to %rax - the return value
    movq %rdi, %r9
    
    # The first byte is the unsigned char
    incq %rdi
    
.scloop:
    # Read byte from string
    movb (%rdi), %al
    # If we're at the end of the string, exit
    cmpb $0x0, %al
    je .sc_done

    # If the value of the byte is less then 'Z', it may be in caps
    cmpb $'Z', %al
    jle .sc_caps_or_not
    # If the value of the byte is greater then 'a' it may be lowercase
    cmpb $'a', %al
    jge .sc_lower_or_not

    # The character is not a letter, we won't change it
    jmp .sc_next


.sc_caps_or_not:
    # If the character is not between 'A' - 'Z' it's not a caps letter
    cmpb $'A',%al
    jl .sc_next
    # Adding 32 to a caps letter makes it lowercase, we then move it to the dest string
    addb $32, %al
    movb %al, (%rdi)
    jmp .sc_next

.sc_lower_or_not:
    # If the character is not between 'a' - 'z' it's not a caps letter
    cmpb $'z',%al
    jg .sc_next
    # subtracting 32 from a lowercase letter makes it caps, we then move it to the dest string
    subb $32, %al
    movb %al, (%rdi)
    jmp .sc_next
.sc_next:
    # Increment the pointer, and continue to sc_next iteration
    incq %rdi
    jmp .scloop

.sc_done:
    # making the return value the pointer to our pstr
    movq %r9, %rax
    ret



.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    # Save the dst pointer to %rax - the return value
    movq %rdi, %rax
    
    # The first byte is the unsigned char
    incq %rdi
    incq %rsi
    
    # Start from the i-th index, we will subtract i from j and use rcx as the counter
    addq %rdx, %rdi
    addq %rdx, %rsi
    subq %rdx, %rcx
    
.ij_loop:
    # Read byte from string
    movb (%rsi), %al

    # Swap the characters in the strings
    movb %al, (%rdi)

    # If we're at j, exit
    cmp $0, %rcx
    je .ij_done

.ij_next:
    # Increment the pointer, and continue to next iteration
    incq %rdi
    incq %rsi
    decq %rcx
    jmp .ij_loop

.ij_done:

    ret

