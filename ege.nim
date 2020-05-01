#[
    ege graphics library wrapper
    complie command:
        nim cpp ege.nim
]#

{.passL: "-lgraphics -lgdi32 -limm32 -lmsimg32 -lole32 -loleaut32 -lwinmm -luuid".}

proc closegraph*(){.importc:"closegraph", header:"graphics.h", cdecl.}
proc initgraph*(Width: cint; Height: cint; Flag: cint = 0x100){.cdecl, importc:"initgraph", header:"graphics.h", exportc, dynlib.}
proc initgraph*(gdriver: ptr cint; gmode: ptr cint; path: cstring) {.importc:"initgraph", header:"graphics.h", cdecl, exportc, dynlib.}
proc getch*(){.importc:"getch", header:"graphics.h", cdecl.}


#[

to do：
待完成:

]#

when isMainModule:
    initgraph(640,480)
    getch()
    closegraph()