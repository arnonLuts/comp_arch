.section .text
.global pstrlen
.type pstrlen, @function

pstrlen:
    //debug
    movb 0(%rdi), %al         
    ret
