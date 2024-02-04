.section .text
.global pstrlen
.type pstrlen, @function

pstrlen:
    movb 0(%rdi), %al         
    ret


.global swapCase
.type swapCase, @function
swapCase:
    # The first byte is the unsigned char
    incq %rdi

.scloop:
    # Read byte from string
    movb (%rdi), %al

    # If we're at the end of the string, exit
    cmpb $0x0, %al
    je .sc_done

    # If the byte is 'a', change it to 'B'
    cmpb $'Z', %al
    jle .sc_caps_or_not

    cmpb $'a', %al
    jge .sc_lower_or_not

    jmp .sc_next


.sc_caps_or_not:
    cmpb $'A',%al
    jl .sc_next
    addb $32, %al
    movb %al, (%rdi)
    jmp .sc_next

.sc_lower_or_not:
    cmpb $'z',%al
    jg .sc_next
    subb $32, %al
    movb %al, (%rdi)
    jmp .sc_next
.sc_next:
    # Increment the pointer, and continue to sc_next iteration
    incq %rdi
    jmp .scloop

.sc_done:
    ret



.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    # The first byte is the unsigned char
    incq %rdi
    incq %rsi
    # Start from the i-th index, we will subtract i from j and use rcx as the counter
    addq %rdx, %rdi
    addq %rdx, %rsi
    subq %rdx, %rcx
    
.ij_loop:
    # Read byte from string
    movb (%rdi), %al

    # Swap the characters in the strings
    movb %al, (%rsi)

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

