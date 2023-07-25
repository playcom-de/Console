(******************************************************************************

  Name          : Ply.Types.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 01.05.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Types;

interface

{$I Ply.Defines.inc}

Uses
  Generics.Collections,
  Winapi.Windows;

Const _Codepage_IBM_PC       = 437;
      _Codepage_437          = 437;
      _Codepage_Latin1       = 819;    (* Latin-1 ISO/ICE 8859-1              *)
      _Codepage_DOS          = 850;    (* Dos_Latin1                          *)
      _Codepage_850          = 850;    (* ALIAS to _Codepage_DOS              *)
      _Codepage_Unicode      = 1200;   (* UnicodeString                       *)
      _Codepage_UTF16_LE     = 1200;   (* ALIAS to _Codepage_Unicode          *)
      _Codepage_UTF16_BE     = 1201;
      _Codepage_1250         = 1250;   (* Central European                    *)
      _Codepage_1251         = 1251;   (* Cyrillic                            *)
      _Codepage_Win          = 1252;   (* US-english                          *)
      _Codepage_1252         = 1252;   (* Western European                    *)
      _Codepage_1253         = 1253;   (* Greek                               *)
      _Codepage_1254         = 1254;   (* Turkish                             *)
      _Codepage_1255         = 1255;   (* Hebrew                              *)
      _Codepage_1256         = 1256;   (* Arabic                              *)
      _Codepage_1257         = 1257;   (* Baltic                              *)
      _Codepage_1258         = 1258;   (* Vietnamese                          *)

      _Codepage_ISO8859_1    = 28591;  (* Latin 1 - Western European          *)
      _Codepage_ISO8859_2    = 28592;  (* Latin-2 - Central European          *)
      _Codepage_ISO8859_3    = 28593;  (* Latin-3 - Southern European         *)
      _Codepage_ISO8859_4    = 28594;  (* Latin-4 - Northern European|Baltic  *)
      _Codepage_ISO8859_5    = 28595;  (* Cyrillic                            *)
      _Codepage_ISO8859_6    = 28596;  (* Arabic                              *)
      _Codepage_ISO8859_7    = 28597;  (* Greek                               *)
      _Codepage_ISO8859_8    = 28598;  (* Hebrew                              *)
      _Codepage_ISO8859_9    = 28599;  (* Latin-5, Turkish                    *)
      _Codepage_ISO8859_15   = 28605;  (* Latin-9, Western European           *)
      _Codepage_UTF7         = 65000;
      _Codepage_UTF8         = 65001;
      _Codepage_RawByte      = 65535;  (* $FFFF                               *)

      _KeyboardLayout_de_DE  = $0407;  (* #1031 - Germany                     *)
      _KeyboardLayout_en_US  = $0409;  (* #1033 - United States               *)
      _KeyboardLayout_de_CH  = $0807;  (* #2055 - Switzerland                 *)
      _KeyboardLayout_en_GB  = $0809;  (* #2057 - Great Britan                *)
      _KeyboardLayout_de_AT  = $0C07;  (* #3079 - Austria                     *)
      _KeyboardLayout_en_AU  = $0C09;  (* #3081 - Australia                   *)
      _KeyboardLayout_de_LU  = $1007;  (* #4103 - Luxemburg                   *)
      _KeyboardLayout_en_CA  = $1009;  (* #4105 - Canada                      *)
      _KeyboardLayout_de_LI  = $1407;  (* #5127 - Liechtenstein               *)
      _KeyboardLayout_en_KH  = $3C09;  (* #15369 - Hong Kong                  *)

Const FM_R        = $00; (* #00 Filemode read only                            *)
      FM_W        = $01; (* #01 Filemode write only                           *)
      FM_RW       = $02; (* #02 Filemode read & write = Standard              *)

      FM_Deny_Dos = $00; (* #00 Compatibility mode, no protection             *)
      FM_Deny_RW  = $10; (* #16 deny read & write (prohibited by others)      *)
      FM_Deny_W   = $20; (* #32 allow read, deny write (by others)            *)
      FM_Deny_R   = $30; (* #48 Does not work, deny read & allow write        *)
      FM_Deny_No  = $40; (* #64 allow read & write (protect by record locking)*)

      fmDenyRW    = FM_RW+FM_Deny_RW; (* $12 = #18 = exclusiv, deny RW        *)
      fmDenyW     = FM_RW+FM_Deny_W;  (* $22 = #34 = exclusiv, deny W         *)
      // nwDenyR  = FM_RW+FM_Deny_R;  (* $32 = #50 = exclusiv, deny R         *)
      fmShareR    = FM_R +FM_Deny_No; (* $40 = #64                            *)
      fmShare     = FM_RW+FM_Deny_No; (* $42 = #66 = standard                 *)

Type AStr3         = String[3];
     AStr4         = String[4];
     AChar3        = Array [0..2] of AnsiChar;
     AChar4        = Array [0..3] of AnsiChar;
     WStr20        = Array [0..19] of WideChar;
     WStr30        = Array [0..29] of WideChar;
     TDynStr       = TArray<WideChar>;
     TDynWord      = TArray<Word>;
     TDynLongword  = Array of Longword;

     UTF8String    = Type AnsiString(_Codepage_UTF8);
     CP437String   = Type AnsiString(_Codepage_437);
     CP850String   = Type AnsiString(_Codepage_850);
     CP1252String  = Type AnsiString(_Codepage_1252);

// WideChar - Unicode-Char - ASCII-Signs
Const _0_low                   = $2080;  (* #8320 ₀                           *)
      _1_low                   = $2081;  (* #8321 ₁                           *)
      _2_low                   = $2082;  (* #8322 ₂                           *)
      _3_low                   = $2083;  (* #8323 ₃                           *)
      _4_low                   = $2084;  (* #8324 ₄                           *)
      _5_low                   = $2085;  (* #8325 ₅                           *)
      _6_low                   = $2086;  (* #8326 ₆                           *)
      _7_low                   = $2087;  (* #8327 ₇                           *)
      _8_low                   = $2088;  (* #8328 ₈                           *)
      _9_low                   = $2089;  (* #8329 ₉                           *)
      _0_high                  = $2070;  (* #8304 ⁰                           *)
      _1_high                  = $00B9;  (* #185  ¹                           *)
      _2_high                  = $00B2;  (* #178  ²                           *)
      _3_high                  = $00B3;  (* #179  ³                           *)
      _4_high                  = $2074;  (* #8308 ⁴                           *)
      _5_high                  = $2075;  (* #8309 ⁵                           *)
      _6_high                  = $2076;  (* #8310 ⁶                           *)
      _7_high                  = $2077;  (* #8311 ⁷                           *)
      _8_high                  = $2078;  (* #8312 ⁸                           *)
      _9_high                  = $2079;  (* #8313 ⁹                           *)
      _i_high                  = $2071;  (* #8305 ⁱ                           *)
      _n_high                  = $207F;  (* #8319 ⁿ                           *)
      _TripplePoint            = $2026;  (* #8230 …                           *)
      _Promill                 = $2030;  (* #8240 ‰                           *)
      _Pound_Sign              = $20A4;  (* #8356 £ Britisch Pound            *)
      _Euro_Sign               = $20AC;  (* #8364 € Euro Sign                 *)
      _Arrow_Left              = $2190;  (* #8592 ←                           *)
      _Arrow_Up                = $2191;  (* #8592 ↑                           *)
      _Arrow_Right             = $2192;  (* #8592 →                           *)
      _Arrow_Down              = $2193;  (* #8592 ↓                           *)
      _NBSP                    = $00A0;  (* #160    Non-breaking space        *)

      _Frame_single_hori       = $2500;  (* #9472 ─                           *)
      _Frame_single_vert       = $2502;  (* #9474 │                           *)
      _Frame_single_corner_tl  = $250C;  (* #9484 ┌                           *)
      _Frane_single_conrer_tr  = $2510;  (* #9488 ┐                           *)
      _Frame_single_corner_bl  = $2514;  (* #9492 └                           *)
      _Frame_single_corner_br  = $2518;  (* #9496 ┘                           *)
      _Frame_single_vert_right = $251C;  (* #9500 ├                           *)
      _Frame_single_vert_left  = $2524;  (* #9508 ┤                           *)
      _Frame_single_hori_down  = $252C;  (* #9516 ┬                           *)
      _Frame_single_hori_up    = $2534;  (* #9524 ┴                           *)
      _Frame_single_cross      = $253C;  (* #9532 ┼                           *)

      _Frame_double_hori       = $2550;  (* #9552 ═                           *)
      _Frame_double_vert       = $2551;  (* #9553 ║                           *)
      _Frame_double_corner_tl  = $2554;  (* #9556 ╔                           *)
      _Frame_double_corner_tr  = $2557;  (* #9559 ╗                           *)
      _Frame_double_corner_bl  = $255A;  (* #9562 ╚                           *)
      _Frame_double_corner_br  = $255D;  (* #9565 ╝                           *)
      _Frame_double_vert_right = $2560;  (* #9568 ╠                           *)
      _Frame_double_vert_left  = $2563;  (* #9571 ╣                           *)
      _Frame_double_hori_down  = $2566;  (* #9574 ╦                           *)
      _Frame_double_hori_up    = $2569;  (* #9577 ╩                           *)
      _Frame_double_cross      = $256C;  (* #9580 ╬                           *)

      _Full_Block              = $2588;  (* #9608 █                           *)

      _Black_Telefon           = $260E;  (* #9742 ☎                          *)
      _Female_Sign             = $2640;  (* #9792 ♀                           *)
      _Male_Sign               = $2642;  (* #9794 ♂                           *)

      _Dingbat_Negative_1      = $2776;  (* #10102 ❶                          *)
      _Dingbat_Negative_2      = $2777;  (* #10102 ❷                          *)
      _Dingbat_Negative_3      = $2778;  (* #10102 ❸                          *)
      _Dingbat_Negative_4      = $2779;  (* #10102 ❹                          *)
      _Dingbat_Negative_5      = $277A;  (* #10102 ❺                          *)
      _Dingbat_Negative_6      = $277B;  (* #10102 ❻                          *)
      _Dingbat_Negative_7      = $277C;  (* #10102 ❼                          *)
      _Dingbat_Negative_8      = $277D;  (* #10102 ❽                          *)
      _Dingbat_Negative_9      = $277E;  (* #10102 ❾                          *)
      _Dingbat_Negative_10     = $277F;  (* #10102 ❿                          *)

      _Fullwidth_A             = $FF21;  (* #65313 Ａ                         *)
      _Fullwidth_B             = $FF22;  (* #65314 Ｂ                         *)
      _Fullwidth_C             = $FF23;  (* #65315 Ｃ                         *)
      _Fullwidth_D             = $FF24;  (* #65316 Ｄ                         *)
      _Fullwidth_E             = $FF25;  (* #65317 Ｅ                         *)
      _Fullwidth_F             = $FF26;  (* #65318 Ｆ                         *)

Const
   // _Inp_CursorPos1 = Place the cursor on the first letter
  _Inp_CursorPos1        = $0100;
   // _Inp_ExitOnKey  = Exit Function "Input" after every key
  _Inp_ExitOnKey         = $0200;
   // _Inp_ClrIfKey   = Clear InputString on first keypressed
  _Inp_ClrIfKey          = $0400;
   // _Inp_InsertMode = Insert characters on cursorpos
  _Inp_InsertMode        = $0800;
   // _Inp_Password   = Input is Password -> Do not show text
  _Inp_Password          = $1000;
  _Inp_Date              = $2000;
  _Inp_Time              = $4000;

Procedure FillWord(Var Dest; Count:Integer; Value:Word);
Procedure FillLongword(Var Dest; Count:Integer; Value:Longword);

Type
  TSortValue              = Int64;
  TPlyBoolean             = Boolean;
  // TCodepage            : ConsoleCodepage (Input / Output)
  TCodepage               = Longword;
  // TKeyboardLayout
  TKeyboardLayout         = Longword;
  // TConHandle           : Standard-Con-Handles
  TConHandle              = Winapi.Windows.THandle;
  // TFileSize
  TFileSize               = Int64;
  // TFileMode
  TFileModeOpen           = Byte;
  TFileModeStatus         = Word;
  // TFileRecSize
  TFileRecSize            = Integer;
  // TFileRecCount
  TFileRecCount           = Integer;
  // TFileAttribute
  TPlyFileAttribute       = Integer;
  // TConsoleScreenPoint  : Coord of Smallint (16-Bit) (Char: Size(X,Y) or Point(X,Y))
  TConsoleWindowPoint     = TSmallPoint;
  // TConsoleScreenRect   : Rect of Smallint (16-Bit) (Char: columns & lines)
  TConsoleWindowRect      = TSmallRect;
  // TConsoleDesktopPoint : Coord of Integer (32-Bit) (Pixel: Pos(X,Y))
  TConsoleDesktopPoint    = TPoint;
  // TConsoleDesktopRect  : Rect of Integer (32-Bit) (Pixel on Desktop)
  TConsoleDesktopRect     = TRect;
  // TConsoleScreenBuffer
  TConsoleScreenBuffer    = Array of TCharInfo;
  // TFilesort
  TFilesort = (NameUp, NameDown, ExtensionUp, ExtensionDown, SizeUp, SizeDown, DateTimeUp,  DateTimeDown);

  TFileSizeHelper = Record Helper for TFileSize
  public
    Function  ToString(Width:Integer=0) : String;
    Function  ToStringReadable(ShowByte:Boolean=True) : String;
  End;

  TPlyBooleanHelper = record helper for TPlyBoolean
  public
    Function ZeroOne: Byte;
    Function ZeroOneChar : WideChar;
    Function YesNo: String;
    Function JaNein: String;
  end;

  TCoordHelper = record helper for TCoord
  public
    Procedure Clr;
    Function  ToString: String;   // "X x Y" e.g. "80 x 25"
    constructor Create(Const X,Y: Smallint); overload;
    constructor Create(Const Value:TCoord); overload;
    procedure Normalize(MinX:Smallint=1; MinY:Smallint=1);
    {$IFDEF DELPHI10UP}
    class operator Equal(Lhs, Rhs: TCoord) : Boolean;
    class operator notEqual(Lhs, Rhs: TCoord) : Boolean;
    {$ENDIF DELPHI10UP}
  end;

  TSmallPointHelper = record helper for TSmallPoint
  public
    procedure Clear;
    Function  IsClear : Boolean;
    Function  ToStringSize: String;   // "X x Y" e.g. "80 x 25"
    Function  ToStringPos: String;    // "X | Y" e.g. "10 | 5"
    Procedure Normalize(Const MinX:Smallint=1; MinY:Smallint=1); Overload;
    Procedure Normalize(Const MinSize:TSmallPoint); Overload;
  end;

  TSmallRectHelper = record helper for TSmallRect
  private
    Function  GetWidth : Smallint;
    Procedure SetWidth(Const Value: Smallint);
    Function  GetHeight : Smallint;
    Procedure SetHeight(Const Value: Smallint);
    Function  GetSize : TSmallPoint;
    Function  GetTopLeft : TSmallPoint;
    Procedure SetTopLeft(Value: TSmallPoint);
    Function  GetBottomRight : TSmallPoint;
    Procedure SetBottomRight(Value: TSmallPoint);
  public
    Function ToStringRect: String;
    Function ToStringPos: String;   // Top | Left
    Function ToStringSize: String;  // Width x Height
    constructor Create(const Left, Top, Right, Bottom: SmallInt); overload;
    constructor Create(Const Width,Height: Smallint); overload;       // rect with Top=0 and Left=0
    constructor Create(Const Size:TSmallPoint); overload;             // rect with Top=0 and Left=0
    constructor Create(Const Rect:TSmallRect; Normalize: Boolean = False); overload;              // copy rect
    constructor Create(const Origin: TCoord; Width, Height: Smallint); overload; // at TPoint of origin with width and height
    constructor Create(const P1, P2: TCoord; Normalize: Boolean = False); overload;  // with corners specified by p1 and p2
    {$IFDEF DELPHI10UP}
    class operator Equal(Lhs, Rhs: TSmallRect) : Boolean;
    class operator NotEqual(Lhs, Rhs: TSmallRect) : Boolean;
    {$ENDIF DELPHI10UP}
    procedure NormalizeRect;
    Property Width       : Smallint    Read GetWidth       Write SetWidth;
    Property Height      : Smallint    Read GetHeight      Write SetHeight;
    Property Size        : TSmallPoint Read GetSize;
    Property TopLeft     : TSmallPoint Read GetTopLeft     Write SetTopLeft;
    Property BottomRight : TSmallPoint Read GetBottomRight Write SetBottomRight;
  end;

  {$IFDEF DELPHIXE8DOWN}
  Function TSmallRectEqual(Lhs, Rhs: TSmallRect) : Boolean;
  {$ENDIF DELPHIXE8DOWN}

Type
  TPointHelper = record helper for TPoint
  private
  public
    procedure MaximizeToZero;
    procedure Init(ValueX,ValueY: Longint);
    function ToStringSize: String;
  end;

  TRectHelper = record helper for TRect
  private
  public
    Procedure Clear;
    // Moves the window if it extends beyond the limits of the screen
    // Returns true if the window was moved
    Function  FitScreen(Const WorkArea:TRect) : Boolean;
    // TextPositionSize (Left|Top|Width|Height in Pixel)
    // e.g. "  10 |   10, Size :  800 x  400"
    Function  ToStringPosSize : String;
    // ToStringRect (Left|Top|Right|Bottom in Pixel)
    // e.g. " 100 | 100 x  900 |  500"
    function  ToStringRect: String;
    // ToStringPos: e.g. " 800 |  400"
    function  ToStringPos: String;
    // ToStringSize (Width|Height in Pixel): e.g. " 800 x  400"
    function  ToStringSize: String;
  end;

  // Coordinates from current Window on Screen within the Consol-Window
  // Zero-Base-Values : (0,0,79,24) for Standardsize
  TPlyConWinSize = record
  private
    Function  GetWidth : Smallint;
    Procedure SetWidth(Const Value:SmallInt);
    Function  GetHeight : Smallint;
    Procedure SetHeight(Const Value:SmallInt);
    Function  GetWindMin : Word;
    Procedure SetWindMin(Const Value:Word);
    Function  GetWindMax : Word;
    Procedure SetWindMax(Const Value:Word);
  public
    Procedure Clear;
    Function ToStringRect : String;
    Function ToStringSize : String;
    Property Width   : Smallint Read GetWidth   Write SetWidth;
    Property Height  : Smallint Read GetHeight  Write SetHeight;
    Property WindMin : Word     Read GetWindMin Write SetWindMin;
    Property WindMax : Word     Read GetWindMax Write SetWindMax;
  case Integer of
    0: (Left, Top,  Right, Bottom: Smallint);
    1: (MinX, MinY, MaxX,  MaxY  : Smallint);
    2: (TopLeft, BottomRight: TConsoleWindowPoint);
    3: (SmallRect:TConsoleWindowRect);
  end;

Type TBooleanList = TList<Boolean>;
Type TIntegerList = TList<Integer>;

{$IFDEF DELPHI10UP}
Type TBooleanListHelper = Class Helper for TBooleanList
     public
       Function  ToString : String;
     end;
{$ENDIF}

Type TIntegerListHelper = Class Helper for TIntegerList
     public
       Procedure AddIfnotExists(Const Value:Integer);
       {$IFDEF DELPHI10UP}
       Function  ToString : String;
       {$ENDIF DELPHI10UP}
     end;

Const BitValue08 : Array [0..7]  of Byte = (1,2,4,8,16,32,64,128);
Const BitValue32 : Array [0..31] of Cardinal =
        (       $1,       $2,       $4,       $8,
               $10,      $20,      $40,      $80,
              $100,     $200,     $400,     $800,
             $1000,    $2000,    $4000,    $8000,
            $10000,   $20000,   $40000,   $80000,
           $100000,  $200000,  $400000,  $800000,
          $1000000, $2000000, $4000000, $8000000,
         $10000000,$20000000,$40000000,$80000000);

Type TBoolean32 = Record
     private
       Procedure SetBool32(Index:Byte; Value:Boolean);
       Function  GetBool32(Index:Byte) : Boolean;
     public
       Procedure Clear;
       property Bools[Index: Byte]: Boolean Read GetBool32 Write SetBool32; default;
     case Cardinal of
       0: (FValue: Cardinal);
       1: (FByte: Array [0..3] of Byte);
     end;

Const PlyBoolSize : Cardinal = 32;

Type TPlyBoolList = Class(TObject)
     Private
       FItems : Array of TBoolean32;   //UInt32
       FCount : Int64;
       Procedure SetItem(Index:Int64; Value:Boolean);
       Function  GetItem(Index:Int64) : Boolean;
       Procedure SetCount(Index:Int64);
       Function  GetCountTrue : Int64;
     Public
       property Items[Index: Int64]: Boolean read GetItem write SetItem; default;
       property Count: Int64 read FCount write SetCount;
       property CountTrue: Int64 read GetCountTrue;
       constructor Create; overload;
       constructor Create(const CountBools:Cardinal; DefaultValue:Boolean=False); overload;
       destructor Destroy; override;
       Procedure Add(Const Value:Boolean); overload;
       Procedure Add(CountBools:Cardinal; Const Value:Boolean); overload;
       Function MemorySizeByte : Cardinal;
       Function ToStringNumberTrue : String;
       Function ToStringNumberFalse : String;
       Function ToStringBooleans : String;
     End;

type TAppender<T> = class
       class procedure Append(var Arr: TArray<T>; Value: T);
     end;

Var PlyCompanyName : String = 'Playcom';
    PlyAppName : String = '';

implementation

Uses
  Ply.Math,
  Ply.StrUtils,
  System.Math,
  System.SysUtils;

Procedure FillWord(Var Dest; Count:Integer; Value:Word);
Var DynWord : TDynWord;
begin
  SetLength(DynWord,count);
  while Count > 0 do
  begin
    Dec(Count);
    DynWord[Count] := Value;
  end;
  Move(DynWord[0],Dest,2*Count);
end;

Procedure FillLongword(Var Dest; Count:Integer; Value:Longword);
Var DynLongword : TDynLongword;
begin
  SetLength(DynLongword,count);
  while Count > 0 do
  begin
    Dec(Count);
    DynLongword[Count] := Value;
  end;
  Move(DynLongword[0],Dest,4*Count);
end;

(***************************)
(***** TFileSizeHelper *****)
(***************************)
Function  TFileSizeHelper.ToString(Width:Integer=0) : String;
var
  FSize: Int64;
  aString: String;
  UnitSize: String;
begin
  FSize := Self;
  UnitSize := '';
  aString := IntToString(FSize)+UnitSize;
  Repeat
    if (Length(aString)<=Width) then
    begin
      Break;
    end else
    begin
      FSize := Round(FSize / 1024);
      if (UnitSize=''   ) then UnitSize := ' KB' else
      if (UnitSize=' KB') then UnitSize := ' MB' else
      if (UnitSize=' MB') then UnitSize := ' GB'
                          else UnitSize := ' TB';
      aString := IntToString(FSize)+UnitSize;
    end;
  until (UnitSize=' TB');
  Result := StringAlignRight(width,aString);
end;

Function  TFileSizeHelper.ToStringReadable(ShowByte:Boolean=True) : String;
var
  FSize: Int64;
  UnitSize : Integer;

Const UnitSizeText : Array [1..5] of String = ('Byte','KByte','MByte','GByte','TByte');

begin
  FSize := Self;
  UnitSize := 1;
  while (FSize>100000) and (UnitSize<5) do
  begin
    FSize := Round(FSize / 1024);
    inc(UnitSize);
  end;
  if not(ShowByte) and (UnitSize=1)
     then Result := ''
     else Result := IntToString(FSize,0,'.')+' '+UnitSizeText[UnitSize];
end;

(**************************)
(***** TBooleanHelper *****)
(**************************)
function TPlyBooleanHelper.JaNein: String;
begin
  if (Self=True) then Result := 'Ja' else Result := 'Nein';
end;

function TPlyBooleanHelper.YesNo: String;
begin
  if (Self=True) then Result := 'Yes' else Result := 'No';
end;

function TPlyBooleanHelper.ZeroOne: Byte;
begin
  if (Self=True) then Result := 1 else Result := 0;
end;

Function TPlyBooleanHelper.ZeroOneChar : WideChar;
begin
  if (Self=True) then Result := '1' else Result := '0';
end;

(************************)
(***** TCoordHelper *****)
(************************)
Procedure TCoordHelper.Clr;
begin
  X := 0;
  Y := 0;
end;

Function  TCoordHelper.ToString: String;   // "X x Y" | "80 x 25"
begin
  Result := X.ToString + ' x ' + Y.ToString;
end;

constructor TCoordHelper.Create(Const X,Y: Smallint);
begin
  Self.X := X;
  Self.Y := Y;
end;

constructor TCoordHelper.Create(Const Value:TCoord);
begin
  Self := Value;
end;

procedure TCoordHelper.Normalize(MinX:Smallint=1; MinY:Smallint=1);
begin
  X := Max(X,MinX);
  Y := Max(Y,MinY);
end;

{$IFDEF DELPHI10UP}
class operator TCoordHelper.equal(Lhs, Rhs: TCoord) : Boolean;
begin
  Result := (Lhs.X = Rhs.X) and (Lhs.Y = Rhs.Y);
end;

class operator TCoordHelper.notEqual(Lhs, Rhs: TCoord) : Boolean;
begin
  Result := Not(Lhs = Rhs);
end;
{$ENDIF DELPHI10UP}

(*****************************)
(***** TSmallPointHelper *****)
(*****************************)
procedure TSmallPointHelper.Clear;
begin
  X := 0;
  Y := 0;
end;

Function  TSmallPointHelper.IsClear : Boolean;
begin
  if (X=0) or (Y=0) then Result := True
                    else Result := False;
end;

// "X x Y" e.g. "80 x 25"
Function  TSmallPointHelper.ToStringSize: String;
begin
  Result := Format('%4d',[x])    +' x '
          + Format('%4d',[y]);
end;

// "x|y"   e.g. "10|5"
Function  TSmallPointHelper.ToStringPos: String;
begin
  Result := Format('%1d',[x])    +' | '
          + Format('%1d',[y]);
end;

procedure TSmallPointHelper.Normalize(Const MinX:Smallint=1; MinY:Smallint=1);
begin
  X := Max(X,MinX);
  Y := Max(Y,MinY);
end;

Procedure TSmallPointHelper.Normalize(Const MinSize:TSmallPoint);
begin
  Normalize(MinSize.x, MinSize.y);
end;

(****************************)
(***** TSmallRectHelper *****)
(****************************)
Function TSmallRectHelper.GetWidth : Smallint;
begin
  Result := Right - Left + 1;
end;

Procedure TSmallRectHelper.SetWidth(Const Value: Smallint);
begin
  if (Value>=1) then Right := Left + Value;
end;

Function TSmallRectHelper.GetHeight : Smallint;
begin
  Result := Bottom - Top + 1;
end;

Procedure TSmallRectHelper.SetHeight(const Value: SmallInt);
begin
  if (Value>=1) then Bottom := Top + Value;
end;

Function TSmallRectHelper.GetSize : TSmallPoint;
begin
  Result.X := Width;
  Result.y := Height;
end;

Function TSmallRectHelper.GetTopLeft : TSmallPoint;
begin
  Result.X := Left;
  Result.Y := Top;
end;

Procedure TSmallRectHelper.SetTopLeft(Value: TSmallPoint);
begin
  Left := Value.X;
  Top  := Value.Y;
end;

Function TSmallRectHelper.GetBottomRight : TSmallPoint;
begin
  Result.X := Right;
  Result.Y := Bottom;
end;

Procedure TSmallRectHelper.SetBottomRight(Value: TSmallPoint);
begin
  Right  := Value.X;
  Bottom := Value.Y;
end;

Function TSmallRectHelper.ToStringRect: String;
begin
  Result := Format('%4d',[Left])   +' | '
          + Format('%4d',[Top])    +' x '
          + Format('%4d',[Right])  +' | '
          + Format('%4d',[Bottom]);
end;

Function TSmallRectHelper.ToStringPos: String;
begin
  Result := Format('%4d',[Top])    +' | '
          + Format('%4d',[Left]);
end;

Function TSmallRectHelper.ToStringSize: String;
begin
  Result := Format('%4d',[Width])    +' x '
          + Format('%4d',[Height]);
end;

constructor TSmallRectHelper.Create(const Left, Top, Right, Bottom: SmallInt);
begin
  Self.Left  := Left;
  Self.Top   := Top;
  Self.Right := Right;
  Self.Bottom:= Bottom;
end;

constructor TSmallRectHelper.Create(Const Width,Height: Smallint);
begin
  Self.Left   := 0;
  Self.Top    := 0;
  Self.Right  := Max(0,Width-1);
  Self.Bottom := Max(0,Height-1);
end;

constructor TSmallRectHelper.Create(Const Size:TSmallPoint);
begin
  Create(Size.X, Size.Y);
end;

constructor TSmallRectHelper.Create(Const Rect:TSmallRect; Normalize: Boolean);
begin
  Self := Rect;
  if Normalize then Self.NormalizeRect;
end;

constructor TSmallRectHelper.Create(const Origin: TCoord; Width, Height: SmallInt);
begin
  Create(Origin.X, Origin.Y, Origin.X + Width, Origin.Y + Height);
end;

constructor TSmallRectHelper.Create(const P1, P2: TCoord; Normalize: Boolean);
begin
  Self.Left   := P1.X;
  Self.Top    := P1.Y;
  Self.Right  := P2.X;
  Self.Bottom := P2.Y;
  if Normalize then Self.NormalizeRect;
end;

{$IFDEF DELPHI10UP}
class operator TSmallRectHelper.equal(Lhs, Rhs: TSmallRect) : Boolean;
begin
  Result := (Lhs.Left  = Rhs.Left)  and (Lhs.Top    = Rhs.Top)  and
            (Lhs.Right = Rhs.Right) and (Lhs.Bottom = Rhs.Bottom);
end;

class operator TSmallRectHelper.notEqual(Lhs, Rhs: TSmallRect) : Boolean;
begin
  Result := Not(Lhs = Rhs);
end;
{$ENDIF DELPHI10UP}

procedure TSmallRectHelper.NormalizeRect;
begin
  if Top > Bottom then
  begin
    Top    := Top xor Bottom;
    Bottom := Top xor Bottom;
    Top    := Top xor Bottom;
  end;
  if Left > Right then
  begin
    Left  := Left xor Right;
    Right := Left xor Right;
    Left  := Left xor Right;
  end
end;

{$IFDEF DELPHIXE8DOWN}
  Function TSmallRectEqual(Lhs, Rhs: TSmallRect) : Boolean;
  begin
    Result := (Lhs.Left  = Rhs.Left)  and (Lhs.Top    = Rhs.Top)  and
              (Lhs.Right = Rhs.Right) and (Lhs.Bottom = Rhs.Bottom);
  end;
{$ENDIF DELPHIXE8DOWN}

(************************)
(***** TPointHelper *****)
(************************)
procedure TPointHelper.MaximizeToZero;
begin
  X := Max(X,0);
  Y := Max(Y,0);
end;

procedure TPointHelper.Init(ValueX,ValueY: Longint);
begin
  X := ValueX;
  Y := ValueY;
end;

Function  TPointHelper.ToStringSize : String;
begin
  Result := Format('%4d',[x])    +' x '
          + Format('%4d',[y]);
end;

(***********************)
(***** TRectHelper *****)
(***********************)
Procedure TRectHelper.Clear;
begin
  FillChar(Self,sizeof(self),#0);
end;

Function  TRectHelper.FitScreen(const WorkArea: TRect) : Boolean;
Var NewRect : TConsoleDesktopRect;
begin
  // NewLeft = Min.WorkArea.Left & (Max.WorkArea.Right-Width)
  NewRect.Left := ValueMinMax(Left             // DefaultValue
                    ,WorkArea.Left             // MinValue
                    ,(WorkArea.Right-Width));  // MaxValue
  // NewTop = Min.Workarea.Top & (Max.Workarea.Bottom - Height)
  NewRect.Top  := ValueMinMax(Top               // DefaultValue
                    ,WorkArea.Top               // MinValue
                    ,(WorkArea.Bottom-Height)); // MaxValue
  // NewSize = OldSize (width & height)
  NewRect.Size := Size;
  if (Self <> NewRect) then
  begin
    Result := True;
    Self   := NewRect;
  end else
  begin
    Result := False;
  end;
end;

// ToStringPosSize: e.g. "  10 |   10, Size :  800 x  400"
function  TRectHelper.ToStringPosSize: String;
begin
  Result := Format('%4d',[Left])   +' | '
          + Format('%4d',[Top])    +', Size : '
          + Format('%4d',[Width])  +' x '
          + Format('%4d',[Height]);
end;

// TextRec: e.g. " 100 | 100 x  900 |  500"
function  TRectHelper.ToStringRect: String;
begin
  Result := Format('%4d',[Left])   +' | '
          + Format('%4d',[Top])    +' x '
          + Format('%4d',[Right])  +' | '
          + Format('%4d',[Bottom]);
end;

// ToStringPos: e.g. " 800 |  400"
function  TRectHelper.ToStringPos: String;
begin
  Result := Format('%4d',[Left])    +' | '
          + Format('%4d',[Top]);
end;

// ToStringSize: e.g. " 800 x  400"
function  TRectHelper.ToStringSize: String;
begin
  Result := Format('%4d',[Width])    +' x '
          + Format('%4d',[Height]);
end;

(**************************)
(***** TPlyConWinSize *****)
(**************************)
Function TPlyConWinSize.GetWidth : Smallint;
begin
  Result := Right - Left + 1;
end;

Procedure TPlyConWinSize.SetWidth(Const Value:SmallInt);
begin
  Left := Right + Value;
end;

Function TPlyConWinSize.GetHeight : Smallint;
begin
  Result := Bottom - Top + 1;
end;

Procedure TPlyConWinSize.SetHeight(const Value: SmallInt);
begin
  Bottom := Top + Value;
end;

Function TPlyConWinSize.GetWindMin : Word;
begin
  Result := (Top shl 8) + Left;
end;

Procedure TPlyConWinSize.SetWindMin(Const Value:Word);
begin
  Left   := Lo(Value);
  Top    := Hi(Value);
end;

Function TPlyConWinSize.GetWindMax : Word;
begin
  Result := (Bottom Shl 8) + (Right);
end;

Procedure TPlyConWinSize.SetWindMax(Const Value:Word);
begin
  Right   := Lo(Value);
  Bottom  := Hi(Value);
end;

Procedure TPlyConWinSize.Clear;
begin
  FillChar(Self,sizeof(Self),#0);
end;

Function TPlyConWinSize.ToStringRect : String;
begin
  Result := SmallRect.ToStringRect;
end;

Function TPlyConWinSize.ToStringSize : String;
begin
  Result := SmallRect.ToStringSize;
end;

{$IFDEF DELPHI10UP}
(******************************)
(***** TBooleanListHelper *****)
(******************************)
Function  TBooleanListHelper.ToString: string;
Var Help : String;
    i    : Integer;
begin
  Help := '[';
  for i := 0 to Count-1 do
  begin
    if (Items[i]) then
    begin
      Help := Help + i.ToString + ', ';
    end;
  end;
  if (Help[length(Help)]=' ') then
  begin
    SetLength(Help,length(Help)-2);
  end;
  Help := Help + ']';
  Result := Help;
end;
{$ENDIF DELPHI10UP}

(******************************)
(***** TIntegerListHelper *****)
(******************************)
Procedure TIntegerListHelper.AddIfNotExists(Const Value:Integer);
begin
  if (IndexOf(Value)=-1) then Add(Value);
end;

{$IFDEF DELPHI10UP}
Function  TIntegerListHelper.ToString : String;
Var
  i : Integer;
begin
  Result := '[';
  for i := 0 to Count-1 do
  begin
    Result := Result + Items[i].ToString;
    if (i<Count-1) then Result := Result + ', ';
  end;
  Result := Result + ']';
end;
{$ENDIF DELPHI10UP}

(**********************)
(***** TBoolean32 *****)
(**********************)
Procedure TBoolean32.SetBool32(Index:Byte; Value:Boolean);
begin
  if (Index<=31) then
  begin
    if (Value) then
    begin
      // Set Boolean to True
      FValue := FValue or BitValue32[Index];
    end else
    begin
      // Set Boolean to False
      FValue := FValue and not(BitValue32[Index]);
    end;
  end;
end;

Function  TBoolean32.GetBool32(Index:Byte) : Boolean;
begin
  if (Index<=31)
     then Result := (FValue and BitValue32[Index]) = BitValue32[Index]
     else Result := False;
end;

Procedure TBoolean32.Clear;
begin
  FValue := 0;
end;

(************************)
(***** TPlyBoolList *****)
(************************)
constructor TPlyBoolList.Create;
begin
  inherited Create;
  SetLength(FItems,0);
  FCount := 0;
end;

constructor TPlyBoolList.Create(const CountBools:Cardinal; DefaultValue:Boolean=False);
var
  i : Cardinal;
begin
  inherited Create;
  SetLength(FItems,(CountBools div PlyBoolSize)+1);
  for i := 0 to length(FItems)-1 do
  begin
    if DefaultValue
       then FItems[i].FValue := $FFFFFFFF  // Set 32 Booleans to True
       else FItems[i].FValue := $0;        // Set 32 Booleans to False
  end;
  FCount := CountBools;
end;

destructor TPlyBoolList.Destroy;
begin
  SetLength(FItems,0);
  FCount := 0;
  inherited Destroy;
end;

Procedure TPlyBoolList.SetItem(Index:Int64; Value:Boolean);
begin
  if (Index<FCount) then
  begin
    FItems[Index div PlyBoolSize].Bools[Index mod PlyBoolSize] := Value;
  end;
end;

Function  TPlyBoolList.GetItem(Index:Int64) : Boolean;
begin
  if (Index<FCount) then
  begin
    Result := FItems[Index div PlyBoolSize].Bools[Index mod PlyBoolSize];
  end else Result := False;
end;

Procedure TPlyBoolList.SetCount(Index:Int64);
begin
  if (Index > FCount) then
  begin
    Add(Index-FCount,False);
  end else
  if (Index < FCount) then
  begin
    SetLength(FItems, (Index div PlyBoolSize)+1);
    FCount := Index;
  end;
end;

Function  TPlyBoolList.GetCountTrue : Int64;
Var
  iCount: Int64;
  {$IFDEF DELPHI10UP}
  i: Int64;
  {$ELSE}
  i : Longint;
  {$ENDIF DELPHI10UP}
begin
  iCount := 0;
  for I := 0 to FCount-1 do
  begin
    if (Items[i]) then inc(iCount);
  end;
  Result := iCount;
end;

Procedure TPlyBoolList.Add(Const Value:Boolean);
begin
  if ((FCount div PlyBoolSize)>=length(FItems)) then
  begin
    // Add 32 new Booleans
    SetLength(FItems,length(FItems)+1);
    // Set 32 new Booleans to False
    FItems[length(FItems)-1].FValue := $0;
  end;
  FItems[FCount div PlyBoolSize].Bools[FCount mod PlyBoolSize] := Value;
  inc(FCount);
end;

Procedure TPlyBoolList.Add(CountBools:Cardinal; Const Value:Boolean);
Var NewCount : Cardinal;
begin
  NewCount := FCount + CountBools;
  // Fill existing Booleans with Value
  while (FCount < NewCount) and
        (FCount div PlyBoolsize <= length(FItems)-1) do
  begin
    FItems[FCount div PlyBoolSize].Bools[FCount mod PlyBoolSize] := Value;
    inc(FCount);
  end;
  while (FCount < NewCount) do
  begin
    // Add 32 new Booleans
    SetLength(FItems,length(FItems)+1);
    // Fill 32 new Bolleans with Value
    if (Value)
       then FItems[length(FItems)-1].FValue := $FFFFFFFF
       else FItems[length(FItems)-1].FValue := $0;
    // Set new FCount
    FCount := Min(FCount+32,NewCount);
  end;
end;

Function TPlyBoolList.MemorySizeByte : Cardinal;
begin
  Result := Length(FItems) * 4;
end;

Function TPlyBoolList.ToStringNumberTrue : String;
Var
  Help: String;
  I: Integer;
  First: Boolean;
begin
  First := True;
  Help := '[';
  for I := 0 to Count-1 do
  begin
    if (Items[i]) then
    begin
      if (First) then
      begin
        Help := Help + i.ToString;
        First := False;
      end else Help := Help + ', ' + i.ToString;
    end;
  end;
  Help := Help + ']';
  Result := Help;
end;

Function TPlyBoolList.ToStringNumberFalse : String;
Var
  Help: String;
  I: Integer;
  First: Boolean;
begin
  First := True;
  Help := '[';
  for I := 0 to Count-1 do
  begin
    if not(Items[i]) then
    begin
      if (First) then
      begin
        Help := Help + i.ToString;
        First := False;
      end else Help := Help + ', ' + i.ToString;
    end;
  end;
  Help := Help + ']';
  Result := Help;
end;

Function TPlyBoolList.ToStringBooleans : String;
Var
  Help: String;
  I: Integer;
  First: Boolean;
begin
  First := True;
  Help := '[';
  for I := 0 to Count-1 do
  begin
    if (First) then
    begin
      Help := Help + Items[i].ZeroOne.ToString;
      First := False;
    end else Help := Help + ', ' + Items[i].ZeroOne.ToString;
  end;
  Help := Help + ']';
  Result := Help;
end;

(*********************)
(***** TAppender *****)
(*********************)
class procedure TAppender<T>.Append(var Arr: TArray<T>; Value: T);
begin
  SetLength(Arr, Length(Arr)+1);
  Arr[High(Arr)] := Value;
end;

end.
