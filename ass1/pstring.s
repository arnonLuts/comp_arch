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

.loop:
    # Read byte from string
    movb (%rdi), %al

    # If we're at the end of the string, exit
    cmpb $0x0, %al
    je .done

    # If the byte is 'a', change it to 'B'
    cmpb $'Z', %al
    jle .caps_or_not

    cmpb $'a', %al
    jge .lower_or_not

    jmp .next


.caps_or_not:
    cmpb $'A',%al
    jl .next
    addb $32, %al
    movb %al, (%rdi)
    jmp .next

.lower_or_not:
    cmpb $'z',%al
    jg .next
    subb $32, %al
    movb %al, (%rdi)
    jmp .next
.next:
    # Increment the pointer, and continue to next iteration
    incq %rdi
    jmp .loop

.done:


    ret



.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:


