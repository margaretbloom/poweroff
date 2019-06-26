BITS 64

GLOBAL _start

SECTION .text

_start:
 ;Set the IOPL, only if greater than 0 (since 0 is the default)
%if IOPL > 0
 lea rsi, [rsp-80h]             ;We don't care about the pt_regs struct and we use the RED ZONE
 mov edi, IOPL                  ;IOPL to set
 mov eax, 172                  
 syscall                        ;Set iopl

 and eax, 0fh                   ;Just keep the last nibble, it can be 0 (success), 10 (invalid IOPL) or 15 (insufficient OS permissions)
 test eax, eax                  ;Test for errors
 mov edi, eax                   ;We exit with status 10 or 15 if the iopl syscall failed
 jnz .exit
%endif 

 ;Power off the PC
 mov dx, PM1a_CNT_BLK
 in eax, dx                     ;Read the current value
 and eax, 0ffffc003h            ;Clear SLP_TYP and SLP_EN
 or eax, (7 << 10) | (1 << 13)  ;Set SLP_TYP to 7 and SLP_EN to 1
 out dx, eax                    ;Power off

 ;This is just for safety, execution should STOP BEFORE arriving here. This exits the process with status
 ;0
 xor edi, edi

 ;Exit the process with a numerical status as specified in RDI
.exit:
 mov eax, 60
 syscall
