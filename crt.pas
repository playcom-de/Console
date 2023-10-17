(******************************************************************************

  Name          : crt.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 30.07.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit crt;

interface

{$I Ply.Defines.inc}

Uses
  Winapi.Windows,
  Ply.Console,
  Ply.Types;

// Turn on this "BP7" compiler-switch if compatibility to
// Borlands Turbo Pascal 7.0 is needed
{$IFDEF BP7}
  var   CheckBreak    : Boolean = True;     (* Enable Ctrl-Break              *)
        DirectVideo   : Boolean deprecated; (* Enable direct video addressing *)
        CheckSnow     : Boolean deprecated; (* Enable snow filtering          *)
        LastMode      : Word = 3;           (* Current text mode              *)
{$ENDIF BP7}

Const
  // CRT modes - for 7.0 compatibility
  BW40          = 0;            (* 40x25 B/W on Color Adapter     *)
  CO40          = 1;            (* 40x25 Color on Color Adapter   *)
  BW80          = 2;            (* 80x25 B/W on Color Adapter     *)
  CO80          = 3;            (* 80x25 Color on Color Adapter   *)
  Mono          = 7;            (* 80x25 on Monochrome Adapter    *)
  Font8x8       = 256;          (* Add-in for ROM font            *)
  // CRT modes - for 3.0 compatibility
  C40           = CO40;
  C80           = CO80;

  CheckEOF : Boolean = False deprecated;    (* Enable Ctrl-Z                  *)

  // Foreground and background color constants
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

  // In BP7-Mode, only Foreground color constants
  // Otherwise, these color can used to Foreground and Background
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

  Blink         = 128;

Const ColorNames : Array [0..15] of String = ('Black','Blue','Green','Cyan'
        ,'Red','Magenta','Brown','Lightgray','Darkgray','Lightblue'
        ,'LightGreen','Lightcyan','Lightred','Lightmagenta','Yellow','White');

{$I crt.inc}

// Var Console: Access to all windows-functions like
// - Font: Fontface & Fontsize
// - Window: Size of console-window (lines & coloums)
// - DesktopPosition & DesktopArea: Position of console-window on the screen
Var
  TextAttr : TTextAttr;
  Console : tConsole = Nil;
  // WindSize: Coordinates from current Window on Screen
  //           Zero-Base-Values : (0,0,79,24) for Standardsize
  // If you need direct access to WindMin and/or WindMax, use
  // WindSize.WindMin and WindSize.WindMax they are representing
  // the equal values as BP7.0 in WindMin and WindMax
  // WindMin : Word = $0;    { Window upper left coordinates }
  // WindMax : Word = $184f; { Window lower right coordinates }
  WindSize : TPlyConWinSize;
  // CursorPos: 1-Based-Cursor-Position based on ConsoleScreenSize
  CursorPos : TConsoleWindowPoint;

(* Interface procedures *)
procedure CrtAssign(var t:Text);
function  KeyPressed: Boolean;
function  ReadKeyA : AnsiChar; Overload;
Function  ReadkeyA(Var Key:Word; SetCursorPos:Boolean=True) : AnsiChar; Overload;
function  ReadkeyW : WideChar; Overload;
function  ReadkeyW(Var Key:Word; SetCursorPos:Boolean=True) : WideChar; Overload;
function  Readkey : WideChar; Overload;
function  Readkey(Var Key:Word) : WideChar; Overload;
Procedure ReadkeyTimeOut(Var Key:Word; TimeOutSeconds:Integer=10; TimeOutKey:Word=_ESC);
function  ReadkeyYesNoEsc : Word;
function  LastReadKeyChar : WideChar;

procedure TextMode(Mode: word);

Procedure Window(X1,Y1,X2,Y2: Integer); Overload;
// Window with MaxSize from Console.Window;
Procedure Window; Overload;

procedure GotoXY(X,Y: Integer);
function  WhereX: Byte;
function  WhereY: Byte;

procedure ClrScr;
procedure ClrEol;
procedure InsLine;

procedure DelLine(y:Integer); Overload;
procedure DelLine; Overload;
Procedure Clrlines(y1,y2:Integer);

// GetTextAttr from Char on Position(x,y)
Function  GetTextAttr(x,y:Integer) : TTextAttr;

Function  TextColor : Byte; Overload;
Procedure TextColor(TColor: Byte); Overload;

Function  TextBackground : Byte; Overload;
procedure TextBackground(BColor: Byte); Overload;

Procedure Color(Const TColor, BColor:Byte);

procedure LowVideo;
procedure HighVideo;
procedure NormVideo;
procedure Delay(MS: Word);
procedure Sound(Hz: Word);
procedure NoSound;

function  WhereX32: Integer;
function  WhereY32: Integer;
Function  MaxX : Integer;
Function  MaxY : Integer;

Type TConsoleChar = Record
     private
       FChar : WideChar;
       FAttr : TTextAttr;
     public
       property Char : WideChar Read FChar Write FChar;
       property Attr : TTextAttr Read FAttr Write FAttr;
       Procedure Init(aChar:WideChar=' '; aAttr:Word=_TextAttr_Default);
       procedure Clear;
       procedure Restore(x, y: Integer);
       procedure Save(x, y: Integer);
     end;

Type TConsoleString = Record
     private
       FStrChar : TDynStr;
       FStrAttr : TDynWord;
       Procedure InitChar(uString:UnicodeString);
       Procedure InitAttr(Len:integer; aAttr:Word=_TextAttr_Default); Overload;
       Procedure InitAttr(aStrAttr: TDynWord); Overload;
       Function  GetConsoleChar(Index:integer) : TConsoleChar;
       Procedure SetConsoleChar(Index:integer; Value:TConsoleChar);
       Function  GetWideChar(Index:integer) : WideChar;
       Procedure SetWideChar(Index:integer; Value:WideChar);
       Function  GetAttribute(Index:integer) : Word;
       Procedure SetAttribute(Index:integer; Value:Word);
     public
       {$IFDEF DELPHI10UP}
       class operator Assign(Var Dest:TConsoleString; Const [ref] Src:TConsoleString);
       class operator Implicit(uString:UnicodeString) : TConsoleString;
       class operator Implicit(cString:TConsoleString) : UnicodeString;
       {$ENDIF DELPHI10UP}
       class operator GreaterThan(a, b:TConsoleString) : Boolean;
       class operator LessThan(a, b:TConsoleString) : Boolean;
       class operator Add(a, b:TConsoleString) : TConsoleString;
       Constructor Create(uString:UnicodeString; TColor:Byte=LightGray; BColor:Byte=Black); Overload;
       Constructor Create(eStrChar:TDynStr; eStrAttr:TDynWord); Overload;
       property  ConsoleChar[index:integer] : TConsoleChar Read GetConsoleChar Write SetConsoleChar; default;
       property  Char[index:integer] : WideChar Read GetWideChar Write SetWideChar;
       property  Attr[index:integer] : Word Read GetAttribute Write SetAttribute;
       Procedure Init(NewLen:integer; aChar:WideChar=' '; aAttr:Word=_TextAttr_Default); Overload;
       Procedure Init(uString:UnicodeString; Textcolor:Byte=0; Textbackground:Byte=0); Overload;
       Function  uString : UnicodeString;
       Function  ToUpper : UnicodeString;
       Procedure Clear(cChar:WideChar=' '; cAttr:Word=0); Overload;
       Procedure Clear(x1,x2:Integer; cChar:WideChar=' '; cAttr:Word=0); Overload;
       Function  Len : integer;
       // Save line - Refers to the current crt.window
       Procedure Save(y:Smallint);
       // Restore line - Refers to the current crt.window
       Procedure Restore(y:Integer);
       Function  GetChar(Index:Integer=1) : TConsoleChar;
       Procedure SetChar(Index:Integer; Value:tConsoleChar);
       Function  StringCopy(Index:integer=1; Count:integer=-1) : TConsoleString;
       Function  StringAlignLeft(Count:Integer; ch:WideChar=' '; Cut:Boolean=False) : TConsoleString;
       Function  StringAlignRight(Count:Integer; ch:WideChar=' '; Cut:Boolean=False) : TConsoleString;
       Function  StringCopyUnicode(Index:integer=1; Count:integer=-1) : UnicodeString;
       Procedure InvertString(Index:Integer=1; Count:Integer=-1);
       Procedure UnderlineString(Index:Integer=1; Count:Integer=-1);
       Procedure OutlineString(Index:Integer=1; Count:Integer=-1);
       Procedure InvertSearchString(SearchString:String; Offset:Integer=1;
                   InvertAll:Boolean=True; CaseSensitive:Boolean=False);
     end;

     tScreenData = Record
       CharData : TDynStr;
       AttrData : TDynStr;
       Procedure Init(Const Len:Cardinal); Overload;
       Procedure Init(Const ScreenSize:TConsoleWindowPoint); Overload;
       Function  SizeChar : Cardinal;
       Function  SizeAttr : Cardinal;
     end;

     tScreen = Record
     private
       FSize  : TConsoleWindowPoint;
       FLines : TArray<TConsoleString>;
       Function  GetLine(Index:integer) : tConsoleString;
       Procedure SetLine(Index:integer; Value:tConsoleString);
     public
       Procedure Clear;
       Procedure Init; Overload;
       Procedure Init(Const ScreenSize:TConsoleWindowPoint); Overload;
       Procedure Save;
       Procedure Restore;
       Procedure RestorePart(X1,Y1,X2,Y2:Integer);
       Procedure CatchUserSelection(Var SelectedScreen:tScreen);
       Procedure InvertString(x,y:Integer; Count:Integer);
       Procedure UnderlineString(x,y:Integer; Count:Integer);
       Procedure OutlineString(x,y:Integer; Count:Integer);
       Procedure ClearLine(y:Integer; cChar:WideChar=' '; cAttr:Word=0); Overload;
       Procedure ClearLine(y,x1,x2:Integer; cChar:WideChar=' '; cAttr:Word=0); Overload;
       property  Size:TConsoleWindowPoint Read FSize Write FSize;
       property  Line[index:integer] : tConsoleString Read GetLine Write SetLine;
       Function  GetChar(x,y:integer) : tConsoleChar;
       Procedure SetChar(x,y:integer; Value:tConsoleChar);
       Procedure GetRect(X1,Y1,X2,Y2:Integer; Var aScreen:tScreen); Overload;
       Procedure GetRect(Rect:TConsoleWindowRect; Var aScreen:tScreen); Overload;
       Procedure SetRect(X1,Y1,X2,Y2:Integer; Var aScreen:tScreen);
       Procedure WriteXY(x,y:integer; uString:String); Overload;
       Procedure WriteXY(x,y:integer; TColor:Byte; uString:String); Overload;
       Procedure MovePartScreen(X1,Y1,X2,Y2,XM,YM:Integer);
       Procedure GetData(Var ScreenData:TScreenData);
       Procedure SetData(Const ScreenSize:TConsoleWindowPoint; Var ScreenData:TScreenData);
     end;

     tScreenSave = Record
     private
     public
       // WindSize: Position of the active window within the console window
       FWindSize  : TPlyConWinSize;
       // CursorPos: Position of the cursor within the active window
       FCursorPos : TConsoleWindowPoint;
       // TextAttr: Current TColor & BColor when saving screen
       FTextAttr  : tTextAttr;
       // Screen: ScreenData (Chars & Colors of each Char)
       FScreen    : tScreen;
       Procedure Clear;
       Function  IsClear : Boolean;
       Procedure Save;
       Procedure RestoreSize;
       Procedure Restore;
       Procedure RestorePart(X1,Y1,X2,Y2:Integer);
       Procedure InvertString(x,y:Integer; Count:Integer);
       Procedure UnderlineString(x,y:Longint; Count:Integer);
       Procedure OutlineString(x,y:Longint; Count:Integer);
       Procedure ClrLine(y1,y2:Integer);
       Function  GetChar(x,y:integer) : tConsoleChar;
       Procedure SetChar(x,y:integer; Value:tConsoleChar);
       Procedure WriteXY(x,y:Integer; cString:CP850String); Overload;
       Procedure WriteXY(x,y:Integer; uString:String); Overload;
       Procedure WriteXY(x,y:Integer; TColor:Byte; uString:String); Overload;
       Procedure MovePartScreen(X1,Y1,X2,Y2,XM,YM:Integer);
     end;

(*********************************)
(***** Console-IO-Operations *****)
(*********************************)
          // WriteXY: Stops output at end of line
          // ShortString
Procedure WriteXY(x,y:Integer; sString:ShortString; SCP:TCodepage=_Codepage_850); Overload;
Procedure WriteXY(x,y:Integer; TColor:Byte; sString:ShortString; SCP:TCodepage=_Codepage_850); Overload;
          // UTF8String
Procedure WriteXY(x,y:Integer; sString:UTF8String); Overload;
Procedure WriteXY(x,y:Integer; TColor:Byte; sString:UTF8String); Overload;
          // CP850String
Procedure WriteXY(x,y:Integer; sString:CP850String); Overload;
Procedure WriteXY(x,y:Integer; TColor:Byte; sString:CP850String); Overload;
          // UnicodeString
Procedure WriteXY(x,y:Integer; uString:UnicodeString); Overload;
Procedure WriteXY(x,y:Integer; TColor:Byte; uString:UnicodeString); Overload;
Procedure WriteXY(x,y:Integer; aTextAttr:TTextAttr; uString:UnicodeString); Overload;
          // ConsoleString
Procedure WriteXY(x,y:Integer; cString:TConsoleString); Overload;

procedure WriteChar(x,y: integer; Const ch:AnsiChar); Overload;
procedure WriteChar(x,y: integer; Const ch:WideChar); Overload;
procedure WriteChar(x,y: integer; Const ch:Word); Overload;

          // WriteConsole: Ignores the boundaries of the current crt.window
Procedure GotoXYConsole(X,Y: Integer);
procedure WriteConsole(Const uString:UnicodeString); Overload;
procedure WritelnConsole(Const uString:UnicodeString); Overload;
procedure WriteConsole(x,y: integer; Const uString:UnicodeString); Overload;

          // WriteString: Observes the boundaries of the current crt.window
procedure WriteString(x,y: integer; Const sString:ShortString;
            SourceCodepage:TCodepage=_Codepage_850); Overload;
procedure WriteString(Const sString:ShortString;
            SourceCodepage:TCodepage=_Codepage_850); Overload;
procedure WriteString(x,y: integer; Const aString:AnsiString); Overload;
procedure WriteString(Const aString:AnsiString); Overload;
procedure WriteString(x,y: integer; Const uString:UnicodeString); Overload;
procedure WriteString(Const uString:UnicodeString); Overload
procedure WriteString(x,y: integer; Const cString:TConsoleString); Overload;
procedure WriteString(Const cString:TConsoleString); Overload;

Procedure WritelnString(Const sString:ShortString); Overload;
Procedure WritelnString(Const aString:AnsiString); Overload;
Procedure WritelnString(Const uString:UnicodeString); Overload;
Procedure WritelnString(TColor:Byte; Const uString:UnicodeString); Overload;
Procedure WritelnString(Const cString:TConsoleString); Overload;

Function  InvertTextAttr(aTextAttr:tTextAttr) : TTextAttr;
Function  UnderlineTextAttr(aTextAttr:TTextAttr) : tTextAttr;
Function  OutlineStartTextAttr(aTextAttr:TTextAttr) : tTextAttr;
Function  OutlineCenterTextAttr(aTextAttr:TTextAttr) : tTextAttr;
Function  OutlineEndTextAttr(aTextAttr:TTextAttr) : tTextAttr;

Procedure InvertString(x,y,l:Integer);
Procedure InvertLine(y:Integer);
Procedure UnderlineString(x,y,l:Integer);
Procedure OutlineString(x,y,l:Integer);

Procedure ColorString(x,y,l:Integer; TextAttr:TTextAttr); Overload;
Procedure ColorString(x,y,l:Integer; TColor:Byte; BColor:Byte=0); Overload;
Procedure ColorLine(y:Integer; TColor:Byte; BColor:Byte=0);

Procedure ReadConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Var ConsoleScreenBuffer:TConsoleScreenBuffer);
Procedure WriteConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Var ConsoleScreenBuffer:TConsoleScreenBuffer);
Procedure FillConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Const ch:WideChar; Attr:Word=0); Overload;
Procedure FillConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Const ch:Word; Attr:Word=0); Overload;

