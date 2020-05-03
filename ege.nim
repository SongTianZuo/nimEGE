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
    
#[
to do：
待完成:

]#

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
