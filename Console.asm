
;------------------------------------------------------------------------------------------------
;                       Destruction Derby 2
;                           10/01/2022
;                         Robert Rayner
;------------------------------------------------------------------------------------------------

format PE console
entry start

include 'C:\Users\Robert\Desktop\Fasm, x86 ASM\INCLUDE\WIN32A.INC'
include 'C:\Users\Robert\Desktop\Fasm, x86 ASM\INCLUDE\cmd.inc'

section '.data' data readable writeable

WindowTitle             db 'PC-DD2',0;
hbuff                   dd ?
hhndl                   dd ?
fms                     db '%s',0
krnl                    db 'kernel32.dll',0
libr                    db 'LoadLibraryA',0
injd                    db 'C:\Users\Robert\Documents\Assembly Test\DD2\Test\DD2.DLL',0
szinjd = $ - injd
procid                  dd ?
procs                   dd ?
pages                   dd ?
thrid                   dd ?

section '.code' code readable executable

        start:

                cinvoke GetProcessHeap
                mov [hhndl],eax
                invoke HeapAlloc,[hhndl],HEAP_NO_SERIALIZE,1000h
                mov [hbuff],eax
                call GetMainArgs
                mov esi,[_argv]
                add esi,4
                cinvoke wsprintf,[hbuff],fms,[esi]

                invoke  FindWindow,NULL,WindowTitle
                invoke  GetWindowThreadProcessId,eax,procid
                invoke  OpenProcess,PROCESS_ALL_ACCESS,FALSE,[procid]

                mov [procs],eax
                cinvoke  VirtualAllocEx,eax,NULL,szinjd,MEM_COMMIT+MEM_RESERVE,PAGE_EXECUTE_READWRITE
                invoke race_car

                mov [pages],eax
                cinvoke  WriteProcessMemory,[procs],[pages],injd,szinjd,0

                invoke  GetModuleHandle,krnl
                invoke  GetProcAddress,eax,libr

                invoke  CreateRemoteThread,[procs],0,0,eax,[pages],0,thrid
                invoke  HeapFree,[hhndl],HEAP_NO_SERIALIZE,[hbuff]
                ret


section '.idata' import data readable

library kernel32,'kernel32.dll',\
        user32,'user32.dll',\
        DD2,'DD2.DLL'

import DD2, race_car, 'race_car'

import kernel32,\
       GetCommandLine,'GetCommandLineA',\
       GetProcessHeap,'GetProcessHeap',\
       HeapAlloc,'HeapAlloc',\
       HeapFree,'HeapFree',\
       OpenProcess,'OpenProcess',\
       VirtualAllocEx,'VirtualAllocEx',\
       WriteProcessMemory,'WriteProcessMemory',\
       GetModuleHandle,'GetModuleHandleA',\
       GetProcAddress,'GetProcAddress',\
       CreateRemoteThread,'CreateRemoteThread',\
       ExitProcess,'ExitProcess'

import user32,\
       MessageBox,'MessageBoxA',\
       wsprintf,'wsprintfA',\
       FindWindow,'FindWindowA',\
       GetWindowThreadProcessId,'GetWindowThreadProcessId'
