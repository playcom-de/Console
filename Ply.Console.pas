(******************************************************************************

  Name          : Ply.Console.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 20.06.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Console;

interface

{$I Ply.Defines.inc}

Uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  Ply.Types,
  Ply.StrUtils;

Const
  // Input Mode flags:
  {$EXTERNALSYM ENABLE_PROCESSED_INPUT}
  ENABLE_PROCESSED_INPUT               = $1;
  {$EXTERNALSYM ENABLE_LINE_INPUT}
  ENABLE_LINE_INPUT                    = $2;
  {$EXTERNALSYM ENABLE_ECHO_INPUT}
  ENABLE_ECHO_INPUT                    = $4;
  {$EXTERNALSYM ENABLE_WINDOW_INPUT}
  ENABLE_WINDOW_INPUT                  = $8;
  {$EXTERNALSYM ENABLE_MOUSE_INPUT}
  ENABLE_MOUSE_INPUT                   = $10;
  {$EXTERNALSYM ENABLE_INSERT_MODE}
  ENABLE_INSERT_MODE                   = $20;
  {$EXTERNALSYM ENABLE_QUICK_EDIT_MODE}
  ENABLE_QUICK_EDIT_MODE               = $40;
  {$EXTERNALSYM ENABLE_EXTENDED_FLAGS}
  ENABLE_EXTENDED_FLAGS                = $80;
  {$EXTERNALSYM ENABLE_AUTO_POSITION}
  ENABLE_AUTO_POSITION                 = $100;  // Not documented by Microsoft!?
  {$EXTERNALSYM ENABLE_VIRTUAL_TERMINAL_INPUT}
  ENABLE_VIRTUAL_TERMINAL_INPUT        = $200;

  // Output Mode flags:
  {$EXTERNALSYM ENABLE_PROCESSED_OUTPUT}
  ENABLE_PROCESSED_OUTPUT              = 1;
  {$EXTERNALSYM ENABLE_WRAP_AT_EOL_OUTPUT}
  ENABLE_WRAP_AT_EOL_OUTPUT            = 2;
  {$EXTERNALSYM ENABLE_VIRTUAL_TERMINAL_PROCESSING}
  ENABLE_VIRTUAL_TERMINAL_PROCESSING   = $4;
  {$EXTERNALSYM ENABLE_VIRTUAL_TERMINAL_PROCESSING}
  DISABLE_NEWLINE_AUTO_RETURN          = $8;
  {$EXTERNALSYM ENABLE_VIRTUAL_TERMINAL_PROCESSING}
  ENABLE_LVB_GRID_WORLDWIDE            = $10;

// HWND WINAPI GetConsoleWindow(void);
// Get handle from current console
function GetConsoleWindow : TConHandle; stdcall;
  external kernel32 Name 'GetConsoleWindow';

function SetConsoleCursorPosition(hConsoleOutput: THandle;
  dwCursorPosition: TConsoleWindowPoint): BOOL; stdcall;
  external kernel32 name 'SetConsoleCursorPosition';

Const
  // Extended-TextAttributes
  _ExtTextAttrInvert    = $4000;
  _ExtTextAttrUnderline = $8000;
  _ExtTextAttrOutline   = $0400 or $0800 or $1000 or $8000;
  // Default TextAttribute Values
  _TextAttr_Default         =   7;  // Textcolor=LightGray, Textbackground=Black
  _TextAttr_Yellow_Black    =  14;  // Textcolor=Yellow   , Textbackground=Black
  _TextAttr_Yellow_Blue     =  30;  // Textcolor=Yellow   , Textbackground=Blue
  _TextAttr_White_Red       =  79;  // Textcolor=White    , Textbackground=Red
  _TextAttr_White_Lightblue = 159;  // Textcolor=White    , Textbackground=Lightblue

// TTextAttr - attribute for write to console
// Textcolor      = Bit 1..4 (16 Colors)  + Blink(#128)
// Textbackground = Bit 5..8 (16 Colors)
// GridTop        = Bit 11
// GridLeft       = Bit 12
// GridRight      = Bit 13
// InvertColors   = Bit 15
// GridBottom     = Bit 16
Type
  TTextAttr = Record
  Private
    FTextAttr : Word;
    Function  GetTextcolor : Byte;
    Procedure SetTextcolor(Value:Byte);
    Function  GetTextbackground : Byte;
    Procedure SetTextbackground(Value:Byte);
    Function  GetInvertColors : Boolean;
    Procedure SetInvertColors(Value:Boolean);
    Function  GetGridTop : Boolean;
    Procedure SetGridTop(Value:Boolean);
    Function  GetGridLeft : Boolean;
    Procedure SetGridLeft(Value:Boolean);
    Function  GetGridBottom : Boolean;
    Procedure SetGridBottom(Value:Boolean);
    Function  GetGridRight : Boolean;
    Procedure SetGridRight(Value:Boolean);
    Function  GetOutline : Boolean;
    Procedure SetOutline(Value:Boolean);
    Function  GetUnderline : Boolean;
    Procedure SetUnderline(Value:Boolean);
  Public
    class operator Implicit(Value: Word): TTextAttr;
    class operator Implicit(Value: tTextAttr): Word;
    Constructor Create(TColor, BColor:Byte); Overload;
    Constructor Create(TColor, BColor:Byte; ExtTextAttr:Word); Overload;
    Property  Attr : Word Read FTextAttr Write FTextAttr;
    Property  Textcolor : Byte Read GetTextcolor Write SetTextcolor;
    Property  Textbackground : Byte Read GetTextbackground Write SetTextbackground;
    Procedure Color(Const TColor,BColor:Byte);
    Procedure SetAttributesV1;
    Property  InvertColors : Boolean Read GetInvertColors Write SetInvertColors;
    Property  GridTop      : Boolean Read GetGridTop      Write SetGridTop;
    Property  GridLeft     : Boolean Read GetGridLeft     Write SetGridLeft;
    Property  GridBottom   : Boolean Read GetGridBottom   Write SetGridBottom;
    Property  GridRight    : Boolean Read GetGridRight    Write SetGridRight;
    Property  Outline      : Boolean Read GetOutline      Write SetOutline;
    Property  Underline    : Boolean Read GetUnderline    Write SetUnderline;
  end;

Type
  TConsoleSelectionInfo = record
    dwFlags: DWORD;
    dwSelectionAnchor: TConsoleWindowPoint;
    srSelection: TConsoleWindowRect;
  end;

function GetConsoleSelectionInfo(var ConsoleSelectionInfo:
  TConsoleSelectionInfo): BOOL; stdcall;
  external kernel32 name 'GetConsoleSelectionInfo';

function CreatePseudoConsole(size:TConsoleWindowPoint; hInput,hOutput:tHandle;
  dwFlags:DWord; phPC:Pointer): HResult; stdcall;
  external kernel32 name 'CreatePseudoConsole';

(*******************************)
(***** Console-Buffer-Info *****)
(*******************************)
Type PConsoleBufferInfo = ^TConsoleBufferInfo;
     TConsoleBufferInfo = record
       dwSize: TConsoleWindowPoint;
       dwCursorPosition: TConsoleWindowPoint;
       wAttributes: Word;
       srWindow: TSmallRect;
       dwMaximumWindowSize: TConsoleWindowPoint;
     end;

function GetConsoleBufferInfo(hConsoleOutput: THandle;
  var lpConsoleBufferInfo: TConsoleBufferInfo): BOOL; stdcall;
  external Kernel32 Name 'GetConsoleScreenBufferInfo';

function SetConsoleBufferSize(hConsoleOutput: THandle;
  dwSize:TConsoleWindowPoint): BOOL; stdcall;
  external kernel32 name 'SetConsoleScreenBufferSize';

(**********************************)
(***** Console-Buffer-Info-EX *****)
(**********************************)
Type PConsoleBufferInfoEx = ^TConsoleBufferInfoEx;
     TConsoleBufferInfoEx = Record
       // cbSize: size of this structure
       cbSize : ULONG;
       // dwSize: size of the console buffer, in character columns and rows
       dwSize : TConsoleWindowPoint;
       // dwCursorPosition: column and row coordinates of the cursor on the console buffer
       dwCursorPosition : TConsoleWindowPoint;
       // wAttributes: attributes of the characters
       wAttributes : WORD;
       // srWindow: contains coordinates of the upper-left and lower-right corners of the window
       srWindow : TSmallRect;
       // dwMaximumWindowSize: contains the maximum size of the console window on the current display
       dwMaximumWindowSize : TConsoleWindowPoint;
       // wPopupAttributes: attribute for console pop-ups
       wPopupAttributes : WORD;
       // bFullscreenSupported: full-screen mode is supported; after Win.Vista alway FALSE
       bFullscreenSupported : BOOL;
       // ColorTable: values that describe the console's color settings
       ColorTable : Array [0..15] of TColorRef;
     end;

function GetConsoleBufferInfoEx(hConsoleOutput: THandle;
           var lpConsoleBufferInfoEx:TConsoleBufferInfoEx) : BOOL; StdCall;
           external Kernel32 Name 'GetConsoleScreenBufferInfoEx';

function SetConsoleBufferInfoEx(hConsoleOutput: THANDLE;
           var lpConsoleBufferInfoEx: TConsoleBufferInfoEx) : BOOL; StdCall;
           external Kernel32 Name 'SetConsoleScreenBufferInfoEx';

// WorkAreas: Size(s) in pixel of the monitor(s)/screen(s) conected to this computer
{$IFDEF DELPHIXE8DOWN}
Type HMonitor = System.UIntPtr;
{$ENDIF DELPHIXE8DOWN}
function GetScaleFactorForMonitor(hMon: HMONITOR; out Scale:Integer): HRESULT; stdcall;
// function GetThemeSysSize(hTheme: THandle; iSizeId: Integer): Integer; stdcall;

Type tWorkArea = record
       Rect : TConsoleDesktopRect;
       Scale : Integer;
     end;

Type tWorkAreas = record
     private
       FAreas : Array of tWorkArea;
       Procedure Add(Const ARect:TConsoleDesktopRect; Const MScale:Integer=100);
     public
                 // Load WorkAreas from TScreen
       Function  GetWorkAreas : Boolean;
                 // GetWorkArea: Returns the WorkArea that contains this Point
       Function  GetWorkArea(aPoint:TConsoleDesktopPoint) : tWorkArea; Overload;
       Function  GetWorkArea(aLeft,aTop:Longint) : tWorkArea; Overload;
                 // GetWorkAreaNext: Returns the next WorkArea that dosn't contain
                 // this Point. If there is only one WorkArea, Result is this WorkArea
       Function  GetWorkAreaNext(aPoint:TConsoleDesktopPoint) : tWorkArea; Overload;
       Function  GetWorkAreaNext(aLeft,aTop:Longint) : tWorkArea; Overload;
                 // Returns the highest right-value of all areas
       Function  MaxRight : Longint;
                 // Returns the highest bottom-value of all areas
       Function  MaxBottom : Longint;
       Procedure Show(y, Lines: Byte);
     end;

Type TConFont = Record
     private
       Function  GetDimensions : TConsoleWindowPoint;
     public
       constructor Create(Const aValue:Word); overload;
       constructor Create(Const aNumber, aSize:Byte); overload;
       Property Dimensions : TConsoleWindowPoint Read GetDimensions;
       class operator equal(Lhs, Rhs: TConFont) : Boolean;
       class operator notequal(Lhs, Rhs: TConFont) : Boolean;
     case integer of
       0 : (FontValue:Word);
       1 : (FontNumber, FontSize:Byte);
     end;

Type EConsoleApiError = class(Exception);

//  { Font Families }
//  FF_DONTCARE   = (0 shl 4);     {  0: Don't care or don't know. }
//  FF_ROMAN      = (1 shl 4);     { 16: Variable stroke width, serifed.Times Roman, Century Schoolbook, etc. }
//  FF_SWISS      = (2 shl 4);     { 32: Variable stroke width, sans-serifed. Helvetica, Swiss, etc. }
//  FF_MODERN     = (3 shl 4);     { 48: Constant stroke width, serifed or sans-serifed. Pica, Elite, Courier, etc. }
Const FF_CONSOLE  = 54;
//  FF_SCRIPT     = (4 shl 4);     { 64: Cursive, etc. }
//  FF_DECORATIVE = (5 shl 4);     { 80: Old English, etc. }

//  { Font Weights }
//  FW_DONTCARE = 0;
//  FW_THIN = 100;
//  FW_EXTRALIGHT = 200;
//  FW_LIGHT = 300;
//  FW_NORMAL = 400;
//  FW_MEDIUM = 500;
//  FW_SEMIBOLD = 600;
//  FW_BOLD = 700;
//  FW_EXTRABOLD = 800;
//  FW_HEAVY = 900;
//  FW_ULTRALIGHT = FW_EXTRALIGHT;
//  FW_REGULAR = FW_NORMAL;
//  FW_DEMIBOLD = FW_SEMIBOLD;
//  FW_ULTRABOLD = FW_EXTRABOLD;
//  FW_BLACK = FW_HEAVY;

Const _ConsoleFontTerminal      = 1;
      _ConsoleFontConsolas      = 2;
      _ConsoleFontLucidaConsole = 3;
      _ConsoleFontCourierNew    = 4;
      _ConsoleFontFiraCode      = 5;

      _ConsoleFontNumberDefault = 2;
      _ConsoleFontNumberMax     = 5;

      _ConsoleFontSizeDefault   = 5;
      _ConsoleFontSizeMax       = 9;

Type TFontName = array [0..LF_FACESIZE-1] of WideChar;

Type _CONSOLE_FONT_INFO      = record
       nFont                 : DWORD;
       dwFontSize            : COORD;
     end;
     TConsole_Font_Info      = _CONSOLE_FONT_INFO;
     PConsole_Font_Info      = ^_CONSOLE_FONT_INFO;

Type _CONSOLE_FONT_INFOEX    = Record
       cbSize                : Cardinal;
       // nFont: index of the font in the system's console font table
       nFont                 : Cardinal;
       // dwFontDimensions: width and height of each character in the font (pixel)
       dwFontDimensions      : TConsoleWindowPoint;
       // FontFamily: font pitch and family
       FontFamily            : Cardinal;
       // FontWeight:  100 to 1000, in multiples of 100. normal weight is 400, while 700 is bold.
       FontWeight            : Cardinal;
       // name of the typeface (such as Terminal or Consolas).
       FaceName              : TFontName;
    end;
    TConsole_Font_InfoEx     = _CONSOLE_FONT_INFOEX;
    PConsole_Font_InfoEx     = ^_CONSOLE_FONT_INFOEX;

Type tConsoleFont = Class
     private
       FConsoleFontEx : TConsole_Font_InfoEx;
       // Clear: FConsoleFontEx FillChar #0
       Procedure Clear;
       // GetConFont: FontNumber and FontSize as TConFont;
       Function GetConFont : tConFont;
       // GetFontName: Fontname as String "Terminal", "Consolas" or "LucidaConsole"
       Function  GetFontName : String;
       // GetFontNumber: 1.._ConsoleFontNumberMax
       // (Terminal, Consolas, Lucida Console, Courier New, Fira Code)
       Function  GetFontNumber : Byte;
       Procedure SetFontNumber(Const Value:Byte);
       // GetFontSize: 1.._ConsoleFontSizeMax representing _ConsoleFontSize
       Function  GetFontSize : Byte;
       Procedure SetFontSize(Const Value:Byte);
     public
       Constructor Create;
       Destructor Destroy; Override;
       // GetCurrentFontEx: Retrieve CurrentFont from System
       Function  GetCurrentFontEx : Boolean;
       Function  GetCurrentFontOld : Boolean; overload;
       Function  GetCurrentFontOld(Var CFont:TConsole_Font_Info) : Boolean; overload;
       // SetCurrentFont: Set CurrentFont
       Procedure SetDefault;
       Function  SetCurrentFont(Font:TConFont) : Boolean; overload;
       Function  SetCurrentFont(FontNr,FontSize:Byte) : Boolean; overload;
       Function  FontNumberText : String;
       Function  FontSizeText : String;
       // GetFontText: FontInfo as String - e.g. "2=Consolas | Size : 4 = 9x20"
       Function  FontText : String;
       // Is_Terminal: True when CurrentFont is "Terminal"
       Function  Is_Terminal : Boolean;
       Procedure DecFontSize;
       Procedure DecFontNumber;
       Procedure IncFontSize;
       Procedure IncFontNumber;
       // Font: FontNumber and FontSize as TConFont;
       Property  Font : TConFont Read GetConFont;
       // GetFontNumber: 1.._ConsoleFontNumberMax
       // (Terminal, Consolas, Lucida Console, Courier New, Fira Code)
       Property  FontNumber : Byte Read GetFontNumber Write SetFontNumber;
       // FontSize: 1..8 representing _ConsoleFontSize
       Property  FontSize : Byte Read GetFontSize Write SetFontSize;
       // FontDimensions: width and height of each character in the font (pixel)
       Property  FontDimensions : TConsoleWindowPoint Read FConsoleFontEx.dwFontDimensions;
       // FontFamily
       Property  FontFamily : Cardinal Read FConsoleFontEx.FontFamily;
       // FontWeight:  100 to 1000, in multiples of 100. normal weight is 400, while 700 is bold.
       Property  FontWeight : Cardinal Read FConsoleFontEx.FontWeight;
       // FontName: name of the font (such as Terminal or Consolas).
       Property  FontName : String Read GetFontName;
     End;

procedure SystemFontsCollect(FontList: TStrings);

(***************************)
(***** tConsoleDesktop *****)
(***************************)
function  Console_GetDesktopArea(Var ConsoleDesktopRect:TConsoleDesktopRect): Boolean;
function  Console_SetDesktopArea(Var ConsoleDesktopRect:TConsoleDesktopRect): Boolean;

Type tConsoleDesktop = Class
     private
       Function  GetArea : TConsoleDesktopRect;
       Procedure SetArea(Value: TConsoleDesktopRect);
       Function  GetPosition : TConsoleDesktopPoint;
       Procedure SetPosition(Value: TConsoleDesktopPoint);
     public
       Property  Area : TConsoleDesktopRect Read GetArea Write SetArea;
       Property  Position : TConsoleDesktopPoint Read GetPosition Write SetPosition;
       Constructor Create;
       Destructor Destroy; Override;
       Procedure AutofitPosition;
       Procedure MoveTo(Const X,Y:Longint; AutoFit:Boolean=False);
       // FrameSize: Border & Caption to be added to WindowSize * FontSize
       //            to get the DesktopSize from Console.Window
       Function  FrameSize : TConsoleDesktopPoint;
       // MinSize: MinSize form System for a Console.Desksize (Pixel)
       Function  SizeMin : TConsoleDesktopPoint;
       // SizeCalculated: DesktopSize calculated based on WindowSize (coloums & lines)
       //                 from FontSize & FrameSize
       Function  SizeCalculated(WindowSize:TSmallPoint) : TConsoleDesktopPoint;
       // FontSize: Calculate current Fontsize based on WindowSize
       Function  Fontsize(WindowSize:TSmallPoint) : TConsoleDesktopPoint;
     End;

(*************************)
(***** tConsoleModes *****)
(*************************)
Type tConsoleModes = Class
     private
       // FModeInput: ProcessedInput, LineInput, EchoInput, ...
       FInput : DWord;
       // FModeOutput: ProcessedOutput, WrapOutput, VirtualTerminal, ...
       FOutput : DWord;
       // FBool32: EnableAsciiCodeInput
       FBool32 : TBoolean32;
       {$IFDEF CONSOLEOPACITY}
       // FOpacity: opacity and transparency
       FOpacityAlpha : Byte;
       {$ENDIF CONSOLEOPACITY}
       // GetConsoleMode & SetConsoleMode
       Function  GetModeInput : Boolean;
       Function  GetModeOutput : Boolean;
       Procedure SetModeInput(Const Value:DWord);
       Procedure SetModeOutput(Const Value:DWord);

       Function  IsModeInputValue(Const aMode:DWord) : Boolean;
       Function  GetModeInputValue(Const aMode:DWord) : Boolean;
       Procedure SetModeInputValue(Const aMode:DWord; Const Value:Boolean);

       Function  IsModeOutputValue(Const aMode:DWord) : Boolean;
       Function  GetModeOutputValue(Const aMode:DWord) : Boolean;
       Procedure SetModeOutputValue(Const aMode:DWord; Const Value:Boolean);

       Function  GetRegistryFeature(ValueName:String) : Boolean;
       Procedure SetRegistryFeature(ValueName:String; Value:Boolean);

       // StdIn $1|#1 ProcessedInput : ENABLE_PROCESSED_INPUT
       Function  GetProcessedInput : Boolean;
       Function  IsProcessedInput : Boolean;
       Procedure SetProcessedInput(Const Value:Boolean);
       // StdIn $2|#2 LineInput : ENABLE_LINE_INPUT
       Function  GetLineInput : Boolean;
       Function  IsLineInput : Boolean;
       Procedure SetLineInput(Const Value:Boolean);
       // StdIn $4|#4 EchoInput : ENABLE_ECHO_INPUT
       Function  GetEchoInput : Boolean;
       Function  IsEchoInput : Boolean;
       Procedure SetEchoInput(Const Value:Boolean);
       // StdIn $8|#8 WindowInput : ENABLE_WINDOW_INPUT
       Function  GetWindowInput : Boolean;
       Function  IsWindowInput : Boolean;
       Procedure SetWindowInput(Const Value:Boolean);
       // StdIn $10|#16 MouseInput : ENABLE_MOUSE_INPUT
       Function  GetMouseInput : Boolean;
       Function  IsMouseInput : Boolean;
       Procedure SetMouseInput(Const Value:Boolean);
       // StdIn $20|#32 InsertMode : ENABLE_INSERT_MODE
       Function  GetInsertMode : Boolean;
       Function  IsInsertMode : Boolean;
       Procedure SetInsertMode(Const Value:Boolean);
       // StdIn $40|#64 QuickEditMode : ENABLE_QUICK_EDIT_MODE
       Function  GetQuickEditMode : Boolean;
       Function  IsQuickEditMode : Boolean;
       Procedure SetQuickEditMode(Const Value:Boolean);
       // StdIn $80|#128 ExtendedFlags : ENABLE_EXTENDED_FLAGS
       Function  GetExtendedFlags : Boolean;
       Function  IsExtendedFlags : Boolean;
       Procedure SetExtendedFlags(Const Value:Boolean);
       // StdIn $100/#256 AutoPosition : ENABLE_AUTO_POSITION
       Function  GetAutoPosition : Boolean;
       Function  IsAutoPosition : Boolean;
       Procedure SetAutoPosition(Const Value:Boolean);
       // StdIn $200/#512 VirtualTerminalInput : ENABLE_VIRTUAL_TERMINAL_INPUT
       Function  GetVirtualTerminalInput : Boolean;
       Function  IsVirtualTerminalInput : Boolean;
       Procedure SetVirtualTerminalInput(Const Value:Boolean);
       // StdOut $1|#1 ProcessedOutput : ENABLE_PROCESSED_OUTPUT
       Function  GetProcessedOutput : Boolean;
       Procedure SetProcessedOutput(Const Value:Boolean);
       // StdOut $2|#2 ENABLE_WRAP_AT_EOL_OUTPUT
          // GER: Textausgabe bei Größenänderung umbrechen
          // ENG: Wrap text output on resize
       Function  GetWrapOutput : Boolean;
       Procedure SetWrapOutput(Const Value:Boolean);
       // StdOut $4|#4 ENABLE_VIRTUAL_TERMINAL_PROCESSING
       Function  GetVirtualTerminal : Boolean;
       Procedure SetVirtualTerminal(Const Value:Boolean);
       // StdOut $8|#8 DISABLE_NEWLINE_AUTO_RETURN
       Function  GetDisableNewlineAutoReturn : Boolean;
       Procedure SetDisableNewlineAutoReturn(Const Value:Boolean);
       // StdOut $10|#16 ENABLE_LVB_GRID_WORLDWIDE
       Function  GetLvbGridWorldwide : Boolean;
       Procedure SetLvbGridWorldwide(Const Value:Boolean);
       {$IFDEF CONSOLEOPACITY}
       // Opacity
       Function  GetOpacity : Byte;
       Procedure SetOpacity(Const Percent:Byte);
       // FBool32[4]: AutoOpacityOnFocus
       Function  GetAutoOpacityOnFocus : Boolean;
       Procedure SetAutoOpacityOnFocus(Value:Boolean);
       {$ENDIF CONSOLEOPACITY}
       // FBool32[0]: EnableAsciiCodeInput
       Function  GetAsciiCodeInput : Boolean;
       Procedure SetAsciiCodeInput(Value:Boolean);
       // FBool32[1]: WrapWord
       Function  GetWrapWord : Boolean;
       Procedure SetWrapWord(Value:Boolean);
       // FBool32[2]: ReplaceControlCharacter
       Function  GetReplaceCtrlChar : Boolean;
       Procedure SetGetReplaceCtrlChar(Value:Boolean);
       // FBool32[3]: UseAlternateWriteProc
       Function  GetUseAlternateWriteProc : Boolean;
       Procedure SetUseAlternateWriteProc(Value:Boolean);
       // Registry: ForceV2
       Function  GetForceV2 : Boolean;
       Procedure SetForceV2(Value:Boolean);
       // Registry: LineSelection
       Function  GetLineSelection : Boolean;
       Procedure SetLineSelection(Value:Boolean);
       // Registry: FilterOnPaste
       Function  GetFilterOnPaste : Boolean;
       Procedure SetFilterOnPaste(Value:Boolean);
       // Registry: LineWrap (on Resize Console.Window)
       Function  GetLineWrap : Boolean;
       Procedure SetLineWrap(Value:Boolean);
       // Registry: CtrlKeyShortcutsDisabled
       Function  GetCtrlKeyShortcutsDisabled : Boolean;
       Procedure SetCtrlKeyShortcutsDisabled(Value:Boolean);
       // Registry: ExtendedEditKeys
       Function  GetExtendedEditKey: Boolean;
       Procedure SetExtendedEditKey(Value: Boolean);
       // Registry: TrimLeadingZeros
       Function  GetTrimLeadingZeros: Boolean;
       Procedure SetTrimLeadingZeros(Value: Boolean);
     public
       // StdIn $1|#1 ProcessedInput : ENABLE_PROCESSED_INPUT
       Property  ProcessedInput : Boolean Read GetProcessedInput Write SetProcessedInput;
       // StdIn $2|#2 LineInput : ENABLE_LINE_INPUT
       Property  LineInput : Boolean Read GetLineInput Write SetLineInput;
       // StdIn $4|#4 EchoInput : ENABLE_ECHO_INPUT
       Property  EchoInput : Boolean Read GetEchoInput Write SetEchoInput;
       // StdIn $8|#8 WindowInput : ENABLE_WINDOW_INPUT
       Property  WindowInput : Boolean Read GetWindowInput Write SetWindowInput;
       // StdIn $10|#16 MouseInput : ENABLE_MOUSE_INPUT
       Property  MouseInput : Boolean Read GetMouseInput Write SetMouseInput;
       // StdIn $20|#32 InsertMode : ENABLE_INSERT_MODE
       Property  InsertMode : Boolean Read GetInsertMode Write SetInsertMode;
       // StdIn $40|#64 QuickEditMode : ENABLE_QUICK_EDIT_MODE
       Property  QuickEditMode : Boolean Read GetQuickEditMode Write SetQuickEditMode;
       // StdIn $80|#128 ExtendedFlags : ENABLE_EXTENDED_FLAGS
       Property  ExtendedFlags : Boolean Read GetExtendedFlags Write SetExtendedFlags;
       // StdIn $100/#256 AutoPosition : ENABLE_AUTO_POSITION
       Property  AutoPosition : Boolean Read GetAutoPosition Write SetAutoPosition;
       // StdIn $200/#512 VirtualTerminalInput : ENABLE_VIRTUAL_TERMINAL_INPUT
       Property  VirtualTerminalInput : Boolean Read GetVirtualTerminalInput Write SetVirtualTerminalInput;
       // StdOut $1|#1 ProcessedOutput : ENABLE_PROCESSED_OUTPUT
       // Backspace, tab, bell, carriage return, and line feed characters are processed.
       Property  ProcessedOutput : Boolean Read GetProcessedOutput Write SetProcessedOutput;
       // StdOut $2|#2 WrapOutput : ENABLE_WRAP_AT_EOL_OUTPUT
       // cursor moves to the beginning of the next row when reaches eol
       // causes scroll up when the cursor reaches the last row in the window
       Property  WrapOutput : Boolean Read GetWrapOutput Write SetWrapOutput;
       // StdOut $4|#4 VirtualTerminal : ENABLE_VIRTUAL_TERMINAL_PROCESSING
       // Control character sequences are parsed for VT100.
       Property  VirtualTerminal : Boolean Read GetVirtualTerminal Write SetVirtualTerminal;
       // StdOut $8|#8 NewlineAutoReturn : DISABLE_NEWLINE_AUTO_RETURN
       // Adds an additional state to end-of-line wrapping that can
       // delay the cursor move and buffer scroll operations. Scroll
       // operation and cursor move is delayed until the next character arrives.
       Property  DisableNewlineAutoReturn : Boolean Read GetDisableNewlineAutoReturn Write SetDisableNewlineAutoReturn;
       // StdOut $10|#16 LvbGridWorldwide : ENABLE_LVB_GRID_WORLDWIDE
       // Allow the usage of character attributes (underline, outline, invert)
       Property  LvbGridWorldwide : Boolean Read GetLvbGridWorldwide Write SetLvbGridWorldwide;
       Property  Input : DWord Read FInput;
       Property  Output : DWord Read FOutput;
       {$IFDEF CONSOLEOPACITY}
       Property  Opacity : Byte Read GetOpacity Write SetOpacity;
       Property  AutoOpacityOnFocus : Boolean Read GetAutoOpacityOnFocus Write SetAutoOpacityOnFocus;
       {$ENDIF CONSOLEOPACITY}
       // EnableAsciiCodeInput: Enable (Ctrl+^) for Ascii-Input-Char
       Property  EnableAsciiCodeInput : Boolean Read GetAsciiCodeInput Write SetAsciiCodeInput;
       // WrapWord: In case of LineWrap, try to find a space to Wrap the line
       Property  WrapWord : Boolean Read GetWrapWord Write SetWrapWord;
       // ReplaceControlCharacter: Replace ControlCharacter with visible Char if ProcessedOutput=False
       Property  ReplaceCtrlChar : Boolean Read GetReplaceCtrlChar Write SetGetReplaceCtrlChar;
       // UseAlternateWriteProc: Redirect System.Write and System.Writeln -> Default=True
       Property  UseAlternateWriteProc : Boolean Read GetUseAlternateWriteProc Write SetUseAlternateWriteProc;
       // ForceV2: True: enables all new console features
       Property  ForceV2 : Boolean Read GetForceV2 Write SetForceV2;
       // LineSelection: enable=line selection / disable=block mode selection
       Property  LineSelection : Boolean Read GetLineSelection Write SetLineSelection;
       // FilterOnPaste: enables new paste behavior
       Property  FilterOnPaste : Boolean Read GetFilterOnPaste Write SetFilterOnPaste;
       // LineWrap: wraps text when you resize console windows
       Property  LineWrap : Boolean Read GetLineWrap Write SetLineWrap;
       // CtrlKeyShortcutsDisabled: enables new key shortcuts / True: disables them
       Property  CtrlKeyShortcutsDisabled : Boolean Read GetCtrlKeyShortcutsDisabled Write SetCtrlKeyShortcutsDisabled;
       // ExtendedEditKeys: enables the full set of keyboard selection keys
       Property  ExtendedEditKey : Boolean Read GetExtendedEditKey Write SetExtendedEditKey;
       // TrimLeadingZeros: trims leading zeroes in selections made by double-clicking
       Property  TrimLeadingZeros : Boolean Read GetTrimLeadingZeros Write SetTrimLeadingZeros;
       Constructor Create;
       Destructor Destroy; Override;
       Procedure Clear;
       Procedure GetCurrentMode;
       Procedure SetDefaultValues;
     End;

(****************************)
(***** tConsoleRegistry *****)
(****************************)
Type tConsoleRegistry = Record
     private
       Function  GetKey : String;
       Function  GetKeyFeatureGlobal : String;
       Function  GetKeyFeatureLocal : String;
       Procedure IncCounter(Const CounterName:String);
     public
       Property  Key : String Read GetKey;
       Procedure IncCountStart;
       Procedure IncCountRead;
       Procedure IncCountWrite;
       Function  GetFeatureGlobal(Const ValueName:String; Var Value:Integer) : Boolean;
       Procedure SetFeatureGlobal(Const ValueName:String; Value:Integer);
       Function  GetFeatureLocal(Const ValueName:String; Var Value:Integer) : Boolean;
       Procedure SetFeatureLocal(Const ValueName:String; Value:Integer);
       Procedure DelFeatrueLocal(Const ValueName:String);
     end;

(****************************)
(***** tConsoleLocation *****)
(****************************)
Type tConsoleLocation = record
     private
       // Position: Pixelpos(X,Y) on desktop
       FPosition : TConsoleDesktopPoint;
       // Font: (Number, Size: Byte)
       //       Number: 1.._ConsoleFontNumberMax _ConsoleFontName[1.._ConsoleFontNumberMax]
       //       Size: 1.._ConsoleFontSizeMax _ConsoleFontSize[1.._ConsoleFontSizeMax]
       FFont : TConFont;
       Procedure SetFont(Const Value:TConFont);
       Procedure SetFontNumber(Const Value:Byte);
       Procedure SetFontSize(Const Value:Byte);
       Function  GetFontDimensions : TConsoleWindowPoint;
     public
       Procedure Clear;
       Procedure Init;
       Procedure AutofitPosition;
       Procedure AutofitFontSize(NewSizeX,NewSizeY:Smallint);
       Procedure TakeCurrentSettings;
       Function  TextPositionFont: String;
       Function  Valid: Boolean;
       Property  Position : TConsoleDesktopPoint Read FPosition Write FPosition;
       Property  Font : TConFont Read FFont Write SetFont;
       Property  FontNumber : Byte Read FFont.FontNumber Write SetFontNumber;
       Property  FontSize : Byte Read FFont.FontSize Write SetFontSize;
       Property  FontDimensions : TConsoleWindowPoint Read GetFontDimensions;
     end;

Type tConsoleLocationComputer = record
     private
       FConsoleLocation : tConsoleLocation;
     public
       Procedure Init;
       Function  LoadFromRegistry : Boolean;
       Procedure SaveToRegistry;
       function  Valid : Boolean;
       Property  ConsoleLocation: tConsoleLocation Read FConsoleLocation Write FConsoleLocation;
     end;

Function  ConsoleLocationMoveComputerRegistry : Boolean;

Type tConsoleLocationUser = record
     private
       FConsoleLocation : Array [0..9] of tConsoleLocation;
     public
       Procedure Init;
       Function  LoadFromRegistry(Const Index:Integer) : Boolean;
       Procedure SaveToRegistry(Const Index:Integer);
       Procedure LoadAllFromRegistry;
       Function  GetConsolePos(Index: Integer) : tConsoleLocation;
       Procedure SetConsolePos(Index: Integer; Const Value:tConsoleLocation);
       Function  GetPosition(Index: Integer) : TConsoleDesktopPoint;
       Procedure SetPosition(Index: Integer; Const Value: TConsoleDesktopPoint);
       Procedure SetFont(Const Index: Integer; Const Value:TConFont);
       Procedure SetFontNumber(Const Index: Integer; Const Value:Byte);
       Procedure SetFontSize(Const Index: Integer; Const Value:Byte);
       Procedure TakeCurrentSettings(Const Index: Integer);
       function  Valid(Const Index:Integer): Boolean;
       Function  TextLine(Const Index: Integer) : String;
       Property  ConsoleLocation[Index:Integer]:tConsoleLocation Read GetConsolePos Write SetConsolePos;
       Property  Position[Index:Integer]:TConsoleDesktopPoint Read GetPosition Write SetPosition;
     end;

Function  ConsoleLocationMoveUserRegistry(Index:Integer; SetDefault:Boolean=True) : Boolean;
Procedure ConsoleLocationSaveUserRegistry(Index:Integer);
Procedure ConsoleLocationMoveDefaultRegistry;

(********************)
(***** tConsole *****)
(********************)
Type tConsole = Class
     Private
       // FScreenBufferInfo contains:
       // dwSize: TCoord;               size of the console screen buffer, in character columns and rows
       // dwCursorPosition: TCoord;     column and row coordinates of the cursor in the console screen buffer.
       // wAttributes: Word;            attributes of the characters written to a screen buffer
       // srWindow: TSmallRect;         coordinates of the current window within the screen buffer
       // dwMaximumWindowSize: TCoord;  maximum size of the console window, in character columns and rows,
       //                               given the current screen buffer size AND font AND the screen size.
       FScreenBufferInfo: TConsoleBufferInfo;
       // indicates when screen buffer was last determined from winapi
       FScreenBufferTime: tDateTime;
       // indicates how often the screen buffer was determined from winapi
       FScreenBufferCount: DWord;
       // FCursorInfo: size and visible of the cursor
       FCursorInfo: TConsoleCursorInfo;
       // FConsoleLocationStandard: Standard Position (pixel) and Font for
       // console-window on the desktop
       FConsoleLocationDefault : tConsoleLocation;
       // Console-Codepages (Windows-Settings)
       FInputCodepage : TCodepage;
       FOutputCodepage : TCodepage;
       // Console-KeyboardLayout
       FKeyboardLayout : TKeyboardLayout;

       // Clear : Clears FScreenBufferInfo
       Procedure Clear;

       Function  GetColor(Index:Integer) : TColorRef;
       Procedure SetColor(Index:Integer; Const aColor:TColorRef);

       Function  GetInputCodepage : tCodepage;
       Procedure SetInputCodepage(Const aCodepage:tCodepage);
       Function  GetOutputCodepage : tCodepage;
       Procedure SetOutputCodepage(Const aCodepage:tCodepage);

       // Current Windows ANSI codepage (ACP) for the operating system.
       Function  GetWindowsCodepage : TCodepage;
       // ANSI code page used by a locale for applications
       Function  GetWindowsLocaleCodePage : TCodepage;

       // There is an open issue with microsoft. It is not possible to detect
       // a change of KeyboardLayout while the programme is running, so we can
       // only detect the KeyboardLayout that was active when the application
       // was started and assume that it will not be changed by the user.
       Function  GetKeyboardLayout : TKeyboardLayout;

       // GetScreenBufferInfo: Retriev the current settings from the system
       Function  GetScreenBufferInfo : Boolean;

       // BufferSize: Console-ScreenBufferSize in Char (columns and lines)
       //             only for internal use
       Function  GetBufferSize : TConsoleWindowPoint;
       Procedure SetBufferSize(Const Value:TConsoleWindowPoint);
       Property  BufferSize : TConsoleWindowPoint Read GetBufferSize Write SetBufferSize;

       // WindowRect: coordinates of the window within the buffer (rows & lines)
       Function  GetWindowRect : TConsoleWindowRect;

       Function  GetWindowSize : TConsoleWindowPoint;
       Procedure SetWindowSize(const WindowSizeNew: TConsoleWindowPoint);

       Function  GetCursorPosition : TConsoleWindowPoint;
       Procedure SetCursorPosition(Const CursorPositionNew:TConsoleWindowPoint); overload;
       Procedure SetCursorPosition(Const X,Y:Smallint); overload;

       Function  GetTitle: string;
       Function  GetOriginalTitle : String;
       Procedure SetTitle(const Value: string);

       Function  GetCursorInfo: Boolean;
       Function  GetCursorVisible : Boolean;
       Procedure SetCursorVisible(Const Value:Boolean);
       Function  GetCursorSize : Longword;
       Procedure SetCursorSize(Const Value:DWord);
       Function  GetCurWorkArea : TWorkArea;
       Function  GetTextAttr : tTextAttr;
       Procedure SetTextAttr(Value:tTextAttr);

     Public
       // Desktop: Area/Position from Console-Window in Pixel on the Screen/Desktop
       Desktop : TConsoleDesktop;
       // Mode: Windows-Properties for Console-Window
       Modes : TConsoleModes;
       // Font-Setting for current Console-Window
       Font : tConsoleFont;

       Constructor Create;
       Destructor Destroy; Override;

       Property Colors[Index:Integer] : TColorRef Read GetColor Write SetColor;
       Property InputCodepage : TCodepage Read FInputCodepage Write SetInputCodepage;
       Property OutputCodepage : TCodepage Read FOutputCodepage Write SetOutputCodepage;
       Property CodepageWindows : TCodepage Read GetWindowsCodepage;
       Property CodepageWindowsLocale : TCodepage Read GetWindowsLocaleCodepage;
       Property KeyboardLayout : TKeyboardLayout Read FKeyboardLayout;

       Procedure UseColorTableDefault;
       Procedure UseColorTableWindows;

       // AutofitFontsize: If the window is too large for the current screen,
       // the font size is reduced until the window fits the screen
       Function  AutofitFontsize(Var NewSize:TConsoleWindowPoint): Boolean; overload;
       Function  AutofitFontsize(Var NewSizeX,NewSizeY:Smallint) : Boolean; overload;

       // AutofitPosition: If the window extends beyond the edges of
       // the screen, the position of the window will be shifted
       Procedure AutofitPosition; overload;

       // WindowRect: coordinates of the window within the buffer (rows & lines)
       Property  WindowRect : TConsoleWindowRect Read GetWindowRect;
       // WindowSize: Console-Window-Size as (Right-Left | Bottom-Top)
       Property  WindowSize : TConsoleWindowPoint Read GetWindowSize write SetWindowSize;
       // Window: Set size of window in char (X * Y)
       Procedure Window(WindowSizeNew: TConsoleWindowPoint;
           FitScreen:Boolean=True; ClearScreen:Boolean=True); overload;
       Procedure Window(Const SizeX,SizeY:Smallint;
           FitScreen:Boolean=True; ClearScreen:Boolean=True); overload;
       // WindowMinSize: Calculated MinSize from DesktopMinSize
       //                for Console.Window (rows & lines)
       Function  WindowSizeMin : TConsoleWindowPoint;
       // MaxWindowSize: Max size of the window (rows & lines) according to
       //                the current WindowSize AND Font AND FontSize
       Property  WindowSizeMax : TConsoleWindowPoint Read FScreenBufferInfo.dwMaximumWindowSize Write FScreenBufferInfo.dwMaximumWindowSize;
       // WindowXXXX: Set size of window to predefined sizes
       Procedure WindowMin;     // usually 13 x 2 Char, depending on Font & Fontsize
       Procedure WindowDefault; //  80 x 25 Char
       Procedure WindowMedium;  // 100 x 35 Char
       Procedure WindowLarge;   // 120 x 50 Char
       // WindowIsDefault: True if current size is 80 x 25
       Function  WindowIsDefault : Boolean;
       Function  WindowIsMedium : Boolean;
       // WindowClrscr: Clr ScreenBuffer set Screen to current TextAttr
       Procedure WindowClrscr;

       // ShowDebug: Show internal values for debuging purposes
       Procedure ShowDebug(x,y:Byte; TColor:Byte=10);

       Procedure CursorOnNormalSize;
       Procedure CursorOnBigSize;
       Function  GetConsoleSelection(Var SelectionAnachor: TConsoleWindowPoint;
                   Var Selection: TConsoleWindowRect) : Boolean;

       // Title: Title of the Consol-Window
       Property  Title : String Read GetTitle Write SetTitle;
       // OriginalTitle: original title for the current console window (ReadOnly)
       Property  OriginalTitle : String Read GetOriginalTitle;

       // CursorPosition: colums & line of the cursor-position
       Property  CursorPosition : TConsoleWindowPoint Read GetCursorPosition Write SetCursorPosition;
       // CursorPositionX: colum of the cursor-position
       Property  CursorPositionX : Smallint Read FScreenBufferInfo.dwCursorPosition.X Write FScreenBufferInfo.dwCursorPosition.X;
       // CursorPositionY: line of the cursor-position
       Property  CursorPositionY : Smallint Read FScreenBufferInfo.dwCursorPosition.Y Write FScreenBufferInfo.dwCursorPosition.Y;

       // Winapi.GetConsoleCursorInfo
       Property  CursorVisible : Boolean Read GetCursorVisible Write SetCursorVisible;
       Property  CursorSize : Longword Read GetCursorSize Write SetCursorSize;

       // CurWorkArea: Size and scaling of the monitor on which the upper
       //              left corner of the current console.window is located
       Property  CurWorkArea : TWorkArea Read GetCurWorkArea;

       // TextAttr: attribute for write to console
       Property  TextAttr : TTextAttr Read GetTextAttr Write SetTextAttr;

       // ScreenBufferTime: Timestamp form last Update
       Property  ScreenBufferTime : tDateTime Read FScreenBufferTime Write FScreenBufferTime;
       // ScreenBufferCount: Count of GetInfoEx since programm started
       Property  ScreenBufferCount : Longword Read FScreenBufferCount Write FScreenBufferCount;

       Property  ConsoleLocationDefault : tConsoleLocation Read FConsoleLocationDefault Write FConsoleLocationDefault;

     End;

Type TConsole_ColorTable = Array [0..15] of TColorRef;

Type tConsoleInfoEx = Class
     Private
        FScreenBufferInfoEx: TConsoleBufferInfoEx;
        Function  GetColor(Index:Integer) : TColorRef;
        Procedure SetColor(Index:Integer; Const Value:TColorRef);
     Public
       Constructor Create;
       Destructor Destroy; Override;
       Function  GetInfoEx : Boolean;
       Function  SetInfoEx : Boolean;
                 // ScreenSize: Console-Buffer in Char (columns and lines)
       Property  ScreenSize : TConsoleWindowPoint Read FScreenBufferInfoEx.dwSize Write FScreenBufferInfoEx.dwSize;
                 // CursorPos: colums & line of the cursor-position
       Property  CursorPos : TConsoleWindowPoint Read FScreenBufferInfoEx.dwCursorPosition Write FScreenBufferInfoEx.dwCursorPosition;
                 // TextAttr: attribute for write to console
       Property  TextAttr : Word Read FScreenBufferInfoEx.wAttributes write FScreenBufferInfoEx.wAttributes;
                 // WindowRect: coordinates of the buffer
       Property  WindowRect : TSmallRect Read FScreenBufferInfoEx.srWindow Write FScreenBufferInfoEx.srWindow;
                 // WindowSizeMax: Max size of the window (rows & lines)
       Property  WindowSizeMax : TConsoleWindowPoint Read FScreenBufferInfoEx.dwMaximumWindowSize Write FScreenBufferInfoEx.dwMaximumWindowSize;
                 // PopupAttributes: I don't know the purpose
       Property  PopupAttributes : Word Read FScreenBufferInfoEx.wPopupAttributes write FScreenBufferInfoEx.wPopupAttributes;
                 // FullscreenSupported: This will always be FALSE for systems after Windows Vista
       Property  FullscreenSupported : BOOL Read FScreenBufferInfoEx.bFullscreenSupported write FScreenBufferInfoEx.bFullscreenSupported;
                 // ColorTable: 16 Colors like "old" crt.pas
       Property  ColorTable[Index:Integer] : TColorRef Read GetColor Write SetColor;
       Procedure SetColorTableDefault;
       Procedure SetColorTableWindows;
     End;

(**********************************)
(***** Console-Windows-Handle *****)
(**********************************)
Var ConHandleWindow  : TConHandle = 0;
    ConHandleStdOut  : TConHandle = 0;
    ConHandleStdIn   : TConHandle = 0;
    ConHandleStdErr  : TConHandle = 0;

procedure PlyConsoleInit;

implementation

Uses
  crt,
  Ply.Math,
  System.Math,
  System.StrUtils,
  System.Win.Registry,
  UxTheme,
  VCL.Dialogs,
  VCL.Forms;        // Get TWorkAreas from TScreen

{$IFDEF DELPHIXE8DOWN}
function GetLayeredWindowAttributes(Hwnd: THandle; var pcrKey: COLORREF; var pbAlpha: Byte;
  var pdwFlags: DWORD): Boolean; external user32 name 'GetLayeredWindowAttributes';

function GetConsoleOriginalTitle(lpConsoleTitle: LPWSTR; nSize: DWORD): DWORD;
  external kernel32 name 'GetConsoleOriginalTitleW';
{$ENDIF DELPHIXE8DOWN}

(*********************)
(***** TTextAttr *****)
(*********************)
function TTextAttr.GetTextcolor: Byte;
begin
  Result := FTextAttr mod 16;
end;

procedure TTextAttr.SetTextcolor(Value: Byte);
begin
  {$IFDEF BP7}
    FTextAttr := (Value and $8F) or (TextAttr and $70);
  {$ELSE}
    // If "Blink"
    if ((Value and $80)=$80) then
    begin
      Value   := Value - $80;
      InvertColors := True;
    end;
    FTextAttr := (Value and $0F) or (FTextAttr and $FFF0);
  {$ENDIF BP7}
end;

function TTextAttr.GetTextbackground: Byte;
begin
  Result := lo(FTextAttr) div 16;
end;

procedure TTextAttr.SetTextbackground(Value: Byte);
begin
  {$IFDEF BP7}
    FTextAttr := ((Color shl 4) and $7F) or (TextAttr and $8F);
  {$ELSE}
    FTextAttr := (Value shl 4) or (FTextAttr and $FF0F);
  {$ENDIF BP7}
end;

Function  TTextAttr.GetInvertColors : Boolean;
begin
  Result := (FTextAttr and COMMON_LVB_REVERSE_VIDEO) = COMMON_LVB_REVERSE_VIDEO;
end;

Procedure TTextAttr.SetInvertColors(Value:Boolean);
begin
  if (Value)
     then FTextAttr := FTextAttr or COMMON_LVB_REVERSE_VIDEO
     else FTextAttr := FTextAttr and not(COMMON_LVB_REVERSE_VIDEO);
end;

Function  TTextAttr.GetGridTop : Boolean;
begin
  Result := (FTextAttr and COMMON_LVB_GRID_HORIZONTAL) = COMMON_LVB_GRID_HORIZONTAL;
end;

Procedure TTextAttr.SetGridTop(Value:Boolean);
begin
  if (Value)
     then FTextAttr := FTextAttr or COMMON_LVB_GRID_HORIZONTAL
     else FTextAttr := FTextAttr and not(COMMON_LVB_GRID_HORIZONTAL);
end;

Function  TTextAttr.GetGridLeft : Boolean;
begin
  Result := (FTextAttr and COMMON_LVB_GRID_LVERTICAL) = COMMON_LVB_GRID_LVERTICAL;
end;

Procedure TTextAttr.SetGridLeft(Value:Boolean);
begin
  if (Value)
     then FTextAttr := FTextAttr or COMMON_LVB_GRID_LVERTICAL
     else FTextAttr := FTextAttr and not(COMMON_LVB_GRID_LVERTICAL);
end;

Function  TTextAttr.GetGridBottom : Boolean;
begin
  Result := (FTextAttr and COMMON_LVB_UNDERSCORE) = COMMON_LVB_UNDERSCORE;
end;

Procedure TTextAttr.SetGridBottom(Value:Boolean);
begin
  if (Value)
     then FTextAttr := FTextAttr or COMMON_LVB_UNDERSCORE
     else FTextAttr := FTextAttr and not(COMMON_LVB_UNDERSCORE);
end;

Function  TTextAttr.GetGridRight : Boolean;
begin
  Result := (FTextAttr and COMMON_LVB_GRID_RVERTICAL) = COMMON_LVB_GRID_RVERTICAL;
end;

Procedure TTextAttr.SetGridRight(Value:Boolean);
begin
  if (Value)
     then FTextAttr := FTextAttr or COMMON_LVB_GRID_RVERTICAL
     else FTextAttr := FTextAttr and not(COMMON_LVB_GRID_RVERTICAL);
end;

Function  TTextAttr.GetOutline : Boolean;
begin
  Result := (GetGridTop and GetGridLeft and GetGridRight and GetGridBottom);
end;

Procedure TTextAttr.SetOutline(Value:Boolean);
begin
  SetGridTop(Value);
  SetGridLeft(Value);
  SetGridRight(Value);
  SetGridBottom(Value);
  if (Value) then SetInvertColors(False);
end;

Function  TTextAttr.GetUnderline : Boolean;
begin
  Result := (not(GetGridTop) and not(GetGridLeft) and not(GetGridRight) and GetGridBottom);
end;

Procedure TTextAttr.SetUnderline(Value:Boolean);
begin
  if (Value) then
  begin
    SetGridTop(False);
    SetGridLeft(False);
    SetGridRight(False);
    SetGridBottom(True);
    SetInvertColors(False);
  end else
  begin
    // Set all Grids to False
    SetOutline(False);
  end;
end;

class operator TTextAttr.Implicit(Value: Word): TTextAttr;
begin
  Result.Attr := Value;
end;

class operator TTextAttr.Implicit(Value: tTextAttr): Word;
begin
  Result := Value.Attr;
end;

Constructor TTextAttr.Create(TColor, BColor:Byte);
begin
  FTextAttr      := 0;
  Textcolor      := TColor;
  Textbackground := BColor;
end;

Constructor TTextAttr.Create(TColor, BColor:Byte; ExtTextAttr:Word);
begin
  Textcolor      := TColor;
  Textbackground := BColor;
  FTextAttr      := FTextAttr or ExtTextAttr;
end;

procedure TTextAttr.Color(const TColor, BColor: Byte);
begin
  Textcolor      := TColor;
  Textbackground := BColor;
end;

// If new Console-Features (ForceV2) are not activated or Common_Lvb is
// disabled, then InvertColor if special attributes are given
Procedure TTextAttr.SetAttributesV1;
Var SaveColor : Byte;
begin
  if (InvertColors) or (Underline) or (Outline) then
  begin
       // Console runs in legacy mode
    if not(Console.Modes.ForceV2)          or
       // Common_LVB is not activated
       not(Console.Modes.LvbGridWorldwide) then
    begin
      SaveColor      := Textcolor;
      Textcolor      := Textbackground;
      Textbackground := SaveColor;
      InvertColors   := False;
    end;
  end;
end;

(*******************************************)
(***** Console-ScreenBuffer-Operations *****)
(*******************************************)
Function  GetConBufferInfo(Var ConsoleBufferInfo:TConsoleBufferinfo) : Boolean;
begin
  Result := False;
  if (ConHandleStdOut>0) then
  begin
    // Kernel32.dll: GetConsoleScreenBufferInfo
    if (GetConsoleBufferInfo(ConHandleStdOut, ConsoleBufferInfo)) then
    begin
      Result := True;
    end else
    begin
      raise EConsoleApiError.Create('GetConsoleBufferInfo;'+SysErrorMessage(GetLastError));
    end;
  end;
end;

Function  SetConBufferInfo(Const BufferSize:TConsoleWindowPoint) : Boolean;
begin
  if (BufferSize<>Console.BufferSize) then
  begin
    Result := False;
    // The buffer must never be smaller than the window
    // check this to avoid exceptions
    if (BufferSize.X>=Console.WindowSize.X) and
       (BufferSize.Y>=Console.WindowSize.Y) then
    begin
      // Kernel32.dll: SetConsoleScreenBufferSize
      if (SetConsoleBufferSize(ConHandleStdOut,BufferSize)) then
      begin
        Result := True;
      end else
      begin
        raise EConsoleApiError.Create('SetConsoleScreenBufferSize;'
                +SysErrorMessage(GetLastError));
      end;
    end;
  end else Result := True;
end;

Function  GetConBufferInfoEx(Var ConsoleBufferInfoEx:TConsoleBufferinfoEx) : Boolean;
begin
  FillChar(ConsoleBufferInfoEx,sizeof(ConsoleBufferInfoEx),#0);
  ConsoleBufferInfoEx.cbSize := sizeof(TConsoleBufferinfoEx);
  {$IFDEF FPC}
  if (GetConsoleBufferInfoEx(ConHandleStdOut, @ConsoleBufferInfoEx)) then
  {$ELSE}
  if (GetConsoleBufferInfoEx(ConHandleStdOut, ConsoleBufferInfoEx)) then
  {$ENDIF}
  begin
    Result := True;
  end else
  begin
    raise EConsoleApiError.Create('GetConsoleScreenBufferInfoEx;'+SysErrorMessage(GetLastError));
    Result := False;
  end;
end;

Function  SetConBufferInfoEx(Var ConsoleBufferInfoEx:TConsoleBufferinfoEx) : Boolean;
begin
  {$IFDEF FPC}
  if (SetConsoleScreenBufferInfoEx(ConHandleStdOut, @ConsoleScreenBufferInfoEx)) then
  {$ELSE}
  if (SetConsoleBufferInfoEx(ConHandleStdOut,ConsoleBufferInfoEx)) then
  {$ENDIF}
  begin
    Result := True;
  end else
  begin
    raise EConsoleApiError.Create('SetConsoleScreenBufferInfoEx;'+SysErrorMessage(GetLastError));
    Result := False;
  end;
end;

(***********************************)
(***** Console-Font-Operations *****)
(***********************************)
function GetCurrentConsoleFont(ConsoleOutput: TConHandle; bMaximumWindow: BOOL;
           var lpConsoleCurrentFont: TConsole_Font_Info): BOOL; stdcall;
           External Kernel32 name 'GetCurrentConsoleFont';

function SetCurrentConsoleFontEx(ConsoleOutput:TConHandle; MaximumWindow:BOOL;
           Var ConsoleInfo:TCONSOLE_FONT_INFOEX) : BOOL; stdcall;
           External Kernel32 name 'SetCurrentConsoleFontEx';

function GetCurrentConsoleFontEx(ConsoleOutput:TConHandle; MaximumWindow:BOOL;
           ConsoleInfo:PCONSOLE_FONT_INFOEX) : BOOL; stdcall;
           External Kernel32 name 'GetCurrentConsoleFontEx';

// Not documented Functions in Kernel32.dll
function GetNumberOfConsoleFonts : DWORD stdcall;
           External Kernel32 name 'GetNumberOfConsoleFonts';

function  SetConsoleFont(ConsoleOutput:TConHandle; FontNumber:DWORD) : BOOL; stdcall;
            External Kernel32 name 'SetConsoleFont';

Var _ConsoleFontName: Array [1.._ConsoleFontNumberMax] of tFontName =
        ('Terminal','Consolas','Lucida Console','Courier New','Fira Code');
      _ConsoleFontFamily: Array [1.._ConsoleFontNumberMax] of Cardinal =
        (FF_MODERN,FF_CONSOLE,FF_CONSOLE,FF_CONSOLE,FF_CONSOLE);
      _ConsoleFontDimensions: Array [1.._ConsoleFontNumberMax,1.._ConsoleFontSizeMax] of TConsoleWindowPoint =
          (* FontSize for "Terminal" *)
        (((x:4;y:6) ,(x:6;y:8) ,(x:5;y:12) ,(x:8;y:8)  ,(x:7;y:12) ,(x:8;y:12) ,(x:16;y:12),(x:12;y:16),(x:10;y:18)),
          (* FontSize for "Consolas" *)
         ((x:6;y:12),(x:7;y:14),(x:8;y:16) ,(x:8;y:18) ,(x:9;y:20) ,(x:11;y:24),(x:13;y:28),(x:15;y:32),(x:17;y:36)),
          (* FontSize for "Lucida Console" *)
         ((x:7;y:12),(x:8;y:14),(x:10;y:16),(x:11;y:18),(x:12;y:20),(x:14;y:24),(x:17;y:28),(x:20;y:33),(x:22;y:36)),
          (* FontSize for "Courier New" *)
         ((x:5;y:8)  ,(x:5;y:12),(x:7;y:14),(x:8;y:16) ,(x:10;y:18),(x:10;y:20),(x:13;y:24),(x:14;y:27),(x:19;y:36)),
          (* FontSize for "Fira Code" *)
         ((x:5;y:9) ,(x:6;y:12),(x:7;y:13),(x:8;y:16) ,(x:9;y:19),(x:10;y:20),(x:12;y:24),(x:14;y:28),(x:18;y:36)));

(**********************)
(***** tWorkAreas *****)
(**********************)
{$WARNINGS OFF}
function GetScaleFactorForMonitor; external 'Shcore.dll' name 'GetScaleFactorForMonitor' delayed;
// function GetThemeSysSize; external 'uxtheme.dll' name 'GetThemeSysSize' delayed;
{$WARNINGS ON}

Procedure tWorkAreas.Add(Const ARect:TConsoleDesktopRect; Const MScale:Integer=100);
begin
  SetLength(FAreas,length(FAreas)+1);
  FAreas[Length(FAreas)-1].Rect  := ARect;
  FAreas[Length(FAreas)-1].Scale := MScale;
end;

Function  tWorkAreas.GetWorkAreas : Boolean;
Var
  iCurrentMonitor : Integer;
  LMonitor : TMonitor;
  LScale : Integer;
begin
  Result := False;
  for iCurrentMonitor := 0 to Screen.MonitorCount-1 do
  begin
    Result := True;
    LMonitor := Screen.Monitors[iCurrentMonitor];
    // It is necessary that a manifest is used so that the scaling is
    // displayed correctly. Otherwise Windows will always simulate a
    // DPI of 96 and a Scale of 100 %.
    if (GetScaleFactorForMonitor(LMonitor.Handle, LScale) = S_OK) then
    begin
      Add(LMonitor.WorkareaRect,Integer(LScale));
    end else
    begin
      Add(LMonitor.WorkareaRect,100);
    end;
  end;
end;

Function  tWorkAreas.GetWorkArea(aPoint:TConsoleDesktopPoint) : tWorkArea;
var
  I: Integer;
begin
  aPoint.MaximizeToZero; // Set negative values to zero
  for I := Low(FAreas) to High(FAreas) do
  begin
    if (FAreas[i].Rect.Contains(aPoint)) then
    begin
      Result := FAreas[i];
      Exit;
    end;
  end;
  // determine first workarea as standard result
  Result := FAreas[0];
end;

Function  tWorkAreas.GetWorkArea(aLeft,aTop:Longint) : tWorkArea;
Var aPoint: TConsoleDesktopPoint;
begin
  aPoint.X := aLeft;
  aPoint.Y := aTop;
  Result := GetWorkArea(aPoint);
end;

Function  tWorkAreas.GetWorkAreaNext(aPoint:TConsoleDesktopPoint) : tWorkArea;
var
  I: Integer;
begin
  if (Length(FAreas)>0) then
  begin
    aPoint.MaximizeToZero; // Set negative values to zero
    for I := Low(FAreas) to High(FAreas) do
    begin
      if (FAreas[i].Rect.Contains(aPoint)) then
      begin
        if (High(FAreas)>i)
           then Result := FAreas[i+1]
           else Result := FAreas[0];
        Exit;
      end;
    end;
  end;
  // determine first workarea as standard result
  Result := FAreas[0];
end;

Function  tWorkAreas.GetWorkAreaNext(aLeft,aTop:Longint) : tWorkArea;
Var aPoint: TConsoleDesktopPoint;
begin
  aPoint.X := aLeft;
  aPoint.Y := aTop;
  Result := GetWorkAreaNext(aPoint);
end;

Function  tWorkAreas.MaxRight : Longint;
var
  I: Integer;
  MRight : Longint;
begin
  MRight := 0;
  for I := Low(FAreas) to High(FAreas) do
  begin
    MRight := Max(MRight,FAreas[i].Rect.Right);
  end;
  Result := MRight;
end;

Function  tWorkAreas.MaxBottom : Longint;
var
  I: Integer;
  MBottom : Longint;
begin
  MBottom := 0;
  for I := Low(FAreas) to High(FAreas) do
  begin
    MBottom := Max(MBottom,FAreas[i].Rect.Bottom);
  end;
  Result := MBottom;
end;

procedure tWorkAreas.Show(y, Lines: Byte);
Var i : integer;
begin
  for i := Low(FAreas) to High(FAreas) do
  begin
    if (i<Lines) then
    begin
      WriteXY(1,y+i,'WorkArea['+i.ToString+'] : Pos : '
          +IntToString(FAreas[i].Rect.Left,4)+'|'+IntToString(FAreas[i].Rect.Top,4)
          +'  Pixel : '+IntToString(FAreas[i].Rect.Width,4)+'|'
          +IntToString(FAreas[i].Rect.Height,4));
    end;
  end;
end;

(********************)
(***** TConFont *****)
(********************)
Function  TConFont.GetDimensions : TConsoleWindowPoint;
begin
  if (FontNumber>=1) and (FontNumber<=_ConsoleFontNumberMax) then
  begin
    if (FontSize>=1) and (FontSize<=_ConsoleFontSizeMax) then
    begin
      Result := _ConsoleFontDimensions[FontNumber,FontSize];
    end else Result := _ConsoleFontDimensions[FontNumber,_ConsoleFontSizeDefault];
  end else Result := _ConsoleFontDimensions[_ConsoleFontNumberDefault,_ConsoleFontSizeDefault];
end;

constructor TConFont.create(const aNumber, aSize: Byte);
begin
  if (aNumber>=1) and (aNumber<=_ConsoleFontNumberMax)
     then FontNumber := aNumber
     else FontNumber := _ConsoleFontNumberDefault;
  if (aSize>=1) and (aSize<=_ConsoleFontSizeMax)
     then FontSize   := aSize
     else FontSize   := _ConsoleFontSizeDefault;
end;

constructor TConFont.create(const aValue:Word);
begin
  FontValue := aValue;
end;

class operator TConFont.equal(Lhs, Rhs: TConFont) : Boolean;
begin
  Result := (Lhs.FontValue = Rhs.FontValue);
end;

class operator TConFont.notequal(Lhs, Rhs: TConFont) : Boolean;
begin
  Result := Not(Lhs = Rhs);
end;

(************************)
(***** TConsoleFont *****)
(************************)
Procedure tConsoleFont.Clear;
begin
  FillChar(FConsoleFontEx,sizeof(FConsoleFontEx),#0);
  FConsoleFontEx.cbSize := sizeof(FConsoleFontEx);
end;

Function tConsoleFont.GetConFont : tConFont;
Var aConFont : TConFont;
begin
  aConFont.FontNumber := GetFontNumber;
  aConFont.FontSize   := GetFontSize;
  Result := aConFont;
end;

Function tConsoleFont.GetFontName : String;
begin
  Result := String(FConsoleFontEx.FaceName);
end;

Function tConsoleFont.GetFontNumber : Byte;
Var b                        : Byte;
begin
  Result := 0;
  For b := 1 to _ConsoleFontNumberMax do
  begin
    if (FConsoleFontEx.FaceName=_ConsoleFontName[b]) then
    begin
      Result := b;
      Exit;
    end;
  end;
end;

Procedure tConsoleFont.SetFontNumber(Const Value:Byte);
begin
  if (Value>=1) and (Value<=_ConsoleFontNumberMax) then
  begin
    SetCurrentFont(Value,FontSize);
  end;
end;

Function tConsoleFont.GetFontSize : Byte;
Var FNummer                  : Byte;
    b                        : Byte;
begin
  Result := 0;
  FNummer  := GetFontNumber;
  if (FNummer>=1) and (FNummer<=_ConsoleFontNumberMax) then
  begin
    for b := 1 to _ConsoleFontSizeMax do
    begin
      if (FConsoleFontEx.dwFontDimensions.X=_ConsoleFontDimensions[FNummer,b].X) and
         (FConsoleFontEx.dwFontDimensions.Y=_ConsoleFontDimensions[FNummer,b].Y) then
      begin
        Result := b;
        Exit;
      end;
    end;
    // Fallback if no match
    Result := _ConsoleFontSizeDefault;
  end;
end;

Procedure tConsoleFont.SetFontSize(Const Value:Byte);
begin
  if (Value>=1) and (Value<=_ConsoleFontSizeMax) then
  begin
    SetCurrentFont(FontNumber,Value);
  end;
end;

Constructor tConsoleFont.Create;
begin
  Inherited Create;
  Clear;
end;

Destructor tConsoleFont.Destroy;
begin
  Inherited Destroy;
end;

Function tConsoleFont.Is_Terminal : Boolean;
begin
  (* Unter WinXP kann der Font nicht ermittelt werden *)
  if (FConsoleFontEx.FaceName=_ConsoleFontName[2]) or    (* Consolas       *)
     (FConsoleFontEx.FaceName=_ConsoleFontName[3]) or    (* Lucida Console *)
     (FConsoleFontEx.FaceName=_ConsoleFontName[4]) or    (* Courier New    *)
     (FConsoleFontEx.FaceName=_ConsoleFontName[5]) then  (* Fira Code      *)
  begin
    Result := False;
  end else
  begin
    Result := True;
  end;
end;

Procedure tConsoleFont.DecFontSize;
begin
  if (FontSize > 1)
     then FontSize := FontSize - 1
     else FontSize := 1;
end;

procedure tConsoleFont.DecFontNumber;
begin
  if (FontNumber > 1)
     then FontNumber := FontNumber -1
     else FontNumber := 1;
end;

Procedure tConsoleFont.IncFontSize;
begin
  if (FontSize < _ConsoleFontSizeMax)
     then FontSize := FontSize + 1
     else FontSize := _ConsoleFontSizeMax;
end;

Procedure tConsoleFont.IncFontNumber;
begin
  if (FontNumber < _ConsoleFontNumberMax)
     then FontNumber := FontNumber + 1
     else FontNumber := _ConsoleFontNumberMax;
end;

// FontNumberText: e.g. "2 = Consolas"
Function tConsoleFont.FontNumberText : String;
begin
  Result := IntToStr(GetFontNumber)+' = '+String(FontName);
end;

// FontSizeText: e.g. "4 = 9x20"
Function tConsoleFont.FontSizeText : String;
begin
  Result := IntToStr(GetFontSize)+' = '
          + IntToStr(FConsoleFontEx.dwFontDimensions.X)+'x'
          + IntToStr(FConsoleFontEx.dwFontDimensions.Y);
end;

// FontText: e.g. "2 = Consolas | Size : 4 = 9x20"
Function tConsoleFont.FontText : String;
begin
  Result := FontNumberText
          + ' | Size : '+FontSizeText;
end;

Function  tConsoleFont.GetCurrentFontEx : Boolean;
begin
  Result := False;
  //GetCurrentConsoleFontEx is available for Windows-Vista and higer
  if (Win32MajorVersion>=6.0) then
  begin
    Clear;
    Try
      if (GetCurrentConsoleFontEx(ConHandleStdOut, FALSE, @FConsoleFontEx)) then
      begin
        Result := True;
        // If unknown FaceName then set Font to Default-Font-Settings
        if (FConsoleFontEx.FaceName<>_ConsoleFontName[1]) and
           (FConsoleFontEx.FaceName<>_ConsoleFontName[2]) and
           (FConsoleFontEx.FaceName<>_ConsoleFontName[3]) and
           (FConsoleFontEx.FaceName<>_ConsoleFontName[4]) and
           (FConsoleFontEx.FaceName<>_ConsoleFontName[5]) then
        begin
          // SetCurrentFont to Default-Values
          SetCurrentFont(_ConsoleFontNumberDefault,_ConsoleFontSizeDefault);
        end;
      end else
      begin
        raise EConsoleApiError.Create('GetCurrentConsoleFontEx;'+SysErrorMessage(GetLastError));
      end;
    except
      raise EConsoleApiError.Create('GetCurrentConsoleFontEx;'+SysErrorMessage(GetLastError));
    end;
  end;
end;

Function  tConsoleFont.GetCurrentFontOld : Boolean;
Var CFont : TConsole_Font_Info;
begin
  Result := False;
  Clear;
  try
    if GetCurrentConsoleFont(ConHandleStdOut, FALSE, CFont) then
    begin
      FConsoleFontEx.nFont              := CFont.nFont;
      FConsoleFontEx.dwFontDimensions.x := CFont.dwFontSize.X;
      FConsoleFontEx.dwFontDimensions.y := CFont.dwFontSize.Y;
      FConsoleFontEx.FontFamily         := 0;
      FConsoleFontEx.FontWeight         := 400;
      FConsoleFontEx.FaceName           := 'Unknown';
      Result := True;
    end;
  except
    raise EConsoleApiError.Create('GetCurrentConsoleFont;'+SysErrorMessage(GetLastError));
  end;
end;

Function  tConsoleFont.GetCurrentFontOld(Var CFont:TConsole_Font_Info) : Boolean;
begin
  Result := False;
  FillChar(CFont,sizeof(CFont),#0);
  try
    if GetCurrentConsoleFont(ConHandleStdOut, FALSE, CFont) then
    begin
      Result := True;
    end;
  except
    raise EConsoleApiError.Create('GetCurrentConsoleFont;'+SysErrorMessage(GetLastError));
  end;
end;

Procedure tConsoleFont.SetDefault;
begin
  SetCurrentFont(_ConsoleFontNumberDefault,_ConsoleFontSizeDefault);
end;

Function  tConsoleFont.SetCurrentFont(Font:TConFont) : Boolean;
begin
  Result := SetCurrentFont(Font.FontNumber,Font.FontSize);
end;

Function  tConsoleFont.SetCurrentFont(FontNr,FontSize:Byte) : Boolean;
var NewFont : TCONSOLE_FONT_INFOEX;
begin
  Result := False;
  //SetCurrentConsoleFontEx is available from Windows-Vista and higer
  if (Win32MajorVersion>=6.0) then
  begin
    if (FontNr>=1) and (FontNr<=_ConsoleFontNumberMax) then
    begin
      if (FontSize>=1) and (FontSize<=_ConsoleFontSizeMax) then
      begin
        Try
          FillChar(NewFont,sizeof(NewFont),#0);
          NewFont.cbSize           := SizeOf(TCONSOLE_FONT_INFOEX);
          NewFont.FontFamily       := _ConsoleFontFamily[FontNr];
          NewFont.dwFontDimensions := _ConsoleFontDimensions[FontNr,FontSize];
          NewFont.FontWeight       := FW_NORMAL; // 400
          NewFont.FaceName         := _ConsoleFontName[FontNr];
          if (SetCurrentConsoleFontEx(ConHandleStdOut,TRUE,NewFont)) then
          begin
            // This is necessary to avoid wrong data e.g. if you retrive
            // the size in pixel of the console-window directly after
            // changing the font-size
            Sleep(25);
            // Get System-Settings and store in var "ConsoleFont"
            GetCurrentFontEx;
            // If the font is not present on the system, then set it to default font
            if (NewFont.FaceName=FConsoleFontEx.FaceName) then
            begin
              Result := True;
              // Depending on the screen resolution and scaling,
              // the FontDimensions may differ from the default values.
              // Adjust values to match the current system configuration.
              if (NewFont.dwFontDimensions.x<>FConsoleFontEx.dwFontDimensions.x) or
                 (NewFont.dwFontDimensions.y<>FConsoleFontEx.dwFontDimensions.y) then
              begin
                _ConsoleFontDimensions[FontNr,FontSize] := FConsoleFontEx.dwFontDimensions;
              end;
            end else
            // If Font (e.g. Fira Code) not present on system, try MS Gothic
            if (NewFont.FaceName<>'MS Gothic') then
            begin
              _ConsoleFontName[FontNr] := 'MS Gothic';
              Result := SetCurrentFont(FontNr, FontSize);
            end;
          end else
          begin
            raise EConsoleApiError.Create('SetCurrentConsoleFontEx;'+SysErrorMessage(GetLastError));
          end;
        except
          raise EConsoleApiError.Create('SetCurrentConsoleFontEx;'+SysErrorMessage(GetLastError));
        end;
      end;
    end;
  end;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
var
  S: TStrings;
  Temp: string;
begin
  S := TStrings(Data);
  Temp := Format('[%4d] : %-35s %3d x %3d'
            , [S.Count,String(LogFont.lfFaceName),LogFont.lfWidth,LogFont.lfHeight]);
  if (S.Count = 0) or (AnsiCompareText(Copy(Temp,10,255),Copy(S[S.Count-1],10,255)) <> 0)
     then S.Add(Temp);
  Result := 1;
end;

procedure SystemFontsCollect(FontList: TStrings);
var
  DC: HDC;
  LFont: TLogFont;
begin
  DC := GetDC(0);
  FillChar(LFont, sizeof(LFont), #0);
  LFont.lfCharset := DEFAULT_CHARSET;
  EnumFontFamiliesEx(DC, LFont, @EnumFontsProc, LPARAM(FontList), 0);
  ReleaseDC(0, DC);
end;

Function  ConsoleFontName(FontNumber:Byte) : String;
begin
  if (FontNumber>=1) and (FontNumber<=_ConsoleFontNumberMax) then
  begin
    Result := String(_ConsoleFontName[FontNumber]);
  end else Result := '???';
end;

Function  ConsoleFontDimensions(FontNumber,FontSize:Byte) : TConsoleWindowPoint;
begin
  if (FontNumber>=1) and (FontNumber<=_ConsoleFontNumberMax) then
  begin
    if (FontSize>=1) and (FontSize<=_ConsoleFontSizeMax) then
    begin
      Result := _ConsoleFontDimensions[FontNumber,FontSize];
    end else Result := Console.Font.FontDimensions;
  end else Result := Console.Font.FontDimensions;
end;

Function  ConsoleFontDimensionsDefault : TConsoleWindowPoint;
begin
  Result := ConsoleFontDimensions(_ConsoleFontNumberDefault,_ConsoleFontSizeDefault);
end;

Function  ConsoleFontDimensionsText(FontNumber,FontSize:Byte) : String;
begin
  if (FontNumber>=1) and (FontNumber<=_ConsoleFontNumberMax) then
  begin
    if (FontSize>=1) and (FontSize<=_ConsoleFontSizeMax) then
    begin
      Result := IntToStr(_ConsoleFontDimensions[FontNumber,FontSize].X)+'x'
              + IntToStr(_ConsoleFontDimensions[FontNumber,FontSize].Y);
    end else Result := '??? invalid FontSize';
  end else Result := '??? invalid FontNumber';
end;

(************************************)
(***** Console-Desktop-Position *****)
(************************************)
function  Console_GetDesktopArea(Var ConsoleDesktopRect:TConsoleDesktopRect): Boolean;
begin
  ConsoleDesktopRect.Clear;
  // user32.dll: GetWindowRect
  if (GetWindowRect(ConHandleWindow,ConsoleDesktopRect)) then
  begin
    Result := True;
  end else
  begin
    Result := False;
    EConsoleApiError.Create('Winapi.GetWindowRect'+SysErrorMessage(GetLastError));
  end;
end;

function  Console_SetDesktopArea(Var ConsoleDesktopRect:TConsoleDesktopRect): Boolean;
Var WindowSizeTarget : TConsoleWindowPoint;
    ScreenSave : tScreenSave;
begin
  ScreenSave.Save;
  // Move console-window to the new position on the desktop
  // user32.dll - MoveWindow
  if (MoveWindow(ConHandleWindow,ConsoleDesktopRect.Left,ConsoleDesktopRect.Top
         ,ConsoleDesktopRect.Width,ConsoleDesktopRect.Height,True)) then
  begin
    Result := True;
    // If the position of the console-window is moved to another screen/monitor
    // and the resolution of the screens/monitors is different, then the size
    // of the window must be adapted to the resolution
    WindowSizeTarget := Console.WindowSize;
    if (Console.GetScreenBufferInfo) then
    begin
      // if the window increases, the buffer has to be enlarged first
      // if the window decreases, the window has to be reduced first
      if (WindowSizeTarget.X>Console.BufferSize.X) or
         (WindowSizeTarget.Y>Console.BufferSize.Y) then
      begin
        // Increase the ScreenBuffer
        Console.BufferSize := WindowSizeTarget;
        // Set ScreenWindowSize
        Console.WindowSize := WindowSizeTarget;
      end else
      begin
        // Set ScreenWindowSize
        Console.WindowSize := WindowSizeTarget;
        // Set ScreenBuffer to ScreenSize
        Console.BufferSize := WindowSizeTarget;
      end;
      ScreenSave.Restore;
    end;
  end else
  begin
    Result := False;
    EConsoleApiError.Create('Winapi.MoveWindow'+SysErrorMessage(GetLastError));
  end;
end;

(***************************)
(***** TConsoleDesktop *****)
(***************************)
Function  TConsoleDesktop.GetArea : TConsoleDesktopRect;
Var
  CurrentDesktopRect : TConsoleDesktopRect;
begin
  // Always load from WinAPI, the user can have the window moved
  // around the screen at any time
  Try
    Console_GetDesktopArea(CurrentDesktopRect);
  Except
    On E : EConsoleApiError do ShowMessage(e.Message);
  End;
  Result := CurrentDesktopRect;
end;

Procedure TConsoleDesktop.SetArea(Value:TConsoleDesktopRect);
begin
  Try
    Console_SetDesktopArea(Value);
  Except
    On E : EConsoleApiError do ShowMessage(e.Message);
  End;
end;

Function  TConsoleDesktop.GetPosition : TConsoleDesktopPoint;
begin
  Result := Area.TopLeft;
end;

Procedure TConsoleDesktop.SetPosition(Value: TConsoleDesktopPoint);
Var
  TargetDesktopRect: TConsoleDesktopRect;
begin
  // Take Position from value
  TargetDesktopRect.TopLeft := Value;
  // Take dimensions (width & height) from current window
  TargetDesktopRect.Size    := Area.Size;
  SetArea(TargetDesktopRect);
end;

Constructor tConsoleDesktop.Create;
begin
  inherited Create;
end;

Destructor tConsoleDesktop.Destroy;
begin
  inherited Destroy;
end;

// AutofitPosition: If the window extends beyond the edges of
// the screen, the position of the window will be shifted
Procedure tConsoleDesktop.AutofitPosition;
Var ActiveWorkArea           : TConsoleDesktopRect;
    CurDesktopRect           : TConsoleDesktopRect;
begin
  // Delay is necessary because otherwise sometimes Console.DesktopPosision
  // returns incorrect values when the position has just been changed
  Sleep(25);

  // Get current rect of ConsoleWindow
  CurDesktopRect := Area;

  // Determine on which monitor (WorkArea) the top left corner of the
  // console window is located
  if (Screen<>Nil) then
  begin
    ActiveWorkArea := Screen.MonitorFromPoint(CurDesktopRect.TopLeft).WorkareaRect;
  end else
  begin
    ActiveWorkArea.Create(0,0,1920,1080);
  end;
  // If the window extends beyond the edges of the WorkArea
  // adapt the position of the window to the size of the WorkArea
  if (CurDesktopRect.FitScreen(ActiveWorkArea)) then
  begin
    Area := CurDesktopRect;
  end;
end;

Procedure TConsoleDesktop.MoveTo(Const X,Y:Longint; AutoFit:Boolean=False);
Var
  TargetDesktopPoint: TConsoleDesktopPoint;
begin
  // Take Position from value
  TargetDesktopPoint.X := X;
  TargetDesktopPoint.Y := Y;
  SetPosition(TargetDesktopPoint);
  if (AutoFit) then
  begin
    AutofitPosition;
  end;
end;

Function  tConsoleDesktop.FrameSize : TConsoleDesktopPoint;
Var
  DeskFrameSize : TConsoleDesktopPoint;
begin
  DeskFrameSize.X := (GetSystemMetrics(SM_CXPADDEDBORDER) + GetSystemMetrics(SM_CXSIZEFRAME)) * 2;
  DeskFrameSize.Y := DeskFrameSize.X + GetSystemMetrics(SM_CYCAPTION);
  Result          := DeskFrameSize;
end;

Function  tConsoleDesktop.SizeMin : TConsoleDesktopPoint;
Var
  DeskMinSize : TConsoleDesktopPoint;
begin
  DeskMinSize.X := GetSystemMetrics(SM_CXMIN);
  DeskMinSize.Y := GetSystemMetrics(SM_CYMIN);
  Result        := DeskMinSize;
end;

Function  tConsoleDesktop.SizeCalculated(WindowSize:TSmallPoint) : TConsoleDesktopPoint;
Var
  CurDeskRect   : TConsoleDesktopRect;
  DeskFrameSize : TConsoleDesktopPoint;
  DeskSizeCalc  : TConsoleDesktopPoint;
  FontSizeCalc  : TConsoleDesktopPoint;
begin
  CurDeskRect     := Area;
  DeskFrameSize   := FrameSize;
  FontsizeCalc.X  := (CurDeskRect.Width -FrameSize.X) div WindowSize.x;
  FontSizeCalc.Y  := (CurDeskRect.Height-FrameSize.Y) div WindowSize.y;
  DeskSizeCalc.X  := (FontSizeCalc.x*WindowSize.x)  + FrameSize.X;
  DeskSizeCalc.Y  := (FontSizeCalc.y*WindowSize.y) + FrameSize.Y;
  Result          := DeskSizeCalc;
end;

Function  tConsoleDesktop.Fontsize(WindowSize:TSmallPoint) : TConsoleDesktopPoint;
Var
  CurDeskRect   : TConsoleDesktopRect;
  DeskFrameSize : TConsoleDesktopPoint;
  FontSizeCalc  : TConsoleDesktopPoint;
begin
  CurDeskRect     := Area;
  DeskFrameSize   := FrameSize;
  FontsizeCalc.X  := (CurDeskRect.Width -DeskFrameSize.X) div WindowSize.x;
  FontSizeCalc.Y  := (CurDeskRect.Height-DeskFrameSize.Y) div WindowSize.y;
  Result          := FontSizeCalc;
end;

(************************)
(***** tConsoleMode *****)
(************************)
{$IFDEF CONSOLEOPACITY}
Function tConsoleModes.GetOpacity : Byte;
Var
 crKey: COLORREF;
 dwFlags: DWord;
begin
  Result := 100;
  if (GetLayeredWindowAttributes(ConHandleWindow,crKey,FOpacityAlpha,dwFlags)) then
  begin
    Result := Trunc(FOpacityAlpha/255*100);
  end;
end;

Procedure  tConsoleModes.SetOpacity(Const Percent:Byte);
Var
 crKey: COLORREF;
begin
  crKey := $0;
  FOpacityAlpha := ValueMinMax(Trunc(255*Percent/100),0,255);
  SetLayeredWindowAttributes(ConHandleWindow,crKey,FOpacityAlpha,LWA_ALPHA);
end;
{$ENDIF CONSOLEOPACITY}

Function tConsoleModes.GetModeInput : Boolean;
begin
  Try
    Result := GetConsoleMode(ConHandleStdIn, FInput);
  Except
    raise EConsoleApiError.Create('WinApi.GetConsoleMode failed : '+SysErrorMessage(GetLastError));
  end;
end;

Procedure tConsoleModes.SetModeInput(Const Value:DWord);
begin
  Try
    SetConsoleMode(ConHandleStdIn, Value);
    FInput := Value;
  Except
    raise EConsoleApiError.Create('WinApi.SetConsoleMode failed : '+SysErrorMessage(GetLastError));
  end;
end;

Function tConsoleModes.GetModeOutput : Boolean;
begin
  Try
    Result := GetConsoleMode(ConHandleStdOut, FOutput);
  Except
    raise EConsoleApiError.Create('WinApi.GetConsoleMode failed : '+SysErrorMessage(GetLastError));
  end;
end;

Procedure tConsoleModes.SetModeOutput(Const Value:DWord);
begin
  Try
    SetConsoleMode(ConHandleStdOut, Value);
    FOutput := Value;
  Except
    raise EConsoleApiError.Create('WinApi.SetConsoleMode failed : '+SysErrorMessage(GetLastError));
  end;
end;

Function  tConsoleModes.IsModeInputValue(Const aMode:DWord) : Boolean;
begin
  Result := ((FInput and aMode)=aMode);
end;

Function  tConsoleModes.GetModeInputValue(Const aMode:DWord) : Boolean;
begin
  if (GetModeInput) then
  begin
    Result := IsModeInputValue(aMode);
  end else
  begin
    Result := False;
  end;
end;

Procedure tConsoleModes.SetModeInputValue(Const aMode:DWord; Const Value:Boolean);
begin
  if (GetModeInput) then
  begin
    if (Value) then
    begin
      // If this mode is not set, then set this mode
      if ((FInput and aMode)<>aMode) then
      begin
        FInput := FInput + aMode;
        SetModeInput(FInput);
      end;
    end else
    begin
      // If this mode is set, then delete this mode
      if ((FInput and aMode)=aMode) then
      begin
        FInput := FInput - aMode;
        SetModeInput(FInput);
      end;
    end;
  end;
end;

Function  tConsoleModes.IsModeOutputValue(Const aMode:DWord) : Boolean;
begin
  Result := ((FOutput and aMode)=aMode);
end;

Function  tConsoleModes.GetModeOutputValue(Const aMode:DWord) : Boolean;
begin
  if (GetModeOutput) then
  begin
    Result := IsModeOutputValue(aMode);
  end else
  begin
    Result := False;
  end;
end;

Procedure tConsoleModes.SetModeOutputValue(Const aMode:DWord; Const Value:Boolean);
begin
  if GetModeOutput then
  begin
    if (Value) then
    begin
      // If this mode is not set, then set this mode
      if ((FOutput and aMode)<>aMode) then
      begin
        FOutput := FOutput + aMode;
        SetModeOutput(FOutput);
      end;
    end else
    begin
      // If this mode is set, then delete this mode
      if ((FOutput and aMode)=aMode) then
      begin
        FOutput := FOutput - aMode;
        SetModeOutput(FOutput);
      end;
    end;
  end;
end;

Function  tConsoleModes.GetRegistryFeature(ValueName:String) : Boolean;
Var ConsoleRegistry : tConsoleRegistry;
    RegValue        : Integer;
begin
  Result := False;
  if (ConsoleRegistry.GetFeatureLocal(ValueName,RegValue)) then
  begin
    Result := (RegValue=1);
  end else
  if (ConsoleRegistry.GetFeatureGlobal(ValueName,RegValue)) then
  begin
    Result := (RegValue=1);
  end;
end;

Procedure tConsoleModes.SetRegistryFeature(ValueName:String; Value:Boolean);
Var ConsoleRegistry : tConsoleRegistry;
    RegValue        : Integer;
begin
  if (ConsoleRegistry.GetFeatureGlobal(ValueName,RegValue)) then
  begin
    if ((RegValue=1)=Value) then
    begin
      ConsoleRegistry.DelFeatrueLocal(ValueName);
    end else
    begin
      if (Value)
         then ConsoleRegistry.SetFeatureLocal(ValueName,1)
         else ConsoleRegistry.SetFeatureLocal(ValueName,0);
    end;
  end;
end;

// ENABLE_PROCESSED_INPUT
// CTRL+C is processed by the system and is not placed in the input buffer.
// If the input buffer is being read by ReadFile or ReadConsole, other control
// keys are processed by the system and are not returned in the ReadFile or
// ReadConsole buffer. If the ENABLE_LINE_INPUT mode is also enabled, backspace,
// carriage return, and line feed characters are handled by the system.
Function  tConsoleModes.GetProcessedInput : Boolean;
begin
  GetProcessedInput := GetModeInputValue(ENABLE_PROCESSED_INPUT);
end;

Function  tConsoleModes.IsProcessedInput : Boolean;
begin
  IsProcessedInput := IsModeInputValue(ENABLE_PROCESSED_INPUT);
end;

Procedure tConsoleModes.SetProcessedInput(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_PROCESSED_INPUT,Value);
end;

// ENABLE_LINE_INPUT
// The ReadFile or ReadConsole function returns only when a carriage return
// character is read. If this mode is disabled, the functions return when one
// or more characters are available.
Function  tConsoleModes.GetLineInput : Boolean;
begin
  GetLineInput := GetModeInputValue(ENABLE_LINE_INPUT);
end;

Function  tConsoleModes.IsLineInput : Boolean;
begin
  IsLineInput := IsModeInputValue(ENABLE_LINE_INPUT);
end;

Procedure tConsoleModes.SetLineInput(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_LINE_INPUT,Value);
end;

// ENABLE_ECHO_INPUT
// Characters read by the ReadFile or ReadConsole function are written to
// the active screen buffer as they are typed into the console. This mode
// can be used only if the ENABLE_LINE_INPUT mode is also enabled.
Function  tConsoleModes.GetEchoInput : Boolean;
begin
  GetEchoInput := GetModeInputValue(ENABLE_ECHO_INPUT);
end;

Function  tConsoleModes.IsEchoInput : Boolean;
begin
  IsEchoInput := IsModeInputValue(ENABLE_ECHO_INPUT);
end;

Procedure tConsoleModes.SetEchoInput(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_ECHO_INPUT,Value);
end;

// ENABLE_Window_INPUT
// User interactions that change the size of the console screen buffer are
// reported in the console's input buffer. Information about these events can
// be read from the input buffer by applications using the ReadConsoleInput
// function, but not by those using ReadFile or ReadConsole.
Function  tConsoleModes.GetWindowInput : Boolean;
begin
  GetWindowInput := GetModeInputValue(ENABLE_Window_INPUT);
end;

Function  tConsoleModes.IsWindowInput : Boolean;
begin
  IsWindowInput := IsModeInputValue(ENABLE_Window_INPUT);
end;

Procedure tConsoleModes.SetWindowInput(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_Window_INPUT,Value);
end;

// ENABLE_MOUSE_INPUT
// If the mouse pointer is within the borders of the console window and the
// window has the keyboard focus, mouse events generated by mouse movement
// and button presses are placed in the input buffer. These events are
// discarded by ReadFile or ReadConsole, even when this mode is enabled.
// The ReadConsoleInput function can be used to read MOUSE_EVENT input
// records from the input buffer.
Function  tConsoleModes.GetMouseInput : Boolean;
begin
  GetMouseInput := GetModeInputValue(ENABLE_MOUSE_INPUT);
end;

Function  tConsoleModes.IsMouseInput : Boolean;
begin
  IsMouseInput := IsModeInputValue(ENABLE_MOUSE_INPUT);
end;

Procedure tConsoleModes.SetMouseInput(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_MOUSE_INPUT,Value);
end;

// ENABLE_INSERT_MODE
// When enabled, text entered in a console window will be inserted at the
// current cursor location and all text following that location will not be
// overwritten. When disabled, all following text will be overwritten.
Function  tConsoleModes.GetInsertMode : Boolean;
begin
  GetInsertMode := GetModeInputValue(ENABLE_INSERT_MODE);
end;

Function  tConsoleModes.IsInsertMode : Boolean;
begin
  IsInsertMode := IsModeInputValue(ENABLE_INSERT_MODE);
end;

Procedure tConsoleModes.SetInsertMode(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_INSERT_MODE,Value);
  SetRegistryFeature('InsertMode',Value);
end;

// ENABLE_QUICK_EDIT_MODE
// This flag enables the user to use the mouse to select and edit text. To
// enable this mode, use ENABLE_QUICK_EDIT_MODE | ENABLE_EXTENDED_FLAGS. To
// disable this mode, use ENABLE_EXTENDED_FLAGS without this flag.
Function  tConsoleModes.GetQuickEditMode : Boolean;
begin
  GetQuickEditMode := GetModeInputValue(ENABLE_QUICK_EDIT_MODE);
end;

Function  tConsoleModes.IsQuickEditMode : Boolean;
begin
  IsQuickEditMode := IsModeInputValue(ENABLE_QUICK_EDIT_MODE);
end;

Procedure tConsoleModes.SetQuickEditMode(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_QUICK_EDIT_MODE,Value);
  SetRegistryFeature('QuickEdit',Value);
end;

// ENABLE_EXTENDED_FLAGS
// see ENABLE_QUICK_EDIT_MODE
Function  tConsoleModes.GetExtendedFlags : Boolean;
begin
  GetExtendedFlags := GetModeInputValue(ENABLE_EXTENDED_FLAGS);
end;

Function  tConsoleModes.IsExtendedFlags : Boolean;
begin
  IsExtendedFlags := IsModeInputValue(ENABLE_EXTENDED_FLAGS);
end;

Procedure tConsoleModes.SetExtendedFlags(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_EXTENDED_FLAGS,Value);
end;

// ENABLE_AUTO_POSITION
// Not documented by Microsoft!?
Function  tConsoleModes.GetAutoPosition : Boolean;
begin
  GetAutoPosition := GetModeInputValue(ENABLE_AUTO_POSITION);
end;

Function  tConsoleModes.IsAutoPosition : Boolean;
begin
  IsAutoPosition := IsModeInputValue(ENABLE_AUTO_POSITION);
end;

Procedure tConsoleModes.SetAutoPosition(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_AUTO_POSITION,Value);
end;

// ENABLE_VIRTUAL_TERMINAL_INPUT
// Setting this flag directs the Virtual Terminal processing engine to convert
// user input received by the console window into Console Virtual Terminal
// Sequences that can be retrieved by a supporting application through ReadFile
// or ReadConsole functions.
// The typical usage of this flag is intended in conjunction with
// ENABLE_VIRTUAL_TERMINAL_PROCESSING on the output handle to connect to an
// application that communicates exclusively via virtual terminal sequences.
Function  tConsoleModes.GetVirtualTerminalInput : Boolean;
begin
  GetVirtualTerminalInput := GetModeInputValue(ENABLE_VIRTUAL_TERMINAL_INPUT);
end;

Function  tConsoleModes.IsVirtualTerminalInput : Boolean;
begin
  IsVirtualTerminalInput := IsModeInputValue(ENABLE_VIRTUAL_TERMINAL_INPUT);
end;

Procedure tConsoleModes.SetVirtualTerminalInput(Const Value:Boolean);
begin
  SetModeInputValue(ENABLE_VIRTUAL_TERMINAL_INPUT,Value);
end;

// ENABLE_PROCESSED_OUTPUT
// When TRUE Backspace, tab, bell, carriage return, and line feed
// characters are processed.
Function  tConsoleModes.GetProcessedOutput : Boolean;
begin
  GetProcessedOutput := GetModeOutputValue(ENABLE_PROCESSED_OUTPUT);
end;

Procedure tConsoleModes.SetProcessedOutput(Const Value:Boolean);
begin
  SetModeOutputValue(ENABLE_PROCESSED_OUTPUT,Value);
end;

// ENABLE_WRAP_AT_EOL_OUTPUT
// When writing to console the cursor moves to the beginning of the next row
// when it reaches the end of the current row. This causes the rows displayed
// in the console window to scroll up automatically when the cursor advances
// beyond the last row in the window.
Function  tConsoleModes.GetWrapOutput : Boolean;
begin
  GetWrapOutput := GetModeOutputValue(ENABLE_WRAP_AT_EOL_OUTPUT);
end;

Procedure tConsoleModes.SetWrapOutput(Const Value:Boolean);
begin
  SetModeOutputValue(ENABLE_WRAP_AT_EOL_OUTPUT,Value);
end;

// ENABLE_VIRTUAL_TERMINAL_PROCESSING
// When writing with WriteFile or WriteConsole, characters are parsed for VT100
// and similar control character sequences that control cursor movement,
// color/font mode, and other operations that can also be performed via the
// existing Console APIs.
Function  tConsoleModes.GetVirtualTerminal : Boolean;
begin
  GetVirtualTerminal := GetModeOutputValue(ENABLE_VIRTUAL_TERMINAL_PROCESSING);
end;

Procedure tConsoleModes.SetVirtualTerminal(Const Value:Boolean);
begin
  SetModeOutputValue(ENABLE_VIRTUAL_TERMINAL_PROCESSING,Value);
  // Ensure ENABLE_PROCESSED_OUTPUT is set when using VirtualTerminal
  if (Value) then SetProcessedOutput(True);
end;

// DISABLE_NEWLINE_AUTO_RETURN
// Normally when ENABLE_WRAP_AT_EOL_OUTPUT is set and text reaches the end of
// the line, the cursor will immediately move to the next line and the contents
// of the buffer will scroll up by one line. In contrast with this flag set,
// the cursor does not move to the next line, and the scroll operation is not
// performed.
Function  tConsoleModes.GetDisableNewlineAutoReturn : Boolean;
begin
  Result := GetModeOutputValue(DISABLE_NEWLINE_AUTO_RETURN);
end;

Procedure tConsoleModes.SetDisableNewlineAutoReturn(Const Value:Boolean);
begin
  SetModeOutputValue(DISABLE_NEWLINE_AUTO_RETURN,Value);
end;

// ENABLE_LVB_GRID_WORLDWIDE
// Setting this flag will allow attributes (Grid & Invert) to be used in
// every code page on every language.
Function  tConsoleModes.GetLvbGridWorldwide : Boolean;
begin
  GetLvbGridWorldwide := GetModeOutputValue(ENABLE_LVB_GRID_WORLDWIDE);
end;

Procedure tConsoleModes.SetLvbGridWorldwide(Const Value:Boolean);
begin
  SetModeOutputValue(ENABLE_LVB_GRID_WORLDWIDE,Value);
end;

Function  tConsoleModes.GetAsciiCodeInput : Boolean;
begin
  Result := FBool32[0];
end;

Procedure tConsoleModes.SetAsciiCodeInput(Value:Boolean);
begin
  FBool32[0] := Value;
end;

Function  tConsoleModes.GetWrapWord : Boolean;
begin
  Result := FBool32[1];
end;

Procedure tConsoleModes.SetWrapWord(Value:Boolean);
begin
  FBool32[1] := Value;
end;

Function  tConsoleModes.GetReplaceCtrlChar : Boolean;
begin
  Result := FBool32[2];
end;

Procedure tConsoleModes.SetGetReplaceCtrlChar(Value:Boolean);
begin
  FBool32[2] := Value;
end;

Function  tConsoleModes.GetUseAlternateWriteProc : Boolean;
begin
  Result := FBool32[3];
end;

Procedure tConsoleModes.SetUseAlternateWriteProc(Value:Boolean);
begin
  FBool32[3] := Value;
  if (Value)
     then AlternateWriteUnicodeStringProc := @CrtWriteAlternate
     else AlternateWriteUnicodeStringProc := Nil;
end;

// AutoOpacityOnFocus: Automatically sets the opacity to 50% if the
// console.window does not have the focus
Function  tConsoleModes.GetAutoOpacityOnFocus : Boolean;
begin
  Result := FBool32[4];
end;

Procedure tConsoleModes.SetAutoOpacityOnFocus(Value:Boolean);
begin
  FBool32[4] := Value;
end;

Function  tConsoleModes.GetForceV2 : Boolean;
begin
  Result := GetRegistryFeature('ForceV2');
end;

Procedure tConsoleModes.SetForceV2(Value:Boolean);
Var ConsoleRegistry : tConsoleRegistry;
begin
  if (Value)
     then ConsoleRegistry.SetFeatureGlobal('ForceV2',1)
     else ConsoleRegistry.SetFeatureGlobal('ForceV2',0);
end;

Function  tConsoleModes.GetLineSelection : Boolean;
begin
  Result := GetRegistryFeature('LineSelection');
end;

Procedure tConsoleModes.SetLineSelection(Value:Boolean);
begin
  SetRegistryFeature('LineSelection',Value);
end;

Function  tConsoleModes.GetFilterOnPaste : Boolean;
begin
  Result := GetRegistryFeature('FilterOnPaste');
end;

Procedure tConsoleModes.SetFilterOnPaste(Value:Boolean);
begin
  SetRegistryFeature('FilterOnPaste',Value);
end;

Function  tConsoleModes.GetLineWrap : Boolean;
begin
  Result := GetRegistryFeature('LineWrap');
end;

Procedure tConsoleModes.SetLineWrap(Value:Boolean);
begin
  SetRegistryFeature('LineWrap',Value);
end;

Function  tConsoleModes.GetCtrlKeyShortcutsDisabled : Boolean;
begin
  Result := GetRegistryFeature('CtrlKeyShortcutsDisabled');
end;

Procedure tConsoleModes.SetCtrlKeyShortcutsDisabled(Value:Boolean);
begin
  SetRegistryFeature('CtrlKeyShortcutsDisabled',Value);
end;

Function  tConsoleModes.GetExtendedEditKey : Boolean;
begin
  Result := GetRegistryFeature('ExtendedEditKeys');
end;

Procedure tConsoleModes.SetExtendedEditKey(Value:Boolean);
begin
  SetRegistryFeature('ExtendedEditKey',Value);
end;

Function  tConsoleModes.GetTrimLeadingZeros : Boolean;
begin
  Result := GetRegistryFeature('TrimLeadingZeros');
end;

Procedure tConsoleModes.SetTrimLeadingZeros(Value:Boolean);
begin
  SetRegistryFeature('TrimLeadingZeros',Value);
end;

Constructor tConsoleModes.Create;
begin
  inherited Create;
  Clear;
end;

Destructor tConsoleModes.Destroy;
begin
  inherited Destroy;
end;

Procedure tConsoleModes.Clear;
begin
  FInput := 0;
  FOutput := 0;
  FBool32.Clear;
  // FBool32[3]: UseAlternateWriteProc -> Default=True
  FBool32[3] := True;
  {$IFDEF CONSOLEOPACITY}
  FOpacityAlpha := 255;
  {$ENDIF CONSOLEOPACITY}
end;

Procedure tConsoleModes.GetCurrentMode;
begin
  GetModeInput;
  GetModeOutput;
end;

Procedure tConsoleModes.SetDefaultValues;
begin
  // Use (Ctrl+C) as Input, not for CheckBreak
  ProcessedInput := False;
  // Disable MouseInput by default
  MouseInput := False;
  // Enable QuickEditMode by default
  QuickEditMode := True;
  // Processe CR LF etc. by default
  ProcessedOutput := True;
  // WrapOutput by default
  WrapOutput := True;
  // DisableNewLineAutoReturn (at End of Screen) by default
  DisableNewlineAutoReturn := True;
  // Enable LVB-Grid-Attributes (underline & outline)
  LvbGridWorldwide := True;
  // Should be activated only when needed
  EnableAsciiCodeInput := False;
  // Linebreake on suitable places
  WrapWord := True;
  // Takes only effect if ProcessedOutput=False
  ReplaceCtrlChar := True;
  // LineSelection off by default
  LineSelection := False;
  // LineWrap on resize of by default
  LineWrap := False;
  // Disable CtrlKeyShortcuts by default
  CtrlKeyShortcutsDisabled := True;
  // not needed within a delphi console application
  ExtendedEditKey := False;
  // TrimLeadingZeros off by default
  TrimLeadingZeros := False;
  {$ifdef CONSOLEOPACITY}
  // Set Opacity to 100%
  Opacity := 100;
  {$endif CONSOLEOPACITY}
end;

(****************************)
(***** tConsoleRegistry *****)
(****************************)
Function  tConsoleRegistry.GetKey : String;
begin
  Result := 'Software\'+PlyCompanyName+'\'
          + FilenameWithoutExtension(Filename_Exe) + '\';
end;

Function  tConsoleRegistry.GetKeyFeatureGlobal : String;
begin
  Result := 'Console\';
end;

Function  tConsoleRegistry.GetKeyFeatureLocal : String;
begin
  Result := 'Console\'
          + StringReplace(FilePathName_Exe,'\','_',[rfReplaceAll]) + '\';
end;

Procedure tConsoleRegistry.IncCounter(Const CounterName:String);
var reg : TRegistry;
    Counter : Integer;
begin
  reg := TRegistry.Create(KEY_READ+KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  if (reg.OpenKey(GetKey,True)) then
  begin
    if (Reg.ValueExists(CounterName))
       then Counter := reg.ReadInteger(CounterName) + 1
       else Counter := 1;
    reg.WriteInteger(CounterName,Counter);
    reg.WriteDateTime(CounterName+'Last',Now);
    reg.CloseKey;
  end;
  reg.Free;
end;

procedure tConsoleRegistry.IncCountStart;
begin
  IncCounter('CountStart');
end;

Procedure tConsoleRegistry.IncCountRead;
begin
  IncCounter('CountRead');
end;

Procedure tConsoleRegistry.IncCountWrite;
begin
  IncCounter('CountWrite');
end;

Function  tConsoleRegistry.GetFeatureGlobal(Const ValueName:String; Var Value:Integer) : Boolean;
var reg : TRegistry;
begin
  Value  := -1;
  Result := False;
  reg := TRegistry.Create(KEY_READ);
  reg.RootKey := HKEY_CURRENT_USER;
  if (reg.OpenKey(GetKeyFeatureGlobal,True)) then
  begin
    if (Reg.ValueExists(ValueName)) then
    begin
      Value  := reg.ReadInteger(ValueName);
      Result := True;
    end;
    reg.CloseKey;
  end;
  reg.Free;
end;

Procedure tConsoleRegistry.SetFeatureGlobal(Const ValueName:String; Value:Integer);
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_READ+KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  if (reg.OpenKey(GetKeyFeatureGlobal,True)) then
  begin
    reg.WriteInteger(ValueName,Value);
    reg.CloseKey;
  end;
  reg.Free;
end;

Function  tConsoleRegistry.GetFeatureLocal(Const ValueName:String; Var Value:Integer) : Boolean;
var reg : TRegistry;
begin
  Value  := -1;
  Result := False;
  reg := TRegistry.Create(KEY_READ);
  reg.RootKey := HKEY_CURRENT_USER;
  if (reg.OpenKey(GetKeyFeatureLocal,True)) then
  begin
    if (Reg.ValueExists(ValueName)) then
    begin
      Value  := reg.ReadInteger(ValueName);
      Result := True;
    end;
    reg.CloseKey;
  end;
  reg.Free;
end;

Procedure tConsoleRegistry.SetFeatureLocal(Const ValueName:String; Value:Integer);
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_READ+KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  if (reg.OpenKey(GetKeyFeatureLocal,True)) then
  begin
    reg.WriteInteger(ValueName,Value);
    reg.CloseKey;
  end;
  reg.Free;
end;

Procedure tConsoleRegistry.DelFeatrueLocal(Const ValueName:String);
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_READ+KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  if (reg.OpenKey(GetKeyFeatureLocal,True)) then
  begin
    if (Reg.ValueExists(ValueName)) then
    begin
      Reg.DeleteValue(ValueName);
    end;
    reg.CloseKey;
  end;
  reg.Free;
end;

(****************************)
(***** tConsoleLocation *****)
(****************************)
Procedure tConsoleLocation.SetFont(Const Value:TConFont);
begin
  FFont := Value;
  FFont.FontNumber := ValueMinMax(FFont.FontNumber,1,_ConsoleFontNumberMax, _ConsoleFontNumberDefault);
  FFont.FontSize   := ValueMinMax(FFont.FontSize  ,1,_ConsoleFontSizeMax  , _ConsoleFontSizeDefault);
end;

Procedure tConsoleLocation.SetFontNumber(Const Value:Byte);
begin
  FFont.FontNumber := ValueMinMax(Value, 1, _ConsoleFontNumberMax, _ConsoleFontNumberDefault);
end;

Procedure tConsoleLocation.SetFontSize(Const Value:Byte);
begin
  FFont.FontSize := ValueMinMax(Value, 1, _ConsoleFontSizeMax, _ConsoleFontSizeDefault);
end;

Function  tConsoleLocation.GetFontDimensions : TConsoleWindowPoint;
begin
  Result := FFont.Dimensions;
end;

Procedure tConsoleLocation.Clear;
begin
  Position.Create(-1,-1);
  FontNumber := _ConsoleFontNumberDefault;
  FontSize   := _ConsoleFontSizeDefault;
end;

Procedure tConsoleLocation.Init;
begin
  Position.Create(10,10);
  FontNumber := _ConsoleFontNumberDefault;
  FontSize   := _ConsoleFontSizeDefault;
end;

Procedure tConsoleLocation.AutofitPosition;
begin
  // Adjust position if necessary
  Console.AutofitPosition;
  // Save Position
  Position := Console.Desktop.Area.TopLeft;
end;

Procedure tConsoleLocation.AutofitFontSize(NewSizeX,NewSizeY:Smallint);
begin
  Console.AutofitFontsize(NewSizeX,NewSizeY);
end;

Procedure tConsoleLocation.TakeCurrentSettings;
begin
  // Determin current Font settings from System, in case user has changed manual
  Console.Font.GetCurrentFontEx;
  // Save current Font (Size and Number)
  SetFont(Console.Font.Font);
  // Save current position on Desktop
  Position := Console.Desktop.Area.TopLeft;
end;

function tConsoleLocation.Valid: Boolean;
begin
  if (Position.x>=0) and
     (Position.y>=0) then
  begin
    Valid := True;
  end else
  begin
    Valid := False;
  end;
end;

function TConsoleLocation.TextPositionFont: String;
begin
  Result := Format('%4d',[Position.x]) + '  '
          + Format('%4d',[Position.y])  + '  '
          + IntToStr(FontNumber) + '='
            + Format('%-14s',[ConsoleFontName(FontNumber)]) + '  '
          + IntToStr(FontSize)   + '='
            + Format('%5s',[ConsoleFontDimensionsText(FontNumber,FontSize)]);
end;

(************************************)
(***** tConsoleLocationComputer *****)
(************************************)
Procedure tConsoleLocationComputer.Init;
begin
  // Default Font & Fontsize, Pos(10,10)
  FConsoleLocation.Init;
end;

Function  tConsoleLocationComputer.LoadFromRegistry : Boolean;
var
  ConReg : tConsoleRegistry;
  reg    : TRegistry;
begin
  Init;
  ConReg.IncCountRead;
  reg := TRegistry.Create(KEY_READ);
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.Access := KEY_READ;
  if (reg.OpenKey(ConReg.GetKey,False)) then
  begin
    Try
      if (Reg.ValueExists('ConsoleLocation')) then
      begin
        reg.ReadBinaryData('ConsoleLocation'
          ,FConsoleLocation,Sizeof(FConsoleLocation));
      end;
      Result := True;
    Except
      Result := False;
    End;
    reg.CloseKey;
  end else Result := False;
  reg.Free;
end;

procedure tConsoleLocationComputer.SaveToRegistry;
var
  ConReg : tConsoleRegistry;
  reg    : TRegistry;
begin
  ConReg.IncCountWrite;
  reg := TRegistry.Create(KEY_WRITE);
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.Access := KEY_WRITE;
  if (reg.OpenKey(ConReg.GetKey,True)) then
  begin
    reg.WriteBinaryData('ConsoleLocation'
      ,FConsoleLocation,Sizeof(FConsoleLocation));
    reg.CloseKey;
  end;
  reg.Free;
end;

function  tConsoleLocationComputer.Valid : Boolean;
begin
  Result := FConsoleLocation.Valid;
end;

Function  ConsoleLocationMoveComputerRegistry : Boolean;
Var ConsoleLocationComputer : tConsoleLocationComputer;
begin
  Result := False;
  if (ConsoleLocationComputer.LoadFromRegistry) then
  begin
    if (ConsoleLocationComputer.Valid) then
    begin
      // Change ConsolenFont to the saved value
      Console.Font.SetCurrentFont(ConsoleLocationComputer.ConsoleLocation.Font);
      // move console-window to saved position
      Console.Desktop.Position := ConsoleLocationComputer.ConsoleLocation.Position;
      // autofit position on this screen
      ConsoleLocationComputer.ConsoleLocation.AutofitPosition;
      Result := True;
    end;
  end;
end;

(********************************)
(***** tConsoleLocationUser *****)
(********************************)
Procedure tConsoleLocationUser.Init;
Var i : integer;
begin
  For i := 0 to 9 do
  begin
    FConsoleLocation[i].Init;  // Default Font & Fontsize
    FConsoleLocation[i].FPosition.X := 10+(i*10);
    FConsoleLocation[i].FPosition.Y := 10+(i*10);
  end;
end;

Function  tConsoleLocationUser.LoadFromRegistry(Const Index:Integer) : Boolean;
var
  ConReg : tConsoleRegistry;
  reg    : TRegistry;
begin
  Result := False;
  Init;
  if (Index>=0) and (Index<=9) then
  begin
    ConReg.IncCountRead;
    reg := TRegistry.Create(KEY_READ);
    reg.RootKey := HKEY_CURRENT_USER;
    reg.Access := KEY_READ;
    if (reg.OpenKey(ConReg.GetKey,False)) then
    begin
      Try
        if (Reg.ValueExists('ConsoleLocation['+Index.ToString+']')) then
        begin
          reg.ReadBinaryData('ConsoleLocation['+Index.ToString+']'
            ,FConsoleLocation[Index],Sizeof(FConsoleLocation[Index]));
        end;
        Result := True;
      Except
        Result := False;
      End;
      reg.CloseKey;
    end else Result := False;
    reg.Free;
  end;
end;

Procedure tConsoleLocationUser.LoadAllFromRegistry;
Var
  Index  : Integer;
  ConReg : tConsoleRegistry;
  reg    : TRegistry;
begin
  Init;
    ConReg.IncCountRead;
  for Index := 0 to 9 do
  begin
    reg := TRegistry.Create(KEY_READ);
    reg.RootKey := HKEY_CURRENT_USER;
    reg.Access := KEY_READ;
    if (reg.OpenKey(ConReg.GetKey,False)) then
    begin
      Try
        if (Reg.ValueExists('ConsoleLocation['+Index.ToString+']')) then
        begin
          reg.ReadBinaryData('ConsoleLocation['+Index.ToString+']'
            ,FConsoleLocation[Index],Sizeof(FConsoleLocation[Index]));
        end;
      Except
      End;
      reg.CloseKey;
    end;
    reg.Free;
  end;
end;

procedure tConsoleLocationUser.SaveToRegistry(Const Index:Integer);
var
  ConReg : tConsoleRegistry;
  reg    : TRegistry;
begin
  if (Index>=0) and (Index<=9) then
  begin
    ConReg.IncCountWrite;
    reg := TRegistry.Create(KEY_WRITE);
    reg.RootKey := HKEY_CURRENT_USER;
    reg.Access := KEY_WRITE;
    if (reg.OpenKey(ConReg.GetKey,True)) then
    begin
      reg.WriteBinaryData('ConsoleLocation['+Index.ToString+']'
        ,FConsoleLocation[Index],Sizeof(FConsoleLocation[Index]));
      reg.CloseKey;
    end;
    reg.Free;
  end;
end;

Function  tConsoleLocationUser.GetConsolePos(Index: Integer) : tConsoleLocation;
begin
  Result := FConsoleLocation[Index];
end;

Procedure tConsoleLocationUser.SetConsolePos(Index: Integer; Const Value:tConsoleLocation);
begin
  FConsoleLocation[Index] := Value;
end;

Function  tConsoleLocationUser.GetPosition(Index: Integer) : TConsoleDesktopPoint;
begin
  Result := FConsoleLocation[Index].Position;
end;

Procedure tConsoleLocationUser.SetPosition(Index: Integer; Const Value: TConsoleDesktopPoint);
begin
  FConsoleLocation[Index].Position := Value;
end;

Procedure tConsoleLocationUser.SetFont(Const Index: Integer; Const Value:TConFont);
begin
  if (Index>=0) and (Index<=9) then
  begin
    FConsoleLocation[Index].Font := Value;
  end;
end;

Procedure tConsoleLocationUser.SetFontNumber(Const Index: Integer; Const Value:Byte);
begin
  if (Index>=0) and (Index<=9) then
  begin
    if (Value>=1) and (Value<=_ConsoleFontNumberMax) then
    begin
      FConsoleLocation[Index].FontNumber := Value;
    end;
  end;
end;

Procedure tConsoleLocationUser.SetFontSize(Const Index: Integer; Const Value:Byte);
begin
  if (Index>=0) and (Index<=9) then
  begin
    if (Value>=1) and (Value<=_ConsoleFontSizeMax) then
    begin
      FConsoleLocation[Index].FontSize := Value;
    end;
  end;
end;

Procedure tConsoleLocationUser.TakeCurrentSettings(Const Index: Integer);
begin
  if (Index>=0) and (Index<=9) then
  begin
    FConsoleLocation[Index].TakeCurrentSettings;
  end;
end;

function  tConsoleLocationUser.Valid(Const Index:Integer): Boolean;
begin
  Result := False;
  if (Index>=0) and (Index<=9) then
  begin
    Result := FConsoleLocation[Index].Valid;
  end;
end;

function tConsoleLocationUser.TextLine(Const Index: Integer): String;
begin
  if (Index>=0) and (Index<=9) then
  begin
    Result := '('+IntToStr(Index)+') Pos['+IntToStr(Index)+']   : '
      +FConsoleLocation[Index].TextPositionFont;
  end;
end;

Function  ConsoleLocationMoveUserRegistry(Index:Integer; SetDefault:Boolean=True) : Boolean;
Var ConsoleLocationUser      : tConsoleLocationUser;
begin
  Result := False;
  if (Index>=0) and (Index<=9) then
  begin
    if (ConsoleLocationUser.LoadFromRegistry(Index)) then
    begin
      if (ConsoleLocationUser.Valid(Index)) then
      begin
        // Change ConsolenFont to the saved value
        Console.Font.SetCurrentFont(ConsoleLocationUser.ConsoleLocation[Index].Font);
        // move console-window to saved position
        Console.Desktop.Position := ConsoleLocationUser.Position[Index];
        // autofit position if out of bounds
        ConsoleLocationUser.ConsoleLocation[Index].AutofitPosition;
        Result := True;
        Exit;
      end;
    end;
    // If no user settings could be loaded, set font to default & don't move window
    if (SetDefault) then
    begin
      // Change ConsolenFont to default value
      Console.Font.SetDefault;
      // autofit position if out of bounds
      Console.AutofitPosition;
    end;
  end;
end;

Procedure ConsoleLocationSaveUserRegistry(Index:Integer);
Var UserConsolePosition      : tConsoleLocationUser;
begin
  if (Index>=0) and (Index<=9) then
  begin
    UserConsolePosition.TakeCurrentSettings(Index);
    UserConsolePosition.SaveToRegistry(Index);
  end;
end;

Procedure ConsoleLocationMoveDefaultRegistry;
begin
  if not(ConsoleLocationMoveComputerRegistry) then
  begin
    ConsoleLocationMoveUserRegistry(0,False);
  end;
end;

// reduces the fontsize if the window with the acutall fontsize is
// larger than the desktop. Desktopsize depends on where the upper left
// corner of the console-window is
// NewSizeX and NewSizeY are colums and rows in char e.g. 80x25 or 120x50
Function  tConsole.AutofitFontsize(Var NewSize:TConsoleWindowPoint) : Boolean;
Var ConsoleMaxSize           : COORD;
begin
  // Retrieves the size of the largest possible console window, based on the
  // current font and the size of the display. Get number of character cell
  // columns (X) and rows (Y) in the largest possible console window
  ConsoleMaxSize := GetLargestConsoleWindowSize(ConHandleStdOut);
  // As long as the window does not fit on the desktop, reduce the font size.
  While ((ConsoleMaxSize.X<NewSize.X) or (ConsoleMaxSize.Y<NewSize.Y)) and
        (Console.Font.FontSize>1) do
  begin
    Console.Font.SetCurrentFont(Console.Font.FontNumber,Console.Font.FontSize-1);
    // Retrieves the size of the largest possible console window, based on the
    // current font and the size of the display. get number of character cell
    // columns (X) and rows (Y) in the largest possible console window
    ConsoleMaxSize := GetLargestConsoleWindowSize(ConHandleStdOut);
  end;
  if ((NewSize.X<=ConsoleMaxSize.X) and (NewSize.Y<=ConsoleMaxSize.Y)) then
  begin
    // NewSize is possible
    Result := True;
  end else
  begin
    // NewSize is not possible
    Result := False;
    // Reduce to the maximum possible size
    NewSize.X := Min(NewSize.X,ConsoleMaxSize.X);
    NewSize.Y := Min(NewSize.Y,ConsoleMaxSize.Y);
  end;
end;

function tConsole.AutofitFontsize(Var NewSizeX,NewSizeY:Smallint): Boolean;
Var NewSize : TConsoleWindowPoint;
begin
  NewSize.X := NewSizeX;
  NewSize.Y := NewSizeY;
  Result := AutofitFontsize(NewSize);
  NewSizeX := NewSize.X;
  NewSizeY := NewSize.Y;
end;

// AutofitPosition: If the window extends beyond the edges of
// the screen, the position of the window will be shifted
Procedure tConsole.AutofitPosition;
Var ActiveWorkArea           : TConsoleDesktopRect;
    CurDesktopRect           : TConsoleDesktopRect;
begin
  // Delay is necessary because otherwise sometimes Console.DesktopPosision
  // returns incorrect values when the position has just been changed
  Sleep(25);

  // Get current rect of ConsoleWindow
  CurDesktopRect := Console.Desktop.Area;

  // Determine on which monitor (WorkArea) the top left corner of the
  // console window is located
  if (Screen<>Nil) then
  begin
    ActiveWorkArea := Screen.MonitorFromPoint(CurDesktopRect.TopLeft).WorkareaRect;
  end else
  begin
    ActiveWorkArea.Create(0,0,1920,1080);
  end;
  // If the window extends beyond the edges of the WorkArea
  // adapt the position of the window to the size of the WorkArea
  if (CurDesktopRect.FitScreen(ActiveWorkArea)) then
  begin
    if (CurDesktopRect.Width<=ActiveWorkArea.Width)   and
       (CurDesktopRect.Height<=ActiveWorkArea.Height) then
    begin
      Console.Desktop.Area := CurDesktopRect;
    end;
  end;
end;

procedure tConsole.Window(WindowSizeNew: TConsoleWindowPoint; FitScreen:
    Boolean = True; ClearScreen: Boolean = True);
Var TargetConsoleRect        : TConsoleDesktopRect;
    WindowSizeHelp           : TConsoleWindowPoint;
begin
  Try
    // Do nothing if WindowSizeNew = actuall size
    if (WindowSizeNew<>WindowSize) then
    begin
      // WindowSizeNew must be at least WindowSizeMin
      WindowSizeNew.Normalize(WindowSizeMin);
      // If (current size = 80 x 25) then save position as default-position
      // for Console-Windows with normal size
      if (WindowIsDefault) then
      begin
        // Save current Console-Pos, font and fontsize
        FConsoleLocationDefault.Position := Console.Desktop.Area.TopLeft;
        FConsoleLocationDefault.Font     := Console.Font.Font;
      end;

      if (ClearScreen) then Console.WindowClrscr;

      // if the window increases, the buffer has to be enlarged first
      // if the window decreases, the window has to be reduced first

      // Window gets reduced -> First reduce size to avoid exceptions
      if (WindowSizeNew.X<Console.WindowSize.X) or
         (WindowSizeNew.Y<Console.WindowSize.Y) then
      begin
        // Perhaps smaller than target size
        WindowSizeHelp.X   := Max(1,Min(Console.WindowSize.X,WindowSizeNew.X-1));
        WindowSizeHelp.Y   := Max(1,Min(Console.WindowSize.Y,WindowSizeNew.Y-1));
        Console.WindowSize := WindowSizeHelp;
      end;

      // Check if the window fits on the screen in the new size
      // If not, reduce the fontsize until the window fits on screen
      if (FitScreen) then
      begin
        // Has only to be checked, if the target-size of the window is larger
        // then the current-size of the window
        if (WindowSizeNew.X>Console.WindowSize.X) or
           (WindowSizeNew.Y>Console.WindowSize.Y) then
        begin
          // Autofit the fontsize of the console-window
          Console.AutofitFontsize(WindowSizeNew);
        end;
      end;

      // Set ScreenBufferSize to target-size
      Console.BufferSize := WindowSizeNew;

      // Set Consol-Window-Size to target size
      Console.WindowSize := WindowSizeNew;
      Crt.WindSize.SmallRect := Console.WindowRect;

      // If go back to default-size (80x25), check if a default-pos (on the
      // desktop) was saved before. If so then set the console-window to the
      // default-pos and size. This is necessary because the position may have
      // been changed by Console.AutofitPosition and/or Console.AutofitFontsize
      if (Console.WindowIsDefault) and (ConsoleLocationDefault.Valid) then
      begin
        TargetConsoleRect.TopLeft := ConsoleLocationDefault.Position;
        // Delay(25) is necessary! SetScreenWindowSize is sometimes to slow and
        // Console.DesktopArea retrieves the "old" value because the
        // window has not been enlarged
        Delay(25);
        // Adopt only the Size (Width & Height) in Pixel keep "TopLeft" untouched
        TargetConsoleRect.Size := Console.Desktop.Area.Size;
        // Move ConsoleWindow to the "old" Position (before AutoFit-Change)
        Console.Desktop.Area := TargetConsoleRect;
        // If the font has been changed form "Console.AutoFitFontSize",
        // set back to the olf font
        if (Console.Font.Font<>ConsoleLocationDefault.Font) then
        begin
          Console.Font.SetCurrentFont(ConsoleLocationDefault.Font);
        end;
      end;

      if (FitScreen) then
      begin
        Console.AutofitPosition;
      end;
    end;
  Except
    on e : EConsoleApiError do ShowMessage(e.Message);
  End;
end;

Procedure tConsole.Window(Const SizeX,SizeY:Smallint; FitScreen:Boolean=True; ClearScreen:Boolean=True);
Var WindowSizeNew:TConsoleWindowPoint;
begin
  WindowSizeNew.X := SizeX;
  WindowSizeNew.Y := SizeY;
  Window(WindowSizeNew,FitScreen,ClearScreen);
end;

Procedure tConsole.WindowMin;
Var WindowSizeNew:TConsoleWindowPoint;
begin
  WindowSizeNew := WindowSizeMin;
  Window(WindowSizeNew);
end;

Procedure tConsole.WindowDefault; //  80 x 25 Char
begin
  Window(80,25);
end;

Procedure tConsole.WindowMedium;  // 100 x 35 Char
begin
  Window(100,35);
end;

Procedure tConsole.WindowLarge;   // 120 x 50 Char
begin
  Window(120,50);
end;

Function  tConsole.GetWindowRect : TConsoleWindowRect;
begin
  Result := FScreenBufferInfo.srWindow;
end;

Function  tConsole.GetWindowSize : TConsoleWindowPoint;
begin
  Result := FScreenBufferInfo.srWindow.Size;
end;

Procedure tConsole.SetWindowSize(const WindowSizeNew: TConsoleWindowPoint);
Var WindowRectNew : TConsoleWindowRect;
    ConsoleInfoEx : tConsoleInfoEx;
begin
  // The window must not be larger than the ScreenBuffer
  // check this to avoid exceptions
  if (WindowSizeNew.X<=BufferSize.X) and
     (WindowSizeNew.Y<=BufferSize.Y) then
  begin
    // It is necessary to set the cursor in the upper left corner to avoid
    // exeptions if the cursor ist outside the new size
    if (CursorPosition.X>WindowSizeNew.X) or
       (CursorPosition.Y>WindowSizeNew.Y) then
    begin
      Console.SetCursorPosition(1,1);
    end;
    // Create ZeroBasedRect from Size
    WindowRectNew.Create(WindowSizeNew);
    Try
      // Kernel32.dll: SetConsoleWindowInfo
      if (SetConsoleWindowInfo(ConHandleStdOut,true,WindowRectNew)) then
      begin
        FScreenBufferInfo.srWindow := WindowRectNew;
        ConsoleInfoEx := tConsoleInfoEx.Create;
        if ConsoleInfoEx.GetInfoEx then
        begin
          {$IFDEF DELPHI10UP}
          if (WindowRect<>ConsoleInfoEx.WindowRect) then
          {$ELSE}
          if (TSmallRectEqual(WindowRect,ConsoleInfoEx.WindowRect)) then
          {$ENDIF DELPHI10UP}
          begin
            FScreenBufferInfo.srWindow := ConsoleInfoEx.WindowRect;
          end;
        end;
        ConsoleInfoEx.Free;
      end else
      begin
        raise EConsoleApiError.Create('SetConsoleWindowInfo;'+SysErrorMessage(GetLastError));
      end;
    except
      raise EConsoleApiError.Create('SetConsoleWindowInfo;'+SysErrorMessage(GetLastError));
    End;
  end;
end;

Function  tConsole.GetTitle : string;
Var ConTitle : Array [0..Max_Path] of Char;
begin
  FillChar(ConTitle,Sizeof(ConTitle),#0);
  GetConsoleTitle(@ConTitle, Max_Path);
  GetTitle := String(ConTitle);
end;

Function tConsole.GetOriginalTitle : String;
Var ConTitle : Array [0..Max_Path] of Char;
begin
  FillChar(ConTitle,Sizeof(ConTitle),#0);
  GetConsoleOriginalTitle(@ConTitle, Max_Path);
  GetOriginalTitle := String(ConTitle);
end;

Procedure TConsole.SetTitle(const Value : string);
begin
  SetConsoleTitle(PChar(Value));
end;

Function  tConsole.GetCursorInfo: Boolean;
begin
  // Kernel32.dll - GetConsoleCursorInfo
  Result := GetConsoleCursorInfo(ConHandleStdOut, FCursorInfo);
end;

Function  tConsole.GetCursorVisible : Boolean;
begin
  Result := FCursorInfo.bVisible;
end;

Procedure tConsole.SetCursorVisible(Const Value:Boolean);
begin
  if (Value<>FCursorInfo.bVisible) then
  begin
    FCursorInfo.bVisible := Value;
    // Kernel32.dll - SetConsoleCursorInfo
    SetConsoleCursorInfo(ConHandleStdOut, FCursorInfo);
  end;
end;

Function  tConsole.GetCursorSize : Longword;
begin
  Result := FCursorInfo.dwSize;
end;

Procedure tConsole.SetCursorSize(Const Value:DWord);
begin
  if (Value<=100) then
  begin
    // call winapi only if value has changed
    if (Value<>FCursorInfo.dwSize) then
    begin
      FCursorInfo.dwSize := Value;
      // Kernel32.dll - SetConsoleCursorInfo
      SetConsoleCursorInfo(ConHandleStdOut, FCursorInfo);
    end;
  end;
end;

Function  tConsole.GetCurWorkArea : TWorkArea;
Var
  LMonitor : TMonitor;
  LWorkArea : TWorkArea;
  LScale : Integer;
begin
  LMonitor := Screen.MonitorFromPoint(Desktop.Area.TopLeft);
  LWorkArea.Rect := LMonitor.WorkareaRect;
  if (GetScaleFactorForMonitor(LMonitor.Handle, LScale) = S_OK)
     then LWorkArea.Scale := LScale
     else LWorkArea.Scale := 100;
  Result := LWorkArea;
end;

Function  tConsole.GetTextAttr : tTextAttr;
begin
  Result := FScreenBufferInfo.wAttributes;
end;

Procedure tConsole.SetTextAttr(Value:tTextAttr);
begin
  SetConsoleTextAttribute(ConHandleStdOut, Value);
  // Save TextAttribute in var Console
  FScreenBufferInfo.wAttributes := Value;
  // Save TextAttribute in Crt.TextAttr
  Crt.TextAttr := Value;
end;

Constructor tConsole.Create;
begin
  Inherited Create;
  Clear;
  Desktop := tConsoleDesktop.Create;
  Modes   := tConsoleModes.Create;
  Font    := tConsoleFont.Create;
  // Get current ConsoleScreenBufferInfo on start
  GetScreenBufferInfo;
  // Get current CursorInfo on start
  GetCursorInfo;
End;

Destructor tConsole.Destroy;
begin
  Font.Free;
  Modes.Free;
  Desktop.Free;
  Inherited Destroy;
end;

Procedure tConsole.Clear;
begin
  FillChar(FScreenBufferInfo,Sizeof(FScreenBufferInfo),#0);
  FScreenBufferTime  := 0;
  FScreenBufferCount := 0;
  FillChar(FCursorInfo,Sizeof(FCursorInfo),#0);
  FConsoleLocationDefault.Clear;
end;

Function  tConsole.GetColor(Index:Integer) : TColorRef;
Var ConsoleInfoEx : tConsoleInfoEx;
begin
  Result := 0;
  if (Index in [0..15]) then
  begin
    ConsoleInfoEx := tConsoleInfoEx.Create;
    if (ConsoleInfoEx.GetInfoEx) then
    begin
      Result := ConsoleInfoEx.ColorTable[index];
    end;
    ConsoleInfoEx.Free;
  end;
end;

Procedure tConsole.SetColor(Index:Integer; Const aColor:TColorRef);
Var ConsoleInfoEx : tConsoleInfoEx;
begin
  if (Index in [0..15]) then
  begin
    ConsoleInfoEx := tConsoleInfoEx.Create;
    if (ConsoleInfoEx.GetInfoEx) then
    begin
      ConsoleInfoEx.ColorTable[index] := aColor;
      ConsoleInfoEx.SetInfoEx;
    end;
    ConsoleInfoEx.Free;
  end;
end;

Function  tConsole.GetInputCodepage : tCodepage;
begin
  FInputCodepage := GetConsoleCP;
  Result := FInputCodepage;
end;

Procedure tConsole.SetInputCodepage(Const aCodepage:tCodepage);
begin
  SetConsoleCP(aCodepage);
  FInputCodepage := aCodepage;
end;

Function  tConsole.GetOutputCodepage : tCodepage;
begin
  FOutputCodepage := GetConsoleOutputCP;
  Result := FOutputCodepage;
end;

Procedure tConsole.SetOutputCodepage(Const aCodepage:tCodepage);
begin
  SetConsoleOutputCP(aCodepage);
  FOutputCodepage := aCodepage;
end;

Function  tConsole.GetWindowsCodepage : tCodepage;
begin
  Result := GetACP;
end;

Function  tConsole.GetWindowsLocaleCodePage : tCodePage;
Var
  LangIdx : Integer;
  LocaleName : String;
  LCData : Array [0..5] of Char;
begin
  try
    // get LocaleName of Keyboard-Layout e.g.
    // 1031 = "de-DE" = _KeyboardLayout_de_DE
    LangIdx := languages.IndexOf(FKeyboardLayout);
    if (LangIdx>=0)
       then LocaleName := Languages.LocaleName[LangIdx]
       else LocaleName := '';
    FillChar(LCData,sizeof(LCData),#0);
    if (getLocaleInfoEx(pchar(LocaleName), LOCALE_IDEFAULTANSICODEPAGE,
          @LCData[0], Sizeof(LCData))>0) then
    begin
      Result := StrToInt(StrPas(LCData));
    end else
    begin
      Result := _Codepage_1252;
    end;
  except
    Result := _Codepage_1252;
  end;
end;

Function  tConsole.GetKeyboardLayout : TKeyboardLayout;
Var
  pwszKLID : Array [0..KL_NameLength] of Char;
begin
  FillChar(pwszKLID,sizeof(pwszKLID),#0);
  if (GetKeyboardLayoutNameW(pwszKLID)) then
  begin
    FKeyboardLayout := StrToUIntDef('$'+StrPas(pwszKLID),_KeyboardLayout_en_US);
  end else
  begin
    FKeyboardLayout := _KeyboardLayout_de_DE;
  end;
  Result := FKeyboardLayout;
end;

Procedure tConsole.UseColorTableDefault;
Var ConsoleInfoEx : tConsoleInfoEx;
begin
  ConsoleInfoEx := tConsoleInfoEx.Create;
  if (ConsoleInfoEx.GetInfoEx) then
  begin
    ConsoleInfoEx.SetColorTableDefault;
    ConsoleInfoEx.SetInfoEx;
  end;
  ConsoleInfoEx.Free;
end;

Procedure tConsole.UseColorTableWindows;
Var ConsoleInfoEx : tConsoleInfoEx;
begin
  ConsoleInfoEx := tConsoleInfoEx.Create;
  if (ConsoleInfoEx.GetInfoEx) then
  begin
    ConsoleInfoEx.SetColorTableDefault;
    ConsoleInfoEx.SetInfoEx;
  end;
  ConsoleInfoEx.Free;
end;

Function  tConsole.GetScreenBufferInfo : Boolean;
begin
  Result := False;
  Try
    if (GetConBufferInfo(FScreenBufferInfo)) then
    begin
      Result := True;
      ScreenBufferTime := Now;
      inc(FScreenBufferCount);
    end else
    begin
      Clear;
    end;
  Except
    On E : EConsoleApiError do ShowMessage(e.Message);
  End;
end;

Function  tConsole.GetBufferSize : TConsoleWindowPoint;
begin
  Result := FScreenBufferInfo.dwSize;
end;

Procedure tConsole.SetBufferSize(Const Value:TConsoleWindowPoint);
begin
  try
    SetConBufferInfo(Value);
    FScreenBufferInfo.dwSize.X := Value.X;
    FScreenBufferInfo.dwSize.Y := Value.Y;
  except
    On E : EConsoleApiError do ShowMessage(e.Message);
  end;
end;

Function  tConsole.GetCursorPosition : TConsoleWindowPoint;
begin
  Result := FScreenBufferInfo.dwCursorPosition;
end;

Procedure tConsole.SetCursorPosition(Const CursorPositionNew:TConsoleWindowPoint);
begin
  // Caution: Ply.Console.ConsolPos is 1-Based
  //          FScreenBufferInfo.dwCursorPosition is Zero-Based
  FScreenBufferInfo.dwCursorPosition.X := CursorPositionNew.X-1;
  FScreenBufferInfo.dwCursorPosition.Y := CursorPositionNew.Y-1;
  try
    // Kernel32.dll: SetConsoleCursorPosition
    SetConsoleCursorPosition(ConHandleStdOut,FScreenBufferInfo.dwCursorPosition);
  except
    raise EConsoleApiError.Create('SetConsoleCursorPosition;'+SysErrorMessage(GetLastError));
  end;
end;

Procedure tConsole.SetCursorPosition(Const X,Y:Smallint);
Var CursorPositionNew : TConsoleWindowPoint;
begin
  CursorPositionNew.X := X;
  CursorPositionNew.Y := Y;
  SetCursorPosition(CursorPositionNew);
end;

Function  tConsole.WindowIsDefault : Boolean;
begin
  Result := (FScreenBufferInfo.srWindow.Size.X=80) and
            (FScreenBufferInfo.srWindow.Size.Y=25);
end;

Function  tConsole.WindowIsMedium : Boolean;
begin
  Result := (FScreenBufferInfo.srWindow.Size.X=100) and
            (FScreenBufferInfo.srWindow.Size.Y=35);
end;

Procedure tConsole.WindowClrscr;
Var dwConSize : LongWord;
    numCharsWritten : LongWord;
    DestCoord : TCoord;
begin
  dwConSize := BufferSize.X * BufferSize.Y;
  DestCoord.Clr;
  FillConsoleOutputCharacter(ConHandleStdOut,#32,dwConSize, DestCoord, numCharsWritten);
  FillConsoleOutputAttribute(ConHandleStdOut,Crt.TextAttr.Attr,dwConSize, DestCoord, numCharsWritten);
  Crt.Window;
  GotoXY(1,1);
end;

procedure tConsole.ShowDebug(x,y:Byte; TColor:Byte=LightGreen);
Var SaveTextAttr  : tTextAttr;
    SaveCursorPos : TConsoleWindowPoint;
begin
  GetScreenBufferInfo;
  SaveTextAttr  := Crt.TextAttr;
  SaveCursorPos := Crt.CursorPos;
  Textcolor(TColor);
  WriteXY(x,y+0,'dwSize      : '+BufferSize.ToStringSize);
  WriteXY(x,y+1,'dwCursorPos : '+SaveCursorPos.ToStringPos);
  WriteXY(x,y+2,'Attribut    : '+SaveTextAttr.Attr.ToString
               +' : BC = '+IntToStr(SaveTextAttr.Textbackground)
                 +' TC = '+IntToStr(SaveTextAttr.Textcolor));
  WriteXY(x,y+3,'srWindow    : '+WindowRect.ToStringRect);
  WriteXY(x,y+4,'dwMaxWinSize: '+WindowSize.ToStringSize);
  Crt.CursorPos := SaveCursorPos;
  Crt.TextAttr  := SaveTextAttr;
end;

Procedure tConsole.CursorOnNormalSize;
begin
  FCursorInfo.dwSize := 25;
  FCursorInfo.bVisible := True;
  SetConsoleCursorInfo(ConHandleStdOut, FCursorInfo);
end;

Procedure tConsole.CursorOnBigSize;
begin
  FCursorInfo.dwSize := 93;
  FCursorInfo.bVisible := True;
  SetConsoleCursorInfo(ConHandleStdOut, FCursorInfo);
end;

Function  tConsole.GetConsoleSelection(Var SelectionAnachor: TConsoleWindowPoint;
                   Var Selection: TConsoleWindowRect) : Boolean;
Var ConsoleSelectionInfo : TConsoleSelectionInfo;
begin
  Result := False;
  if (GetConsoleSelectionInfo(ConsoleSelectionInfo)) then
  begin
    SelectionAnachor := ConsoleSelectionInfo.dwSelectionAnchor;
    Selection        := ConsoleSelectionInfo.srSelection;
    Result := True;
  end;
end;

Function  tConsole.WindowSizeMin : TConsoleWindowPoint;
Var
  DeskSizeMin   : TPoint;
  DeskFontSize  : TConsoleDesktopPoint;
  DeskFrameSize : TConsoleDesktopPoint;
  WinMinSize    : TConsoleWindowPoint;
begin
  // Minimal Desktop-Size in Pixel form System/Windows
  DeskSizeMin   := Desktop.SizeMin;
  // Current Fontsize in Pixel
  DeskFontSize  := Desktop.Fontsize(WindowSize);
  // Current FrameSize according to monitor resulution & scaling
  DeskFrameSize := Desktop.FrameSize;
  // caclulate minimal Window-Size in Char (coloums & lines)
  if (DeskFontSize.X>0) and (DeskFontSize.Y>0) then
  begin
    WinMinSize.x  := ((DeskSizeMin.X - DeskFrameSize.X) div DeskFontSize.X) + 1;
    WinMinSize.y  := ((DeskSizeMin.Y - DeskFrameSize.Y) div DeskFontSize.Y) + 1;
  end;
  // Set Size at least to (20,2)
  WinMinSize.Normalize(20,2);
  Result        := WinMinSize;
end;


(**************************)
(***** tConsoleInfoEx *****)
(**************************)
Function  tConsoleInfoEx.GetColor(Index:Integer) : TColorRef;
begin
  if (Index in [0..15]) then
  begin
    Result := FScreenBufferInfoEx.ColorTable[Index];
  end else
  begin
    Result := 0;
  end;
end;

Procedure tConsoleInfoEx.SetColor(Index:Integer; Const Value:TColorRef);
begin
  if (Index in [0..15]) then
  begin
    FScreenBufferInfoEx.ColorTable[Index] := Value;
  end;
end;

Constructor tConsoleInfoEx.Create;
begin
  Inherited Create;
  FillChar(FScreenBufferInfoEx,Sizeof(FScreenBufferInfoEx),#0);
End;

Destructor tConsoleInfoEx.Destroy;
begin
  Inherited Destroy;
end;

Function  tConsoleInfoEx.GetInfoEx : Boolean;
begin
  Result := False;
  Try
    if (GetConBufferInfoEx(FScreenBufferInfoEx)) then
    begin
      Result := True;
    end;
  Except
    On E : EConsoleApiError do ShowMessage(e.Message);
  End;
end;

Function  tConsoleInfoEx.SetInfoEx : Boolean;
begin
  Result := False;
  Try
    // Bottom and Right must be increased by 1, for whatever reason?
    // Otherwise the size of the window will be changed
    inc(FScreenBufferInfoEx.srWindow.Bottom);
    inc(FScreenBufferInfoEx.srWindow.Right);
    if (SetConBufferInfoEx(FScreenBufferInfoEx)) then
    begin
      Result := True;
      // decrease to get the original Value
      dec(FScreenBufferInfoEx.srWindow.Bottom);
      dec(FScreenBufferInfoEx.srWindow.Right);
    end;
  Except
    On E : EConsoleApiError do ShowMessage(e.Message);
  End;
end;

Procedure tConsoleInfoEx.SetColorTableDefault;
begin
  ColorTable[Black]        := RGB( 10, 10, 10);
  ColorTable[Blue]         := RGB( 30, 30,230);
  ColorTable[Green]        := RGB( 10,180, 10);
  ColorTable[Cyan]         := RGB(  0,180,180);
  ColorTable[Red]          := RGB(230,  0,  0);
  ColorTable[Magenta]      := RGB(230,  0,230);
  ColorTable[Brown]        := RGB(200,160, 30);
  ColorTable[LightGray]    := RGB(200,200,200);
  ColorTable[DarkGray]     := RGB(100,100,100);
  ColorTable[LightBlue]    := RGB( 60,120,250);
  ColorTable[LightGreen]   := RGB( 30,250, 30);
  ColorTable[LightCyan]    := RGB( 60,250,250);
  ColorTable[LightRed]     := RGB(250, 70, 70);
  ColorTable[LightMagenta] := RGB(250, 60,250);
  ColorTable[Yellow]       := RGB(255,255, 50);
  ColorTable[White]        := RGB(255,255,255);
  SetInfoEx;
end;

Procedure tConsoleInfoEx.SetColorTableWindows;
begin
  ColorTable[Black]        := RGB( 34, 33, 32);
  ColorTable[Blue]         := RGB( 32, 32,255);
  ColorTable[Green]        := RGB( 19,161, 14);
  ColorTable[Cyan]         := RGB( 58,150,221);
  ColorTable[Red]          := RGB(197, 15, 31);
  ColorTable[Magenta]      := RGB(136, 23,152);
  ColorTable[Brown]        := RGB(193,156,  0);
  ColorTable[LightGray]    := RGB(204,204,204);
  ColorTable[DarkGray]     := RGB(118,118,118);
  ColorTable[LightBlue]    := RGB( 59,120,255);
  ColorTable[LightGreen]   := RGB( 22,198, 12);
  ColorTable[LightCyan]    := RGB( 97,214,214);
  ColorTable[LightRed]     := RGB(231, 72, 86);
  ColorTable[LightMagenta] := RGB(180,  0,158);
  ColorTable[Yellow]       := RGB(249,241,165);
  ColorTable[White]        := RGB(242,242,242);
  SetInfoEx;
end;

(***********************************)
(***** ConsoleCtrlEventHandler *****)
(***********************************)
function ConsoleCtrlEventHandler(dwCtrlType: DWORD): Bool; stdcall; far;
var S : String;
begin
  case dwCtrlType of
    CTRL_C_EVENT        : S := 'CTRL_C_EVENT';
    CTRL_BREAK_EVENT    : S := 'CTRL_BREAK_EVENT';
    CTRL_CLOSE_EVENT    : S := 'CTRL_CLOSE_EVENT';
    CTRL_LOGOFF_EVENT   : S := 'CTRL_LOGOFF_EVENT';
    CTRL_SHUTDOWN_EVENT : S := 'CTRL_SHUTDOWN_EVENT';
    else S := 'UNKNOWN_EVENT';
  end;
  WriteXY(1,1,Yellow,s+' detected!');
  Readkey;
  Result := True;
end;

(**********************************)
(***** Console-Windows-Handle *****)
(**********************************)
procedure PlyConsoleInit;
Var ConReg : tConsoleRegistry;
begin
  if (ConHandleWindow=0) or
     (ConHandleStdOut=0) then
  begin
    ConHandleWindow  := GetConsoleWindow;
    ConHandleStdOut  := GetStdHandle(STD_OUTPUT_HANDLE);
    ConHandleStdIn   := GetStdHandle(STD_INPUT_HANDLE);
    ConHandleStdErr  := GetStdHandle(STD_ERROR_HANDLE);
  end;
  if (Crt.Console=Nil) then
  begin
    Crt.Console := TConsole.Create;
    Crt.Console.GetScreenBufferInfo;
    // Set Console.Modes to default values
    Console.Modes.SetDefaultValues;
    // Default Cursor Settings
    Console.CursorVisible := True;
    Console.CursorSize    := 25;
    // Get Console-Input- and Output-Codepage
    Crt.Console.GetInputCodepage;
    Crt.Console.GetOutputCodepage;
    // Get Console-KeyboardLayout
    Crt.Console.GetKeyboardLayout;
    // Registry-Counter
    ConReg.IncCountStart;
  end;
  SetConsoleCtrlHandler(@ConsoleCtrlEventHandler, True);
end;

Procedure PlyConsoleDone;
begin
  SetConsoleCtrlHandler(@ConsoleCtrlEventHandler, False);
  FreeAndNil(Crt.Console);
end;

initialization
  PlyConsoleInit;
  Proc_CTRL_ALT_0_9    := ConsoleLocationMoveUserRegistry;
  Proc_CTRL_ALTGR_0_9  := ConsoleLocationSaveUserRegistry;

Finalization
  PlyConsoleDone;

end.
