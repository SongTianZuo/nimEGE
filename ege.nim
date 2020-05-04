## EGE graphics library wrapper
##
##  使用前，先将 EGE 的头文件（graphics.h, ege.h, ege文件夹) 和 
##  对应的静态链接（libgraphics64.a 或 libgraphics.a）安装配置到MingW64/32中
##
##  before using, make sure EGE header files(graphics.h, ege.h, ege folder) and the 
##  corresponding static library(libgraphics64.a or libgraphics.a) copy into MingW64/32

#[
    ege graphics library wrapper
    complie command:
        nim cpp ege.nim
]#

when hostCPU == "amd64":
    {.passL: "-lgraphics64 -lgdi32 -limm32 -lmsimg32 -lole32 -loleaut32 -lwinmm -luuid".}
else:
    {.passL: "-lgraphics -lgdi32 -limm32 -lmsimg32 -lole32 -loleaut32 -lwinmm -luuid".}

const
    CW_USEDEFAULT* = (cast[cint](0x80000000))
    SHOWCONSOLE* = 1
    LF_FACESIZE* = 32

template RGBTOBGR*(color: untyped): untyped =
  ((((color) and 0x000000FF) shl 16) or (((color) and 0x00FF0000) shr 16) or
      ((color) and 0xFF00FF00))

template EGERGB*(r, g, b: untyped): untyped =
    ## EGERGB 宏用于通过红、绿、蓝颜色分量合成颜色。
    ## 
    ## The EGERGB macro is used to synthesize colors through red, green, and blue color components.
    ## 
    (((r) shl 16) or ((g) shl 8) or (b))

template EGERGBA*(r, g, b, a: untyped): untyped =
  (((r) shl 16) or ((g) shl 8) or (b) or ((a) shl 24))

template EGEARGB*(a, r, g, b: untyped): untyped =
  (((r) shl 16) or ((g) shl 8) or (b) or ((a) shl 24))

template EGEACOLOR*(a, color: untyped): untyped =
  (((color) and 0x00FFFFFF) or ((a) shl 24))

template EGECOLORA*(color, a: untyped): untyped =
  (((color) and 0x00FFFFFF) or ((a) shl 24))

template EGEGET_R*(c: untyped): untyped =
    ## EGEGET_R 宏用于返回指定颜色中的红色值。值的范围 0~255。
    ## 
    ## The EGEGET_R macro is used to return the red value in the specified color.Values range from 0 to 255.
    ## 
    (((c) shr 16) and 0x000000FF)

template EGEGET_G*(c: untyped): untyped =
    ## EGEGET_G 宏用于返回指定颜色中的绿色值。值的范围 0~255。
    ## 
    ## The EGEGET_G macro is used to return the green value in the specified color.Values range from 0 to 255.
    ## 
    (((c) shr 8) and 0x000000FF)

template EGEGET_B*(c: untyped): untyped =
    ## EGEGET_B 宏用于返回指定颜色中的蓝色值。值的范围 0~255。
    ## 
    ## The EGEGET_B macro is used to return the blue value in the specified color. Values range from 0 to 255.
    ## 
    (((c)) and 0x000000FF)

template EGEGET_A*(c: untyped): untyped =
  (((c) shr 24) and 0x000000FF)

template EGEGRAY*(gray: untyped): untyped =
  (((gray) shl 16) or ((gray) shl 8) or (gray))

template EGEGRAYA*(gray, a: untyped): untyped =
  (((gray) shl 16) or ((gray) shl 8) or (gray) or ((a) shl 24))

template EGEAGRAY*(a, gray: untyped): untyped =
  (((gray) shl 16) or ((gray) shl 8) or (gray) or ((a) shl 24))

type
    IMAGE = object
    PIMAGE* = ptr IMAGE
    
    rendermode_e* = enum
        RENDER_AUTO, RENDER_MANUAL
        
    initmode_flag* = enum
        INIT_DEFAULT = 0x00000000, INIT_NOBORDER = 0x00000001, INIT_CHILD = 0x00000002,
        INIT_TOPMOST = 0x00000004, INIT_RENDERMANUAL = 0x00000008,
        INIT_NOFORCEEXIT = 0x00000010, INIT_WITHLOGO = 0x00000100,
        INIT_ANIMATION = 0x00000118
        
    COLORS* = enum
        BLACK = 0, BLUE = EGERGB(0, 0, 0x000000A8), GREEN = EGERGB(0, 0x000000A8, 0),
        CYAN = EGERGB(0, 0x000000A8, 0x000000A8), 
        DARKGRAY = EGERGB(0x00000054, 0x00000054, 0x00000054),
        LIGHTBLUE = EGERGB(0x00000054, 0x00000054, 0x000000FC),
        LIGHTGREEN = EGERGB(0x00000054, 0x000000FC, 0x00000054),
        LIGHTCYAN = EGERGB(0x00000054, 0x000000FC, 0x000000FC),
        RED = EGERGB(0x000000A8, 0, 0),
        MAGENTA = EGERGB(0x000000A8, 0, 0x000000A8),
        BROWN = EGERGB(0x000000A8, 0x000000A8, 0),
        LIGHTGRAY = EGERGB(0x000000A8, 0x000000A8, 0x000000A8),        
        LIGHTRED = EGERGB(0x000000FC, 0x00000054, 0x00000054),
        LIGHTMAGENTA = EGERGB(0x000000FC, 0x00000054, 0x000000FC),
        YELLOW = EGERGB(0x000000FC, 0x000000FC, 0x00000054),
        WHITE = EGERGB(0x000000FC, 0x000000FC, 0x000000FC)
        
    color_t* = cuint
    
    wchar* = distinct int16
    
    
    LOGFONT* {.bycopy.} = object
        lfHeight*: clong
        lfWidth*: clong
        lfEscapement*: clong
        lfOrientation*: clong
        lfWeight*: clong
        lfItalic*: byte
        lfUnderline*: byte
        lfStrikeOut*: byte
        lfCharSet*: byte
        lfOutPrecision*: byte
        lfClipPrecision*: byte
        lfQuality*: byte
        lfPitchAndFamily*: byte
        lfFaceName*: array[LF_FACESIZE, char]

# environment
# 绘图环境相关函数
proc cleardevice*(pimg: PIMAGE = nil) {.importc:"cleardevice", header:"graphics.h", cdecl.}
    ## 这个函数用于清除画面内容。具体的，是用当前背景色清空画面。
    ##
    ## This function clears the contents of the screen.Specifically, 
    ## the screen is cleared with the current background color.
    ##
    ## **参数**
    ##
    ##  pimg: 指定要清除的PIMAGE，可选参数。如果不填本参数，则清除屏幕。
    ##
    ## **parameter**
    ##
    ##  pimg: specifies the PIMAGE to clear, an optional parameter.If you do not fill in this parameter, clear the screen.
    
proc clearviewport*(pimg: PIMAGE = nil) {.importc:"clearviewport", header:"graphics.h", cdecl.}
    ## 这个函数用于清空视图。相当于对视图区进行cleardevice。
    ##
    ## This function is used to empty the view.It is equivalent to cleardevice to the view area.
    ## 
    ## **参数**
    ##
    ##   pimg: 见setviewport
    ##
    ## **parameter**
    ##
    ##  pimg: see setviewport

proc closegraph*(){.importc:"closegraph", header:"graphics.h", cdecl.}
    ## 这个函数用于清空视图。相当于对视图区进行cleardevice。
    ## 
    ## This function is used to empty the view.It is equivalent to cleardevice to the view area.
    
proc initgraph*(Width: cint; Height: cint; Flag: cint = 0x00000100){.cdecl, importc:"initgraph", header:"graphics.h", exportc, dynlib.}
    ## 这个函数用于初始化绘图环境。
    ##
    ## This function is used to initialize the drawing environment.
    ##
    ## **参数**
    ##
    ##  Width: 绘图环境的宽度。如果为-1，则使用屏幕的宽度
    ##
    ##  Height: 绘图环境的高度。如果为-1，则使用屏幕的高度
    ##   
    ##  Style: 请留空，为保留参数 
    ##
    ## **parameter**
    ##
    ##  Width: Width of the drawing environment.If it is -1, the width of the screen is used
    ##
    ##  Height: The height of the drawing environment.If it is -1, the height of the screen is used
    ##
    ##  Style: Please leave blank as reserved parameter
    