(******************************)
(***** Keyboard-Functions *****)
(******************************)
Var RKW                      : Word = 0;
    RKW_Form                 : Word = $FFFF; // Key from VCL- or FMX-Form
    RKW_AutoCrLf             : Boolean = False;
    RKW_Unicode              : Word = 0;
    LastKey                  : Word;
    UseRegistry              : Boolean = True;
    UseScreenSaveFile        : Boolean = True;

Function  CrtWriteAlternate(var t: TTextRec; s: UnicodeString) : Pointer;
Procedure CrtReadln(Var uString:UnicodeString);
Function  CrtWriteAlternateConsole(var t: TTextRec; s: UnicodeString) : Pointer;

Const
  // (Ctrl+Alt+0..9) MoveConsoleWindow to UserPosition
  Proc_CTRL_ALT_0_9   : Function(Index:Integer; SetDefault:Boolean=True) : Boolean = Nil;
  // (Ctrl+AltGr+0..9) SaveConsoleWindow to UserPosition
  Proc_CTRL_ALTGR_0_9 : Procedure(Index:Integer) = Nil;
  Proc_CTRL_ALT_L     : Procedure = Nil;  // ScreenSelectFromFile in Ply.Console.Extended.pas
  Proc_CTRL_ALT_M     : Procedure = Nil;
  Proc_CTRL_ALT_N     : Procedure = Nil;
  Proc_CTRL_ALT_O     : Procedure = Nil;
  Proc_CTRL_ALT_P     : Procedure = Nil;
  Proc_CTRL_ALT_Q     : Procedure = Nil;
  Proc_CTRL_ALT_R     : Procedure = Nil;
  Proc_CTRL_ALT_S     : Procedure = Nil;  // ScreenSaveToFile in Ply.Console.Extended.pas
  Proc_CTRL_ALT_T     : Procedure = Nil;
  Proc_CTRL_ALT_U     : Procedure = Nil;

implementation

uses
  Ply.DateTime,
  Ply.Math,
  Ply.Patches,
  Ply.StrUtils,
  System.SysUtils,
  System.Math,
  Vcl.Forms;

(****************************)
(***** Public Functions *****)
(****************************)
procedure TextMode(Mode: word);
begin
  Case Mode of
    BW40 : Console.Window(40,25);
    CO40 : Console.Window(40,25);
    BW80 : Console.Window(80,25);
    CO80 : Console.Window(80,25);
    Mono : Console.Window(80,25);
    Font8x8 :
    begin
      Console.Window(80,25);
      Console.Font.SetCurrentFont(_ConsoleFontTerminal,4);
    end;
  End;
end;

Function  GetTextAttr(x,y:Integer) : TTextAttr;
Var ConsoleChar : tConsoleChar;
begin
  ConsoleChar.Save(x,y);
  Result := ConsoleChar.FAttr;
end;

Function  Textcolor : Byte;
begin
  Result := TextAttr.Textcolor;
end;

Procedure TextColor(TColor: Byte);
Begin
  if ((TColor and Blink)=Blink) then
  begin
    TColor := TColor - Blink;
    TextAttr.InvertColors := True;
  end else TextAttr.InvertColors := False;
  TextAttr.Textcolor := TColor;
End;

Function  TextBackground : Byte;
begin
  Result := TextAttr.Textbackground;
end;

Procedure TextBackground(BColor: Byte);
begin
  TextAttr.Textbackground := BColor;
end;

Procedure Color(Const TColor, BColor:Byte);
begin
  TextAttr.Textcolor      := TColor;
  TextAttr.Textbackground := BColor;
end;

Procedure HighVideo;
begin
  TextColor(TextAttr.Attr or $08);
end;

Procedure LowVideo;
begin
  TextColor(TextAttr.Attr And $77);
end;

Procedure NormVideo;
begin
  TextColor(Lightgray);
  TextBackGround(Black);
end;

Procedure GotoXY(X,Y:Integer);
begin
  If (X > 0) and (X <= WindSize.Width)  and
     (Y > 0) and (Y <= WindSize.Height) Then
  begin
    CursorPos.X := WindSize.Left + X;
    CursorPos.Y := WindSize.Top  + Y;
  end;
end;

Procedure Window(X1, Y1, X2, Y2: Integer);
begin
  if (X1 > X2) or (X2 > Console.WindowSize.X) or
     (Y1 > Y2) or (Y2 > Console.WindowSize.Y) then exit;
  WindSize.Left   := X1-1;
  WindSize.Top    := Y1-1;
  WindSize.Right  := X2-1;
  WindSize.Bottom := Y2-1;
  GotoXY(1, 1);
end;

Procedure Window;
begin
  Window(1,1,Console.WindowSize.x,Console.WindowSize.Y);
end;

