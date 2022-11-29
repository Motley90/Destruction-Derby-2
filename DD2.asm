
;------------------------------------------------------------------------------------------------
;                       Destruction Derby 2
;                           10/01/2022
;                         Robert Rayner
;------------------------------------------------------------------------------------------------

format    PE DLL
entry     race_car

include 'C:\Users\Robert\Desktop\Fasm, x86 ASM\INCLUDE\win32a.inc'

section '.data' data readable writeable

ProcID    dd ?


section '.text' code readable executable



proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
        mov     eax,TRUE
        ret
endp


proc race_car

        mov    eax, DWORD 0x467400      ; Race Car ID
        mov    BYTE [eax], 0x04        ; Unused car ID

      ret
endp

section '.edata' export data readable

export 'DD2.DLL', race_car, 'race_car'

section '.reloc' fixups data readable discardable

  if $=$$
    dd 0,8              ; if there are no fixups, generate dummy entry
  end if
