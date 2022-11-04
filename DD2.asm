
;------------------------------------------------------------------------------------------------
;                       Destruction Derby 2
;                           10/01/2022
;                         Robert Rayner
;------------------------------------------------------------------------------------------------

format PE DLL
entry       DllEntryPoint

include 'C:\Users\Robert\Desktop\Fasm, x86 ASM\INCLUDE\win32a.inc'

message         db "Test",10,0
message2         db "Test 2",10,0
;=================== data ====================
section '.data' data readable writeable
startAddress    dd 0x467400                          ; The memory address we're starting to write from
patchBytes      db 0x03
patchSize       =  $ - patchBytes                      ; Holds the number of bytes we're going to write
patchResult     dd ?                                   ; Holds the number of successfully written bytes

ProcID                  dd ?
;=============================================

section '.text' code readable executable



proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
        mov     eax,TRUE
        ret
endp


proc race_car

      invoke MessageBox,0,message,NULL,MB_OK ; Test before memory calls

      invoke GetWindowThreadProcessId, eax, ProcID   ; Get the ProcessID via the window handle
      invoke OpenProcess, PROCESS_ALL_ACCESS, FALSE, [ProcID]  ; Open the process using PROCESS_ALL_ACCESS (0x1F0FFF) and get a handle
      mov dword[ProcID],eax                      ; move the handle to eax

      mov    eax, DWORD 0x467400      ; Race Car ID
      mov    BYTE [eax], 0x03         ; Unused car ID

      invoke MessageBox,0,message2,NULL,MB_OK ; Test after memory calls

      ret


endp

section '.idata' import data readable writeable

        library kernel32,'KERNEL32.DLL', user32,'USER32.DLL', msvcrt, 'msvcrt.dll'

          import       kernel32,\
                       OpenProcess,'OpenProcess',\
                       VirtualAllocEx, "VirtualAllocEx",\
                       WriteProcessMemory,'WriteProcessMemory'
          import       user32,\
                       FindWindow,'FindWindowA',\
                       GetWindowThreadProcessId,'GetWindowThreadProcessId',\
                       MessageBox,'MessageBoxA'
         import msvcrt, getchar, 'getchar', fopen, 'fopen', fclose, 'fclose', fgets, 'fgets', ftell, 'ftell', fseek, 'fseek', printf, 'printf', \
malloc, 'malloc', free, 'free', rewind, 'rewind'

section '.edata' export data readable

export 'DD2.DLL', race_car, 'race_car'

section '.reloc' fixups data readable discardable

  if $=$$
    dd 0,8              ; if there are no fixups, generate dummy entry
  end if
