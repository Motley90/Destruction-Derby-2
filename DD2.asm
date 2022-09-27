format PE DLL
entry DllEntryPoint

include 'C:\Users\Robert\Desktop\Fasm, x86 ASM\INCLUDE\win32a.inc'

;=================== main ====================

section '.text' code readable executable

proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
        mov     eax,TRUE
        ret
endp
; Test
proc SetCar
        mov    eax, DWORD 0x467400      ; Race Car ID
        mov    BYTE [eax], 0x03         ; Unused car ID
       ret

endp

section '.edata' export data readable

export 'DD2.DLL', SetCar,'SetCar'

section '.reloc' fixups/fuckups data readable discardable

  if $=$$
    dd 0,8              ; if there are no fixups, generate dummy entry
  end if