proc initgraph*(gdriver: ptr cint; gmode: ptr cint; path: cstring) {.importc:"initgraph", header:"graphics.h", cdecl, exportc, dynlib.}
    ## 这个函数用于初始化绘图环境。
    ##
    ## This function is used to initialize the drawing environment.
    
proc gettarget*(): PIMAGE {.importc:"gettarget", header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前绘图对象。
    ## 
    ## This function is used to get the current drawing object.
    
proc getviewport*(pleft: ptr cint; ptop: ptr cint; pright: ptr cint; pbottom: ptr cint;
                 pclip: ptr cint = nil; pimg: PIMAGE = nil) {.importc:"getviewport", header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前视图信息。
    ## 
    ## This function is used to get the current view information.
    ##
    ## **参数**
    ## 
    ##  pleft: 返回当前视图的左部 x 坐标。
    ##
    ##  ptop: 返回当前视图的上部 y 坐标。
    ##
    ##  pright: 返回当前视图的右部 x 坐标。
    ##
    ##  pbottom: 返回当前视图的下部 y 坐标。
    ##
    ##  pclip: 返回当前视图的裁剪标志。
    ##
    ##  pimg: 详见setviewport的说明
    ##
    ## **parameter**
    ##
    ##  pleft: returns the left x coordinate of the current view.
    ##
    ##  ptop: returns the upper y coordinate of the current view.
    ##
    ##  pright: returns the right x-coordinate of the current view.
    ##
    ##  pbottom: returns the lower y coordinate of the current view.
    ##
    ##  pclip: returns the clipping flag for the current view.
    ##
    ##  pimg: see the setviewport for details
    
proc is_run*(): bool {.importc:"is_run", header:"graphics.h", cdecl.}
    ## 这个函数用于判断窗口是否还存在。
    ##
    ## This function is used to determine if the window still exists.
    ## 
    ## **返回值**
    ##
    ##  false: 表示窗口被关闭了
    ##
    ##  true: 表示窗口没有被关闭，程序还在运行
    ##
    ## **return**
    ##
    ##  false: window is closed
    ##
    ##  true: The window is not closed and the program is still running
    
proc setactivepage*(page: cint) {.importc:"setactivepage", header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前绘图页。
    ## 
    ## This function sets the current drawing page.
    ## 
    ## **参数**
    ## 
    ##  page: 绘图页，范围从，范围从0-3，越界会导致程序错误。默认值为0
    ## 
    ## **parameter**
    ## 
    ##  Page: drawing page, range from, range from 0 to 3. Overstepping the bounds causes program errors.The default value is 0
    ## 

proc setcaption*(caption: cstring) {.importc:"setcaption", header:"graphics.h", cdecl.}
    ## 这个函数用设置窗口标题。
    ## 
    ## This function sets the window title.
    ## 
    ## **参数**
    ## 
    ##  caption: 指定要设置的标题字符串。
    ## 
    ## **parameter**
    ## 
    ##  caption: specifies the title string to set.
    ## 

proc setcaption*(caption: WideCString ) {.importc:"setcaption", header:"graphics.h", cdecl.}
    ## 这个函数用设置窗口标题。
    ## 
    ## This function sets the window title.
    ## 
    ## **参数**
    ## 
    ##  caption: 指定要设置的标题字符串。
    ## 
    ## **parameter**
    ## 
    ##  caption: specifies the title string to set.
    ## 

proc setinitmode*(mode: cint; x: cint = CW_USEDEFAULT; y: cint = CW_USEDEFAULT)  {.importc:"setinitmode", header:"graphics.h", cdecl.}
    ## 这个函数用于设置初始化图形的选项和模式。
    ## 
    ## This function sets the options and modes for initializing the graph.
    ## 
    ## **参数**
    ## 
    ##  mode
    ## 
    ##   初始化模式，是二进制组合的值。如果为INIT_DEFAULT 表示使用默认值。
    ## 
    ##   可以使用的值的组合：
    ## 
    ##    INIT_NOBORDER 为无边框窗口
    ## 
    ##    INIT_CHILD 为子窗口（需要使用attachHWND指定要依附的父窗口，此函数不另说明）
    ## 
    ##    INIT_TOPMOST 使窗口总在最前
    ## 
    ##    INIT_RENDERMANUAL 手动更新标志，即调用delay_fps/delay_ms等会等待操作的函数时会更新窗口，否则保持窗口内容
    ## 
    ##    INIT_WITHLOGO 使initgraph的时候显示开场动画logo
    ## 
    ##    INIT_NOFORCEEXIT 使关闭窗口的时候不强制退出程序，但窗口会消失，需要配合is_run函数
    ## 
    ##    INIT_DEFAULT 默认参数，不调用本函数时即使用此参数
    ## 
    ##    INIT_ANIMATION 是INIT_DEFAULT, INIT_RENDERMANUAL, INIT_NOFORCEEXIT的组合，用于动画编写
    ## 
    ##  x, y
    ## 
    ##   初始化时窗口左上角在屏幕的坐标，默认为系统分配。
    ## 
    ## **parameter**
    ## 
    ##  mode
    ## 
    ##   The initialization mode is a binary combination of values.If INIT_DEFAULT is used, the default value is used.
    ## 
    ##   Combination of values that can be used:
    ## 
    ##    INIT_NOBORDER is an unbordered window
    ## 
    ##    INIT_CHILD is the child window (use attachHWND to specify the parent window to attach to, this function does not specify otherwise)
    ## 
    ##    INIT_TOPMOST keeps the window at the top
    ## 
    ##    INIT_RENDERMANUAL manually updates the flag, meaning that the window is updated when a function such as delay_fps/delay_ms is called that waits for an operation, otherwise the window contents are preserved
    ## 
    ##    INIT_WITHLOGO causes the initgraph to display the opening animation logo
    ## 
    ##    INIT_NOFORCEEXIT allows you to close the window without forcing you to exit the program, but the window disappears, so you need to cooperate with the is_run function
    ## 
    ##    INIT_DEFAULT parameter, which is used when this function is not called
    ## 
    ##    INIT_ANIMATION is a combination of INIT_DEFAULT, INIT_RENDERMANUAL, and INIT_NOFORCEEXIT for animation
    ## 
    ##  x, y,
    ## 
    ##   The coordinates of the upper left corner of the window on the screen when initialized, which are assigned by default to the system.
    ## 

proc setrendermode*(mode: rendermode_e) {.importc:"setrendermode", header:"graphics.h", cdecl.}
    ## 这个函数用于设置更新窗口的模式，模式有两种，自动更新和手动更新。
    ## 
    ## This function sets the mode of the update window. There are two modes, automatic and manual.
    ## 
    ## **参数**
    ## 
    ##  mode
    ## 
    ##   值可能为 RENDER_AUTO 或者 RENDER_MANUAL ，前者自动（默认值），后者手动
    ## 
    ##   自动模式用于简单绘图，手动模式用于制作动画或者游戏
    ## 
    ##   所谓手动模式，即需要调用delay_fps/delay_ms等带有等待特性的函数时才会更新窗口
    ## 
    ## **parameter**
    ## 
    ##  mode
    ## 
    ##   The value may be RENDER_AUTO or RENDER_MANUAL, with the former automatically (the default) and the latter manually
    ## 
    ##   Auto mode for simple drawing, manual mode for animation or game
    ## 
    ##   In manual mode, the window is not updated until a function with the wait feature, such as delay_fps/delay_ms, is called
    ## 

proc settarget*(pbuf: PIMAGE = nil) {.importc:"settarget", header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前绘图对象。
    ## 
    ## This function is used to set the current drawing object.
    ## 
    ## **参数**
    ## 
    ##  pbuf: 绘图对象，为PIMAGE类型，你要绘画到的PIMAGE，如果不填，则还原为窗口
    ## 
    ## **parameter**
    ## 
    ##  pbuf: drawing object, is the PIMAGE type, you want to draw to the PIMAGE, if you do not fill, restore to the window
    ## 

proc setviewport*(left: cint; top: cint; right: cint; bottom: cint; clip: cint = 1;
                 pimg: PIMAGE = nil) {.importc:"setviewport", header:"graphics.h", cdecl.}
        ## 这个函数用于设置当前视图。并且，将坐标原点移动到新的视图的 (0, 0) 位置。
    ## 
    ## This function is used to set the current view.Also, move the origin of coordinates to the (0, 0) position of the new view.
    ## 
    ## **参数**
    ## 
    ##  left: 视图的左部 x 坐标。
    ## 
    ##  top: 视图的上部 y 坐标。(left, top) 将成为新的原点。
    ## 
    ##  right: 视图的右部 x 坐标。
    ## 
    ##  bottom: 视图的下部 y 坐标。（right-1, bottom-1) 是视图的右下角坐标。
    ## 
    ##  clip: 视图的裁剪标志。如果为真，所有超出视图区域的绘图都会被裁剪掉。
    ## 
    ##  pimg: 要设置的图片
    ## 
    ## **parameter**
    ## 
    ##  left: the left x coordinate of the view.
    ## 
    ##  top: the top y coordinate of the view.(left, top) will be the new origin.
    ## 
    ##  right: the right x-coordinate of the view.
    ## 
    ##  bottom: the lower y coordinate of the view.(right-1, bottom-1) is the coordinate at the bottom right corner of the view.
    ## 
    ##  clip: clipping flag for the view.If true, all drawings outside the view area are clipped.
    ## 
    ##  pimg: image to set
    ## 

proc setvisualpage*(page: cint) {.importc:"setvisualpage", header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前显示页，显示页是输出到窗口的页。
    ## 
    ## This function sets the current display page, which is the page output to the window.
    ## 
    ## **参数**
    ## 
    ##  page: 绘图页，范围从，范围从0-3，越界会导致程序错误。默认值为0
    ## 
    ## **parameter**
    ## 
    ##  page: drawing page, range from, range from 0 to 3. Overstepping the bounds causes program errors.The default value is 0
    ## 

proc window_getviewport*(pleft: ptr cint; ptop: ptr cint; pright: ptr cint;
                        pbottom: ptr cint) {.importc:"window_getviewport", header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前窗口可见区域。
    ## 
    ## This function is used to get the visible area of the current window.
    ## 
    ## **参数**
    ## 
    ##  pleft: 返回当前视图的左部 x 坐标。
    ## 
    ##  ptop: 返回当前视图的上部 y 坐标。
    ## 
    ##  pright: 返回当前视图的右部 x 坐标。
    ## 
    ##  pbottom: 返回当前视图的下部 y 坐标。
    ## 
    ## **parameter**
    ## 
    ##  pleft: returns the left x coordinate of the current view.
    ## 
    ##  ptop: returns the upper y coordinate of the current view.
    ## 
    ##  pright: returns the right x-coordinate of the current view.
    ## 
    ##  pbottom: returns the lower y coordinate of the current view.
    ## 

proc window_setviewport*(left: cint; top: cint; right: cint; bottom: cint)  {.importc:"window_setviewport", header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前窗口可见区域。
    ## 
    ## This function sets the visible area of the current window.
    ## 
    ## **参数**
    ## 
    ##  left: 可见区域的左部 x 坐标。
    ## 
    ##  top: 可见区域的上部 y 坐标。(left, top) 将成为新的原点。
    ## 
    ##  right: 可见区域的右部 x 坐标。
    ## 
    ##  bottom: 可见区域的下部 y 坐标。（right-1, bottom-1) 是视图的右下角坐标。
    ## 
    ## **parameter**
    ## 
    ##  left: the left x coordinate of the visible region.
    ## 
    ##  top: the upper y coordinate of the visible region.(left, top) will be the new origin.
    ## 
    ##  right: the x-coordinate of the right part of the visible region.
    ## 
    ##  bottom: the lower y coordinate of the visible region.(right-1, bottom-1) is the coordinate at the bottom right corner of the view.
    ## 

# colors
# 颜色表示及相关函数
proc getbkcolor*(pimg: PIMAGE = nil): color_t {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前绘图背景色。
    ## 
    ## This function is used to get the current drawing background color.
    ## 
    ## **返回值**
    ## 
    ##  返回当前绘图背景色。
    ## 
    ## **return**
    ## 
    ##  Returns the current drawing background color.
    ## 

proc getcolor*(pimg: PIMAGE = nil): color_t {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前绘图前景色。
    ## 
    ## This function is used to get the current drawing foreground.
    ## 

proc getfillcolor*(pimg: PIMAGE = nil): color_t {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前绘图填充色。
    ## 
    ## This function is used to get the current drawing fill color.
    ## 

proc hsl2rgb*(H: cfloat; S: cfloat; L: cfloat): color_t {.importc, header:"graphics.h", cdecl.}
    ## 该函数用于转换 HSL 颜色为 RGB 颜色。
    ## 
    ## This function is used to convert HSL color to RGB color.
    ##
    ## **参数** 
    ## 
    ##  H
    ## 
    ##  原 HSL 颜色模型的 Hue(色相) 分量，0 ≤ H ＜ 360。
    ## 
    ##  S
    ## 
    ##  原 HSL 颜色模型的 Saturation(饱和度) 分量，0 ≤ S ≤ 1。
    ## 
    ##  L
    ## 
    ##  原 HSL 颜色模型的 Lightness(亮度) 分量，0 ≤ L ≤ 1。
    ## 
    ## **parameter**
    ## 
    ##  H.
    ## 
    ##  Hue(Hue) component of the original HSL color model, 0 ≤ H < 360.
    ## 
    ##  s.
    ## 
    ##  The Saturation component of the original HSL color model is 0 ≤ S ≤ 1.
    ## 
    ##  L
    ## 
    ##  The Lightness of an HSL color model (brightness) component, 0 ≤ L ≤ 1。
    ## 
    
    
proc hsv2rgb*(H: cfloat; S: cfloat; V: cfloat): color_t {.importc, header:"graphics.h", cdecl.}
    ## 该函数用于转换 HSV 颜色为 RGB 颜色。
    ## 
    ## This function is used to convert HSV color to RGB color.
    ## 
    ## **参数** 
    ## 
    ##  H
    ## 
    ##  原 HSL 颜色模型的 Hue(色相) 分量，0 ≤ H ＜ 360。
    ## 
    ##  S
    ## 
    ##  原 HSL 颜色模型的 Saturation(饱和度) 分量，0 ≤ S ≤ 1。
    ## 
    ##  V
    ## 
    ##  原 HSL 颜色模型的 Value(明度) 分量，0 ≤ L ≤ 1。
    ## 
    ## **parameter**
    ## 
    ##  H.
    ## 
    ##  Hue(Hue) component of the original HSL color model, 0 ≤ H < 360.
    ## 
    ##  s.
    ## 
    ##  The Saturation component of the original HSL color model is 0 ≤ S ≤ 1.
    ## 
    ##  V
    ## 
    ##  The Value(lightness) component of the original HSL color model is 0 ≤ L ≤ 1.
    ## 

proc rgb2gray*(rgb: color_t): color_t {.importc, header:"graphics.h", cdecl.}
    ## 该函数用于返回与指定颜色对应的灰度值颜色。
    ## 
    ## This function returns the color of the grayscale value corresponding to the specified color.
    ## 
    
#[
proc rgb2gray*(rgb: COLORS): color_t =
    ## 详见 rgb2gray(rgb: color_t)
    ##
    ## see rgb2gray(rgb: color_t)
    rgb2gray(cast[color_t](rgb))
]#
    
proc rgb2hsl*(rgb: color_t; H: ptr cfloat; S: ptr cfloat; L: ptr cfloat) {.importc, header:"graphics.h", cdecl.}
    ## 该函数用于转换 RGB 颜色为 HSL 颜色。
    ## 
    ## This function is used to convert RGB color to HSL color.
    ## 
    ## **参数** 
    ## 
    ##  rgb
    ## 
    ##  原 RGB 颜色。
    ## 
    ##  H
    ## 
    ##  原 HSL 颜色模型的 Hue(色相) 分量，0 ≤ H ＜ 360。
    ## 
    ##  S
    ## 
    ##  原 HSL 颜色模型的 Saturation(饱和度) 分量，0 ≤ S ≤ 1。
    ## 
    ##  L
    ## 
    ##  原 HSL 颜色模型的 Lightness(亮度) 分量，0 ≤ L ≤ 1。
    ## 
    ## **parameter**
    ## 
    ##  rgb
    ## 
    ##  Original RGB color.
    ## 
    ##  H.
    ## 
    ##  Hue(Hue) component of the original HSL color model, 0 ≤ H < 360.
    ## 
    ##  s.
    ## 
    ##  The Saturation component of the original HSL color model is 0 ≤ S ≤ 1.
    ## 
    ##  L
    ## 
    ##  The Lightness of an HSL color model (brightness) component, 0 ≤ L ≤ 1。
    ## 

#[
proc rgb2hsl*(rgb: COLORS; H: ptr cfloat; S: ptr cfloat; L: ptr cfloat) =
    ## 详见 rgb2hsl(rgb: color_t; H: ptr cfloat; S: ptr cfloat; L: ptr cfloat)
    ##
    ## see rgb2hsl(rgb: color_t; H: ptr cfloat; S: ptr cfloat; L: ptr cfloat)
    rgb2hsl(cast[color_t](rgb), H, S, L)
 ]#
 
proc rgb2hsv*(rgb: color_t; H: ptr cfloat; S: ptr cfloat; V: ptr cfloat) {.importc, header:"graphics.h", cdecl.}
    ## 该函数用于转换 RGB 颜色为 HSV 颜色。
    ## 
    ## This function is used to convert RGB color to HSV color.
    ## 
    ## **参数** 
    ## 
    ##  rgb
    ## 
    ##  原 RGB 颜色。
    ## 
    ##  H
    ## 
    ##  原 HSL 颜色模型的 Hue(色相) 分量，0 ≤ H ＜ 360。
    ## 
    ##  S
    ## 
    ##  原 HSL 颜色模型的 Saturation(饱和度) 分量，0 ≤ S ≤ 1。
    ## 
    ##  V
    ## 
    ##  原 HSL 颜色模型的 Value(明度) 分量，0 ≤ L ≤ 1。
    ## 
    ## **parameter**
    ## 
    ##  rgb
    ## 
    ##  Original RGB color.
    ## 
    ##  H.
    ## 
    ##  Hue(Hue) component of the original HSL color model, 0 ≤ H < 360.
    ## 
    ##  s.
    ## 
    ##  The Saturation component of the original HSL color model is 0 ≤ S ≤ 1.
    ## 
    ##  V
    ## 
    ##  The Value(lightness) component of the original HSL color model is 0 ≤ L ≤ 1.
    ## 

#[
proc rgb2hsv*(rgb: COLORS; H: ptr cfloat; S: ptr cfloat; V: ptr cfloat)=
    ## 详见 rgb2hsv(rgb: color_t; H: ptr cfloat; S: ptr cfloat; V: ptr cfloat)
    ##
    ## See rgb2hsv(rgb: color_t; H: ptr cfloat; S: ptr cfloat; V: ptr cfloat)
    rgb2hsv(cast[color_t](rgb), H, S, V)
]#
    
proc setbkcolor*(color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前背景色。并且会把当前图片上是原背景色的像素，转变为新的背景色。
    ## 
    ## This function is used to set the current background color.And will be the current image is the original background color pixels, the new background color.
    ## 
    ## **参数** 
    ## 
    ##  color
    ## 
    ##  指定要设置的背景颜色。注意，该设置会同时影响文字背景色。
    ## 
    ## **parameter**
    ## 
    ##  color
    ## 
    ##  Specifies the background color to set.Note that this setting also affects the text background color.
    ## 

#[
proc setbkcolor*(color: COLORS; pimg: PIMAGE = nil)=
    ## 详见 setbkcolor(color: color_t; pimg: PIMAGE = nil)
    ## 
    ## See setbkcolor(color: color_t; pimg: PIMAGE = nil)
    setbkcolor(cast[color_t](color), pimg)
 ]#
    
proc setbkcolor_f*(color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 设置清屏时所用的背景色。
    ## 即仅设置cleardevice时所使用的颜色，不立即生效，需要等cleardevice调用。 
    ##
    ## Sets the background color to use when clearing the screen。
    ## That is, only the color used when setting cleardevice does not take effect immediately, so you need to wait for cleardevice call.
    ##

#[    
proc setbkcolor_f*(color: COLORS; pimg: PIMAGE = nil)=
    ## 详见 setbkcolor_f(color: color_t; pimg: PIMAGE = nil)
    ## 
    ## See setbkcolor_f(color: color_t; pimg: PIMAGE = nil)
    setbkcolor_f(cast[color_t](color), pimg)
]#

proc setbkmode*(iBkMode: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置输出文字时的背景模式。
    ## 
    ## This function sets the background mode for the output text.
    ## 
    ## **参数** 
    ## 
    ##  iBkMode
    ## 
    ##  指定输出文字时的背景模式，可以是以下值：
    ## 
    ##   OPAQUE值：	背景用当前背景色填充（默认）。
    ## 
    ##   TRANSPARENT：	背景是透明的。
    ## 
    ## **parameter**
    ## 
    ##  iBkMode
    ## 
    ##  Specifies the background mode for the output text, which can be the following:
    ## 
    ##   OPAQUE：   The background is filled with the current background color (default).
    ## 
    ##   TRANSPARENT： The background is transparent.
    ## 

proc setcolor*(color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置绘图前景色。
    ## 
    ## This function is used to set the drawing foreground.
    ## 

#[    
proc setcolor*(color: COLORS; pimg: PIMAGE = nil)=
    ## 详见 setcolor(color: color_t; pimg: PIMAGE = nil)
    ##
    ## See setcolor(color: color_t; pimg: PIMAGE = nil)
    setcolor(cast[color_t](color), pimg)
 ]#
 
proc setfillcolor*(color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置绘图填充色。
    ## 
    ## This function is used to set the drawing fill color.
    ## 
    
#[    
proc setfillcolor*(color: COLORS; pimg: PIMAGE = nil)=
    ## 详见 setfillcolor(color: color_t; pimg: PIMAGE = nil)
    ##
    ## See setfillcolor(color: color_t; pimg: PIMAGE = nil)
    setfillcolor(cast[color_t](color), pimg)
]#
    
proc setfontbkcolor*(color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置文字背景色。
    ## 
    ## This function is used to set the text background color.
    ## 

#[    
proc setfontbkcolor*(color: COLORS; pimg: PIMAGE = nil)=
    ## 详见 setfontbkcolor(color: color_t; pimg: PIMAGE = nil)
    ##
    ## See setfontbkcolor(color: color_t; pimg: PIMAGE = nil)
    setfontbkcolor(cast[color_t](color), pimg)
]#

    


proc getch*():cint{.importc:"getch", header:"graphics.h", cdecl.}
    ## 这个函数用于获取键盘字符输入，如果当前没有输入，则等待。
    ## 
    ## This function is used to get keyboard character input and to wait if none is currently entered.
    ## 
    ## **返回值**
    ## 
    ##  如果存在键盘字符输入，返回按键键码；否则不返回一直等待。
    ## 
    ## **return**
    ## 
    ##  If there is keyboard character input, return the key code;Otherwise do not return and wait.
    ## 
    
proc arc*(x: cint; y: cint; stangle: cint; endangle: cint; radius: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc arcf*(x: cfloat; y: cfloat; stangle: cfloat; endangle: cfloat; radius: cfloat;
          pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画圆弧。边线颜色由setcolor函数决定
    ##
    ## **参数**
    ##  x
    ##
    ##  圆弧的圆心 x 坐标。
    ##
    ##  y
    ##
    ##  圆弧的圆心 y 坐标。
    ##
    ##  stangle
    ##
    ##  圆弧的起始角的角度。
    ##
    ##  endangle
    ##
    ##  圆弧的终止角的角度。
    ##
    ##  radius
    ##
    ##  圆弧的半径。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc bar*(left: cint; top: cint; right: cint; bottom: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画无边框填充矩形。其中，填充颜色由setfillstyle函数决定
    ##
    ## **参数**
    ##  left
    ##
    ##  矩形左部 x 坐标。
    ##
    ##  top
    ##
    ##  矩形上部 y 坐标。
    ##
    ##  right
    ##
    ##  矩形右部 x 坐标（该点取不到，实际右边界为right-1）。
    ##
    ##  bottom
    ##
    ##  矩形下部 y 坐标（该点取不到，实际下边界为bottom-1）。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc bar3d*(left: cint; top: cint; right: cint; bottom: cint; depth: cint; topflag: bool;
           pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画有边框三维填充矩形。其中，填充颜色由setfillstyle函数决定
    ##
    ## **参数**
    ##  left
    ##
    ##  矩形左部 x 坐标。
    ##
    ##  top
    ##
    ##  矩形上部 y 坐标。
    ##
    ##  right
    ##
    ##  矩形右部 x 坐标（该点取不到，实际右边界为right-1）。
    ##
    ##  bottom
    ##
    ##  矩形下部 y 坐标（该点取不到，实际下边界为bottom-1）。
    ##
    ##  depth
    ##
    ##  矩形深度。
    ##
    ##  topflag
    ##
    ##  为 false 时，将不画矩形的三维顶部。该选项可用来画堆叠的三维矩形。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  #include "graphics.h"
    ##
    ##  int main()
    ##
    ##  {
    ##
    ##      initgraph(600, 400);
    ##
    ##      setfillstyle(RED);
    ##
    ##      bar3d(100, 100, 150, 150, 20, 1);
    ##
    ##      getch();
    ##
    ##      return 0;
    ##
    ##  }
    ##  示例效果：
    ##
    ##
    ##
    ##

proc circle*(x: cint; y: cint; radius: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc circlef*(x: cfloat; y: cfloat; radius: cfloat; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画圆。此圆是空心的，不填充，而边线颜色由setcolor函数决定
    ##
    ## **参数**
    ##  x
    ##
    ##  圆的圆心 x 坐标。
    ##
    ##  y
    ##
    ##  圆的圆心 y 坐标。
    ##
    ##  radius
    ##
    ##  圆的半径。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc drawbezier*(numpoints: cint; polypoints: ptr cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画bezier曲线。边线颜色由setcolor函数决定
    ##
    ## **参数**
    ##  numpoints
    ##
    ##  多边形点的个数，需要是被3除余1的数，如果不是，则忽略最后面若干个点。
    ##
    ##  polypoints
    ##
    ##  每个点的坐标（依次两个分别为x,y），数组元素个数为 numpoints * 2。
    ##
    ##  每一条bezier曲线由两个端点和两个控制点组成，相邻两条则共用端点。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc drawlines*(numliness: cint; polypoints: ptr cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画多条线段。边线颜色由setcolor函数决定
    ##
    ## **参数**
    ##  numlines
    ##
    ##  线段数目。
    ##
    ##  polypoints
    ##
    ##  每个点的坐标（依次两个分别为x,y），数组元素个数为 numlines * 4。
    ##
    ##  每两个点画一线段。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc drawpoly*(numliness: cint; polypoints: ptr cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画多边形。边线颜色由setcolor函数决定
    ##
    ## **参数**
    ##  numpoints
    ##
    ##  多边形点的个数。
    ##
    ##  polypoints
    ##
    ##  每个点的坐标（依次两个分别为x,y），数组元素个数为 numpoints * 2。
    ##
    ##  该函数并不会自动连接多边形首尾。如果需要画封闭的多边形，请将最后一个点设置为与第一点相同。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc ellipse*(x: cint; y: cint; stangle: cint; endangle: cint; xradius: cint;
             yradius: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc ellipsef*(x: cfloat; y: cfloat; stangle: cfloat; endangle: cfloat; xradius: cfloat;
              yradius: cfloat; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画椭圆弧线。边线颜色由setcolor函数决定
    ##
    ## **参数**
    ##  x
    ##
    ##  椭圆弧线的圆心 x 坐标。
    ##
    ##  y
    ##
    ##  椭圆弧线的圆心 y 坐标。
    ##
    ##  stangle
    ##
    ##  椭圆弧线的起始角的角度。
    ##
    ##  endangle
    ##
    ##  椭圆弧线的终止角的角度。
    ##
    ##  xradius
    ##
    ##  椭圆弧线的 x 轴半径。
    ##
    ##  yradius
    ##
    ##  椭圆弧线的 y 轴半径。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc fillellipse*(x: cint; y: cint; xradius: cint; yradius: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc fillellipsef*(x: cfloat; y: cfloat; xradius: cfloat; yradius: cfloat;
                  pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画填充的椭圆。边线颜色由setcolor函数决定，填充颜色由setfillstyle函数决定。
    ##
    ## **参数**
    ##  x
    ##
    ##  椭圆的圆心 x 坐标。
    ##
    ##  y
    ##
    ##  椭圆的圆心 y 坐标。
    ##
    ##  xradius
    ##
    ##  椭圆的 x 轴半径。
    ##
    ##  yradius
    ##
    ##  椭圆的 y 轴半径。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc fillpoly*(numpoints: cint; polypoints: ptr cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画填充的多边形。边线颜色由setcolor函数决定，填充颜色由setfillstyle函数决定
    ##
    ## **参数**
    ##  numpoints
    ##
    ##  多边形点的个数。
    ##
    ##  polypoints
    ##
    ##  每个点的坐标，数组元素个数为 numpoints * 2。
    ##
    ##  该函数会自动连接多边形首尾。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  说明：
    ##
    ##  如果这个多边形发生自相交，那么自交次数为奇数的区域则不填充，偶数次的填充，不自交就是偶数次。不过这样说明相信非常难理解，以下给个例子：
    ##
    ##  #include "graphics.h"
    ##
    ##  int main()
    ##
    ##  {
    ##
    ##      initgraph(600, 400);
    ##
    ##      setfillstyle(RED);
    ##
    ##      int pt[] = {
    ##
    ##          0,   0,
    ##
    ##          100, 0,
    ##
    ##          100, 100,
    ##
    ##          10,  10,
    ##
    ##          90,  10,
    ##
    ##          0,   100,
    ##
    ##      };
    ##
    ##      fillpoly(6, pt);
    ##
    ##      getch();
    ##
    ##      return 0;
    ##
    ##  }
    ##  运行结果：
    ##
    ##  第二个例子：
    ##
    ##  #include "graphics.h"
    ##
    ##  int main()
    ##
    ##  {
    ##
    ##      initgraph(600, 400);
    ##
    ##      setfillstyle(RED);
    ##
    ##      int pt[] = {
    ##
    ##          0,   0,
    ##
    ##          100, 0,
    ##
    ##          100, 100,
    ##
    ##          0,   100,
    ##
    ##          0,   0,
    ##
    ##          100, 0,
    ##
    ##          100, 120,
    ##
    ##          0,   100,
    ##
    ##      };
    ##
    ##      fillpoly(8, pt);
    ##
    ##      getch();
    ##
    ##      return 0;
    ##
    ##  }
    ##  运行结果：
    ##
    ##
    ##
    ##

proc floodfill*(x: cint; y: cint; border: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数使用setfillstyle设置的填充方式对区域进行填充。填充颜色由setfillstyle函数决定。
    ##
    ## **参数**
    ##  x
    ##
    ##  填充的起始点 x 坐标。
    ##
    ##  y
    ##
    ##  填充的起始点 y 坐标。
    ##
    ##  border
    ##
    ##  填充的边界颜色。填充动作在该颜色围成的区域内填充。如果该颜色围成的区域不封闭，那么将使全屏幕都填充上。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc floodfillsurface*(x: cint; y: cint; areacolor: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数使用setfillstyle设置的填充方式对区域进行填充。填充颜色由setfillstyle函数决定。
    ##
    ## **参数**
    ##  x
    ##
    ##  填充的起始点 x 坐标。
    ##
    ##  y
    ##
    ##  填充的起始点 y 坐标。
    ##
    ##  areacolor
    ##
    ##  填充区域的原本颜色。等于该颜色且与起始点相连所构成的区域，由setfillcolor所设置的颜色来填充。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##



proc getheight*(pimg: PIMAGE = nil): cint {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取图片高度。
    ##
    ## **参数**
    ##  （无）
    ##
    ##
    ## **返回值**
    ##  返回图片高度。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc getlinestyle*(plinestyle: ptr cint; pupattern: ptr cushort = nil;
                  pthickness: ptr cint = nil; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前线形。
    ##
    ## **参数**
    ##  plinestyle
    ##
    ##  返回当前线型。详见 setlinestyle。
    ##
    ##  pupattern
    ##
    ##  返回当前自定义线形数据。
    ##
    ##  pthickness
    ##
    ##  返回当前线形宽度。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc getpixel*(x: cint; y: cint; pimg: PIMAGE = nil): color_t {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取像素点的颜色。
    ##
    ## **参数**
    ##  x
    ##
    ##  要获取颜色的 x 坐标。
    ##
    ##  y
    ##
    ##  要获取颜色的 y 坐标。
    ##
    ##
    ## **返回值**
    ##  指定点的颜色。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  其它说明：另有高速版的getpixel_f函数，参数一样，作用一样，但不进行相对坐标变换和边界检查（如果越界绘图，要么画错地方，要么程序结果莫名其妙，甚至直接崩溃），并且必须在批量绘图模式下才能使用，否则将发生不可预知的结果。
    ##
    ##
    ##
    ##

proc getwidth*(pimg: PIMAGE = nil): cint {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取图片宽度。
    ##
    ## **参数**
    ##  （无）
    ##
    ##
    ## **返回值**
    ##  返回图片宽度。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc getx*(pimg: PIMAGE = nil): cint {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前 x 坐标。
    ##
    ## **参数**
    ##  （无）
    ##
    ##
    ## **返回值**
    ##  返回当前 x 坐标。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc gety*(pimg: PIMAGE = nil): cint {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前 y 坐标。
    ##
    ## **参数**
    ##  （无）
    ##
    ##
    ## **返回值**
    ##  返回当前 y 坐标。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc line*(x1: cint; y1: cint; x2: cint; y2: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画线。
    ##
    ## **参数**
    ##  x1
    ##
    ##  线的起始点的 x 坐标。
    ##
    ##  y1
    ##
    ##  线的起始点的 y 坐标。
    ##
    ##  x2
    ##
    ##  线的终止点的 x 坐标（该点本身画不到）。
    ##
    ##  y2
    ##
    ##  线的终止点的 y 坐标（该点本身画不到）。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  其它说明：另有高速版的line_f函数，参数一样，作用一样，但不进行相对坐标变换和边界检查（如果越界绘图，要么画错地方，要么程序结果莫名其妙，甚至直接崩溃），并且必须在窗口锁定绘图模式下才能使用，否则将发生不可预知的结果。
    ##
    ##
    ##
    ##

proc linerel*(dx: cint; dy: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画线。
    ##
    ## **参数**
    ##  dx
    ##
    ##  从“当前点”cx开始画线，沿 x 轴偏移 dx，终点为cx+dx（终点本身画不到）。
    ##
    ##  dy
    ##
    ##  从“当前点”cy开始画线，沿 y 轴偏移 dy，终点为cy+dy（终点本身画不到）。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  其它说明：另有高速版的linerel_f函数，参数一样，作用一样，但不进行相对坐标变换和边界检查（如果越界绘图，要么画错地方，要么程序结果莫名其妙，甚至直接崩溃），并且必须在窗口锁定绘图模式下才能使用，否则将发生不可预知的结果。
    ##
    ##
    ##
    ##

proc lineto*(x: cint; y: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画线。
    ##
    ## **参数**
    ##  x
    ##
    ##  从“当前点”开始画线，终点横坐标为 x （终点本身画不到）。
    ##
    ##  y
    ##
    ##  从“当前点”开始画线，终点纵坐标为 y （终点本身画不到）。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  其它说明：另有高速版的lineto_f函数，参数一样，作用一样，但不进行相对坐标变换和边界检查（如果越界绘图，要么画错地方，要么程序结果莫名其妙，甚至直接崩溃），并且必须在窗口锁定绘图模式下才能使用，否则将发生不可预知的结果。
    ##
    ##
    ##
    ##

proc moverel*(dx: cint; dy: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于移动当前点。有些绘图操作会从“当前点”开始，这个函数可以设置该点。
    ##
    ## **参数**
    ##  dx
    ##
    ##  将当前点沿 x 轴移动 dx。
    ##
    ##  dy
    ##
    ##  将当前点沿 y 轴移动 dy。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc moveto*(x: cint; y: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于移动当前点。有些绘图操作会从“当前点”开始，这个函数可以设置该点。
    ##
    ## **参数**
    ##  x
    ##
    ##  新的当前点 x 坐标。
    ##
    ##  y
    ##
    ##  新的当前点 y 坐标。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc pieslice*(x: cint; y: cint; stangle: cint; endangle: cint; radius: cint;
              pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc pieslicef*(x: cfloat; y: cfloat; stangle: cfloat; endangle: cfloat; radius: cfloat;
               pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画填充圆扇形。
    ##
    ## **参数**
    ##  x
    ##
    ##  圆扇形的圆心 x 坐标。
    ##
    ##  y
    ##
    ##  圆扇形的圆心 y 坐标。
    ##
    ##  stangle
    ##
    ##  圆扇形的起始角的角度。
    ##
    ##  endangle
    ##
    ##  圆扇形的终止角的角度。
    ##
    ##  radius
    ##
    ##  圆扇形的半径。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc putpixel*(x: cint; y: cint; color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画点。
    ##
    ## **参数**
    ##  x
    ##
    ##  点的 x 坐标。
    ##
    ##  y
    ##
    ##  点的 y 坐标。
    ##
    ##  color
    ##
    ##  点的颜色。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  其它说明：另有高速版的putpixel_f函数，参数一样，作用一样，但不进行相对坐标变换和边界检查（如果越界绘图，要么画错地方，要么程序结果莫名其妙，甚至直接崩溃），并且必须在窗口锁定绘图模式下才能使用，否则将发生不可预知的结果。
    ##
    ##
    ##
    ##

proc putpixels*(nPoint: cint; pPoints: ptr cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画多个点。
    ##
    ## **参数**
    ##  nPoint
    ##
    ##  点的数目。
    ##
    ##  pPoints
    ##
    ##  指向点的描述的指针，一个int型的数组，依次每三个int描述一个点：第一个为x坐标，第二个为y坐标，第三个为颜色值。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##  其它说明：另有高速版的putpixels_f函数，参数一样，作用一样，但不进行相对坐标变换和边界检查（如果越界绘图，要么画错地方，要么程序结果莫名其妙，甚至直接崩溃），并且必须在窗口锁定绘图模式下才能使用，否则将发生不可预知的结果。
    ##
    ##
    ##
    ##

proc rectangle*(left: cint; top: cint; right: cint; bottom: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画空心矩形。
    ##
    ## **参数**
    ##  left
    ##
    ##  矩形左部 x 坐标。
    ##
    ##  top
    ##
    ##  矩形上部 y 坐标。
    ##
    ##  right
    ##
    ##  矩形右部 x 坐标。
    ##
    ##  bottom
    ##
    ##  矩形下部 y 坐标。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc sector*(x: cint; y: cint; stangle: cint; endangle: cint; xradius: cint; yradius: cint;
            pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc sectorf*(x: cfloat; y: cfloat; stangle: cfloat; endangle: cfloat; xradius: cfloat;
             yradius: cfloat; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于画填充椭圆扇形。
    ##
    ## **参数**
    ##  x
    ##
    ##  椭圆扇形的圆心 x 坐标。
    ##
    ##  y
    ##
    ##  椭圆扇形的圆心 y 坐标。
    ##
    ##  stangle
    ##
    ##  椭圆扇形的起始角的角度。
    ##
    ##  endangle
    ##
    ##  椭圆扇形的终止角的角度。
    ##
    ##  xradius
    ##
    ##  椭圆扇形的 x 轴半径。
    ##
    ##  yradius
    ##
    ##  椭圆扇形的 y 轴半径。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##



proc setfillstyle*(pattern: cint; color: color_t; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前填充类型。该函数的自定义填充部分尚不支持。
    ##
    ## **参数**
    ##  pattern
    ##
    ##  填充类型，可以是以下宏或值：
    ##
    ##  宏值含义
    ##
    ##  NULL_FILL1不填充
    ##
    ##  SOLID_FILL2固实填充
    ##
    ##  pupattern
    ##
    ##  color
    ##
    ##  填充颜色。
    ##
    ##  指定图案填充时的样式，目前无作用。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  设置蓝色固实填充：
    ##
    ##  setfillstyle(SOLID_FILL, BLUE);
    ##
    ##
    ##
    ##

proc setlinestyle*(linestyle: cint; upattern: cushort = 0; thickness: cint = 1;
                  pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前线形。
    ##
    ## **参数**
    ##  linestyle
    ##
    ##  线型，可以是以下值：
    ##
    ##  值含义
    ##
    ##  SOLID_LINE线形为实线。
    ##
    ##  CENTER_LINE线形为：－－－－－－－－－－－－
    ##
    ##  DOTTED_LINE线形为：●●●●●●●●●●●●
    ##
    ##  DASHED_LINE线形为：－●－●－●－●－●－●
    ##
    ##  NULL_LINE线形为不可见。
    ##
    ##  USERBIT_LINE线形样式是自定义的，依赖于 upattern 参数。
    ##
    ##  upattern
    ##
    ##  自定义线形数据。
    ##
    ##  自定义规则：该数据为 WORD 类型，共 16 个二进制位，每位为 1 表示画线，为 0 表示空白。从低位到高位表示从起始到终止的方向。
    ##
    ##  仅当线型为 PS_USERSTYLE 时该参数有效。
    ##
    ##  thickness
    ##
    ##  线形宽度。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  设置线形为点划线： setlinestyle(PS_DASHDOT);
    ##
    ##  设置线形为宽度 3 像素的虚线： setlinestyle(PS_DASH, NULL, 3);
    ##
    ##
    ##
    ##

proc setlinewidth*(thickness: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前线宽。
    ##
    ## **参数**
    ##  thickness
    ##
    ##  线形宽度。
    ##
    ##
    ## **返回值**
    ##
    ## **示例**
    ##
    ##
    ##

proc setwritemode*(mode: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置绘图位操作模式。
    ##
    ## **参数**
    ##  mode
    ##
    ##  二元光栅操作码（即位操作模式），支持全部的 16 种二元光栅操作码，罗列如下：
    ##
    ##  位操作模式描述
    ##
    ##  R2_BLACK绘制出的像素颜色 = 黑色
    ##
    ##  R2_COPYPEN绘制出的像素颜色 = 当前颜色（默认）
    ##
    ##  R2_MASKNOTPEN绘制出的像素颜色 = 屏幕颜色 AND (NOT 当前颜色)
    ##
    ##  R2_MASKPEN绘制出的像素颜色 = 屏幕颜色 AND 当前颜色
    ##
    ##  R2_MASKPENNOT绘制出的像素颜色 = (NOT 屏幕颜色) AND 当前颜色
    ##
    ##  R2_MERGENOTPEN绘制出的像素颜色 = 屏幕颜色 OR (NOT 当前颜色)
    ##
    ##  R2_MERGEPEN绘制出的像素颜色 = 屏幕颜色 OR 当前颜色
    ##
    ##  R2_MERGEPENNOT绘制出的像素颜色 = (NOT 屏幕颜色) OR 当前颜色
    ##
    ##  R2_NOP绘制出的像素颜色 = 屏幕颜色
    ##
    ##  R2_NOT绘制出的像素颜色 = NOT 屏幕颜色
    ##
    ##  R2_NOTCOPYPEN绘制出的像素颜色 = NOT 当前颜色
    ##
    ##  R2_NOTMASKPEN绘制出的像素颜色 = NOT (屏幕颜色 AND 当前颜色)
    ##
    ##  R2_NOTMERGEPEN绘制出的像素颜色 = NOT (屏幕颜色 OR 当前颜色)
    ##
    ##  R2_NOTXORPEN绘制出的像素颜色 = NOT (屏幕颜色 XOR 当前颜色)
    ##
    ##  R2_WHITE绘制出的像素颜色 = 白色
    ##
    ##  R2_XORPEN绘制出的像素颜色 = 屏幕颜色 XOR 当前颜色
    ##
    ##  注：1. AND / OR / NOT / XOR 为布尔位运算。2. "屏幕颜色"指绘制所经过的屏幕像素点的颜色。3. "当前颜色"是指通过 setcolor 设置的用于当前绘制的颜色。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc getfont*(font: ptr LOGFONT; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取当前字体样式
    ##
    ## **参数**
    ##  font
    ##
    ##  指向 LOGFONT 结构体的指针。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc outtext*(textstring: cstring; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtext*(c: char; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtext*(textstring: WideCString; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtext*(c: wchar; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于在当前位置输出字符串。
    ##
    ## **参数**
    ##  textstring
    ##
    ##  要输出的字符串的指针。
    ##
    ##  c
    ##
    ##  要输出的字符。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  // 输出字符串
    ##
    ##  char s[] = "Hello World";
    ##
    ##  outtext(s);
    ##
    ##  // 输出字符
    ##
    ##  char c = 'A';
    ##
    ##  outtext(c);
    ##
    ##  // 输出数值，先将数字格式化输出为字符串
    ##
    ##  char s[5];
    ##
    ##  sprintf(s, "%d", 1024);
    ##
    ##  outtext(s);
    ##
    ##
    ##
    ##

proc outtextrect*(x: cint; y: cint; w: cint; h: cint; textstring: cstring;
                 pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtextrect*(x: cint; y: cint; w: cint; h: cint; textstring: WideCString;
                 pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ##
    ## 这个函数用于在指定矩形范围内输出字符串。
    ##
    ## **参数**
    ##  x, y, w, h
    ##
    ##  要输出字符串所在的矩形区域
    ##
    ##  textstring
    ##
    ##  要输出的字符串的指针。
    ##
    ##
    ## **返回值**
    ##
    ## **示例**
    ##
    ##
    ##

proc outtextxy*(x: cint; y: cint; textstring: cstring; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtextxy*(x: cint; y: cint; c: char; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtextxy*(x: cint; y: cint; textstring: WideCString; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc outtextxy*(x: cint; y: cint; c: wchar; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于在指定位置输出字符串。
    ##
    ## **参数**
    ##  x
    ##
    ##  字符串输出时头字母的 x 轴的坐标值
    ##
    ##  y
    ##
    ##  字符串输出时头字母的 y 轴的坐标值。
    ##
    ##  textstring
    ##
    ##  要输出的字符串的指针。
    ##
    ##  c
    ##
    ##  要输出的字符。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  // 输出字符串
    ##
    ##  char s[] = "Hello World";
    ##
    ##  outtextxy(10, 20, s);
    ##
    ##  // 输出字符
    ##
    ##  char c = 'A';
    ##
    ##  outtextxy(10, 40, c);
    ##
    ##  // 输出数值，先将数字格式化输出为字符串
    ##
    ##  char s[5];
    ##
    ##  sprintf(s, "%d", 1024);
    ##
    ##  outtextxy(10, 60, s);
    ##
    ##
    ##
    ##

proc xyprintf*(x: cint; y: cint; w: cint; h: cint; textstring: cstring) {.varargs, importc, header:"graphics.h", cdecl.}
proc xyprintf*(x: cint; y: cint; w: cint; h: cint; textstring: WideCString) {.varargs, importc, header:"graphics.h", cdecl.}
    ## 这个函数用于在指定位置格式化输出字符串。
    ##
    ## **参数**
    ##  x, y, w, h
    ##
    ##  要输出字符串所在的矩形区域
    ##
    ##  textstring
    ##
    ##  要输出的字符串的指针。
    ##
    ##  ...
    ##
    ##  要输出的内容的参数，类似printf。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  无
    ##
    ##
    ##
    ##

proc setfont*(nHeight: cint; nWidth: cint; lpszFace: cstring; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc setfont*(nHeight: cint; nWidth: cint; lpszFace: cstring; nEscapement: cint;
             nOrientation: cint; nWeight: cint; bItalic: bool; bUnderline: bool;
             bStrikeOut: bool; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc setfont*(nHeight: cint; nWidth: cint; lpszFace: cstring; nEscapement: cint;
             nOrientation: cint; nWeight: cint; bItalic: bool; bUnderline: bool;
             bStrikeOut: bool; fbCharSet: byte; fbOutPrecision: byte;
             fbClipPrecision: byte; fbQuality: byte; fbPitchAndFamily: byte;
             pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
proc setfont*(font: ptr LOGFONT; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置当前字体样式。
    ##
    ## **参数**
    ##  nHeight
    ##
    ##  指定高度（逻辑单位）。如果为正，表示指定的高度包括字体的默认行距；如果为负，表示指定的高度只是字符的高度。
    ##
    ##  nWidth
    ##
    ##  字符的平均宽度（逻辑单位）。如果为 0，则比例自适应。
    ##
    ##  lpszFace
    ##
    ##  字体名称。对于此参数均有cstring和WideCString两个版本，以上函数声明仅列出一种。提供两个接口是为了方便能同时使用两种不同的字符集。
    ##
    ##  常用的字体名称有：宋体，楷体_GB2312，隶书，黑体，幼圆，新宋体，仿宋_GB2312，Fixedsys，Arial，Times New Roman
    ##
    ##  具体可用名字，可查阅你系统已安装字体。
    ##
    ##  nEscapement
    ##
    ##  字符串的书写角度，单位 0.1 度。
    ##
    ##  nOrientation
    ##
    ##  每个字符的书写角度，单位 0.1 度。
    ##
    ##  nWeight
    ##
    ##  字符的笔画粗细，范围 0~1000。0 表示默认粗细。使用数字或下表中定义的宏均可：
    ##
    ##  宏粗细值
    ##
    ##  FW_DONTCARE0
    ##
    ##  FW_THIN100
    ##
    ##  FW_EXTRALIGHT200
    ##
    ##  FW_ULTRALIGHT200
    ##
    ##  FW_LIGHT300
    ##
    ##  FW_NORMAL400
    ##
    ##  FW_REGULAR400
    ##
    ##  FW_MEDIUM500
    ##
    ##  FW_SEMIBOLD600
    ##
    ##  FW_DEMIBOLD600
    ##
    ##  FW_BOLD700
    ##
    ##  FW_EXTRABOLD800
    ##
    ##  FW_ULTRABOLD800
    ##
    ##  FW_HEAVY900
    ##
    ##  FW_BLACK900
    ##
    ##  bItalic
    ##
    ##  是否斜体，true / false。
    ##
    ##  bUnderline
    ##
    ##  是否有下划线，true / false。
    ##
    ##  bStrikeOut
    ##
    ##  是否有删除线，true / false。
    ##
    ##  fbCharSet
    ##
    ##  指定字符集(详见 LOGFONT 结构体)。
    ##
    ##  fbOutPrecision
    ##
    ##  指定文字的输出精度(详见 LOGFONT 结构体)。
    ##
    ##  fbClipPrecision
    ##
    ##  指定文字的剪辑精度(详见 LOGFONT 结构体)。
    ##
    ##  fbQuality
    ##
    ##  指定文字的输出质量(详见 LOGFONT 结构体)。
    ##
    ##  fbPitchAndFamily
    ##
    ##  指定以常规方式描述字体的字体系列(详见 LOGFONT 结构体)。
    ##
    ##  font
    ##
    ##  指向 LOGFONT 结构体的指针。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  // 设置当前字体为高 16 像素的“宋体”（忽略行距）。
    ##
    ##  setfont(-16, 0,"宋体");
    ##
    ##  outtextxy(0, 0,"测试");
    ##
    ##  // 设置输出效果为抗锯齿（LOGFONTA是MBCS版本，LOGFONTW是UTF16版本）
    ##
    ##  LOGFONTA f;
    ##
    ##  getfont(&amp;f);                          // 获取当前字体设置
    ##
    ##  f.lfHeight = 48;                      // 设置字体高度为 48（包含行距）
    ##
    ##  strcpy(f.lfFaceName, "黑体");         // 设置字体为“黑体”
    ##
    ##  f.lfQuality = ANTIALIASED_QUALITY;    // 设置输出效果为抗锯齿
    ##
    ##  setfont(&amp;f);                          // 设置字体样式
    ##
    ##  outtextxy(0,50,"抗锯齿效果");
    ##
    ##
    ##
    ##

proc settextjustify*(horiz: cint; vert: cint; pimg: PIMAGE = nil) {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于设置文字对齐方式。
    ##
    ## **参数**
    ##  horiz
    ##
    ##  横向对齐方式，可选值LEFT_TEXT (默认), CENTER_TEXT, RIGHT_TEXT
    ##
    ##  vert
    ##
    ##  纵向对齐方式，可选值TOP_TEXT (默认), CENTER_TEXT, BOTTOM_TEXT
    ##
    ##  textstring
    ##
    ##  要输出的字符串的指针。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc textheight*(textstring: cstring; pimg: PIMAGE = nil): cint {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取输出字符串的高（像素为单位）
    ##
    ## **参数**
    ##  textstring
    ##
    ##  指定的字符串指针。
    ##
    ##
    ## **返回值**
    ##  该字符串实际占用的像素高度。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc textwidth*(textstring: cstring; pimg: PIMAGE = nil): cint {.importc, header:"graphics.h", cdecl.}
    ## 这个函数用于获取字符串的宽（像素为单位）
    ##
    ## **参数**
    ##  textstring
    ##
    ##  指定的字符串指针。
    ##
    ##
    ## **返回值**
    ##  该字符串实际占用的像素宽度。
    ##
    ##
    ## **示例**
    ##  （无）
    ##
    ##
    ##
    ##

proc xyprintf*(x: cint; y: cint; textstring: cstring) {.varargs, importc, header:"graphics.h", cdecl.}
proc xyprintf*(x: cint; y: cint; textstring: WideCString) {.varargs, importc, header:"graphics.h", cdecl.}
    ## 这个函数用于在指定位置格式化输出字符串。
    ##
    ## **参数**
    ##  x
    ##
    ##  字符串输出时头字母的 x 轴的坐标值
    ##
    ##  y
    ##
    ##  字符串输出时头字母的 y 轴的坐标值。
    ##
    ##  textstring
    ##
    ##  要输出的字符串的指针。
    ##
    ##  ...
    ##
    ##  要输出的内容的参数，类似printf。
    ##
    ##
    ## **返回值**
    ##  （无）
    ##
    ##
    ## **示例**
    ##  无
    ##
    ##
    ##
    ##


when isMainModule:
    initgraph(640,480)
    setcaption("windows Title")
    setcolor(0xff0000);
    setcolor(cast[color_t](BLUE))
    setcolor(EGERGB(0, 0, 255))
    setcolor(hsl2rgb(240, 1, 0.5))
    setbkcolor_f(cast[color_t](RED))
    cleardevice()
    discard getch()
    setcaption( newWideCString("窗口标题"))
    setbkcolor_f( cast[color_t](YELLOW))
    cleardevice()
    discard getch()
    closegraph()