procedure ClrScr;
begin
  FillConsoleRectangular(WindSize.Left+1,WindSize.Top+1
    ,WindSize.Width,WindSize.Height,#32,TextAttr.Attr);
  GotoXY(1, 1);
end;

procedure ClrEol;
var aChar                    : Char;
    Coord                    : TCoord;
    NumChars                 : Longword;
    NumWritten               : Longword;
begin
  aChar    := #32;
  Coord.X  := CursorPos.X - 1;
  Coord.Y  := CursorPos.Y - 1;
  NumChars := WindSize.Right - CursorPos.X + 2;
  FillConsoleOutputAttribute(ConHandleStdOut,TextAttr, NumChars, Coord, NumWritten);
  FillConsoleOutputCharacter(ConHandleStdOut,aChar, NumChars ,Coord, NumWritten);
end;

Function WhereX: Byte;
begin
  Result := WhereX32 mod 256;
end;

Function WhereX32: Integer;
begin
  Result := CursorPos.X - WindSize.Left;
end;

Function WhereY: Byte;
begin
  Result := WhereY32 mod 256;
end;

Function WhereY32: Integer;
begin
  Result := CursorPos.Y - WindSize.Top;
end;

Function  MaxX : Integer;
begin
  Result := WindSize.Width;
end;

Function  MaxY : Integer;
begin
  Result := WindSize.Height;
end;

procedure Delay(MS: Word);
begin
  Sleep(ms);
end;

procedure sound(hz : word);
begin
  MessageBeep(MB_OK);
end;

procedure nosound;
begin
end;

procedure InsLine;
var ScrollRectangle  : TSmallRect;
    ClipRectangle    : TSmallRect;
    DestinationCoord : TCoord;
    FillChar         : TCharInfo;
begin
  FillChar.UnicodeChar   := #32;
  FillChar.Attributes    := TextAttr;

  ScrollRectangle.Top    := CursorPos.Y - 1;
  ScrollRectangle.Left   := WindSize.Left;
  ScrollRectangle.Right  := WindSize.Right;
  ScrollRectangle.Bottom := WindSize.Bottom + 1;

  DestinationCoord.X     := WindSize.Left;
  DestinationCoord.Y     := CursorPos.Y;
  ClipRectangle          := ScrollRectangle;
  ClipRectangle.Bottom   := WindSize.Bottom - 1;

  {$IFDEF FPC}
    ScrollConsoleScreenBuffer(ConHandleStdOut
      ,ScrollRectangle,ClipRectangle,DestinationCoord,FillChar);
  {$ELSE}
    ScrollConsoleScreenBuffer(ConHandleStdOut
      ,@ScrollRectangle,@ClipRectangle,DestinationCoord,FillChar);
  {$ENDIF FPC}
end;

procedure DelLine(y:Integer);
var ScrollRectangle    : TSmallRect;
    ClipRectangle      : TSmallRect;
    DestinationCoord   : TCoord;
    FillChar           : TCharInfo;
begin
  FillChar.UnicodeChar := #32;
  FillChar.Attributes  := TextAttr;

  Y := WindSize.Top + Y;

  ScrollRectangle.Top    := smallint(Y);
  ScrollRectangle.Left   := WindSize.Left;
  ScrollRectangle.Right  := WindSize.Right;
  ScrollRectangle.Bottom := WindSize.Bottom;

  DestinationCoord.X     := WindSize.Left;
  DestinationCoord.Y     := Smallint(Y - 1);

  ClipRectangle          := ScrollRectangle;
  ClipRectangle.top      := DestinationCoord.y;
  {$IFDEF FPC}
    ScrollConsoleScreenBuffer(ConHandleStdOut
      ,ScrollRectangle, ClipRectangle, DestinationCoord, FillChar);
  {$ELSE}
    ScrollConsoleScreenBuffer(ConHandleStdOut
      ,@ScrollRectangle, @ClipRectangle, DestinationCoord, FillChar);
  {$ENDIF FPC}
end;

procedure DelLine;
begin
  DelLine(wherey);
end;

Procedure Clrlines(y1,y2:Integer);
var y : Integer;
begin
  for y := y1 to y2 do
  begin
    gotoxy(1,y); clreol;
  end;
end;

(************************)
(***** TConsoleChar *****)
(************************)
Procedure TConsoleChar.Init(aChar:WideChar=' '; aAttr:Word=_TextAttr_Default);
begin
  FChar := aChar;
  FAttr := aAttr;
end;

Procedure TConsoleChar.Clear;
begin
  FChar := WideChar($20);
  FAttr := _TextAttr_Default;
end;

Procedure TConsoleChar.Save(x,y:Integer);
Var Coord                    : tCoord;
    NumRead                  : DWord;
begin
  Clear;
  Coord.X  := WindSize.Left + x - 1;
  Coord.Y  := WindSize.Top + y - 1;
  NumRead  := 0;
  ReadConsoleOutputAttribute(ConHandleStdOut
    ,@FAttr,1,Coord,numRead);
  ReadConsoleOutputCharacterW(ConHandleStdOut
    ,@FChar,1,Coord,numRead);
end;

Procedure TConsoleChar.Restore(x,y:Integer);
Var Coord                    : tCoord;
    NumWritten               : DWord;
begin
  Coord.X    := WindSize.Left + x - 1;
  Coord.Y    := WindSize.Top + y - 1;
  NumWritten := 0;
  WriteConsoleOutputAttribute(ConHandleStdOut
    ,@FAttr,1,Coord,NumWritten);
  WriteConsoleOutputCharacterW(ConHandleStdOut
    ,@FChar,1,Coord,NumWritten);
end;

(**************************)
(***** TConsoleString *****)
(**************************)
Procedure TConsoleString.InitChar(uString:UnicodeString);
begin
  SetLength(FStrChar,length(uString));
  FStrChar := uString.ToCharArray;
end;

Procedure TConsoleString.InitAttr(Len:integer; aAttr:Word=_TextAttr_Default);
Var i : Integer;
begin
  SetLength(FStrAttr,len);
  For i := 0 to len-1 do
  begin
    FStrAttr[i] := aAttr;
  end;
end;

Procedure TConsoleString.InitAttr(aStrAttr: TDynWord);
begin
  FStrAttr := aStrAttr;
end;

Function  TConsoleString.GetConsoleChar(Index:integer) : TConsoleChar;
Var aConsoleChar : TConsoleChar;
begin
  if (Index >= 1) and (Index <= Length(FStrChar)) then
  begin
    aConsoleChar.FChar := FStrChar[Index-1];
    aConsoleChar.FAttr := FStrAttr[Index-1];
  end else
  begin
    aConsoleChar.FChar := #0;
    aConsoleChar.FAttr := 0;
  end;
  Result := aConsoleChar;
end;

Procedure TConsoleString.SetConsoleChar(Index:integer; Value:TConsoleChar);
begin
  if (Index >= 1) and (Index <= Length(FStrChar)) then
  begin
    FStrChar[Index-1] := Value.FChar;
  end;
  if (Index >= 1) and (Index <= Length(FStrAttr)) then
  begin
    FStrAttr[Index-1] := Value.FAttr;
  end else
  // if Char comes with attribute
  if (Value.Attr.Attr>0) then
  begin
    // Create Attribute for whole String
    SetLength(FStrAttr,Length(FStrChar));
    // no colorinformation for all other chars
    FillWord(FStrAttr,Length(FStrAttr),0);
    // set colorinformation for this char
    FStrAttr[Index-1] := Value.FAttr;
  end;
end;

Function  TConsoleString.GetWideChar(Index:integer) : WideChar;
begin
  if (Index >= 1) and (Index <= Length(FStrChar))
     then Result := FStrChar[Index-1]
     else Result := #0;
end;

Procedure TConsoleString.SetWideChar(Index:integer; Value:WideChar);
begin
  if (Index >= 1) and (Index <= Length(FStrChar))
     then FStrChar[Index-1] := Value;
end;

Function  TConsoleString.GetAttribute(Index:integer) : Word;
begin
  if (Index >= 1) and (Index <= Length(FStrAttr))
     then Result := FStrAttr[Index-1]
     else Result := 0;
end;

Procedure TConsoleString.SetAttribute(Index:integer; Value:Word);
begin
  if (Index >= 1) and (Index <= Length(FStrAttr))
     then FStrAttr[Index-1] := Value;
end;

{$IFDEF DELPHI10UP}
class operator TConsoleString.Assign(Var Dest:TConsoleString; Const [ref] Src:TConsoleString);
begin
  Dest.FStrChar := Copy(Src.FStrChar);
  Dest.FStrAttr := Copy(Src.FStrAttr);
end;

class operator TConsoleString.Implicit(uString:UnicodeString) : TConsoleString;
Var cString : TConsoleString;
begin
  SetLength(cString.FStrChar,length(uString));
  cString.FStrChar := uString.ToCharArray;
  // default color information for this TConsoleString
  cString.InitAttr(Length(uString),_TextAttr_Default);
  Result := cString;
end;

class operator TConsoleString.Implicit(cString:TConsoleString) : UnicodeString;
begin
  if Length(cString.FStrChar)>0
     then SetString(Result, PChar(@cString.FStrChar[0]), Length(cString.FStrChar))
     else Result := '';
end;
{$ENDIF DELPHI10UP}

class operator TConsoleString.GreaterThan(a, b:TConsoleString) : Boolean;
begin
  {$IFDEF DELPHI10UP}
  Result := (CompareText(UnicodeString(a),UnicodeString(b))>0);
  {$ELSE}
  Result := (CompareText(UnicodeString(a.FStrChar),UnicodeString(b.FStrChar))>0);
  {$ENDIF DELPHI10UP}
end;

class operator TConsoleString.LessThan(a, b:TConsoleString) : Boolean;
begin
  {$IFDEF DELPHI10UP}
  Result := (CompareText(UnicodeString(a),UnicodeString(b))<0);
  {$ELSE}
  Result := (CompareText(UnicodeString(a.FStrChar),UnicodeString(b.FStrChar))<0);
  {$ENDIF DELPHI10UP}
end;

class operator TConsoleString.Add(a, b:TConsoleString) : TConsoleString;
{$IFDEF DELPHIXE8DOWN}
Var NewAttr : TDynWord;
{$ENDIF DELPHIXE8DOWN}
begin
  Result.InitChar(a.StringCopyUnicode+b.StringCopyUnicode);
  {$IFDEF DELPHIXE8DOWN}
  SetLength(NewAttr,a.Len+b.Len);
  if (a.Len>0) then System.Move(a.FStrAttr[0], NewAttr[0], a.Len * SizeOf(a.FStrAttr[0]));
  if (b.Len>0) then System.Move(b.FStrAttr[0], NewAttr[a.Len], b.Len * Sizeof(b.FStrAttr[0]));
  Result.InitAttr(NewAttr);
  {$ELSE}
  Result.InitAttr(a.FStrAttr + b.FStrAttr);
  {$ENDIF DELPHIXE8DOWN}
end;

Constructor TConsoleString.Create(uString:UnicodeString; TColor:Byte=LightGray; BColor:Byte=Black);
begin
  InitChar(uString);
  InitAttr(Length(uString),TTextAttr.Create(TColor,BColor));
end;

Constructor TConsoleString.Create(eStrChar:TDynStr; eStrAttr:TDynWord);
begin
  while Length(eStrAttr) < Length(eStrChar) do
  begin
    TAppender<Word>.Append(eStrAttr,_TextAttr_Default);
  end;
  SetLength(eStrAttr,Length(eStrChar));
  FStrChar := eStrChar;
  FStrAttr := eStrAttr;
end;

Procedure TConsoleString.Init(NewLen:integer; aChar:WideChar=' ';
            aAttr:Word=_TextAttr_Default);
Var i : integer;
begin
  SetLength(FStrChar,NewLen);
  SetLength(FStrAttr,NewLen);
  For i := 0 to NewLen-1 do
  begin
    FStrChar[i] := aChar;
    FStrAttr[i] := aAttr;
  end;
end;

Procedure TConsoleString.Init(uString:UnicodeString; Textcolor:Byte=0;
            Textbackground:Byte=0);
Var TextAttr : tTextAttr;
begin
  SetLength(FStrChar,length(uString));
  FStrChar := uString.ToCharArray;

  if (Textcolor>0) or (Textbackground>0)
     then TextAttr.Create(Textcolor,Textbackground)
     else TextAttr.Attr := _TextAttr_Default;
  InitAttr(length(uString),TextAttr.Attr);
end;

Function  TConsoleString.uString : UnicodeString;
begin
  Result := UnicodeString(FStrChar);
end;

Function  TConsoleString.ToUpper : UnicodeString;
begin
  Result := PlyUpperCase(UnicodeString(FStrChar));
end;

Procedure TConsoleString.Clear(cChar:WideChar=' '; cAttr:Word=0);
Var i : integer;
begin
  For i := 0 to length(FStrChar)-1 do
  begin
    FStrChar[i] := cChar;
    if cAttr>0 then FStrAttr[i] := cAttr;
  end;
end;

Procedure TConsoleString.Clear(x1,x2:Integer; cChar:WideChar=' '; cAttr:Word=0);
Var i : integer;
begin
  For i := x1 to x2 do
  begin
    if (i>=0) and (i<=Length(FStrChar)-1) then
    begin
      FStrChar[i] := cChar;
    end;
    if cAttr>0 then
    begin
      if (i>=0) and (i<=Length(FStrAttr)-1) then
      begin
        FStrAttr[i] := cAttr;
      end;
    end;
  end;
end;

Function  TConsoleString.Len : integer;
begin
  Result := length(FStrChar);
end;

Procedure TConsoleString.Save(y:Smallint);
Var Coord                    : tCoord;
    NumRead                  : DWord;
begin
  Init(WindSize.Width);
  Coord.X  := Max(0,smallint(WindSize.Left + 0));
  Coord.Y  := Max(0,smallint(WindSize.Top + y - 1));
  NumRead  := 0;
  ReadConsoleOutputAttribute(ConHandleStdOut
    ,@FStrAttr[0],WindSize.Width,Coord,numRead);
  ReadConsoleOutputCharacterW(ConHandleStdOut
    ,@FStrChar[0],WindSize.Width,Coord,numRead);
end;

Procedure TConsoleString.Restore(y:Integer);
Var Coord                    : tCoord;
    Count                    : DWord;
    NumWritten               : DWord;
begin
  Coord.X    := Max(0,smallint(WindSize.Left + 0));
  Coord.Y    := Max(0,smallint(WindSize.Top + y - 1));
  Count      := Min(length(FStrChar),WindSize.Width);
  NumWritten := 0;
  WriteConsoleOutputAttribute(ConHandleStdOut
    ,@FStrAttr[0],Count,Coord,NumWritten);
  WriteConsoleOutputCharacterW(ConHandleStdOut
    ,@FStrChar[0],Count,Coord,NumWritten);
end;

Function  TConsoleString.GetChar(Index:Integer=1) : TConsoleChar;
begin
  Result.FChar := Char[Index];
  Result.FAttr := Attr[Index];
end;

Procedure TConsoleString.SetChar(Index:Integer; Value:tConsoleChar);
begin
  Char[Index] := Value.FChar;
  Attr[Index] := Value.FAttr;
end;

Function  TConsoleString.StringCopy(Index:integer=1; Count:integer=-1) : tConsoleString;
begin
  if (Count=-1) then Count := Length(FStrChar);
  Count := ValueMinMax(Count,0,Length(FStrChar)-Index+1);
  Result.Init(Count);
  if (Count>0) then
  begin
    Result.FStrChar := Copy(FStrChar,Index-1,Count);
    Result.FStrAttr := Copy(FStrAttr,Index-1,Count);
  end;
end;

Function  TConsoleString.StringAlignLeft(Count:Integer; ch:WideChar=' '; Cut:Boolean=False) : TConsoleString;
Var AddStr : TConsoleString;
begin
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;
  if (len < Count) then
  begin
    AddStr.Init(Count-Len,ch,Attr[Len]);
    Self := Self + AddStr;
  end;
  if (Cut) then Result := StringCopy(1,Count)
           else Result := Self;
end;

Function  TConsoleString.StringAlignRight(Count:Integer; ch:WideChar=' '; Cut:Boolean=False) : TConsoleString;
Var AddStr : TConsoleString;
begin
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  if (len < Count) then
  begin
    AddStr.Init(Count-Len,ch,GetChar(1).Attr);
    Self := AddStr + Self;
  end;
  if (Cut) then Result := StringCopy(1,Count)
           else Result := Self;
end;

Function  TConsoleString.StringCopyUnicode(Index:integer=1; Count:integer=-1) : UnicodeString;
begin
  if (Count=-1) then Count := Length(FStrChar)-Index+1;
  Result := Copy(UnicodeString(FStrChar),Index-1,Count);
end;

Procedure TConsoleString.InvertString(Index:Integer=1; Count:Integer=-1);
Var i : integer;
begin
  if (Count=-1) then Count := Length(FStrChar)-Index+1;
  for i := Index-1 to Index+Count-2 do
  begin
    if (i>=0) and (i<=High(FStrAttr)) then
    begin
      FStrAttr[i] := InvertTextAttr(FStrAttr[i]);
    end;
  end;
end;

Procedure TConsoleString.UnderlineString(Index:Integer=1; Count:Integer=-1);
Var i : integer;
begin
  if (Count=-1) then Count := Length(FStrChar)-Index+1;
  for i := Index-1 to Index+Count-2 do
  begin
    if (i>=0) and (i<=High(FStrAttr)) then
    begin
      FStrAttr[i] := UnderlineTextAttr(FStrAttr[i]);
    end;
  end;
end;

Procedure TConsoleString.OutlineString(Index:Integer=1; Count:Integer=-1);
Var i : integer;
begin
  if (Count=-1) then Count := Length(FStrChar)-Index+1;
  for i := Index-1 to Index+Count-2 do
  begin
    if (i>=0) and (i<=High(FStrAttr)) then
    begin
      if (i=Index-1)       then FStrAttr[i] := OutlineStartTextAttr(FStrAttr[i]) else
      if (i=Index+Count-2) then FStrAttr[i] := OutlineEndTextAttr(FStrAttr[i])
                           else FStrAttr[i] := OutlineCenterTextAttr(FStrAttr[i])
    end;
  end;
end;

Procedure TConsoleString.InvertSearchString(SearchString:String; Offset:Integer=1;
            InvertAll:Boolean=True; CaseSensitive:Boolean=False);
Var ConString  : String;
    sPos       : Integer;
begin
  if (SearchString<>'') then
  begin
    ConString := uString;
    if not(CaseSensitive) then
    begin
      SearchString := PlyUpperCase(SearchString);
      ConString    := PlyUpperCase(ConString);
    end;
    Repeat
      sPos := Pos(SearchString,ConString,Offset);
      if (sPos>=1) then
      begin
        InvertString(sPos,length(SearchString));
        if not(InvertAll) then Exit;
        Offset := sPos + Length(SearchString);
      end;
    Until (sPos<=0);
  end;
end;

(***********************)
(***** TScreenData *****)
(***********************)
Procedure TScreenData.Init(Const Len:Cardinal);
begin
  SetLength(CharData,Len);
  SetLength(AttrData,Len);
end;

Procedure TScreenData.Init(Const ScreenSize:TConsoleWindowPoint);
begin
  Init(ScreenSize.x*ScreenSize.y);
end;

Function  TScreenData.SizeChar : Cardinal;
begin
  Result := (Length(CharData) * Sizeof(WideChar));
end;

Function  TScreenData.SizeAttr : Cardinal;
begin
  Result := (Length(AttrData) * Sizeof(Word));
end;

(*******************)
(***** tScreen *****)
(*******************)
Function  tScreen.GetLine(Index:integer) : tConsoleString;
begin
  if (Index>=1) and (Index<Length(FLines))
     then Result := FLines[Index-1]
     else Result.Init(0);
end;

Procedure tScreen.SetLine(Index:integer; Value:tConsoleString);
begin
  if (Index>=1) and (Index<Length(FLines)) then
  begin
    FLines[Index-1] := Value;
  end;
end;

Procedure tScreen.Clear;
begin
  FSize.X := 0;
  FSize.Y := 0;
  SetLength(FLines,0);
end;

Procedure tScreen.Init;
Var i : integer;
begin
  Size := Console.WindowSize;
  SetLength(FLines,Size.y);
  for i := 0 to length(FLines)-1 do
  begin
    FLines[i].Init(Size.x);
  end;
end;

Procedure tScreen.Init(Const ScreenSize:TConsoleWindowPoint);
Var i : integer;
begin
  Size := ScreenSize;
  SetLength(FLines,Size.y);
  for i := 0 to length(FLines)-1 do
  begin
    FLines[i].Init(Size.x);
  end;
end;

Procedure tScreen.Save;
Var Coord   : tCoord;
    NumRead : DWord;
begin
  Init;
  Coord.X  := 0;
  Coord.Y  := 0;
  NumRead  := 0;
  Repeat
    ReadConsoleOutputAttribute(ConHandleStdOut,@FLines[Coord.Y].FStrAttr[0]
      ,Size.X,Coord,numRead);
    ReadConsoleOutputCharacterW(ConHandleStdOut,@FLines[Coord.Y].FStrChar[0]
      ,Size.X,Coord,numRead);
    inc(Coord.Y);
  until (Longint(Coord.Y)>=Size.Y);
end;

Procedure tScreen.Restore;
Var Coord                    : tCoord;
    NumWritten               : DWord;
begin
  if not(Size.IsClear) then
  begin
    Console.Window(FSize);
    Coord.X    := 0;
    Coord.Y    := 0;
    NumWritten := 0;
    Repeat
      WriteConsoleOutputAttribute(ConHandleStdOut,@FLines[Coord.Y].FStrAttr[0]
        ,Size.X,Coord,NumWritten);
      WriteConsoleOutputCharacterW(ConHandleStdOut,@FLines[Coord.Y].FStrChar[0]
        ,Size.X,Coord,NumWritten);
      inc(Coord.Y);
    until (Coord.Y>=Size.Y);
  end;
end;

Procedure tScreen.RestorePart(X1,Y1,X2,Y2:Integer);
Var CurScreen                : tScreen;
    ConsoleChar              : tConsoleChar;
    ax,ay                    : Byte;
begin
  // Get current screen
  CurScreen.Save;
  // Overwrite the specified part with saved/old data
  For ay := Y1 to Y2 do
  begin
    if (ay>=1) and (ay<Length(FLines)) then
    begin
      For ax := X1 to X2 do
      begin
        if (ax>=1) and (ax<Length(FLines[ay].FStrChar)) then
        begin
          ConsoleChar := GetChar(ax,ay);
          ConsoleChar.FAttr.Textbackground := Green;
          CurScreen.SetChar(ax,ay,ConsoleChar);
        end;
      end;
    end;
  end;
  // Restore modified screen
  CurScreen.Restore;
end;

Procedure tScreen.CatchUserSelection(Var SelectedScreen:tScreen);
Var SelectionAnachor : TConsoleWindowPoint;
    Selection        : TConsoleWindowRect;
begin
  if (Console.GetConsoleSelection(SelectionAnachor,Selection)) then
  begin
    Save;
    GetRect(Selection,SelectedScreen);
  end;
end;

Procedure tScreen.InvertString(x,y:Integer; Count:Integer);
begin
  if (y>=1) and (y<Length(FLines)) then
  begin
    if (x>=1) and (x<FLines[y-1].Len) then
    begin
      FLines[y-1].InvertString(x,Count);
    end;
  end;
end;

Procedure tScreen.UnderlineString(x,y:Integer; Count:Integer);
begin
  if (y>=1) and (y<Length(FLines)) then
  begin
    if (x>=1) and (x<FLines[y-1].Len) then
    begin
      FLines[y-1].UnderlineString(x,Count);
    end;
  end;
end;

Procedure tScreen.OutlineString(x,y:Integer; Count:Integer);
begin
  if (y>=1) and (y<Length(FLines)) then
  begin
    if (x>=1) and (x<FLines[y-1].Len) then
    begin
      FLines[y-1].OutlineString(x,Count);
    end;
  end;
end;

Procedure tScreen.ClearLine(y:Integer; cChar:WideChar=' '; cAttr:Word=0);
begin
  if (y>=1) and (y<Length(FLines)) then
  begin
    FLines[y-1].Clear(cChar,cAttr);
  end;
end;

Procedure tScreen.ClearLine(y,x1,x2:Integer; cChar:WideChar=' '; cAttr:Word=0);
begin
  if (y>=1) and (y<Length(FLines)) then
  begin
    FLines[y-1].Clear(x1,x2,cChar,cAttr);
  end;
end;

Function  tScreen.GetChar(x,y:Integer) : tConsoleChar;
begin
  Result.FChar := Line[y].Char[x];
  Result.FAttr := Line[y].Attr[x];
end;

Procedure tScreen.SetChar(x,y:Integer; Value:tConsoleChar);
begin
  if (y>=1) and (y<Length(FLines)) then
  begin
    FLines[y-1].Char[x] := Value.FChar;
    FLines[y-1].Attr[x] := Value.FAttr;
  end;
end;

Procedure tScreen.GetRect(X1,Y1,X2,Y2:Integer; Var aScreen:tScreen);
Var aScreenSize : TConsoleWindowPoint;
    ay : integer;
begin
  if (X1>0) and (Y1>0) and (X2>=X1) and (Y2>=Y1) then
  begin
    aScreenSize.x := X2-X1+1;
    aScreenSize.y := Y2-Y1+1;
    aScreen.Init(aScreenSize);
    for ay := Y1 to Y2 do
    begin
      aScreen.FLines[ay-Y1] := FLines[aY-1].StringCopy(X1,X2-X1+1);
    end;
  end else aScreen.Clear;
end;

Procedure tScreen.GetRect(Rect:TConsoleWindowRect; Var aScreen:tScreen);
begin
  GetRect(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom,aScreen);
end;

Procedure tScreen.SetRect(X1,Y1,X2,Y2:Integer; Var aScreen:tScreen);
Var ax,ay : integer;
begin
  for ay := Y1 to Y2 do
  begin
    for ax := X1 to X2 do
    begin
      FLines[ay-1].ConsoleChar[ax] := aScreen.FLines[ay-Y1].ConsoleChar[ax-X1+1];
    end;
  end;
end;

Procedure tScreen.WriteXY(x,y:Integer; uString:String);
Var i                        : Integer;
    ax                       : Integer;
begin
  if (x>=1) and (x<=Size.x) and
     (y>=1) and (y<=Size.y) then
  begin
    For i := 1 to length(uString) do
    begin
      ax := x+i-1;
      if (ax<=Size.x) then
      begin
        // Set current text attribute
        FLines[y-1].Attr[ax] := TextAttr;
        // Set Char
        FLines[y-1].Char[ax] := uString[i];
      end;
    end;
  end;
end;

Procedure tScreen.WriteXY(x,y:Integer; TColor:Byte; uString:String);
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  Textcolor(TColor);
  WriteXY(x,y,uString);
  TextAttr := SaveAttr;
end;

Procedure tScreen.MovePartScreen(X1,Y1,X2,Y2,XM,YM:Integer);
Var PartScreen : tScreen;
begin
  PartScreen.Clear;
  GetRect(X1,Y1,X2,Y2,PartScreen);
  SetRect(X1+XM,Y1+YM,X2+XM,Y2+YM,PartScreen);
  Restore;
end;

Procedure tScreen.GetData(Var ScreenData:TScreenData);
Var LineCount : Integer;
    MoveSize : Integer;
    DestPos : Integer;
begin
  if (Size.IsClear) then ScreenData.Init(0) else
  begin
    ScreenData.Init(Size);
    for LineCount := 0 to Size.y-1 do
    begin
      MoveSize := FSize.X * sizeof(Word);
      DestPos  := LineCount * FSize.x;
      Move(FLines[LineCount].FStrChar[0],ScreenData.CharData[DestPos],MoveSize);
      Move(FLines[LineCount].FStrAttr[0],ScreenData.AttrData[DestPos],MoveSize);
    end;
  end;
end;

Procedure tScreen.SetData(Const ScreenSize:TConsoleWindowPoint;
            Var ScreenData:TScreenData);
Var LineCount : Integer;
    MoveSize : Integer;
    SourPos : Integer;
begin
  Init(ScreenSize);
  if not(ScreenSize.IsClear) then
  begin
    for LineCount := 0 to ScreenSize.y-1 do
    begin
      MoveSize := ScreenSize.X * sizeof(Word);
      SourPos  := LineCount * Size.x;
      Move(ScreenData.CharData[SourPos],FLines[LineCount].FStrChar[0],MoveSize);
      Move(ScreenData.AttrData[SourPos],FLines[LineCount].FStrAttr[0],MoveSize);
    end;
  end;
end;

(***********************)
(***** tScreenSave *****)
(***********************)
Procedure tScreenSave.Clear;
begin
  FWindSize.Clear;
  FCursorPos.Clear;
  FTextAttr  := _TextAttr_Default;
  FScreen.Clear;
end;

Function  tScreenSave.IsClear : Boolean;
begin
  Result := FScreen.Size.IsClear;
end;

Procedure tScreenSave.Save;
begin
  FWindSize  := Crt.WindSize;
  FCursorPos := Crt.CursorPos;
  FTextAttr  := Crt.TextAttr;
  FScreen.Save;
end;

Procedure tScreenSave.RestoreSize;
begin
  if not(IsClear) then
  begin
    Crt.WindSize  := FWindSize;
    Crt.CursorPos := FCursorPos;
  end;
end;

Procedure tScreenSave.Restore;
begin
  if not(IsClear) then
  begin
    FScreen.Restore;
    Crt.WindSize     := FWindSize;
    Crt.CursorPos    := FCursorPos;
    Crt.TextAttr     := FTextAttr;
  end;
end;

Procedure tScreenSave.RestorePart(X1,Y1,X2,Y2:Integer);
begin
  X1 := ValueMinMax(X1,1,MaxX);
  Y1 := ValueMinMax(Y1,1,MaxY);
  X2 := ValueMinMax(X2,X1,MaxX);
  Y2 := ValueMinMax(Y2,Y1,MaxY);
  FScreen.RestorePart(WindSize.Left+X1,WindSize.Top+Y1
                    ,WindSize.Left+X2,WindSize.Top+Y2);
end;

Procedure tScreenSave.InvertString(x,y:Longint; Count:Integer);
begin
  if (x>=1) and (x<=WindSize.Width)  and
     (y>=1) and (y<=WindSize.Height) then
  begin
    FScreen.InvertString(WindSize.Left+x,WindSize.Top+y,Count);
  end;
end;

Procedure tScreenSave.UnderlineString(x,y:Longint; Count:Integer);
begin
  if (x>=1) and (x<=WindSize.Width)  and
     (y>=1) and (y<=WindSize.Height) then
  begin
    FScreen.UnderlineString(WindSize.Left+x,WindSize.Top+y,Count);
  end;
end;

Procedure tScreenSave.OutlineString(x,y:Longint; Count:Integer);
begin
  if (x>=1) and (x<=WindSize.Width)  and
     (y>=1) and (y<=WindSize.Height) then
  begin
    FScreen.OutlineString(WindSize.Left+x,WindSize.Top+y,Count);
  end;
end;

Procedure tScreenSave.ClrLine(y1,y2:Integer);
Var y : Integer;
begin
  For y := y1 to y2 do
  begin
    FScreen.ClearLine(WindSize.Top+y,WindSize.Left,WindSize.Right);
  end;
end;

Function  tScreenSave.GetChar(x,y:integer) : tConsoleChar;
begin
  Result := FScreen.GetChar(WindSize.Left+x,WindSize.Top+y);
end;

Procedure tScreenSave.SetChar(x,y:integer; Value:tConsoleChar);
begin
  FScreen.SetChar(WindSize.Left+x,WindSize.Top+y,Value);
end;

Procedure tScreenSave.WriteXY(x,y:Longint; cString:CP850String);
begin
  WriteXY(x,y,Str_CP850_Unicode(cString));
end;

Procedure tScreenSave.WriteXY(x,y:Longint; uString:String);
begin
  uString := Copy(uString,1,MaxX-X+1);
  FScreen.WriteXY(FWindSize.Left+x,FWindSize.Top+y,uString);
  // Place the cursor at the end of the text
  FCursorPos.x := Min((FWindSize.Left+x+length(uString)),FWindSize.Left+FWindSize.Width);
  FCursorPos.y := FWindSize.Top+y;
end;

Procedure tScreenSave.WriteXY(x,y:Integer; TColor:Byte; uString:String);
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  TextColor(TColor);
  WriteXY(x,y,uString);
  TextAttr := SaveAttr;
end;

Procedure tScreenSave.MovePartScreen(X1,Y1,X2,Y2,XM,YM:Integer);
begin
  FScreen.MovePartScreen(FWindSize.Left+X1,FWindSize.Top+Y1
                        ,FWindSize.Left+X2,FWindSize.Top+Y2,XM,YM)
end;

(******************************)
(***** Internal Functions *****)
(******************************)
procedure CrtWriteAnsiChar(Const ac: AnsiChar);
var WritePos                 : Coord;
    numWritten               : Longword;
    wch                      : WideChar;
begin
  Case ac of
    // MessageBeep
    #07 :  MessageBeep(MB_OK);
    // BackSpace
    #08 : if (CursorPos.X > WindSize.Left+1) then Dec(CursorPos.X);
    // LineFeed
    #10 : Inc(CursorPos.Y);
    // CarriageReturn
    #13 : CursorPos.X := WindSize.Left+1;
    else begin
      WritePos.X := CursorPos.X - 1;
      WritePos.Y := CursorPos.Y - 1;
      // WriteChar
      // If Euro-Sign, then
      if (ac=#128) and (Console.InputCodepage=_Codepage_850) then
      begin
        // Font.Terminal has no Euro-Sign -> print Ç
        if (Console.Font.Is_Terminal) then
        begin
          WriteConsoleOutputCharacterA(ConHandleStdOut,@ac,1,writePos,numWritten);
        end else
        // if (font <> Terminal) replace with Euro-Sign
        begin
          wch := WideChar(_Euro_Sign);
          WriteConsoleOutputCharacterW(ConHandleStdOut,@wch,1,writePos,numWritten);
        end;
      end else
      begin
        if (Console.OutputCodepage=_Codepage_850)
           then wch := Char_CP850_Unicode(ac)
           else wch := Char_CP1252_Unicode(ac);
        WriteConsoleOutputCharacterW(ConHandleStdOut,@wch,1,writePos,numWritten);
      end;
      // SetAttribute
      WriteConsoleOutputAttribute(ConHandleStdOut,@TextAttr.Attr,1,writePos,numWritten);
      Inc(CursorPos.X);
    end;
  end;

  if CursorPos.X > WindSize.Right+1 then
  begin
    CursorPos.X := WindSize.Left+1;
    Inc(CursorPos.Y);
  end;
  While CursorPos.Y > WindSize.Bottom+1 do
  begin
    DelLine(1);
    Dec(CursorPos.Y);
  end;
end;

procedure CrtWriteWideChar(Const wc: WideChar);
var WritePos                 : Coord;
    numWritten               : Longword;
    WinAttr                  : word;
begin
  Case Word(wc) of
    // MessageBeep
    7 :  MessageBeep(MB_OK);
    // BackSpace
    8 : if (CursorPos.X > WindSize.Left+1) then Dec(CursorPos.X);
    // LineFeed
    10 : Inc(CursorPos.Y);
    // CarriageReturn
    13 : CursorPos.X := WindSize.Left+1;
    else begin
      WritePos.X := CursorPos.X - 1;
      WritePos.Y := CursorPos.Y - 1;
      // WriteChar
      // If Euro-Sign, then
      if (Word(wc)=_Euro_Sign) and (Console.Font.Is_Terminal) then
      begin
        // Font.Terminal has no Euro-Sign -> print Ç
        WriteConsoleOutputCharacterW(ConHandleStdOut,'Ç',1,writePos,numWritten);
      end else
      begin
        WriteConsoleOutputCharacterW(ConHandleStdOut,@wc,1,writePos,numWritten);
      end;
      // SetAttribute
      WinAttr:=TextAttr;
      WriteConsoleOutputAttribute(ConHandleStdOut,@WinAttr,1,writePos,numWritten);
      Inc(CursorPos.X);
    end;
  end;

  if (CursorPos.X > WindSize.Right+1) then
  begin
    CursorPos.X := WindSize.Left+1;
    Inc(CursorPos.Y);
  end;
  While CursorPos.Y > WindSize.Bottom+1 do
  begin
    DelLine(1);
    Dec(CursorPos.Y);
  end;
end;

procedure CrtWriteString(uString: UnicodeString);
var ProcOutput               : Boolean;
    WrapOutput               : Boolean;
    NextLine                 : Boolean;
    WritePos                 : Coord;
    PosCtrlChar              : Longword;
    PosWrapWord              : Longword;
    numWritten               : Longword;
    numWrite                 : Longword;
    sLen                     : Integer;
    WinAttr                  : WideString;
    sPos                     : Integer;
begin
  if (uString<>'') then
  begin
    ProcOutput := Console.Modes.ProcessedOutput;
    WrapOutput := Console.Modes.WrapOutput;

    if not(ProcOutput) and (Console.Modes.ReplaceCtrlChar) then
    begin
      uString := StringReplaceControlCharacter(uString);
    end;

    sPos    := 1;
    sLen    := Length(uString);
    WinAttr := System.StringOfChar(WideChar(TextAttr),sLen);
    Repeat
      NextLine := False;
      numWrite := Min(WindSize.Right-CursorPos.X+2,sLen+1-sPos);
      if (ProcOutput) and (CharIsControlCharacter(uString[sPos])) then
      begin
        CrtWriteWideChar(uString[sPos]);
        inc(sPos,1);
      end else
      begin
        if (WrapOutput) and (Console.Modes.WrapWord) and (Integer(numWrite)<sLen-sPos+1) then
        begin
          PosWrapWord := StringPosWrapWord(uString,numWrite,sPos);
          if (PosWrapWord<numWrite) then
          begin
            NumWrite := PosWrapWord;
            NextLine := True;
          end;
        end;
        if (ProcOutput) then
        begin
          PosCtrlChar := StringPosControlCharacter(uString,sPos);
          if (PosCtrlChar>0) and (PosCtrlChar<=numWrite) then
          begin
            numWrite := Min(numWrite,PosCtrlChar-1);
            NextLine := False;
          end;
        end;
        // WritePos is ZeroBased
        WritePos.X := CursorPos.X-1;
        WritePos.Y := CursorPos.Y-1;
        // Output numWrite Characters and Attributes
        WriteConsoleOutputCharacterW(ConHandleStdOut,@uString[sPos],numWrite,writePos,numWritten);
        WriteConsoleOutputAttribute(ConHandleStdOut,@WinAttr[sPos],numWrite,writePos,numWritten);
        inc(CursorPos.X,numWrite);
        inc(sPos,numWrite);
      end;
      if (CursorPos.X>WindSize.Right+1) or (NextLine) then
      begin
        CursorPos.X := WindSize.Left + 1;
        if (WrapOutput) then Inc(CursorPos.Y);
        // If not all characters from uString have been written yet and the
        // last character in the current crt.window has been reached, scroll up
        // within the current crt.window to be able to fill the last line with
        // the further characters from uString
        if (sPos<=sLen) then
        begin
          While (CursorPos.Y>WindSize.Bottom+1) do
          begin
            DelLine(1);
            Dec(CursorPos.Y);
          end;
          WritePos.X:=CursorPos.X-1;
          WritePos.Y:=CursorPos.Y-1;
        end else
        // If there are no more characters, place the cursor on last character
        begin
          CursorPos.X := WindSize.Right+1;
          Dec(CursorPos.Y);
        end;
      end;
    Until (sPos>sLen);
  end;
end;

Function CrtWrite(var t:TTextrec) : integer;
var
  i : longint;
  s : String;
begin
  if (t.BufPos>0) then
  begin
    s := '';
    for i := 0 to t.bufpos-1 do
    begin
      // special chars (including €-Sign) write as Char
      if t.buffer[i] in [#7,#8,#10,#13,#128] then
      begin
        if s<>'' then
        begin
          CrtWriteString(s);
          s:='';
        end;
        CrtWriteAnsiChar(t.buffer[i]);
      end else
      begin
        s := s + WideChar(t.buffer[i]);
      end;
    end;
    if s<>'' then
    begin
      CrtWriteString(s);
    end;
    t.bufpos := 0;
  end;
  CrtWrite := 0;
end;

Function CrtWriteAlternate(var t: TTextRec; s: UnicodeString) : Pointer;
begin
  CrtWriteString(s);
  Result := @t;
end;

Function CrtRead(Var t:TTextRec): Integer;

  Procedure _CrtRETURN(Var t:TTextRec);
  begin
    t.bufptr[t.bufend]   := #13;
    t.bufptr[t.bufend+1] := #10;
    inc(t.bufend,2);
  end;

  Procedure _CrtCursorLeft(Var t:TTextRec);
  begin
    if t.bufpos>0 then
    begin
      dec(t.bufpos);
      if (CursorPos.X>1) then dec(CursorPos.X) else
      begin
        dec(CursorPos.Y);
        CursorPos.X := WindSize.Right+1;
      end;
    end;
  end;

  Procedure _CrtCursorCtrlLeft(Var t:TTextRec);
  begin
    While t.bufpos>0 do
    begin
      _CrtCursorLeft(t);
      if (t.Buffer[t.BufPos]=' ') then Exit;
    end;
  end;

  Procedure _CrtCursorRight(Var t:TTextRec);
  begin
    if t.bufpos<t.bufend then
    begin
      inc(t.bufpos);
      if (CursorPos.X<WindSize.Right+1) then inc(CursorPos.X) else
      begin
        inc(CursorPos.Y);
        CursorPos.X := 1;
      end;
    end;
  end;

  Procedure _CrtCursorCtrlRight(Var t:TTextRec);
  begin
    While t.bufpos<t.bufend do
    begin
      _CrtCursorRight(t);
      if (t.Buffer[t.BufPos]=' ') then Exit;
    end;
  end;

  Procedure _CrtPos1(Var t:TTextRec);
  begin
    while (t.BufPos>0) do
    begin
      _CrtCursorLeft(t);
    end;
  end;

  Procedure _CrtEnd(Var t:TTextRec);
  begin
    while t.bufpos<t.bufend do
    begin
      _CrtCursorRight(t);
    end;
  end;

  Procedure _CrtInsert(Var t:TTextRec);
  Var SaveBufPos : Byte;
  begin
    if (t.BufEnd<t.BufSize) then
    begin
      SaveBufPos := t.BufPos;
      _CrtEnd(t);
      while (t.BufPos>SaveBufPos) do
      begin
        t.Buffer[t.BufPos] := t.Buffer[t.BufPos-1];
        CrtWriteAnsiChar(t.Buffer[t.BufPos]);
        _CrtCursorLeft(t);
        if (CursorPos.X>1) then Dec(CursorPos.X) else
        begin
          dec(CursorPos.Y);
          CursorPos.X := WindSize.Right+1;
        end;
      end;
      t.Buffer[t.BufPos] := ' ';
      CrtWriteAnsiChar(t.Buffer[t.BufPos]);
      Dec(CursorPos.X);
      inc(t.BufEnd);
    end;
  end;

  procedure _CrtDelete(Var t:TTextRec);
  Var SaveBufPos : Byte;
      SaveCursorPos : TConsoleWindowPoint;
  begin
    if t.BufPos<t.BufEnd then
    begin
      SaveBufPos := t.BufPos;
      SaveCursorPos := CursorPos;
      while (t.BufPos<t.BufEnd) do
      begin
        t.Buffer[t.BufPos] := t.Buffer[t.BufPos+1];
        CrtWriteAnsiChar(t.Buffer[t.BufPos]);
        inc(t.BufPos);
      end;
      dec(t.BufEnd);
      t.BufPos := SaveBufPos;
      CursorPos := SaveCursorPos;
    end;
  end;

  procedure _CrtBackSpace(Var t:TTextRec);
  begin
    if (t.bufpos>0) and (t.bufpos<=t.bufend) then
    begin
      _CrtCursorLeft(t);
      _CrtDelete(t);
    end;
  end;

  // EOF | ^Z | _CTRL_Z | #26 | $1A
  Function _CrtEOF(Var t:TTextRec) : Boolean;
  begin
    {$WARNINGS OFF}
    if CheckEOF then
    begin
      t.bufptr[t.bufend] := #26;
      inc(t.bufend);
      Result := True;
    end else Result := False;
    {$WARNINGS ON}
  end;

  Procedure _CrtEscape(Var t:TTextRec);
  begin
    t.BufPos := t.BufEnd;
    while t.bufend>0 do _CrtBackSpace(t);
  end;

  Procedure _CrtSlashNumpad(Var t:TTextRec);
  begin
    if t.bufpos<t.bufsize-2 then
    begin
      t.buffer[t.bufpos] := '/';
      CrtWriteAnsiChar(t.buffer[t.bufpos]);
      inc(t.bufpos);
    end;
  end;

var Key : Word;
    wc  : WideChar;
Begin
  t.bufpos   := 0;
  t.bufend   := 0;
  t.CodePage := Console.InputCodepage;
  // DefaultSystemCodePage := Console.InputCodepage;

  FillChar(t.Buffer,sizeof(t.Buffer),#0);
  repeat
    if t.bufpos>t.bufend then t.bufend := t.bufpos;
    Console.CursorPosition := CursorPos;
    wc := ReadkeyW(Key);
    if (Key=_DIVIDE_NumPad) then _CrtSlashNumpad(t)     else    // numpad "/"
    if (Key=_Pos1)          then _CrtPos1(t)            else    // Pos1
    if (Key=_Left)          then _CrtCursorLeft(t)      else    // cursor left
    if (Key=_CTRL_Left)     then _CrtCursorCtrlLeft(t)  else
    if (Key=_Right)         then _CrtCursorRight(t)     else    // cursor right
    if (Key=_CTRL_Right)    then _CrtCursorCtrlRight(t) else
    if (Key=_End)           then _CrtEnd(t)             else    // End
    if (Key=_Insert)        then _CrtInsert(t)          else    // Insert
    if (Key=_DELETE_CRT)    then _CrtDelete(t)          else    // Del
    if (Key=_BackSpace)     then _CrtBackSpace(t)       else    // BackSpace
    if (Key=_CTRL_Z)        then                                // Ctrl+Z = EOF
    begin
      if (_CrtEoF(t)) then break;
    end else
    if (Key=_ESC)        then _CrtEscape(t) else    // Escape
    if (Key=_Return) or (Key=_Ctrl_RETURN) then     // (RETURN) or (Ctrl+RETURN)
    begin
      _CrtRETURN(t);
      break;
    end else
    // Add Char to TextBuffer
    if (ord(wc)>$0000) then
    begin
      if t.bufpos<t.bufsize-2 then
      begin
        if (Console.InputCodepage=_Codepage_850)
           then t.Buffer[t.BufPos] := Char_Unicode_CP850(wc)
           else t.Buffer[t.BufPos] := Char_Unicode_CP1252(wc);
        inc(t.bufpos);
        CrtWriteWideChar(wc);
      end;
    end;
  until false;
  t.bufpos := 0;
  Result   := 0;
  // DefaultSystemCodePage := Console.CodepageWindows;
End;

Procedure CrtReadln(Var uString:UnicodeString);
Var wc   : WideChar;
    Key  : Word;
    sPos : Integer;

  Procedure __CursorLeft;
  begin
    if sPos>1 then
    begin
      dec(sPos);
      if (CursorPos.X>1) then dec(CursorPos.X) else
      begin
        dec(CursorPos.Y);
        CursorPos.X := WindSize.Right+1;
      end;
    end;
  end;

  Procedure __CursorCtrlLeft;
  begin
    While sPos>1 do
    begin
      __CursorLeft;
      if (uString[sPos]=' ') then Exit;
    end;
  end;

  Procedure __CursorRight;
  begin
    if sPos<=length(uString) then
    begin
      inc(sPos);
      if (CursorPos.X<WindSize.Right+1) then inc(CursorPos.X) else
      begin
        inc(CursorPos.Y);
        CursorPos.X := 1;
      end;
    end;
  end;

  Procedure __CursorCtrlRight;
  begin
    While sPos<=length(uString) do
    begin
      __CursorRight;
      if (sPos>Length(uString)) then Exit else
      if (uString[sPos]=' ')    then Exit;
    end;
  end;

  Procedure __Pos1;
  begin
    while (sPos>1) do
    begin
      __CursorLeft;
    end;
  end;

  Procedure __End;
  begin
    while sPos<=length(uString) do
    begin
      __CursorRight;
    end;
  end;

  Procedure __Insert;
  Var SavePos : Integer;
  begin
    SavePos := sPos;
    __End;
    SetLength(uString,length(uString)+1);
    while (sPos>SavePos) do
    begin
      uString[sPos] := uString[sPos-1];
      CrtWriteWideChar(uString[sPos]);
      __CursorLeft;
      if (CursorPos.X>1) then Dec(CursorPos.X) else
      begin
        dec(CursorPos.Y);
        CursorPos.X := WindSize.Right+1;
      end;
    end;
    uString[sPos] := ' ';
    CrtWriteWideChar(uString[sPos]);
    Dec(CursorPos.X);
  end;

  procedure __Delete;
  Var SavePos : Integer;
      SaveCursorPos : TConsoleWindowPoint;
  begin
    if sPos<=length(uString) then
    begin
      SavePos := sPos;
      SaveCursorPos := CursorPos;
      while (sPos<=Length(uString)) do
      begin
        if (sPos<Length(uString)) then
        begin
          uString[sPos] := uString[sPos+1];
          CrtWriteWideChar(uString[sPos]);
        end else
        begin
          CrtWriteWideChar(' ');
        end;
        inc(sPos);
      end;
      SetLength(uString,length(uString)-1);
      sPos := SavePos;
      CursorPos := SaveCursorPos;
    end;
  end;

  procedure __BackSpace;
  begin
    if (sPos>1) then
    begin
      __CursorLeft;
      __Delete;
    end;
  end;

  Procedure __Escape;
  begin
    sPos := Length(uString)+1;
    while sPos>1 do __BackSpace;
  end;

begin
  sPos    := 1;
  uString := '';
  Repeat
    Console.CursorPosition := CursorPos;
    wc := ReadkeyW(Key);
    if (Key=_Pos1)       then __Pos1            else    // Pos1
    if (Key=_Left)       then __CursorLeft      else    // left
    if (Key=_CTRL_Left)  then __CursorCtrlLeft  else    // crtl+left
    if (Key=_Right)      then __CursorRight     else    // right
    if (Key=_CTRL_Right) then __CursorCtrlRight else    // ctrl+right
    if (Key=_End)        then __End             else    // End
    if (Key=_Insert)     then __Insert          else    // Insert
    if (Key=_DELETE_CRT) then __Delete          else    // Del
    if (Key=_BackSpace)  then __BackSpace       else    // BackSpace
    if (Key=_ESC)        then __Escape          else    // Escape
    if (Key=_Return) or (Key=_Ctrl_RETURN) then         // (RETURN) or (Ctrl+RETURN)
    begin
      break;
    end else
    // Add Char to String
    if (wc>#0) then
    begin
      if (length(uString)<SPos) then SetLength(uString,length(uString)+1);
      uString[sPos] := wc;
      CrtWriteWideChar(uString[sPos]);
      inc(sPos);
    end;
  Until (LastKey=_ALT_X);
  uString := TrimRight(uString);
end;

Function CrtNoProc(var t): Integer;
begin
  Result := 0;
end;

function CrtOpen(var t:TTextRec): Integer;
begin
  Result   := 0;
  t.BufPos := 0;
  t.BufEnd := 0;
  case t.Mode of
    // Reset
    fmInput:
      begin
        t.InOutFunc := @CrtRead;
        t.FlushFunc := @CrtNoProc;
        t.CodePage  := Console.InputCodepage;
      end;
    // Rewrite
    fmOutput:
      begin
        t.InOutFunc := @CrtWrite;
        t.FlushFunc := @CrtWrite;
        t.CodePage  := Console.OutputCodepage;
        if (Console.Modes.AlternateWriteProc=awCrt)
           then AlternateWriteUnicodeStringProc := @CrtWriteAlternate else
        if (Console.Modes.AlternateWriteProc=awConsole)
           then AlternateWriteUnicodeStringProc := @CrtWriteAlternateConsole;
      end;
    // Append
    fmInOut:
      begin
        t.InOutFunc := @CrtWrite;
        t.FlushFunc := @CrtWrite;
      end;
  else
    Exit;
  end;
  // don't overwrite bufptr provided by SetTextBuf
  if t.BufPtr = nil then
  begin
    t.BufPtr  := @t.Buffer;
    t.BufSize := SizeOf(t.Buffer);
  end;
  // CloseFunc = No Function
  t.CloseFunc := @CrtNoProc;
  // Set Handle
  if t.Mode = fmOutput then
  begin
    if @t = @ErrOutput
       then t.Handle := ConHandleStdErr
       else t.Handle := ConHandleStdOut;
  end else
  begin
    t.Handle := ConHandleStdIn;
  end;
end;

procedure CrtAssign(var t:Text);
begin
  Assign(t,'');
  tTextRec(t).OpenFunc := @CrtOpen;
end;

Function CrtClose(Var t:TTextRec): Integer;
Begin
  T.Mode   := fmClosed;
  if not(CloseHandle(T.Handle)) then Result := GetLastError
                                else Result := 0;
End;

(************************************)
(***** Console-Write-Operations *****)
(************************************)
Procedure WriteXY(x,y:Integer; sString:ShortString; SCP:TCodepage=_Codepage_Dos);
begin
  if (SCP=_Codepage_1252)
     then WriteXY(x,y,Str_CP1252_Unicode(sString))
     else WriteXY(x,y,Str_CP850_Unicode(sString));
end;

Procedure WriteXY(x,y:Integer; TColor:Byte; sString:ShortString; SCP:TCodepage=_Codepage_850); Overload;
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  Textcolor(TColor);
  WriteXY(x,y,sString,SCP);
  TextAttr := SaveAttr;
end;

Procedure WriteXY(x,y:Integer; sString:UTF8String); Overload;
begin
  WriteXY(x,y,UTF8ToString(sString));
end;

Procedure WriteXY(x,y:Integer; TColor:Byte; sString:UTF8String); Overload;
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  Textcolor(TColor);
  WriteXY(x,y,UTF8ToString(sString));
  TextAttr := SaveAttr;
end;

Procedure WriteXY(x,y:Integer; sString:CP850String); Overload;
begin
  WriteXY(x,y,Str_CP850_Unicode(sString));
end;

Procedure WriteXY(x,y:Integer; TColor:Byte; sString:CP850String); Overload;
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  Textcolor(TColor);
  WriteXY(x,y,Str_CP850_Unicode(sString));
  TextAttr := SaveAttr;
end;

Procedure WriteXY(x,y:Integer; uString:UnicodeString);
Var MaxLen : Integer;
begin
  if (uString<>'') then
  begin
    MaxLen := MaxX - X + 1;
    if (MaxLen>0) then
    begin
      TextAttr.SetAttributesV1;
      if (TextAttr.Outline) then
      begin
        TextAttr.Outline := False;
        WriteString(x,y,Copy(uString,1,MaxLen));
        OutlineString(x,y,Min(length(uString),MaxLen));
        TextAttr.Outline := True;
      end else
      begin
        WriteString(x,y,Copy(uString,1,MaxLen));
      end;
      TextAttr.SetAttributesV1;
    end;
  end;
end;

Procedure WriteXY(x,y:Integer; TColor:Byte; uString:UnicodeString);
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  Textcolor(TColor);
  WriteXY(x,y,uString);
  TextAttr := SaveAttr;
end;

Procedure WriteXY(x,y:Integer; aTextAttr:TTextAttr; uString:UnicodeString);
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  TextAttr := aTextAttr;
  WriteXY(x,y,uString);
  TextAttr := SaveAttr;
end;

Procedure WriteXY(x,y:Integer; cString:TConsoleString);
Var MaxLen : Integer;
begin
  if (cString.Len>0) then
  begin
    MaxLen := MaxX - X + 1;
    if (MaxLen>0) then
    begin
      WriteString(x,y,cString.StringCopy(1,MaxLen));
    end;
  end;
end;

procedure WriteChar(x,y: integer; Const ch:AnsiChar);
var numChars                 : integer;
    CharCoord                : TCoord;
    NumWritten               : Longword;
begin
  CharCoord.X := Max(0,x + WindSize.Left - 1);
  CharCoord.Y := Max(0,y + WindSize.Top - 1);
  numChars    := 1;
  NumWritten  := 0;
  FillConsoleOutputAttribute( ConHandleStdOut, TextAttr, numChars
    , CharCoord, NumWritten);
  FillConsoleOutputCharacterA(ConHandleStdOut, ch      , numChars
    , CharCoord, NumWritten);
end;

procedure WriteChar(x,y: integer; Const ch:WideChar);
var numChars                 : integer;
    CharCoord                : coord;
    NumWritten               : longword;
begin
  CharCoord.X := Max(0,x + WindSize.Left - 1);
  CharCoord.Y := Max(0,y + WindSize.Top - 1);
  numChars    := 1;
  NumWritten  := 0;
  FillConsoleOutputAttribute( ConHandleStdOut, TextAttr.Attr, numChars
    , CharCoord, NumWritten);
  FillConsoleOutputCharacterW(ConHandleStdOut, ch      , numChars
    , CharCoord, NumWritten);
end;

procedure WriteChar(x,y: integer; Const ch:Word);
begin
  WriteChar(x,y,WideChar(ch));
end;

Procedure GotoXYConsole(X,Y: Integer);
Var ConCursorPos             : TConsoleWindowPoint;
begin
  // ConCursorPos is Zerobased
  ConCursorPos.x := x-1;
  ConCursorPos.y := y-1;
  Console.CursorPosition := ConCursorPos;
end;

procedure WriteConsole(Const uString:UnicodeString);
var numWritten               : Longword;
    numWrite                 : Longword;
begin
  // Winapi.Windows.WriteConsole uses Console.TextAttr so force TextAttr here
  Console.TextAttr := TextAttr;
  numWrite := Length(uString);
  Winapi.Windows.WriteConsole(ConHandleStdOut, @uString[1], NumWrite, NumWritten, nil);
end;

procedure WritelnConsole(Const uString:UnicodeString); Overload;
begin
  WriteConsole(uString+sLineBreak);
end;

procedure WriteConsole(x,y: integer; Const uString:UnicodeString);
begin
  GotoXYConsole(x,y);
  WriteConsole(uString);
end;

Function CrtWriteAlternateConsole(var t: TTextRec; s: UnicodeString) : Pointer;
begin
  WriteConsole(s);
  Result := @t;
end;

procedure WriteString(x,y: integer; Const sString:ShortString;
            SourceCodepage:TCodepage=_Codepage_850);
begin
  if (SourceCodepage=_Codepage_1252)
     then WriteString(x,y,Str_CP1252_Unicode(sString))
     else WriteString(x,y,Str_CP850_Unicode(sString));
end;

procedure WriteString(Const sString:ShortString;
            SourceCodepage:TCodepage=_Codepage_850);
begin
  WriteString(WhereX,WhereY,sString);
end;

procedure WriteString(x,y: integer; Const aString:AnsiString);
var numWritten               : Longword;
    numWrite                 : Longword;
    posWrite                 : TCOORD;
    aStringLen               : Longword;
    aStringPos               : Longword;
begin
  GotoXY(x,y);
  posWrite.X := CursorPos.X-2;
  posWrite.Y := CursorPos.Y-1;

  numWritten := 0;
  aStringLen := Length(aString);
  aStringPos := 1;
  Repeat
    inc(posWrite.X);
    numWrite := Min(WindSize.Right-CursorPos.X+2,aStringLen+1-aStringPos);

    FillConsoleOutputAttribute(ConHandleStdOut,TextAttr,numWrite,posWrite,numWritten);
    WriteConsoleOutputCharacterA(ConHandleStdOut, @aString[1],numWrite,posWrite,numWritten);
    inc(CursorPos.X,numWrite);
    inc(aStringPos,numWrite);
    if CursorPos.X>WindSize.Right then
    begin
      CursorPos.X := WindSize.Left;
      Inc(CursorPos.Y);
      // If not all characters from aString have been written yet and the
      // last character in the current window has been reached, then scroll
      // up within the current window to be able to fill the last line with
      // the further characters from aString
      if (aStringPos<=aStringLen) then
      begin
        While CursorPos.Y>WindSize.Bottom do
        begin
          DelLine(1);
          Dec(CursorPos.Y);
        end;
        posWrite.X := CursorPos.X-1;
        posWrite.Y := CursorPos.Y-1;
      end else
      // If there are no more characters, place the cursor on the last
      // character in the current window.
      begin
        CursorPos.X := WindSize.Right;
        Dec(CursorPos.Y);
      end;
    end;
  until (aStringPos>aStringLen);
end;

procedure WriteString(Const aString:AnsiString);
begin
  WriteString(WhereX,WhereY,aString);
end;

procedure WriteString(x,y: integer; Const uString:UnicodeString);
begin
  if (x<=WindSize.Width) and (y<=WindSize.Height) then
  begin
    GotoXY(x,y);
    CrtWriteString(uString);
  end;
end;

procedure WriteString(Const uString:UnicodeString);
begin
  CrtWriteString(uString);
end;

procedure WriteString(x,y: integer; Const cString:TConsoleString); Overload;
var numWritten               : Longword;
    numWrite                 : Longword;
    posWrite                 : TCOORD;
    wStringLen               : Longword;
    wStringPos               : Longword;
begin
  if (x<=WindSize.Width) and (y<=WindSize.Height) then
  begin
    GotoXY(x,y);
    if (cString.Len>0) then
    begin
      numWritten := 0;
      wStringLen := cString.Len;
      // FStrChar & FStrAtt are ZeroBased
      wStringPos := 0;
      Repeat
        numWrite := Min(WindSize.Right-CursorPos.X+2,wStringLen-wStringPos);
        // posWrite is ZeroBased
        posWrite.X := CursorPos.X-1;
        posWrite.Y := CursorPos.Y-1;

        WriteConsoleOutputAttribute(ConHandleStdOut,@cString.FStrAttr[wStringPos],numWrite,posWrite,numWritten);
        WriteConsoleOutputCharacterW(ConHandleStdOut,@cString.FStrChar[wStringPos],numWrite,posWrite,numWritten);
        inc(CursorPos.X,numWritten);
        inc(wStringPos,numWritten);
        // if CursorPos.X exceeds WindSize
        if (CursorPos.X>WindSize.Right+1) then
        begin
          // If not all characters from uString have been output yet
          if (wStringPos<wStringLen) then
          begin
            // Set Cursor to Pos1 in next line
            CursorPos.X := WindSize.Left+1;
            Inc(CursorPos.Y);
            // if next line exceeds WindSize
            if (CursorPos.Y>WindSize.Bottom+1) then
            begin
              // Delete Line 1 in window and move all lines 1 up
              DelLine(1);
              // Set Cursor to last line
              Dec(CursorPos.Y);
            end;
          end else
          // if all characters have been output
          begin
            // make sure that the cursor is in the window
            CursorPos.X := Min(CursorPos.x,WindSize.Right+1);
          end;
        end;
      until (wStringPos>=wStringLen);
    end;
  end;
end;

procedure WriteString(Const cString:TConsoleString); Overload;
begin
  WriteString(WhereX,WhereY,cString);
end;

Procedure WritelnString(Const sString:ShortString);
begin
  WriteString(sString+#13+#10);
end;

Procedure WritelnString(Const aString:AnsiString);
begin
  WriteString(aString+sLineBreak);
end;

Procedure WritelnString(Const uString:UnicodeString);
begin
  WriteString(uString+WideChar(#13)+WideChar(#10));
end;

Procedure WritelnString(TColor:Byte; Const uString:UnicodeString);
Var SaveAttr : tTextAttr;
begin
  SaveAttr := TextAttr;
  Textcolor(TColor);
  WritelnString(uString);
  TextAttr := SaveAttr;
end;

Procedure WritelnString(Const cString:TConsoleString);
begin
  WriteString(cString + TConsoleString.Create(sLineBreak));
end;

Function  InvertTextAttr(aTextAttr:TTextAttr) : tTextAttr;
begin
  aTextAttr.InvertColors := not(aTextAttr.InvertColors);
  Result := aTextAttr;
end;

Function  UnderlineTextAttr(aTextAttr:TTextAttr) : tTextAttr;
begin
  aTextAttr.GridBottom := True;
  Result := aTextAttr;
end;

Function  OutlineStartTextAttr(aTextAttr:TTextAttr) : tTextAttr;
begin
  aTextAttr.GridTop    := True;
  aTextAttr.GridLeft   := True;
  aTextAttr.GridBottom := True;
  Result := aTextAttr;
end;

Function  OutlineCenterTextAttr(aTextAttr:TTextAttr) : tTextAttr;
begin
  aTextAttr.GridTop    := True;
  aTextAttr.GridBottom := True;
  Result := aTextAttr;
end;

Function  OutlineEndTextAttr(aTextAttr:TTextAttr) : tTextAttr;
begin
  aTextAttr.GridTop    := True;
  aTextAttr.GridRight  := True;
  aTextAttr.GridBottom := True;
  Result := aTextAttr;
end;

Procedure InvertString(x,y,l:Integer);
Var ConsoleString            : TConsoleString;
    xs                       : Smallint;
begin
  if ((y>=1) and (y<=MaxY)) then
  begin
    if ((x>=1) and (x<=MaxX)) then
    begin
      ConsoleString.Save(y);
      For xs := x to x+l-1 do
      begin
        ConsoleString.Attr[xs] := InvertTextAttr(ConsoleString.Attr[xs]);
      end;
      ConsoleString.Restore(y);
    end;
  end;
end;

Procedure InvertLine(y:Integer);
begin
  InvertString(1,y,MaxX);
end;

Procedure UnderlineString(x,y,l:Integer);
Var ConsoleString            : TConsoleString;
    xs                       : Smallint;
begin
  if ((y>=1) and (y<=MaxY)) then
  begin
    if ((x>=1) and (x<=MaxX)) then
    begin
      ConsoleString.Save(y);
      For xs := x to x+l-1 do
      begin
        ConsoleString.Attr[xs] := UnderlineTextAttr(ConsoleString.Attr[xs]);
      end;
      ConsoleString.Restore(y);
    end;
  end;
end;

Procedure OutlineString(x,y,l:Integer);
Var ConsoleString            : TConsoleString;
    xs                       : Smallint;
begin
  if ((y>=1) and (y<=MaxY)) then
  begin
    if ((x>=1) and (x<=MaxX)) then
    begin
      ConsoleString.Save(y);
      For xs := x to x+l-1 do
      begin
        if (xs=x)     then ConsoleString.Attr[xs] := OutlineStartTextAttr(ConsoleString.Attr[xs]) else
        if (xs=x+l-1) then ConsoleString.Attr[xs] := OutlineEndTextAttr(ConsoleString.Attr[xs])
                      else ConsoleString.Attr[xs] := OutlineCenterTextAttr(ConsoleString.Attr[xs]);
      end;
      ConsoleString.Restore(y);
    end;
  end;
end;

Procedure ColorString(x,y,l:Integer; TextAttr:TTextAttr);
Var ConsoleString            : TConsoleString;
    xs                       : Integer;
begin
  if ((y>=1) and (y<=MaxY)) then
  begin
    if ((x>=1) and (x<=MaxX)) then
    begin
      ConsoleString.Save(y);
      For xs := x to x+l-1 do
      begin
        ConsoleString.Attr[xs] := TextAttr;
      end;
      ConsoleString.Restore(y);
    end;
  end;
end;

Procedure ColorString(x,y,l:Integer; TColor:Byte; BColor:Byte=0);
Var TextAttr : TTextAttr;
begin
  TextAttr.Color(TColor,BColor);
  ColorString(x,y,l,TextAttr);
end;

Procedure ColorLine(y:Integer; TColor:Byte; BColor:Byte=0);
begin
  ColorString(1,y,MaxX,TColor,BColor);
end;

Procedure ReadConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Var ConsoleScreenBuffer:TConsoleScreenBuffer);
Var  dwBufferSize            : TCoord;
     dwBufferCoord           : TCoord;
     lpWriteRegion           : TSmallRect;
     ScreenBufferSize        : Integer;
begin
  ScreenBufferSize := SizeX * SizeY;
  SetLength(ConsoleScreenBuffer,ScreenBufferSize);
  // Size of ConsoleBuffer
  dwBufferSize.X       := SizeX;
  dwBufferSize.Y       := SizeY;
  // Position in the buffer where the data should be stored
  dwBufferCoord.X      := 0;
  dwBufferCoord.y      := 0;
  // Absolute coordinates of the console screen buffer to be read
  lpWriteRegion.Left   := x-1;
  lpWriteRegion.Top    := y-1;
  lpWriteRegion.Right  := lpWriteRegion.Left+SizeX-1;
  lpWriteRegion.Bottom := lpWriteRegion.Top+SizeY-1;
  // Read Rectangular to ConsoleScreen
  if not(ReadConsoleOutputW(ConHandleStdOut,@ConsoleScreenBuffer[0]
       ,dwBufferSize,dwBufferCoord,lpWriteRegion)) then
  begin
    SetLength(ConsoleScreenBuffer,0);
  end;
end;

Procedure WriteConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Var ConsoleScreenBuffer:TConsoleScreenBuffer);
Var  dwBufferSize            : TCoord;
     dwBufferCoord           : TCoord;
     lpWriteRegion           : TSmallRect;
begin
  // ConsoleScreenBuffer must have same size as (SizeX * SizeY)
  if (Length(ConsoleScreenBuffer)=(SizeX*SizeY)) then
  begin
    // Size of ConsoleBuffer
    dwBufferSize.X       := SizeX;
    dwBufferSize.Y       := SizeY;
    // Position in the buffer where the data is to be read
    dwBufferCoord.X      := 0;
    dwBufferCoord.y      := 0;
    // Absolute coordinates of the console screen buffer to be written
    lpWriteRegion.Left   := x-1;
    lpWriteRegion.Top    := y-1;
    lpWriteRegion.Right  := lpWriteRegion.Left+SizeX-1;
    lpWriteRegion.Bottom := lpWriteRegion.Top+SizeY-1;
    // write Rectangular to ConsoleScreen
    WriteConsoleOutputW(ConHandleStdOut,@ConsoleScreenBuffer[0],dwBufferSize
      ,dwBufferCoord,lpWriteRegion);
  end;
end;

Procedure FillConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Const ch:WideChar; Attr:Word=0);
Var  dwBufferSize            : TCoord;
     dwBufferCoord           : TCoord;
     lpWriteRegion           : TSmallRect;
     p                       : Longint;
     aAttr                   : Word;
     ConsoleScreenBuffer     : Array of TCharInfo;
     ScreenBufferSize        : Integer;
begin
  if (Attr>0) then aAttr := Attr else aAttr := TextAttr.Attr;
  ScreenBufferSize := SizeX*SizeY;
  SetLength(ConsoleScreenBuffer,ScreenBufferSize);
  for p := 0 to ScreenBufferSize-1 do
  begin
    ConsoleScreenBuffer[p].UnicodeChar := ch;
    ConsoleScreenBuffer[p].Attributes  := aAttr;
  end;
  dwBufferSize.X := SizeX;
  dwBufferSize.Y := SizeY;
  // Position in the buffer where the data should be written
  dwBufferCoord.X      := 0;
  dwBufferCoord.y      := 0;
  // Absolute coordinates of the console screen buffer to be written
  lpWriteRegion.Left   := x-1;
  lpWriteRegion.Top    := y-1;
  lpWriteRegion.Right  := lpWriteRegion.Left+SizeX-1;
  lpWriteRegion.Bottom := lpWriteRegion.Top+SizeY-1;
  // write Rectangular to ConsoleScreen
  WriteConsoleOutputW(ConHandleStdOut,@ConsoleScreenBuffer[0],dwBufferSize
    ,dwBufferCoord,lpWriteRegion);
end;

Procedure FillConsoleRectangular(x,y:Integer; SizeX,SizeY:Integer;
            Const ch:Word; Attr:Word=0);
begin
  FillConsoleRectangular(x,y,SizeX,SizeY,WideChar(ch),Attr);
end;

Function Keypressed : boolean;
var nevents                  : dword;
    nread                    : dword;
    dw                       : dword;
    buf                      : TINPUTRECORD;
begin
  {$IF Defined(USEVCL) or Defined(USEFMX)}
  Application.ProcessMessages; // Do not freez Application
  {$IFEND}
  Result := False;
  GetNumberOfConsoleInputEvents(ConHandleStdIn,nevents);
  // If ConsoleInputEvents is present
  if (nevents>0) then
  begin
    // Check whether a relevant event is present
    For dw := 1 to nevents do
    begin
      // Read ConsoleInputBuffer, do not clear
      PeekConsoleInputA(ConHandleStdIn,buf,1,nread);
          // Ignore events that do not come from the keyboard
      if (buf.EventType = KEY_EVENT)   and
          // Event must be KeyDown
         (buf.Event.KeyEvent.bKeyDown) and
          // Ignore: SHIFT, ALT, CTRL, CAPITAL, NUMLOCK and Scroll *)
          not(Buf.Event.KeyEvent.wVirtualKeyCode in [VK_SHIFT, VK_MENU,
                  VK_CONTROL, VK_CAPITAL, VK_NUMLOCK, VK_SCROLL]) then
      begin
        Result := True;
        Exit;
      end else
      begin
        // Read ConsoleInputBuffer and clear
        ReadConsoleInputA(ConHandleStdIn,buf,1,nread);
      end;
    end;
  end;
end;

// 3-digits User-ASCII-Code-Input [000..255]
// 4-digits User-Unicode-Input    [0000..FFFF]
Function _AsciiCodeInput : Boolean;
Var CodeInput   : String;
    w           : Word;
    wc          : WideChar;
    Key         : Word;
    x,y         : Integer;
    SaveAttr    : tTextAttr;
begin
  Result      := False;
  RKW_Unicode := 0;
  if (Console.Modes.EnableAsciiCodeInput) then
  begin
    Console.Modes.EnableAsciiCodeInput := False;
    SaveAttr := TextAttr;
    Color(Yellow,Magenta);
    x := WhereX;
    y := WhereY;
    ColorString(x,y,4,Yellow,Magenta);
    CodeInput := '';
    Repeat
      wc := Upcase(Readkey(Key));
      FlushConsoleInputBuffer(ConHandleStdIn);
      if (Key=_BackSpace) and (CodeInput<>'') then
      begin
        CodeInput := Copy(CodeInput,1,length(CodeInput)-1);
      end else
      if ((wc>='0') and (wc<='9')) or
         ((wc>='A') and (wc<='F')) then
      begin
        CodeInput := CodeInput + wc;
      end;
      WriteXY(x,y,'    ');
      WriteXY(x,y,CodeInput);
    Until (length(CodeInput)>=4) or (Key=_Return) or (Key=_ESC);
    if (Key<>_ESC) then
    begin
      if (Length(CodeInput)=4) then
      begin
        RKW_Unicode := StringToInteger('$'+CodeInput);
      end else
      if (Length(CodeInput)=3) then
      begin
        w := StrToInt(CodeInput);
        case Console.InputCodepage of
          _Codepage_437 : RKW_Unicode := Ord(Char_CP437_Unicode(AnsiChar(Lo(w))));
          _Codepage_850 : RKW_Unicode := ord(Char_CP850_Unicode(AnsiChar(Lo(w))));
        else
          RKW_Unicode := Ord(Char_CP1252_Unicode(AnsiChar(Lo(W))));
        end;
      end;
      if (RKW_Unicode>0) then
      begin
        Result := True;
      end;
    end;
    TextAttr := SaveAttr;
    Console.Modes.EnableAsciiCodeInput := True;
  end;
end;

{$IFDEF DEBUG_CONSOLE}
Procedure ShowDebugConsole(Var Buf:TInputRecord);
Var x : Integer;
    aAttr : Word;
    SaveAttr : Word;
begin
  x     := MaxX-20;
  SaveAttr := TextAttr;
  TextAttr := GetTextAttr(x,1);
  WriteXY(x,1,'VKC : $'+Buf.Event.KeyEvent.wVirtualKeyCode.ToHexString+'=#'
    +IntToStringLZ(Buf.Event.KeyEvent.wVirtualKeyCode,5));
  WriteXY(x,2,'VSC : $'+Buf.Event.KeyEvent.wVirtualScanCode.ToHexString+'=#'
    +IntToStringLZ(Buf.Event.KeyEvent.wVirtualScanCode,5));
  WriteXY(x,3,'CKS : $'+Buf.Event.KeyEvent.dwControlKeyState.ToHexString(4)+'=#'
    +IntToStringLZ(Buf.Event.KeyEvent.dwControlKeyState,5));
  WriteXY(x,4,'UCH : '+ord(Buf.Event.KeyEvent.UnicodeChar).ToHexString
    +'="'+Buf.Event.KeyEvent.UnicodeChar+'"');
  WriteXY(x,5,'ACH : '+ord(Buf.Event.KeyEvent.AsciiChar).ToHexString
    +'="'+Buf.Event.KeyEvent.AsciiChar+'"');
  TextAttr := SaveAttr;
end;
{$ENDIF DEBUG_CONSOLE}

Function _ReadKeyWord_Console : boolean;
var nevents,nread            : dword;
    buf                      : TINPUTRECORD;
    {$IFDEF DEBUG_READKEY}
    SaveAttr                 : Byte;
    ShowX                    : Byte;
    ShowY                    : Byte;
    {$ENDIF}
begin
  Result      := FALSE;
  RKW         := $FFFF;
  RKW_Unicode := 0;
  GetNumberOfConsoleInputEvents(ConHandleStdIn,nevents);
  while (nevents>0) and (RKW=$FFFF) do
  begin
    ReadConsoleInputA(ConHandleStdIn,buf,1,nread);
    if buf.EventType = KEY_EVENT then
    begin
      if buf.Event.KeyEvent.bKeyDown then
      begin
        if not(Buf.Event.KeyEvent.wVirtualKeyCode in [VK_SHIFT, VK_MENU, VK_CONTROL,
                 VK_CAPITAL, VK_LWIN, VK_RWIN, VK_APPS, VK_NUMLOCK, VK_SCROLL]) then
        begin
          Result := True;
          RKW := word((buf.Event.KeyEvent.wVirtualScanCode*256)
                      + Ord(buf.Event.KeyEvent.AsciiChar));
          {$IFDEF DEBUG_CONSOLE}
          ShowDebugConsole(Buf);
          {$ENDIF}
          (* Ctrl (Right) & AltGr (Right) *)
          If ((buf.Event.KeyEvent.dwControlKeyState and _CKS_RIGHT_CTRL_PRESSED)>0) and
             ((buf.Event.KeyEvent.dwControlKeyState and _CKS_RIGHT_ALT_PRESSED)>0)  then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_0        .. _VKC_9             : RKW := $CE00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_A        .. _VKC_Z             : RKW := $CE00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_DIVIDE_NumPad : RKW := $CE00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_F1       .. _VKC_F24           : RKW := $CE00 + buf.Event.KeyEvent.wVirtualKeyCode;
            end;
          end else
          (* Ctrl (Left) & Alt (Left) *)
          If ((buf.Event.KeyEvent.dwControlKeyState and _CKS_LEFT_CTRL_PRESSED)>0) and
             ((buf.Event.KeyEvent.dwControlKeyState and _CKS_LEFT_ALT_PRESSED)>0)  then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_TAB                            : RKW := _CTRL_ALT_TAB;
              _VKC_RETURN                         : RKW := _CTRL_ALT_Return;
              _VKC_PLUS                           : RKW := _CTRL_ALT_Plus;
              _VKC_MINUS                          : RKW := _CTRL_ALT_Minus;
              _VKC_0        .. _VKC_9             : RKW := $CD00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_A        .. _VKC_Z             : RKW := $CD00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_DIVIDE_NumPad : RKW := $CD00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_F1       .. _VKC_F24           : RKW := $CD00 + buf.Event.KeyEvent.wVirtualKeyCode;
            end;
          end else
          (* AltGr (Right) *)
          if ((buf.Event.KeyEvent.dwControlKeyState and _CKS_RIGHT_ALT_PRESSED)>0) then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_INSERT                    : RKW := _ALTGR_INSERT;
              _VKC_1                         : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_4        .. _VKC_6        : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_A        .. _VKC_L        : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              // AltGr+M = µ
              _VKC_N        .. _VKC_P        : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              // AltGr+@ = @
              _VKC_R        .. _VKC_Z        : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_9_NumPad : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_PLUS_NumPad               : RKW := _ALTGR_PLUS_NumPad;
              _VKC_MINUS_NumPad              : RKW := _ALTGR_Minus_NumPad;
              _VKC_F1       .. _VKC_F24      : RKW := $5200 + buf.Event.KeyEvent.wVirtualKeyCode;
              // _VKC_Plus -> AltGr++ = ~
              _VKC_Minus                     : RKW := _ALTGR_Minus;
            end;
          end else
          (* Alt (Left) & Shift *)
          if ((buf.Event.KeyEvent.dwControlKeyState and _CKS_LEFT_ALT_PRESSED)>0) and
             ((buf.Event.KeyEvent.dwControlKeyState and _CKS_SHIFT_PRESSED)>0)    then
          begin
            // Do something in future
          end else
          (* Alt (Left) *)
          if ((buf.Event.KeyEvent.dwControlKeyState and _CKS_LEFT_ALT_PRESSED)>0) then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_INSERT                         : RKW := _ALT_Insert;
              _VKC_DELETE                         : RKW := _ALT_Delete;
              _VKC_0        .. _VKC_9             : RKW := $5000 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_A        .. _VKC_Z             : RKW := $5000 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_DIVIDE_NumPad : RKW := $5000 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_F1       .. _VKC_F24           : RKW := $5000 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_Plus                           : RKW := _ALT_PLUS;
              _VKC_Minus                          : RKW := _ALT_Minus;
              _VKC_OEM5 :
                begin
                  _AsciiCodeInput;
                  RKW := 0;
                  Exit;
                end;
            end;
          end else
          (* CTRL (left or right) *)
          if ((buf.Event.KeyEvent.dwControlKeyState and _CKS_LEFT_CTRL_PRESSED)>0)  or
             ((buf.Event.KeyEvent.dwControlKeyState and _CKS_RIGHT_CTRL_PRESSED)>0) then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_TAB                            : RKW := _CTRL_TAB;
              _VKC_RETURN                         : RKW := _CTRL_Return;
              _VKC_SPACE    .. _VKC_DOWN          : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0        .. _VKC_9             : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_A        .. _VKC_Z             : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM1                           : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM3                           : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM7                           : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_DIVIDE_NumPad : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_F1       .. _VKC_F24           : RKW := $4E00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_PLUS                           : RKW := _CTRL_PLUS;
              _VKC_MINUS                          : RKW := _CTRL_MINUS;
            end;
          end else
          (* Shift (Left or Right) *)
          if ((buf.Event.KeyEvent.dwControlKeyState and _CKS_SHIFT_PRESSED)>0)      then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_TAB                       : RKW := _SHIFT_TAB;
              _VKC_RETURN                    : RKW := _SHIFT_RETURN;
              _VKC_INSERT                    : RKW := _SHIFT_INSERT;
              _VKC_DELETE                    : RKW := _SHIFT_DELETE;
              _VKC_A        .. _VKC_Z        : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
                // OEM1=ü | OEM3=ö | OEM7=ä
              _VKC_OEM1                      : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM3                      : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM7                      : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_9_NumPad : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_DIVIDE_NumPad             : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_F1 .. _VKC_F24            : RKW := $4C00 + buf.Event.KeyEvent.wVirtualKeyCode;
            end;
          end else
          (* If enhanced key is pressed, then *)
          If ((buf.Event.KeyEvent.dwControlKeyState and _CKS_ENHANCED_KEY)>0) then
          begin
            (* ignore Windows-Key *)
            if (buf.Event.KeyEvent.wVirtualKeyCode=_VKC_LWin)  and
               (buf.Event.KeyEvent.wVirtualScanCode=_VKC_LWin) then
            begin
              RKW := $FFFF;
            end else
            begin
              case buf.Event.KeyEvent.wVirtualKeyCode of
                _VKC_RETURN                    : RKW := _Return_NumPad;
                _VKC_PgUp .. _VKC_DOWN         : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
                _VKC_INSERT                    : RKW := _INSERT;
                _VKC_DELETE                    : RKW := _DELETE_CRT;
                _VKC_DIVIDE_NumPad             : RKW := _DIVIDE_NumPad;
              end;
            end;
          end else
          (* No enhanced key is pressed *)
          if ((buf.Event.KeyEvent.dwControlKeyState and _CKS_ENHANCED_KEY)=0) then
          begin
            case buf.Event.KeyEvent.wVirtualKeyCode of
              _VKC_BACK                        : RKW := _BackSpace;
              _VKC_TAB                         : RKW := _TAB;
              _VKC_RETURN                      : RKW := _Return;
              _VKC_ESCAPE                      : RKW := _Escape;
              _VKC_SPACE                       : RKW := _Space;
                // NumLock off (0..9) -> Cursor Keys
              _VKC_PgUp .. _VKC_DOWN           : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0        .. _VKC_9          : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_A        .. _VKC_Z          : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
                // OEM1=ü | OEM3=ö | OEM4=ß | OEM7=ä
              _VKC_OEM1                        : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM3                        : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM4                        : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_OEM7                        : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_0_NumPad .. _VKC_9_NumPad   : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
              _VKC_MULTIPLY_NumPad             : RKW := _MULTIPLY_NumPad;
              _VKC_PLUS_NumPad                 : RKW := _PLUS_NumPad;
              _VKC_MINUS_NumPad                : RKW := _MINUS_NumPad;
              _VKC_F1       .. _VKC_F24        : RKW := buf.Event.KeyEvent.wVirtualKeyCode;
            end;
          end;
        end else
        begin
          {$IFDEF DEBUG_CONSOLE}
          ShowDebugConsole(Buf);
          {$ENDIF}
        end;
      end;
    end else
    if (Buf.EventType = _MOUSE_EVENT) then
    begin
      // do something in future
    end else
    if (Buf.EventType = WINDOW_BUFFER_SIZE_EVENT) then
    begin
      // do something in future
    end else
    if (Buf.EventType = FOCUS_EVENT) then
    begin
      {$IFDEF CONSOLEOPACITY}
      if (Console.Modes.AutoOpacityOnFocus) then
      begin
        if (Buf.Event.FocusEvent.bSetFocus)
           then Console.Modes.Opacity := 100
           else Console.Modes.Opacity := 50;
      end;
      {$ENDIF CONSOLEOPACITY}
    end;
    if (RKW=$FFFF) then
    begin
      GetNumberOfConsoleInputEvents(ConHandleStdIn,nevents);
    end;
  end;
end;

(* ReadKeyWord : Returns ASCII code in low byte, scan code in high byte *)
Function _ReadKeyWord : Word;
{$IF Defined(USEVCL) or Defined(USEFMX)}
  Var Count : Integer = 0;
{$IFEND}
begin
  while (not(_ReadKeyWord_Console)) do
  begin
    // If the keyboard memory is empty and "RKW_AutoCrLf",
    // then automatically supply an "Enter".
    if (RKW_AutoCrLf) then
    begin
      RKW := _Return;
      RKW_AutoCrLf := False;
      _ReadKeyWord := RKW;
      Exit;
    end else
    // When a keyboard command comes from a VCL- or FMX-form
    if (RKW_Form<>$FFFF) then
    begin
      RKW := RKW_Form;
      RKW_Form := $FFFF;
      _ReadKeyWord := RKW;
      Exit;
    end else
    begin
      Sleep(5);
      {$IF Defined(USEVCL) or Defined(USEFMX)}
        inc(Count);
        if (Count>=10) then
        begin
          Application.ProcessMessages; // Do not freez Application
          Count := 0;
        end;
      {$IFEND}
    end;
  end;
  Result := RKW;
end;

Function  _RKW_to_Key(Const RKW:Word) : Word;
begin
  Result := RKW; // Return input value if no other has been defined
  Case RKW of
    // Simplify return values by default, if the exact return value is needed
    // e.g. you have to distinguish between CTRL+ALT+0 and CTRL+ALT+0_NumPad,
    // the global variable RKW can be queried directly

    // NumPad -> Normal
    _RETURN_NumPad                   : Result := _RETURN;
    _MINUS_NumPad                    : Result := _Minus;
    _PLUS_NumPad                     : Result := _Plus;
    _0_NumPad      .. _9_NumPad      : Result := _0      + (RKW - _0_NumPad);

    // Ctrl + NumPad -> Ctrl + Normal
    _CTRL_0_NumPad .. _CTRL_9_NumPad : Result := _CTRL_0 + (RKW - _CTRL_0_NumPad);
    _CTRL_PLUS_NumPad                : Result := _CTRL_PLUS;
    _CTRL_MINUS_NumPad               : Result := _CTRL_MINUS;

    // Alt + NumPad -> Alt + Normal
    _ALT_0_NumPad .. _ALT_9_NumPad   : Result := _ALT_0  + (RKW - _ALT_0_NumPad);
    _ALT_PLUS_NumPad                 : Result := _ALT_PLUS;
    _ALT_MINUS_NumPad                : Result := _ALT_MINUS;

    // Ctrl + Alt + NumPad -> Ctrl + Alt + Normal
    _CTRL_ALT_0_NumPad   .. _CTRL_ALT_9_NumPad   : Result := _CTRL_ALT_0    + (RKW - _CTRL_ALT_0_NumPad);
    _CTRL_ALT_Plus_NumPad                        : Result := _CTRL_ALT_Plus;
    _CTRL_ALT_Minus_NumPad                       : Result := _CTRL_ALT_Minus;

    // Ctrl + AltGr + NumPad -> Ctrl + AltGr + Normal
    _CTRL_ALTGR_0_NumPad .. _CTRL_ALTGR_9_NumPad : Result := _CTRL_ALTGR_0  + (RKW - _CTRL_ALTGR_0_NumPad);
    _CTRL_ALTGR_Plus_NumPad                      : Result := _CTRL_ALTGR_Plus;
    _CTRL_ALTGR_Minus_NumPad                     : Result := _CTRL_ALTGR_Minus;
  end;
end;

Function  _RKW_to_AnsiChar(Const RKW:Word) : AnsiChar;

  Function WideToAnsiCH(WS:String; Pos:Integer=1) : AnsiChar;
  Var aString : AnsiString;
  begin
    aString := AnsiString(WS);
    Result  := aString[Pos];
  end;

begin
  if (RKW_Unicode>0) then
  begin
    if (Console.InputCodepage=_Codepage_850)
       then Result := Char_Unicode_CP850(WideChar(RKW_Unicode))
       else Result := Char_Unicode_CP1252(WideChar(RKW_Unicode));
  end else
  begin
    Result := AnsiChar(Lo(RKW));
    case (Hi(RKW)) of
      // Do not provide a character for these keys
      $4E : Result := #0;   // CTRL (left or right)
      $50 : Result := #0;   // ALT (left)
      $CD : Result := #0;   // CTRL (left) + ALT (left)
      $CE : Result := #0;   // CTRL (right) + ALTGR (right)
    else
      case RKW of
        // Do not provide a character for these keys
        _BackSpace           .. _ESC                 : Result := #0;
        _PgUp                .. _DELETE_CRT          : Result := #0;
        _Return_NumPad                               : Result := #0;
        _F1                  .. _F24                 : Result := #0;
        // Provide spezial characters for these keys
                                 // make small letters (a..z)
        _A        .. _Z        : Result := AnsiChar(97 + (RKW-_A));
                                 // make numbers (0..9)
        _0_NumPad .. _9_NumPad : Result := AnsiChar(48 + (RKW-_0_NumPad));
        _MULTIPLY_NumPad : Result := '*';
        _PLUS_NumPad     : Result := '+';
        _MINUS_NumPad    : Result := '-';
        _DIVIDE_NumPad   : Result := '/';
        _ALTGR_1         : if (Console.InputCodepage=_Codepage_850) then Result := #251 else Result := '¹';
        _ALTGR_E         : if (Console.InputCodepage=_Codepage_850) then Result := #128 else Result := '€';
        _ALTGR_C         : if (Console.InputCodepage=_Codepage_850) then Result := #184 else Result := '©';
        _ALTGR_R         : if (Console.InputCodepage=_Codepage_850) then Result := #169 else Result := '®';
      end;
    end;
  end;
end;

Function  _RKW_to_WideChar(Const RKW:Word) : WideChar;
begin
  if (RKW_Unicode>0) then Result := WideChar(RKW_Unicode) else
  begin
    if (Console.InputCodepage=_Codepage_437)
       then Result := Char_CP437_Unicode(AnsiChar(lo(RKW))) else
    if (Console.InputCodepage=_Codepage_850)
       then Result := Char_CP850_Unicode(AnsiChar(lo(RKW)))
       else Result := Char_CP1252_Unicode(AnsiChar(lo(RKW)));
    case (Hi(RKW)) of
      // Do not provide a character for these keys
      $4E : Result := #0;   // CTRL (left or right)
      $50 : Result := #0;   // ALT (left)
      $CD : Result := #0;   // CTRL (left) + ALT (left)
      $CE : Result := #0;   // CTRL (right) + ALTGR (right)
    else
      case RKW of
        // Do not provide a character for these keys
        _BackSpace           .. _ESC                 : Result := #0;
        _PgUp                .. _DELETE_CRT          : Result := #0;
        _Return_NumPad                               : Result := #0;
        _F1                  .. _F24                 : Result := #0;
        _ALTGR_0_NumPad      .. _ALTGR_9_NumPad      : Result := #0;
        // make numbers (0..9)
        _0_NumPad .. _9_NumPad : Result := WideChar(48 + (RKW-_0_NumPad));
        // Provide spezial characters for these keys
        // make small letters
        _A        .. _Z  : Result := WideChar(97 + (RKW-_A));
        _AE              : Result := 'ä';
        _OE              : Result := 'ö';
        _UE              : Result := 'ü';
        _SHIFT_AE        : Result := 'Ä';
        _SHIFT_OE        : Result := 'Ö';
        _SHIFT_UE        : Result := 'Ü';
        _SS              : Result := 'ß';
        _MULTIPLY_NumPad : Result := '*';
        _PLUS_NumPad     : Result := '+';
        _MINUS_NumPad    : Result := '-';
        _DIVIDE_NumPad   : Result := '/';
        _ALTGR_1         : Result := '¹';
        _ALTGR_4         : Result := '⁴';
        _ALTGR_5         : Result := '⁵';
        _ALTGR_6         : Result := '⁶';
        _ALTGR_E         : Result := '€';
        _ALTGR_C         : Result := '©';
        _ALTGR_R         : Result := '®';
        _ALTGR_N         : Result := 'ⁿ';
      end;
    end;
  end;
end;

Procedure _Readkey_Shortcuts(Const Key:Word);
begin
  if (Key=_CTRL_ALT_Plus)  then
  begin
    Console.Font.IncFontSize;
    Console.AutoFitPosition;
  end else
  if (Key=_CTRL_ALT_Minus) then
  begin
    Console.Font.DecFontSize;
  end else
  if (Key>=_CTRL_ALT_0) and (Key<=_CTRL_ALT_9) and (@Proc_CTRL_ALT_0_9<>Nil) then
  begin
    // (Ctrl+Alt+0..9) Set ConsoleWindow to previous saved ConsoleScreenPos
    Proc_CTRL_ALT_0_9(Key-_CTRL_ALT_0);
  end else
  if (Key>=_CTRL_ALTGR_0) and (Key<=_CTRL_ALTGR_9) and (@Proc_CTRL_ALTGR_0_9<>Nil) then
  begin
    // (Strg+Alt+0..9) Save current ConsoleScreenPos
    Proc_CTRL_ALTGR_0_9(Key-_CTRL_ALTGR_0);
  end else
  if ((Key=_CTRL_ALT_L) and (@Proc_CTRL_ALT_L<>Nil)) then Proc_CTRL_ALT_L else
  if ((Key=_CTRL_ALT_M) and (@Proc_CTRL_ALT_M<>Nil)) then Proc_CTRL_ALT_M else
  if ((Key=_CTRL_ALT_N) and (@Proc_CTRL_ALT_N<>Nil)) then Proc_CTRL_ALT_N else
  if ((Key=_CTRL_ALT_O) and (@Proc_CTRL_ALT_O<>Nil)) then Proc_CTRL_ALT_O else
  if ((Key=_CTRL_ALT_P) and (@Proc_CTRL_ALT_P<>Nil)) then Proc_CTRL_ALT_P else
  if ((Key=_CTRL_ALT_Q) and (@Proc_CTRL_ALT_Q<>Nil)) then Proc_CTRL_ALT_Q else
  if ((Key=_CTRL_ALT_R) and (@Proc_CTRL_ALT_R<>Nil)) then Proc_CTRL_ALT_R else
  if ((Key=_CTRL_ALT_S) and (@Proc_CTRL_ALT_S<>Nil)) then Proc_CTRL_ALT_S else
  if ((Key=_CTRL_ALT_T) and (@Proc_CTRL_ALT_T<>Nil)) then Proc_CTRL_ALT_T else
  if ((Key=_CTRL_ALT_U) and (@Proc_CTRL_ALT_U<>Nil)) then Proc_CTRL_ALT_U;
end;

Function  ReadkeyA : AnsiChar;
Var Key : Word;
begin
  Result := ReadkeyA(Key);
end;

Function  ReadkeyA(Var Key:Word; SetCursorPos:Boolean=True) : AnsiChar;
begin
  // Set position of the cursor
  if (SetCursorPos) then
  begin
    Console.SetCursorPosition(CursorPos.x-1,CursorPos.y-1);
  end;
  Repeat
    RKW     := _ReadKeyWord;
    Result  := _RKW_to_AnsiChar(RKW);
    Key     := _RKW_to_Key(RKW);
    LastKey := Key;    // save Value for external use
    // execute shortcut-function if declared
    _Readkey_Shortcuts(Key);
  Until (RKW<>$FFFF);
end;

Function  ReadkeyW : WideChar;
Var Key : Word;
begin
  Result := ReadkeyW(Key);
end;

Function  ReadkeyW(Var Key:Word; SetCursorPos:Boolean=True) : WideChar;
begin
  // Set position of the cursor
  if (SetCursorPos) then
  begin
    Console.SetCursorPosition(CursorPos.x-1,CursorPos.y-1);
  end;
  Repeat
    RKW     := _ReadKeyWord;
    Result  := _RKW_to_WideChar(RKW);
    Key     := _RKW_to_Key(RKW);
    LastKey := Key;  // save value for external use
    // execute shortcut-function if declared
    _Readkey_Shortcuts(LastKey);
  Until (RKW<>$FFFF);
end;

function  Readkey : WideChar; Overload;
begin
  Result := ReadkeyW;
end;

function  Readkey(Var Key:Word) : WideChar; Overload;
begin
  Result := ReadkeyW(Key);
end;

Procedure ReadkeyTimeOut(Var Key:Word; TimeOutSeconds:Integer=10; TimeOutKey:Word=_ESC);
Var StartDateTime : tDateTime;
begin
  if (TimeOutSeconds>0) then
  begin
    Key := TimeOutKey;
    StartDateTime.InitNow;
    Repeat
      if (Keypressed) then
      begin
        Readkey(Key);
        Exit;
      end else
      begin
        Delay(50);
      end;
    Until (StartDateTime.AgeSeconds>=TimeOutSeconds);
  end else Readkey(Key);
end;

Function  ReadkeyYesNoEsc : Word;
Var Key : Word;
begin
  Repeat
    ReadkeyW(Key);
    // J/Y = Yes (German Ja)
    // N   = No  (German Nein)
    if (Key=_J) or (Key=_CTRL_ALT_J) or
       (Key=_Y) or (Key=_CTRL_ALT_Y) then Key := _Yes else
    if (Key=_N) or (Key=_CTRL_ALT_N) then Key := _No;
  Until (Key=_Yes) or (Key=_No) or (Key=_ESC);
  Result := Key;
end;

Function  LastReadKeyChar : WideChar;
begin
  Result := _RKW_to_WideChar(RKW);
end;

// Get current CrtWindow and attribute
Procedure CrtInit;
begin
  // Set current crt.window to Console.Window
  WindSize.SmallRect := Console.WindowRect;
  // Set cursor to the upper left corner
  CursorPos.X := 1;
  CursorPos.Y := 1;
  // Redirect standard output
  CrtAssign(Output);
  Rewrite(Output);
  // Redirect standard input
  CrtAssign(Input);
  Reset(Input);
  // Move ConsoleWindow to startposition
  ConsoleLocationMoveDefaultRegistry;
  // Use Default ColorTable
  Console.UseColorTableDefault;
  // Set Default TextAttribute
  TextAttr := _TextAttr_Default;
end;

begin
  // Activate Console Window
  SetActiveWindow(0);
  // Force ConsoleInit before CrtInit
  if (Console=Nil) then PlyConsoleInit;
  // Init Crt;
  CrtInit;
end.
