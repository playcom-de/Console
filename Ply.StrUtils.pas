(******************************************************************************

  Name          : Ply.StrUtils.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 20.06.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.StrUtils;

interface

{$I Ply.Defines.inc}

Uses
  Ply.Types,
  System.Classes,
  System.SysUtils;

Function  PosRight(SubStr, sString: ShortString) : Integer; Overload;
Function  PosRight(SubStr, uString: UnicodeString) : Integer; Overload;
Function  StrCountChar(ch:Char; Help:String) : Longword;
Function  StrGetNumbers(Help:String) : String;
Function  ValidateEmail(Const aEmail: string): Boolean;
Function  ValidateDate(Const aDate: String) : Boolean;

Function  StringCopyRight(sString:ShortString; Count:Integer) : ShortString; Overload;
Function  StringCopyRight(aString:RawByteString; Count:Integer) : RawByteString; Overload;
Function  StringCopyRight(uString:UnicodeString; Count:Integer) : UnicodeString; Overload;

Function  StringAlignLeft(Count:Integer; sString:ShortString; ch:AnsiChar=' ';
            Cut:Boolean=False) : ShortString; Overload;
Function  StringAlignLeft(Count:Integer; aString:RawByteString; ch:AnsiChar=' ';
            Cut:Boolean=False) : RawByteString; Overload;
Function  StringAlignLeft(Count:Integer; uString:UnicodeString; ch:WideChar=' ';
            Cut:Boolean=False) : UnicodeString; Overload;

Function  StringAlignRight(Count:Integer; sString:ShortString; ch:AnsiChar=' ';
            Cut:Boolean=False) : ShortString; Overload;
Function  StringAlignRight(Count:Integer; aString:RawByteString; ch:AnsiChar=' ';
            Cut:Boolean=False) : RawByteString; Overload;
Function  StringAlignRight(Count:Integer; uString:UnicodeString; ch:WideChar=' ';
            Cut:Boolean=False) : UnicodeString; Overload;

Function  StringOfChar(Count:Integer) : UnicodeString; Overload;
Function  StringOfChar(ch:AnsiChar; Count:Integer) : UnicodeString; Overload;
Function  StringOfChar(ch:Word; Count:Integer) : UnicodeString; Overload;

          // Leading Spaces
Function  IntToString(Value:Int64; Width:Integer=0;
            ThousendSeperator:WideChar='?') : UnicodeString;
          // LZ = Leading Zeros
Function  IntToStringLZ(Value:Int64; MinDigits:Integer=3) : UnicodeString;

Function  IntToCounterFilename(Value:Int64; MinDigits:Integer=0) : UnicodeString;

Function  StringToInteger(NumberString:String; Default:Integer=0) : Integer;
Function  StringToInt64(NumberString:String; Default:Integer=0) : Int64;

function  DoubleToString(Number:Double; Width:Integer=0; Comma:Byte=2;
            DecimalSeparator:WideChar='.'; ThousandSeparator:WideChar='?') : String;
Function  StringToDouble(NumberString:UnicodeString; ThousandSeparator:WideChar='?') : Double;
Function  StringReplaceGermanUmlauts(aString:String) : String;
Function  StringDeleteSpaces(aString:String) : String;

Function  BoolToStringJaNein(ABool:Boolean) : String;
Function  BoolToStringYesNo(ABool:Boolean) : String;
          // if aBool=True, Result aString else empty-String
Function  BoolToString(aBool:Boolean; aString:String; len:integer=0) : String; Overload;
          // if aBool=True, Result TextTrue else TextFalse
Function  BoolToString(aBool:Boolean; TextTrue,TextFalse:String) : String; Overload;
          // 0 = '00000000', 255 = '11111111'
Function  ByteToBinaryString(Value:Byte) : String;
          // 0 = '0000000000000000', 65535 = '1111111111111111'
Function  WordToBinaryString(Value:Word) : String;

Function  GetCurrentUsername: String;
Function  GetWindowsUsername : String;
Function  GetWindowsComputername : String;

Function  DataEqual(Var Data1,Data2; Size:Longword) : Boolean;

          // %APPDATA% - C:\Users\USERNAME\AppData\Roaming\
Function  Filepath_AppDataRoaming : String;
          // %LOCALAPPDATA% - C:\Users\USERNAME\AppData\Local\
Function  Filepath_AppDataLocal : String;  // %APPDATA%
          // %PROGRAMDATA% - C:\ProgramData\
Function  Filepath_Progamdata : String;
          // %TEMP% - C:\Users\USERNAME\AppData\Local\Temp\
Function  Filepath_Temp : String;
          // %PUBLIC% - C:\Users\Public\
Function  Filepath_Public : String;

Function  Filename_Make_Valid(Filename_ex_path:String) : String;
Function  FilenameCheckMask(Filename:String; Mask:String;
            CaseSensitiv:Boolean=False) : Boolean;
Function  FilenameCheckFilter(Filename:String; Filter:String;
            CaseSensitiv:Boolean=False) : Boolean; Overload;
Function  FilenameCheckFilter(Filename:String; Var Filter:TStringList;
            CaseSensitiv:Boolean=False) : Boolean; Overload;

          // ExeFilePathName: 'C:\Program Files\Company\MyProg.exe'
Function  ExeFile_Filename : String;
          // ExeFilePath : 'C:\Program Files\Company\'
Function  ExeFile_Path : String;
          // ExeFileName: 'MyProg.exe'
Function  ExeFile_Name : String;
          // ExeFileNameName: 'MyProg'
Function  ExeFile_NameName : String;

          // PlyFilePath: 'C:\Windows\notepad.exe' -> 'C:\Windows\'
Function  PlyFilePath(Filename:String) : String;
          // PlyFileName: 'C:\Windows\notepad.exe' -> 'notepad.exe'
Function  PlyFileName(Filename:String) : String;
          // PlyFileNameName: 'C:\Windows\notepad.exe' -> 'notepad'
Function  PlyFileNameName(Filename:String) : String;
          // PlyFileNameExtension 'C:\Windows\notepad.exe' -> 'exe'
Function  PlyFileNameExtension(Const Filename:String) : String;

Function  FilenameReplaceExtension(Const Filename:String; Const NewExtension:String) : String;
Function  FilenameReplacePlaceholder(Const Filename:String; ReplaceDateTime:tDateTime) : String;

Function  ExtractParrentFilePath(aPath:String) : String;

Function  CharIsArithmeticOperator(wch:WideChar) : Boolean;
Function  StringHasArithmeticOperator(Const uString:UnicodeString) : Boolean;

Function  CharIsControlCharacter(ach:AnsiChar) : Boolean; Overload;
Function  CharIsControlCharacter(wch:WideChar) : Boolean; Overload;

Function  CharIsWrapCharacter(ach:AnsiChar) : Boolean; Overload;
Function  CharIsWrapCharacter(wch:WideChar) : Boolean; Overload;

Function  StringDeleteControlCharacter(sString:ShortString) : ShortString; Overload;
Function  StringDeleteControlCharacter(aString:AnsiString) : AnsiString; Overload;
Function  StringDeleteControlCharacter(uString:UnicodeString) : UnicodeString; Overload;

Function  StringReplaceControlCharacter(uString:UnicodeString) : UnicodeString;
Function  StringPosControlCharacter(uString:UnicodeString; Offset:Longword=1) : Integer;
Function  StringPosWrapWord(uString:UnicodeString; MaxLen:Integer; Offset:Integer=1) : Integer;

Function  PlyLowerCase(sString:ShortString) : ShortString; Overload;
Function  PlyLowerCase(aString:AnsiString) : AnsiString; Overload;
Function  PlyLowerCase(cString:CP850String) : CP850String; Overload;
Function  PlyLowerCase(uString:UnicodeString) : UnicodeString; Overload;

Function  PlyUpperCase(sString:ShortString) : ShortString; Overload;
Function  PlyUpperCase(aString:AnsiString) : AnsiString; Overload;
Function  PlyUpperCase(cString:CP850String) : CP850String; Overload;
Function  PlyUpperCase(uString:UnicodeString) : UnicodeString; Overload;

Function  Char_CP437_Unicode(ch:AnsiChar) : WideChar;

Function  Char_CP850_CP1252(ch:AnsiChar) : AnsiChar;

          // Ignore_CP850_UTF8 is used for delimiters which should not be converted
          Var Ignore_CP850_UTF8 : Set of AnsiChar;
Function  Char_CP850_UTF8(ch:AnsiChar) : AStr3;

Function  Char_CP850_Unicode(ch:AnsiChar) : WideChar;
Function  Char_Unicode_CP850(ch:WideChar) : AnsiChar;

Function  Char_CP1252_CP850(ch:AnsiChar) : AnsiChar;
Function  Char_CP1252_Unicode(ch:AnsiChar) : WideChar;
Function  Char_Unicode_CP1252(wc:WideChar) : AnsiChar;

Function  Str_CP850_UTF8(aString:RawByteString) : UTF8String;

Function  Str_CP850_Unicode(sString:ShortString; ReplaceControlCode:Boolean=False) : UnicodeString; Overload;
Function  Str_CP850_Unicode(cString:CP850String; ReplaceControlCode:Boolean=False) : UnicodeString; Overload;

Function  Str_CP1252_CP850(Const cString:RawByteString) : RawByteString;
Function  Str_CP1252_Unicode(Const cString:CP1252String) : UnicodeString;

Function  Str_Unicode_CP850(Const uString:UnicodeString) : CP850String;
Function  Str_Unicode_RawByteString(Const uString:UnicodeString) : RawByteString;
Function  Str_Unicode_ShortString(Const uString:UnicodeString) : ShortString;

Function  Guess_UTF8(Const Bytes:TBytes) : Boolean; Overload;
Function  Guess_UTF8(Const aString:AnsiString) : Boolean; Overload;

implementation

Uses
  Ply.DateTime,
  Ply.Math,
  System.IOUtils,
  System.Masks,
  System.Math,
  System.StrUtils,
  System.RegularExpressions,
  Winapi.Windows;

const
  // https://docs.microsoft.com/de-de/windows/win32/shell/knownfolderid
  FOLDERID_ProgramData    : TGUID = '{62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}';
  FOLDERID_RoamingAppData : TGUID = '{3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}';
  FOLDERID_LocalAppData   : TGUID = '{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}';
  FOLDERID_Documents      : TGUID = '{FDD39AD0-238F-46AF-ADB4-6C85480369C7}';
  FOLDERID_Public         : TGUID = '{DFDF76A2-C82A-4D63-906A-5644AC457385}';

function SHGetKnownFolderPath(const rfid:TGuid; dwFlags:DWORD; hToken:THandle;
           out ppszPath:PWideChar): HRESULT; stdcall; external 'shell32.dll'
           name 'SHGetKnownFolderPath';

Function GetFolderPath(Const FolderId:TGuid) : String;
var
  ppszPath: PWideChar;
begin
  if (SHGetKnownFolderPath(FolderId, 0, 0, ppszPath) = S_OK) then
  begin
    Result := IncludeTrailingPathDelimiter(ppszPath);
  end else
  begin
    Result := '';
  end;
end;

Function  PosRight(SubStr, sString: ShortString) : Integer;
Var
  Offset : Integer;
  CurPos : Integer;
begin
  Result := 0;
  Offset := 1;
  Repeat
    CurPos := Pos(SubStr, sString, Offset);
    if (CurPos>0) then
    begin
      Result := CurPos;
      Offset := CurPos+1;
    end;
  Until (CurPos=0);
end;

Function  PosRight(SubStr, uString: UnicodeString) : Integer;
Var
  Offset : Integer;
  CurPos : Integer;
begin
  Result := 0;
  Offset := 1;
  Repeat
    CurPos := Pos(SubStr, uString, Offset);
    if (CurPos>0) then
    begin
      Result := CurPos;
      Offset := CurPos+1;
    end;
  Until (CurPos=0);
end;

Function  StrCountChar(ch:Char; Help:String) : Longword;
begin
  Result := Help.CountChar(ch);
end;

Function  StrGetNumbers(Help:String) : String;
(* Alle Zeichen bis auf 0..9 loeschen *)
Var Numbers                  : String;
    i                        : Integer;
begin
  (* Voranstehendes Minus übernehmen *)
  if (Help[1]='-') then Numbers := '-'
                   else Numbers := '';
  for i := low(Help) to high(Help) do
  begin
    if (Help[i] >='0') and (Help[i] <= '9') then
    begin
      Numbers := Numbers + Help[i];
    end;
  end;
  Result := Numbers;
end;

Function  ValidateEmail(Const aEmail: string): Boolean;
var RegEx: TRegEx;
begin
  RegEx := TRegex.Create('^[A-Za-z0-9_.%+-]+@[A-Za-z0-9][A-Za-z0-9-.]{1,61}\.[A-Za-z]{2,}$');
  Result := RegEx.Match(Trim(aEmail)).Success;
end;

Function  ValidateDate(Const aDate: String) : Boolean;
var RegEx: TRegEx;
begin
  RegEx := TRegex.Create('^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$');
  Result := RegEx.Match(Trim(aDate)).Success;
end;

Function  Insert_ThousendSeperator(Help:UnicodeString; ThousendSeperator:WideChar) : UnicodeString;
Var SPos : Integer;
begin
  // Makes "   123456789" to "   123.456.789"
  // Enlarges the String length
  SPos := Length(Help)-2;
  While (SPos>1) and (Help[SPos-1]<>' ') do
  begin
    Insert(ThousendSeperator,Help,SPos);
    SPos := SPos - 3;
  end;
  Result := Help;
end;

Function  StringCopyRight(sString:ShortString; Count:Integer) : ShortString;
begin
  if (Count>=length(sString)) then
  begin
    Result := sString;
  end else
  begin
    Result := Copy(sString,Length(sString)-Count+1,Count);
  end;
end;

Function  StringCopyRight(aString:RawByteString; Count:Integer) : RawByteString; Overload;
begin
  if (Count>=length(aString)) then
  begin
    Result := aString;
  end else
  begin
    Result := Copy(aString,Length(aString)-Count+1,Count);
  end;
end;

Function  StringCopyRight(uString:UnicodeString; Count:Integer) : UnicodeString;
begin
  if (Count>=length(uString)) then
  begin
    Result := uString;
  end else
  begin
    Result := Copy(uString,Length(uString)-Count+1,Count);
  end;
end;

Function  StringAlignLeft(Count:Integer; sString:ShortString; ch:AnsiChar=' ';
            Cut:Boolean=False) : ShortString;
begin
  Count := ValueMinMax(Count,0,255);
  // if aString has an invalid value, then set as empty string
  if (sString=#0) then sString := '';
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  While (length(sString) < Count) do
  begin
    sString := sString + ch;
  end;
  if (Cut) then Result := Copy(sString,1,Count)
           else Result := sString;
end;

Function  StringAlignLeft(Count:Integer; aString:RawByteString; ch:AnsiChar=' ';
            Cut:Boolean=False) : RawByteString;
begin
  // if aString has an invalid value, then set as empty string
  if (aString=#0) then aString := '';
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  While (length(aString) < Count) do
  begin
    aString := aString + ch;
  end;
  if (Cut) then Result := Copy(aString,1,Count)
           else Result := aString;
end;

Function  StringAlignLeft(Count:Integer; uString:UnicodeString; ch:WideChar=' ';
            Cut:Boolean=False) : UnicodeString;
begin
  // if aString has an invalid value, then set as empty string
  if (uString=#0) then uString := '';
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  While (length(uString) < Count) do
  begin
    uString := uString + ch;
  end;
  if (Cut) then Result := Copy(uString,1,Count)
           else Result := uString;
end;

Function  StringAlignRight(Count:Integer; sString:ShortString; ch:AnsiChar=' ';
            Cut:Boolean=False) : ShortString;
begin
  // if aString has an invalid value, then set as empty string
  if (sString=#0) then sString := '';
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  if (Cut) then sString := StringCopyRight(sString,Count);

  While (length(sString) < Count) do
  begin
    sString := ch + sString;
  end;
  Result := sString;
end;

Function  StringAlignRight(Count:Integer; aString:RawByteString; ch:AnsiChar=' ';
            Cut:Boolean=False) : RawByteString;
begin
  // if aString has an invalid value, then set as empty string
  if (aString=#0) then aString := '';
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  if (Cut) then aString := StringCopyRight(aString,Count);

  While (length(aString) < Count) do
  begin
    aString := ch + aString;
  end;
  Result := aString;
end;

Function  StringAlignRight(Count:Integer; uString:UnicodeString; ch:WideChar=' ';
            Cut:Boolean=False) : UnicodeString;
begin
  // if aString has an invalid value, then set as empty string
  if (uString=#0) then uString := '';
  // if ch has an invalid value, then set to space
  if (ch=#0) or (ch='') then ch := #32;

  if (Cut) then uString := StringCopyRight(uString,Count);

  While (length(uString) < Count) do
  begin
    uString := ch + uString;
  end;
  Result := uString;
end;

Function  StringOfChar(Count:Integer) : UnicodeString;
begin
  Result := System.StringOfChar(WideChar(' '),Count);
end;

Function  StringOfChar(ch:AnsiChar; Count:Integer) : UnicodeString; Overload;
begin
  Result := System.StringOfChar(WideChar(AnsiChar(ch)),Count);
end;

Function  StringOfChar(ch:Word; Count:Integer) : UnicodeString; Overload;
begin
  Result := System.StringOfChar(WideChar(ch),Count);
end;

Function  IntToString(Value:Int64; Width:Integer=0; ThousendSeperator:WideChar='?') : UnicodeString;
var Help : UnicodeString;
begin
  {$WARNINGS OFF}
  str(Value:Width,Help);
  if (ThousendSeperator<>'?') then Help := Insert_ThousendSeperator(Help,ThousendSeperator);
  Result := Help;
  {$WARNINGS ON}
end;

Function  IntToStringLZ(Value:Int64; MinDigits:Integer=3) : UnicodeString;
var Help : UnicodeString;
begin
  Help := IntToStr(Value);
  While (length(Help)<MinDigits) do Help := '0' + Help;
  Result := Help;
end;

Function  IntToCounterFilename(Value:Int64; MinDigits:Integer=0) : UnicodeString;
Const HelpChar : Array [0..35] of Char =
      ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H'
      ,'I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
Var Help                     : String;
    i                        : Integer;
    HighValue                : Longint;
    PowerValue               : Double;
    Negativ                  : Boolean;
begin
  Help := '';
  if (Value<0) then
  begin
    Value   := Value * -1;
    Negativ := True;
  end else Negativ := False;
  For i := 5 downto 1 do
  begin
    PowerValue := Power(36,i);
    HighValue  := Value div Trunc(PowerValue);
    Value      := Value mod Trunc(PowerValue);
    if (Help<>'') or (HighValue>0) then
    begin
      Help := Help + HelpChar[HighValue];
    end;
  end;
  Help := Help + HelpChar[Value];
  while (length(Help)<MinDigits) do Help := '0' + Help;
  if (Negativ) then Help := '-' + Help;
  Result := Help;
end;

Function  StringToInteger(NumberString:String; Default:Integer=0) : Integer;
Var Code : Integer;
begin
  NumberString := NumberString.Trim;
  Val(NumberString,Result,Code);
  // Code indicates the position in "NumberString" at which the conversion failed
  if (Code>0) then Result := Default;
end;

Function  StringToInt64(NumberString:String; Default:Integer=0) : Int64;
Var Code : Integer;
begin
  NumberString := NumberString.Trim;
  Val(NumberString,Result,Code);
  // Code indicates the position in "NumberString" at which the conversion failed
  if (Code>0) then Result := Default;
end;

function  DoubleToString(Number:Double; Width:Integer=0; Comma:Byte=2;
            DecimalSeparator:WideChar='.'; ThousandSeparator:WideChar='?') : String;
Var PosThousandSeparator : Integer;
begin
  {$WARNINGS OFF}
  Str(Number:0:Comma,Result);
  {$WARNINGS ON}
  // If a different DecimalSeparator is specified
  if (Comma>0) and (DecimalSeparator<>'.') then
  begin
    Result := StringReplace(Result,'.',DecimalSeparator,[]);
  end;
  // If a ThousandSeparator is specified, insert ThousandSeparator
  if (ThousandSeparator<>'?') then
  begin
    if (Comma>0) then PosThousandSeparator := Pos(DecimalSeparator,Result)-3
                 else PosThousandSeparator := Length(Result)-2;
    While (PosThousandSeparator>1) do
    begin
      if (Result[PosThousandSeparator-1]>='0') and
         (Result[PosThousandSeparator-1]<='9') then
      begin
        Insert(ThousandSeparator,Result,PosThousandSeparator);
      end;
      PosThousandSeparator := PosThousandSeparator - 3;
    end;
  end;
  Result := StringAlignRight(Width,Result,' ');
end;

Function  StringToDouble(NumberString:UnicodeString; ThousandSeparator:WideChar='?') : Double;
var PosPlus,PosMinus,PosMulti,PosDivide : Integer;
    SubNumber : UnicodeString;
    negativ : Boolean;

  function StringToDoubleEmbedded(Number:String) : Double;
  Var Code : integer;
  begin
    val(Number,Result,code);
  end;

begin
  // Default return value is zero if NumberString cannot be interpreted
  Result := 0;
  if (NumberString<>'') then
  begin
    // Remove ThousandSeparator
    if (ThousandSeparator<>'?') then
    begin
      NumberString := StringReplace(NumberString,ThousandSeparator,'',[rfReplaceAll]);
    end;
    // Remove spaces and € sign at the end
    While (NumberString[length(NumberString)]=' ') or
          (NumberString[length(NumberString)]='Ç') do delete(NumberString,length(NumberString),1);
    // Remove spaces and equal signs at the beginning
    While ((NumberString[1]=' ') or (NumberString[1]='=')) do delete(NumberString,1,1);
    // Check if the number is negative
    If (NumberString[1]='-') then
    begin
      delete(NumberString,1,1);
      negativ := True;
    end else negativ := False;

    (* 42=* 43=+ 44=, 45=- 46=. 47=/ 48-57=0..9 *)
    if ((NumberString[1]>=#42) and (NumberString[1]<=#57)) then
    begin
      // Dots and commas are equally interpreted as decimal separators
      // Replace all commas with dots
      NumberString := StringReplace(NumberString,',','.',[rfReplaceAll]);
      If StringHasArithmeticOperator(NumberString) then         // 14+12*3-7 = 43
      begin
        PosPlus    := Pos('+',NumberString);
        PosMinus   := Pos('-',NumberString);
        PosMulti   := Pos('*',NumberString);
        PosDivide  := Pos('/',NumberString);
        // Multiplication and division are at the bottom so that they are
        // calculated first -> dot before dash
        if (PosPlus>0) Then
        begin
          SubNumber := copy(NumberString,1,PosPlus-1);
          Delete(NumberString,1,PosPlus);
          if (negativ) then
          begin
            SubNumber := '-' + SubNumber;
            negativ   := False;
          end;
          // Recursive call of the two partial strings
          Result := StringToDouble(SubNumber) + StringToDouble(NumberString);
        end else
        if (PosMinus>0) Then
        begin
          SubNumber := copy(NumberString,1,PosMinus-1);
          Delete(NumberString,1,PosMinus);
          if (negativ) then
          begin
            SubNumber := '-' + SubNumber;
            negativ   := False;
          end;
          Result := StringToDouble(SubNumber) - StringToDouble(NumberString);
        end else
        if (PosMulti>0) Then
        begin
          SubNumber := copy(NumberString,1,PosMulti-1);
          Delete(NumberString,1,PosMulti);
          Result := StringToDouble(SubNumber) * StringToDouble(NumberString);
        end else
        if (PosDivide>0) Then
        begin
          SubNumber := copy(NumberString,1,PosDivide-1);
          Delete(NumberString,1,PosDivide);
          // avoid division by zero
          Result := StringToDouble(NumberString);
          if (Result<>0) then Result := StringToDouble(SubNumber) / Result
                         else Result := 0;
        end;
      end else
      begin
        Result := StringToDoubleEmbedded(NumberString);
      end;
    end;
    if (negativ) then Result := Result - (2*Result);
  end;
end;

Function  StringReplaceGermanUmlauts(aString:String) : String;
begin
  aString := StringReplace(aString,'ä','ae',[rfReplaceAll]);
  aString := StringReplace(aString,'ö','oe',[rfReplaceAll]);
  aString := StringReplace(aString,'ü','ue',[rfReplaceAll]);
  aString := StringReplace(aString,'ß','ss',[rfReplaceAll]);
  aString := StringReplace(aString,'Ä','Ae',[rfReplaceAll]);
  aString := StringReplace(aString,'Ö','Oe',[rfReplaceAll]);
  Result  := StringReplace(aString,'Ü','Ue',[rfReplaceAll]);
end;

Function  StringDeleteSpaces(aString:String) : String;
begin
  // Delete normal Spaces
  aString := StringReplace(aString,' ','',[rfReplaceAll]);
  // Delete Non breaking Spaces
  Result := StringReplace(aString,WideChar(_NBSP),'',[rfReplaceAll]);
end;

Function  BoolToStringJaNein(ABool:Boolean) : String;
begin
  if (ABool) then Result := 'Ja  ' else Result := 'Nein';
end;

Function  BoolToStringYesNo(ABool:Boolean) : String;
begin
  if (ABool) then Result := 'Yes' else Result := 'No ';
end;

Function  BoolToString(aBool:Boolean; aString:String; len:integer=0) : String;
begin
  if (aBool) then Result := StringAlignLeft(len,aString)
             else Result := StringAlignLeft(len,'');
end;

Function  BoolToString(aBool:Boolean; TextTrue,TextFalse:String) : String;
begin
  if (aBool) then Result := TextTrue
             else Result := TextFalse;
end;

Function  ByteToBinaryString(Value:Byte) : String;
Var i : integer;
begin
  Result := '';
  for i := 0 to (Sizeof(Byte)*8)-1 do
  begin
    Result := ((Value and BitValue32[i]) = BitValue32[i]).ToInteger.ToString + Result;
  end;
end;

Function  WordToBinaryString(Value:Word) : String;
Var i : integer;
begin
  Result := '';
  for i := 0 to (Sizeof(Word)*8)-1 do
  begin
    Result := ((Value and BitValue32[i]) = BitValue32[i]).ToInteger.ToString + Result;
  end;
end;

Function  GetCurrentUserName : string;
const cnMaxUserNameLen       = 254;
var sUserName                : string;
    dwUserNameLen            : Cardinal;
begin
  dwUserNameLen := cnMaxUserNameLen-1;
  SetLength(sUserName, cnMaxUserNameLen );
  GetUserName(PChar(sUserName),dwUserNameLen);
  SetLength(sUserName, dwUserNameLen-1);
  Result := sUserName;
end;

Function  GetWindowsUsername : String;
Var UName                    : String;
begin
  (* Get CurrentUserName from Kernel32.dll *)
  UName := GetCurrentUsername;
  (* Get "Username" from environment-variable *)
  if (UName='') then UName := GetEnvironmentVariable('USERNAME');
  (* Get "User" from environment-variable *)
  if (UName='') then UName := GetEnvironmentVariable('USER');
  (* Make Uppercase *)
  Result := UName.ToUpper;
end;

Function  GetWindowsComputername : String;
begin
  Result := GetEnvironmentVariable('COMPUTERNAME');
end;

//Function  Path_Remove(FilenameWithPath:String) : String;
//begin
//  Result := ExtractFileName(FilenameWithPath);
//end;
//
//Function  Path_Only(FilenameWithPath:String) : String;
//begin
//  Result := ExtractFilePath(FilenameWithPath);
//end;

Function  DataEqual(Var Data1,Data2; Size:Longword) : Boolean;
Const MaxByte  = 65536;
Type BytePtr   = ^ByteArray;
     ByteArray = Array [1..MaxByte] of Byte;
Var p1,p2                    : BytePtr;
    lw                       : Longword;
    Equal                    : Boolean;
begin
  if (Size<=MaxByte) then
  begin
    Equal := True;
    p1    := Addr(Data1);
    p2    := Addr(Data2);
    lw    := 1;
    Repeat
      if (P1^[lw]<>P2^[lw]) then
      begin
        Equal := False;
      end;
      inc(lw);
    Until (not(Equal)) or (lw>Size);
  end else Equal := False;
  DataEqual := Equal;
end;

Function  Filepath_AppDataRoaming : String;
begin
  Result := GetFolderPath(FOLDERID_RoamingAppData);
end;

Function  Filepath_AppDataLocal : String;
begin
  Result := GetFolderPath(FOLDERID_LocalAppData);
end;

Function  Filepath_Progamdata : String;
begin
  Result := GetFolderPath(FOLDERID_ProgramData);
end;

Function  Filepath_Temp : String;
begin
  Result := TPath.GetTempPath;
end;

Function  Filepath_Public : String;
begin
  Result := GetFolderPath(FOLDERID_Public);
end;

Const (* ForbiddenCharsWinPath   : Set of AnsiChar = [#0..#31, '"', '*', '<', '>', '?', '|']; *)
      ForbiddenCharsFilepath : Set of AnsiChar = [#0..#31, #33..#34,#38..#44
        , #59..#62, #91, #93, #94, #96
        , #123..#128
       // #129 = Umlaut ü approved
        , #130, #131
       // #132 = Umlaut ä approved
        , #133..#141
       // #142 = Umlaut Ä approved
        , #143..#147
       // #148 = Umlaut ö approved
        , #149..#152
       // #153 = Umlaut Ö approved
       // #154 = Umlaut Ü approved
        , #155..#224
       // #225 = Umlaut ß approved
        , #226..#255];
      ForbiddenCharsFilename : Set of AnsiChar = ['/', ':', '\'];

Function  Char_Filename_Valid(ch:AnsiChar) : Boolean;
begin
  (* Is this Char valid for filenames? *)
  if (ch in ForbiddenCharsFilename) or
     (ch in ForbiddenCharsFilepath) then
  begin
    Result := False;
  end else
  begin
    Result := True;
  end;
end;

Function  Filename_Make_Valid(Filename_ex_path:String) : String;
Var
  i : integer;
begin
  For i := length(Filename_ex_path) downto 1 do
  begin
    if (Filename_ex_path[i]=' ') then
    begin
      Filename_ex_path[i] := '_';
    end else
    if not(Char_Filename_valid(AnsiChar(Filename_ex_path[i]))) then
    begin
      Delete(Filename_ex_path,i,1);
    end;
  end;
  Result := Filename_ex_path;
end;

Function  FilenameCheckMask(Filename:String; Mask:String; CaseSensitiv:Boolean=False) : Boolean;
begin
  if not(CaseSensitiv) then
  begin
    Filename := Filename.ToUpper;
    Mask     := Mask.ToUpper;
  end;
  try
    Result := MatchesMask(Filename, Mask);
  except
    Result := False;
  end;
end;

Function  FilenameCheckFilter(Filename:String; Filter:String; CaseSensitiv:Boolean=False) : Boolean;
Var FilterName               : String;
    FilterExt                : String;
    SPos                     : Integer;
    DateiName                : String;
    DateiErw                 : String;
    Equal                    : Boolean;
begin
  Result := False;
  // If case insensitivity is required, then convert both strings to upper case
  if not(CaseSensitiv) then
  begin
    Filename := UpperCase(Filename);
    Filter   := UpperCase(Filter);
  end;
  // Check if a file extension is specified in the filter
  SPos := PosRight('.',Filter);
  if (SPos>0) then
  begin
    FilterName := Copy(Filter,1,SPos-1);
    FilterExt  := Copy(Filter,SPos+1,255);
  end else
  begin
    FilterName := Filter;
    FilterExt  := '';
  end;
  // Check if the filename has a file extension
  SPos := PosRight('.',Filename);
  if (SPos>0) then
  begin
    DateiName := Copy(Filename,1,SPos-1);
    DateiErw  := Copy(Filename,SPos+1,255);
  end else
  begin
    DateiName := Filter;
    DateiErw  := '';
  end;
  // if Filter = "all Files"
  if (FilterName='*') and (FilterExt='') then
  begin
    Result := True;
  end else
  begin
    // Check if the file extension matches
    if ((FilterExt='*') and (DateiErw<>'')) or
       (FilterExt=DateiErw)                 then
    begin
      // Check if the filename matches
      if (FilterName='*')       or
         (FilterName=DateiName) then
      begin
        Result := True;
      end else
      // otherwise, check if "XYZ*" is specified as filter
      begin
        // Determine position of the * in the filter
        SPos := Pos('*',FilterName);
        if (SPos>0) then
        begin
          // If the filename matches the filter up to the *
          if (Copy(FilterName,1,SPos-1)=Copy(DateiName,1,SPos-1)) then
          begin
            Result := True;
          end;
        end else
        // If filtername is as long as filename, then check for ?
        if (Length(FilterName)=Length(DateiName)) then
        begin
          Equal := True;
          SPos   := 1;
          Repeat
            if (FilterName[SPos]<>'?')             and
               (FilterName[SPos]<>Dateiname[SPos]) then
            begin
              Equal := False;
            end else
            begin
              inc(SPos);
            end;
          until (not(Equal)) or (SPos>length(FilterName));
          if (Equal) then
          begin
            Result := True;
          end;
        end;
      end;
    end;
  end;
end;

Function  FilenameCheckFilter(Filename:String; Var Filter:TStringList; CaseSensitiv:Boolean=False) : Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Filter.Count-1 do
  begin
    if (FilenameCheckMask(Filename,Filter[i])) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

Function  ExeFile_Filename : String;
begin
  Result := ParamStr(0);
end;

Function  ExeFile_Path : String;
begin
  Result := PlyFilePath(ParamStr(0));
end;

Function  ExeFile_Name : String;
begin
  Result := PlyFileName(ParamStr(0));
end;

Function  ExeFile_NameName : String;
begin
  Result := PlyFileNameName(ParamStr(0));
end;

Function  PlyFilePath(Filename:String) : String;
begin
  Result := System.SysUtils.ExtractFilePath(Filename);
end;

Function  PlyFileName(Filename:String) : String;
begin
  Result := System.SysUtils.ExtractFileName(Filename);
end;

Function  PlyFileNameName(Filename:String) : String;
begin
  Result := System.IOUtils.TPath.GetFileNameWithoutExtension(Filename);
end;

Function  PlyFileNameExtension(Const Filename:String) : String;
begin
  Result := ReplaceStr(System.IOUtils.TPath.GetExtension(FileName),'.','');
end;

Function  FilenameReplaceExtension(Const Filename:String; Const NewExtension:String) : String;
Var
  DotPos : Integer;
begin
  Result := Filename;
  DotPos := PosRight('.',Result);
  if (DotPos>0) then
  begin
    Delete(Result,DotPos+1,length(Result));
    Result := Result + NewExtension;
  end;
end;

Function  FilenameReplacePlaceholder(Const Filename:String; ReplaceDateTime:tDateTime) : String;
begin
  (* %DATE% -> YYYYMMDD *)
  Result := ReplaceStr(Filename,'%DATE%',ReplaceDateTime.YYYYMMDD);
  (* %TIME% -> HHMMSS *)
  Result := ReplaceStr(Result,'%TIME%',ReplaceDateTime.HHMMSS);
  (* %DATETIME% -> YYYYMMDD_HHMMSS *)
  Result := ReplaceStr(Result,'%DATETIME%',ReplaceDateTime.DateTimeFilename);
  (* %YYYY% *)
  Result := ReplaceStr(Result,'%YYYY%',Copy(ReplaceDateTime.YYYYMMDD,1,4));
  (* %MM% -> MM *)
  Result := ReplaceStr(Result,'%MM%',Copy(ReplaceDateTime.YYYYMMDD,5,2));
  (* %DD% -> DD *)
  Result := ReplaceStr(Result,'%DD%',Copy(ReplaceDateTime.YYYYMMDD,7,2));
  (* %YYMM% *)
  Result := ReplaceStr(Result,'%YYMM%',Copy(ReplaceDateTime.YYYYMMDD,3,4));
  (* %YYMMDD% *)
  Result := ReplaceStr(Result,'%YYMMDD%',Copy(ReplaceDateTime.YYYYMMDD,3,6));
  (* %YYYYMM% *)
  Result := ReplaceStr(Result,'%YYYYMM%',Copy(ReplaceDateTime.YYYYMMDD,1,6));
  (* %DOY% -> DDD = Day of Year 001..366 *)
  Result := ReplaceStr(Result,'%DOY%',IntToStringLZ(ReplaceDateTime.DayOfYear,3));
end;

// ParentDir is returned with backslash at the end
Function  ExtractParrentFilePath(aPath:String) : String;
Var Help                     : String;
    Pos_BSlash               : Integer;
begin
  Help := aPath;
  if (Help[Length(Help)]='\') then Delete(Help,Length(Help),1);
  Pos_BSlash := PosRight('\',Help);
  if (Pos_BSlash>=2) then
  begin
    ExtractParrentFilePath := Copy(Help,1,Pos_BSlash);
  end else
  begin
    ExtractParrentFilePath := '';
  end;
end;

Const
  ArithmeticOperators : Set of AnsiChar = ['*','/','-','+'];
  //  #0 <NUL>     Null
  //  #1 <SOH>     Start of Heading
  //  #2 <STX>     Start of Text
  //  #3 <ETX>     End of Text
  //  #4 <EOT>     End of Transmission
  //  #5 <ENQ>     Enquiry
  //  #6 <ACK>     Acknowledge
  //  #7 <BEL>     Bell
  //  #8 <BS>      Backspace
  //  #9 <HT>      <TAB> Horizontal Tab
  // #10 <LF>      Line Feed
  // #11 <VT>      Vertical Tab
  // #12 <FF>      Form Feed
  // #13 <CR>      Carriage Return
  ControlCharacter    : Set of AnsiChar = [#0..#13];
  WrapCharacter       : Set of AnsiChar = [#32, '|', '/', '\', '-', '(', ')', '[', ']'];

Function CharIsArithmeticOperator(wch:WideChar) : Boolean;
begin
  Result := CharInSet(wch,ArithmeticOperators);
end;

Function StringHasArithmeticOperator(Const uString:UnicodeString) : Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to length(uString) do
  begin
    if CharIsArithmeticOperator(uString[i]) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

Function  CharIsControlCharacter(ach:AnsiChar) : Boolean;
begin
  Result := (ach in ControlCharacter);
end;

Function  CharIsControlCharacter(wch:WideChar) : Boolean;
begin
  Result := CharInSet(wch,ControlCharacter);
end;

Function  CharIsWrapCharacter(ach:AnsiChar) : Boolean;
begin
  Result := (ach in WrapCharacter);
end;

Function  CharIsWrapCharacter(wch:WideChar) : Boolean;
begin
  Result := CharInSet(wch,WrapCharacter);
end;

Function  StringDeleteControlCharacter(sString:ShortString) : ShortString; Overload;
Var i : Integer;
begin
  for i := Length(sString) downto 1 do
  begin
    if (CharIsControlCharacter(sString[i])) then
    begin
      Delete(sString,i,1);
    end;
  end;
  Result := sString;
end;

Function  StringDeleteControlCharacter(aString:AnsiString) : AnsiString;
Var i : Integer;
begin
  for i := Length(aString) downto 1 do
  begin
    if (CharIsControlCharacter(aString[i])) then
    begin
      Delete(aString,i,1);
    end;
  end;
  Result := aString;
end;

Function  StringDeleteControlCharacter(uString:UnicodeString) : UnicodeString;
Var i : Integer;
begin
  for i := Length(uString) downto 1 do
  begin
    if (CharIsControlCharacter(uString[i])) then
    begin
      Delete(uString,i,1);
    end;
  end;
  Result := uString;
end;

Function  StringReplaceControlCharacter(uString:UnicodeString) : UnicodeString;
Var i : Integer;
begin
  for i := Length(uString) downto 1 do
  begin
    if (CharIsControlCharacter(uString[i])) then
    begin
      uString[i] := Char_CP850_Unicode(AnsiChar(uString[i]));
    end;
  end;
  Result := uString;
end;

Function  StringPosControlCharacter(uString:UnicodeString; Offset:Longword=1) : Integer;
var
  I: Longword;
begin
  Result := 0;
  for I := Offset to length(uString) do
  begin
    if CharIsControlCharacter(uString[i]) then
    begin
      Result := i - Offset + 1;
      Exit;
    end;
  end;
end;

Function  StringPosWrapWord(uString:UnicodeString; MaxLen:Integer; Offset:Integer=1) : Integer;
Var
  MinLen : Integer;
  i : Integer;
begin
  Result := Min(MaxLen,(Length(uString)-Offset));
  if (Length(uString)>Offset) then
  begin
    MinLen := ValueMinMax((MaxLen Div 4) * 3,5,MaxLen);
    i      := (Offset+MaxLen) - 1;
    While (i>Offset+MinLen) do
    begin
      if CharIsWrapCharacter(uString[i])    or
         CharIsControlCharacter(uString[i]) then
      begin
        Result := i - Offset + 1;
        Exit;
      end else
      begin
        Dec(i);
      end;
    end;
  end;
end;

Function  PlyLowerCase(sString:ShortString) : ShortString;
begin
  Result := Str_Unicode_CP850(Str_CP850_Unicode(sString).ToLower);
end;

Function  PlyLowerCase(aString:AnsiString) : AnsiString;
begin
  Result := AnsiString(String(aString).ToLower);
end;

Function  PlyLowerCase(cString:CP850String) : CP850String;
begin
  Result := CP850String(String(cString).ToLower);
end;

Function  PlyLowerCase(uString:UnicodeString) : UnicodeString;
begin
  Result := uString.ToLower;
end;

Function  PlyUpperCase(sString:ShortString) : ShortString;
begin
  Result := Str_Unicode_CP850(Str_CP850_Unicode(sString).ToUpper);
end;

Function  PlyUpperCase(aString:AnsiString) : AnsiString;
begin
  Result := AnsiString(String(aString).ToUpper);
end;

Function  PlyUpperCase(cString:CP850String) : CP850String;
begin
  Result := CP850String(String(cString).ToUpper);
end;

Function  PlyUpperCase(uString:UnicodeString) : UnicodeString;
begin
  Result := uString.ToUpper;
end;

Function  Char_CP437_Unicode(ch:AnsiChar) : WideChar;
begin
  Result := Widechar(ch);
  case ord(ch) of
    1 .. 154 : Result := Char_CP850_Unicode(ch);
    155 : Result := WideChar($00A2);     (* ¢ = Cent-Sign                        *)
    156 : Result := WideChar($00A3);     (* £ = british pound                    *)
    157 : Result := WideChar($00A5);     (* ¥ = yen-sign                         *)
    158 : Result := WideChar($20A7);     (* ₧ = Peseta                           *)
    159 : Result := WideChar($0192);     (* ƒ                                    *)
    160 : Result := WideChar($00E1);     (* á                                    *)
    161 : Result := WideChar($00ED);     (* í                                    *)
    162 : Result := WideChar($00F3);     (* ó                                    *)
    163 : Result := WideChar($00FA);     (* ú                                    *)
    164 : Result := WideChar($00F1);     (* ñ                                    *)
    165 : Result := WideChar($00D1);     (* Ñ                                    *)
    166 : Result := WideChar($00AA);     (* ª                                    *)
    167 : Result := WideChar($00BA);     (* º                                    *)
    168 : Result := WideChar($00BF);     (* ¿                                    *)
    169 : Result := WideChar($2310);     (* ⌐                                    *)
    170 : Result := WideChar($00AC);     (* ¬                                    *)
    171 : Result := WideChar($00BD);     (* ½                                    *)
    172 : Result := WideChar($00BC);     (* ¼                                    *)
    173 : Result := WideChar($00A1);     (* ¡                                    *)
    174 : Result := WideChar($00AB);     (* «                                    *)
    175 : Result := WideChar($00BB);     (* »                                    *)
    176 : Result := WideChar($2591);     (* ░                                    *)
    177 : Result := WideChar($2592);     (* ▒                                    *)
    178 : Result := WideChar($2593);     (* ▓                                    *)
    179 : Result := WideChar($2502);     (* │                                    *)
    180 : Result := WideChar($2524);     (* ┤                                    *)
    181 : Result := WideChar($2561);     (* ╡                                    *)
    182 : Result := WideChar($2562);     (* ╢                                    *)
    183 : Result := WideChar($2556);     (* ╖                                    *)
    184 : Result := WideChar($2555);     (* ╕                                    *)
    185 : Result := WideChar($2563);     (* ╣ = Box drawing character            *)
    186 : Result := WideChar($2551);     (* ║                                    *)
    187 : Result := WideChar($2557);     (* ╗                                    *)
    188 : Result := WideChar($255D);     (* ╝                                    *)
    189 : Result := WideChar($255C);     (* ╜                                    *)
    190 : Result := WideChar($255B);     (* ╛                                    *)
    191 : Result := WideChar($2510);     (* ┐                                    *)
    192 : Result := WideChar($2514);     (* └                                    *)
    193 : Result := WideChar($2534);     (* ┴                                    *)
    194 : Result := WideChar($252C);     (* ┬                                    *)
    195 : Result := WideChar($251C);     (* ├                                    *)
    196 : Result := WideChar($2500);     (* ─                                    *)
    197 : Result := WideChar($253C);     (* ┼                                    *)
    198 : Result := WideChar($255E);     (* ╞                                    *)
    199 : Result := WideChar($255F);     (* ╟                                    *)
    200 : Result := WideChar($255A);     (* ╚                                    *)
    201 : Result := WideChar($2554);     (* ╔                                    *)
    202 : Result := WideChar($2569);     (* ╩                                    *)
    203 : Result := WideChar($2566);     (* ╦                                    *)
    204 : Result := WideChar($2560);     (* ╠                                    *)
    205 : Result := WideChar($2550);     (* ═                                    *)
    206 : Result := WideChar($256C);     (* ╬                                    *)
    207 : Result := WideChar($2567);     (* ╧                                    *)
    208 : Result := WideChar($2568);     (* ╨                                    *)
    209 : Result := WideChar($2564);     (* ╤                                    *)
    210 : Result := WideChar($2565);     (* ╥                                    *)
    211 : Result := WideChar($2559);     (* ╙                                    *)
    212 : Result := WideChar($2558);     (* ╘                                    *)
    213 : Result := WideChar($2552);     (* ╒                                    *)
    214 : Result := WideChar($2553);     (* ╓                                    *)
    215 : Result := WideChar($256B);     (* ╫                                    *)
    216 : Result := WideChar($256A);     (* ╪                                    *)
    217 : Result := WideChar($2518);     (* ┘                                    *)
    218 : Result := WideChar($250C);     (* ┌                                    *)
    219 : Result := WideChar($2588);     (* █                                    *)
    220 : Result := WideChar($2584);     (* ▄                                    *)
    221 : Result := WideChar($258C);     (* ▌                                    *)
    222 : Result := WideChar($2590);     (* ▐                                    *)
    223 : Result := WideChar($2580);     (* ▀                                    *)
    224 : Result := WideChar($03B1);     (* α                                    *)
    225 : Result := WideChar($00DF);     (* ß                                    *)
    226 : Result := WideChar($0393);     (* Γ                                    *)
    227 : Result := WideChar($03C0);     (* π                                    *)
    228 : Result := WideChar($03A3);     (* Σ                                    *)
    229 : Result := WideChar($03C3);     (* σ                                    *)
    230 : Result := WideChar($00B5);     (* µ                                    *)
    231 : Result := WideChar($03C4);     (* τ                                    *)
    232 : Result := WideChar($03A6);     (* Φ                                    *)
    233 : Result := WideChar($0398);     (* Θ                                    *)
    234 : Result := WideChar($03A9);     (* Ω                                    *)
    235 : Result := WideChar($03B4);     (* δ                                    *)
    236 : Result := WideChar($221E);     (* ∞                                    *)
    237 : Result := WideChar($03C6);     (* φ                                    *)
    238 : Result := WideChar($03B5);     (* ε                                    *)
    239 : Result := WideChar($2229);     (* ∩                                    *)
    240 : Result := WideChar($2261);     (* ≡                                    *)
    241 : Result := WideChar($00B1);     (* ±                                    *)
    242 : Result := WideChar($2265);     (* ≥                                    *)
    243 : Result := WideChar($2264);     (* ≤                                    *)
    244 : Result := WideChar($2320);     (* ⌠                                    *)
    245 : Result := WideChar($2321);     (* ⌡                                    *)
    246 : Result := WideChar($00F7);     (* ÷                                    *)
    247 : Result := WideChar($2248);     (* ≈                                    *)
    248 : Result := WideChar($00B0);     (* °                                    *)
    249 : Result := WideChar($2219);     (* ∙                                    *)
    250 : Result := WideChar($00B7);     (* ·                                    *)
    251 : Result := WideChar($22A1);     (* √                                    *)
    252 : Result := WideChar($207F);     (* ⁿ                                    *)
    253 : Result := WideChar($00B2);     (* ²                                    *)
    254 : Result := WideChar($25A0);     (* ■                                    *)
    255 : Result := WideChar($00A0);     (* NBSP = Non-breaking space            *)
  end;
end;

Function  Char_CP850_CP1252(ch:AnsiChar) : AnsiChar;
begin
  Result := ch;
  case ord(ch) of
     20 : Result := AnsiChar(182);  (* ¶ = Pilcrow/Absatzzeichen            *)
     21 : Result := AnsiChar(167);  (* § = Paragraph                        *)
         (* In CP850 we use 128=Ç for Euro-sign, in CP1252 chr(128) is      *)
         (* also the Euro-Sign, therefore we do not translate here          *)
         (* 128 : Result := AnsiChar(199);     Ç = C mit Akzent unten       *)
    129 : Result := AnsiChar(252);  (* ü = übermut klein                    *)
    130 : Result := AnsiChar(233);  (* é = René (e mit ')                   *)
    131 : Result := AnsiChar(226);  (* â = a mit Dach                       *)
    132 : Result := AnsiChar(228);  (* ä = ähnlich klein                    *)
    133 : Result := AnsiChar(224);  (* à = a mit invers '                   *)
    134 : Result := AnsiChar(229);  (* å = a mit Ring                       *)
    135 : Result := AnsiChar(231);  (* ç = c mit Akzent unten               *)
    136 : Result := AnsiChar(234);  (* ê = e mit ^                          *)
    137 : Result := AnsiChar(235);  (* ë = e mit :                          *)
    138 : Result := AnsiChar(232);  (* è = e mit invers '                   *)
    139 : Result := AnsiChar(239);  (* ï = i mit :                          *)
    140 : Result := AnsiChar(238);  (* î = i mit ^                          *)
    141 : Result := AnsiChar(236);  (* ì = i mit invers '                   *)
    142 : Result := AnsiChar(196);  (* Ä = Ähnlich gross                    *)
    143 : Result := AnsiChar(197);  (* Å = A mit Ring                       *)
    144 : Result := AnsiChar(201);  (* É = E mit '                          *)
    145 : Result := AnsiChar(230);  (* æ = ae Minuskel                      *)
    146 : Result := AnsiChar(198);  (* Æ = AE Majuskel                      *)
    147 : Result := AnsiChar(244);  (* ô = kleines o mit Dach               *)
    148 : Result := AnsiChar(246);  (* ö = ökologie klein                   *)
    149 : Result := AnsiChar(242);  (* ò = o mit invers '                   *)
    150 : Result := AnsiChar(251);  (* û = kleines u mit Dach               *)
    151 : Result := AnsiChar(249);  (* ù = kleines u mit invers '           *)
    152 : Result := AnsiChar(255);  (* ÿ = großes Y mit :                   *)
    153 : Result := AnsiChar(214);  (* Ö = Ökologie gross                   *)
    154 : Result := AnsiChar(220);  (* Ü = Übermut gross                    *)
    155 : Result := AnsiChar(248);  (* ø = kleines o durchgestrichen        *)
    156 : Result := AnsiChar(163);  (* £ = GBP (Pfund)                      *)
    157 : Result := AnsiChar(216);  (* Ø = großes O durchgestrichen         *)
 (* 158 : x = Multiplikation-Sign × nicht in CP437 und CP1252               *)
 (* 159 : ƒ = geschwungenes f (minuscule) ƒ, not in CP1252                  *)
    160 : Result := AnsiChar(225);  (* á = a mit '                          *)
    161 : Result := AnsiChar(237);  (* í = i mit '                          *)
    162 : Result := AnsiChar(243);  (* ó = o mit '                          *)
    163 : Result := AnsiChar(250);  (* ú = kleines u mit '                  *)
    164 : Result := AnsiChar(241);  (* ñ = kleines n mit ~                  *)
    165 : Result := AnsiChar(209);  (* Ñ = großes N mit ~                   *)
    166 : Result := AnsiChar(170);  (* ª = hogestelltes kleines a           *)
    167 : Result := AnsiChar(186);  (* º = hogestelltes kleines o           *)
    168 : Result := AnsiChar(191);  (* ¿ = auf den Kopf gestelltes ?        *)
    169 : Result := AnsiChar(174);  (* ® = R mit Kreis Registrierte Marke   *)
    170 : Result := AnsiChar(172);  (* ¬ = Negation                         *)
    171 : Result := AnsiChar(189);  (* ½ = 1/2                              *)
    172 : Result := AnsiChar(188);  (* ¼ = 1/4                              *)
    173 : Result := AnsiChar(161);  (* ¡ = ! umgedreht                      *)
    174 : Result := AnsiChar(171);  (* « = <<                               *)
    175 : Result := AnsiChar(187);  (* » = >>                               *)
 (* 176..180 : Box drawing Character  ░▒▓│┤   no Representative in CP1252   *)
    181 : Result := AnsiChar(193);  (* Á = großes A mit '                   *)
    182 : Result := AnsiChar(194);  (* Â = großes A mit ^                   *)
    183 : Result := AnsiChar(192);  (* À = großes A mit invers '            *)
    184 : Result := AnsiChar(169);  (* © = C mit Kreis Copyright Zeichen    *)
 (* 185..188 : Box drawing Character ╣║╗╝     no Representative in CP1252   *)
    189 : Result := AnsiChar(162);  (* ¢ = kleines c mit Strichen           *)
    190 : Result := AnsiChar(165);  (* ¥ = Janische Jen Y mit =             *)
 (* 191..197 : Box drawing Character ┐└┴┬├─┼  no Representative in CP1252   *)
    198 : Result := AnsiChar(227);  (* ã = kleines a mit ~                  *)
    199 : Result := AnsiChar(195);  (* Ã = großes A mit ~                   *)
 (* 200..206 : Box drawing Character  ╚╔╩╦╠═╬ no Representative in CP1252   *)
    207 : Result := AnsiChar(164);  (* ¤ = Currency Sign = kleines o mit 4' *)
    208 : Result := AnsiChar(240);  (* ð = kleines Eth                      *)
    209 : Result := AnsiChar(208);  (* Ð = großes Eth                       *)
    210 : Result := AnsiChar(202);  (* Ê = großes E mit ^                   *)
    211 : Result := AnsiChar(203);  (* Ë = großes E mit :                   *)
    212 : Result := AnsiChar(200);  (* È = großes E mit invers '            *)
 (* 213 : ı = griechischer Buchstabe i ı, not in CP437 und CP1252           *)
    214 : Result := AnsiChar(205);  (* Í = großes I mit '                   *)
    215 : Result := AnsiChar(206);  (* Î = großes I mit ^                   *)
    216 : Result := AnsiChar(207);  (* Ï = großes I mit :                   *)
 (* 217..220 : Box drawing Character  ┘┌█▄    no Representative in CP1252   *)
    221 : Result := AnsiChar(166);  (* ¦ = broken vertical bar              *)
    222 : Result := AnsiChar(204);  (* Ì = großes I mit invers '            *)
 (* 223 : Box drawing Character  ▀            no Representative in CP1252   *)
    224 : Result := AnsiChar(211);  (* Ó = großes O mit '                   *)
    225 : Result := AnsiChar(223);  (* ß = ss                               *)
    226 : Result := AnsiChar(212);  (* Ô = großes O mit ^                   *)
    227 : Result := AnsiChar(210);  (* Ò = großes O mit invers '            *)
    228 : Result := AnsiChar(245);  (* õ = kleines o mit ~                  *)
    229 : Result := AnsiChar(213);  (* õ = großes O mit ~                   *)
    230 : Result := AnsiChar(181);  (* µ = My griechischer Buchstabe        *)
    231 : Result := AnsiChar(254);  (* þ = groß Thorn englischer Buchstabe  *)
    232 : Result := AnsiChar(222);  (* Þ = klein Thorn englischer Buchstabe *)
    233 : Result := AnsiChar(218);  (* Ú = großes U mit '                   *)
    234 : Result := AnsiChar(219);  (* Û = großes U mit ^                   *)
    235 : Result := AnsiChar(217);  (* Ù = großes U mit invers '            *)
    236 : Result := AnsiChar(253);  (* ý = kleines y mit '                  *)
    237 : Result := AnsiChar(221);  (* Ý = großes y mit '                   *)
    238 : Result := AnsiChar(175);  (* ¯ = Markon / Überstrich              *)
    239 : Result := AnsiChar(180);  (* ´ = Akut-Akzent (Hochkomma)          *)
    240 : Result := AnsiChar(173);  (* ­ = SHY = Weiches Trennzeichen       *)
    241 : Result := AnsiChar(177);  (* ± = +/- Zeichen                      *)
 (* 242 : double underscore ‗ not in CP437 and CP1252                       *)
    243 : Result := AnsiChar(190);  (* ¾ = 3/4 Dreiviertel                  *)
    244 : Result := AnsiChar(182);  (* ¶ = Pilcrow/Absatzzeichen            *)
    245 : Result := AnsiChar(167);  (* § = Paragraph                        *)
    246 : Result := AnsiChar(247);  (* ÷ = Obelus/Geteiltzeichen            *)
    247 : Result := AnsiChar(184);  (* ¸ = Cedilla/Cedille                  *)
    248 : Result := AnsiChar(176);  (* ° = Grad-Zeichen                     *)
    249 : Result := AnsiChar(168);  (* ¨ = Diaeresis/Trema                  *)
    250 : Result := AnsiChar(183);  (* · = Interpunct/Mittelpunkt           *)
    251 : Result := AnsiChar(185);  (* ¹ = Hochgestellte 1                  *)
    252 : Result := AnsiChar(179);  (* ³ = Hochgestellte 3 (AltGr+3)        *)
    253 : Result := AnsiChar(178);  (* ² = Hochgestellte 2 (AltGr+2)        *)
 (* 254 : Box drawing Character not in CP1252                               *)
    255 : Result := AnsiChar(160);  (*   = NBSP non-breaking space          *)
  end;
end;

Function  Char_CP850_UTF8(ch:AnsiChar) : AStr3;
begin
  Result := ch;
  if not(ch in Ignore_CP850_UTF8) then
  begin
    case ord(ch) of
        1 : Result := AnsiChar($e2) + AnsiChar($98) + AnsiChar($ba); (* Smily white                      *)
        2 : Result := AnsiChar($e2) + AnsiChar($98) + AnsiChar($bb); (* Smily black                      *)
        3 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($a5); (* Herz  black                      *)
        4 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($a6); (* Karro black                      *)
        5 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($a3); (* Kreuz black                      *)
        6 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($a0); (* Pik black                        *)
        7 : Result := AnsiChar($e2) + AnsiChar($80) + AnsiChar($a2); (* BULLET                           *)
        8 : Result := AnsiChar($e2) + AnsiChar($97) + AnsiChar($98); (* INVERSE BULLET                   *)
        9 : Result := AnsiChar($e2) + AnsiChar($97) + AnsiChar($8b); (* White Circle                     *)
       10 : Result := AnsiChar($e2) + AnsiChar($97) + AnsiChar($99); (* Inverse White Circle             *)
       11 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($82); (* Male-Symbol                      *)
       12 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($80); (* Female-Symbol                    *)
       13 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($aa); (* EIGHTH NOTE                      *)
       14 : Result := AnsiChar($e2) + AnsiChar($99) + AnsiChar($ab); (* BEAMED EIGHTH NOTES              *)
       15 : Result := AnsiChar($e2) + AnsiChar($98) + AnsiChar($bc); (* WHITE SUN WITH RAYS              *)
       16 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($ba); (* BLACK RIGHT-POINTING POINTER     *)
       17 : Result := AnsiChar($e2) + AnsiChar($97) + AnsiChar($84); (* BLACK LEFT-POINTING POINTER      *)
       18 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($95); (* UP DOWN ARROW                    *)
       19 : Result := AnsiChar($e2) + AnsiChar($80) + AnsiChar($bc); (* DOUBLE EXCLAMATION MARK          *)
       20 : Result := AnsiChar($c2) + AnsiChar($b6);                 (* ¶ = Pilcrow Sing                 *)
       21 : Result := AnsiChar($c2) + AnsiChar($a7);                 (* § = Paragraph                    *)
       22 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($ac); (* BLACK RECTANGLE                  *)
       23 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($a8); (* UP DOWN ARROW WITH BASE          *)
       24 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($91); (* UPWARDS ARROW                    *)
       25 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($93); (* DOWNWARDS ARROW                  *)
       26 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($92); (* RIGHTWARDS ARROW                 *)
       27 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($90); (* LEFTWARDS ARROW                  *)
       28 : Result := AnsiChar($e2) + AnsiChar($88) + AnsiChar($9f); (* RIGHT ANGLE                      *)
       29 : Result := AnsiChar($e2) + AnsiChar($86) + AnsiChar($94); (* LEFT RIGHT ARROW                 *)
       30 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($b2); (* BLACK UP-POINTING TRIANGLE       *)
       31 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($bc); (* BLACK DOWN-POINTING TRIANGLE     *)
   (*  32 .. 126 are equal in UTF8 *)
      127 : Result := AnsiChar($e2) + AnsiChar($8c) + AnsiChar($82); (* House                            *)
      (* In CP850 128=Ç is used for the € Euro-Sign, therefor we translate                               *)
      (* chr(128) to € Euro-sign                                                                         *)
   (* 128 : Result := AnsiChar($c3) + AnsiChar($87);                Ç = C mit Akzent unten               *)
      128 : Result := AnsiChar($e2) + AnsiChar($82) + AnsiChar($ac);  (* Euro-Sign                            *)
      129 : Result := AnsiChar($c3) + AnsiChar($bc);             (* ü = übermut klein                    *)
      130 : Result := AnsiChar($c3) + AnsiChar($a9);             (* é = René (e mit ')                   *)
      131 : Result := AnsiChar($c3) + AnsiChar($a2);             (* â = a mit Dach                       *)
      132 : Result := AnsiChar($c3) + AnsiChar($a4);             (* ä = ähnlich klein                    *)
      133 : Result := AnsiChar($c3) + AnsiChar($a0);             (* à = a mit invers '                   *)
      134 : Result := AnsiChar($c3) + AnsiChar($a5);             (* å = a mit Ring                       *)
      135 : Result := AnsiChar($c3) + AnsiChar($a7);             (* ç = c mit , unten                    *)
      136 : Result := AnsiChar($c3) + AnsiChar($aa);             (* ê = e mit ^                          *)
      137 : Result := AnsiChar($c3) + AnsiChar($ab);             (* ë = e mit :                          *)
      138 : Result := AnsiChar($c3) + AnsiChar($a8);             (* è = e mit invers '                   *)
      139 : Result := AnsiChar($c3) + AnsiChar($af);             (* ï = i mit :                          *)
      140 : Result := AnsiChar($c3) + AnsiChar($ae);             (* î = i mit ^                          *)
      141 : Result := AnsiChar($c3) + AnsiChar($ac);             (* ì = i mit invers '                   *)
      142 : Result := AnsiChar($c3) + AnsiChar($84);             (* Ä = Ähnlich gross                    *)
      143 : Result := AnsiChar($c3) + AnsiChar($85);             (* Å = A mit Ring                       *)
      144 : Result := AnsiChar($c3) + AnsiChar($89);             (* É = E mit '                          *)
      145 : Result := AnsiChar($c3) + AnsiChar($a6);             (* æ = ae Minuskel                      *)
      146 : Result := AnsiChar($c3) + AnsiChar($86);             (* Æ = AE Majuskel                      *)
      147 : Result := AnsiChar($c3) + AnsiChar($b4);             (* ô = kleines o mit Dach               *)
      148 : Result := AnsiChar($c3) + AnsiChar($b6);             (* ö = ökologie klein                   *)
      149 : Result := AnsiChar($c3) + AnsiChar($b2);             (* ò = o mit invers '                   *)
      150 : Result := AnsiChar($c3) + AnsiChar($bb);             (* û = kleines u mit Dach               *)
      151 : Result := AnsiChar($c3) + AnsiChar($b9);             (* ù = kl. u mit invers '               *)
      152 : Result := AnsiChar($c3) + AnsiChar($bf);             (* ÿ = kleines y mit :                  *)
      153 : Result := AnsiChar($c3) + AnsiChar($96);             (* Ö = Ökologie gross                   *)
      154 : Result := AnsiChar($c3) + AnsiChar($9c);             (* Ü = Übermut gross                    *)
      155 : Result := AnsiChar($c3) + AnsiChar($b8);             (* ø = kleines o durchgestrichen        *)
      156 : Result := AnsiChar($c2) + AnsiChar($a3);             (* £ = Pfund-Zeichen GBP                *)
      157 : Result := AnsiChar($c3) + AnsiChar($98);             (* Ø = großes O durchgestrichen         *)
      158 : Result := AnsiChar($c3) + AnsiChar($97);             (* x = Multiplikation-Sign nicht        *)
      159 : Result := AnsiChar($c6) + AnsiChar($92);             (* ƒ = geschwungenes f (minuscule)      *)
      160 : Result := AnsiChar($c3) + AnsiChar($a1);             (* á = a mit '                          *)
      161 : Result := AnsiChar($c3) + AnsiChar($ad);             (* í = i mit '                          *)
      162 : Result := AnsiChar($c3) + AnsiChar($b3);             (* ó = o mit '                          *)
      163 : Result := AnsiChar($c3) + AnsiChar($ba);             (* ú = kleines u mit '                  *)
      164 : Result := AnsiChar($c3) + AnsiChar($b1);             (* ñ = kleines n mit ~                  *)
      165 : Result := AnsiChar($c3) + AnsiChar($91);             (* Ñ = großes N mit ~                   *)
      166 : Result := AnsiChar($c2) + AnsiChar($aa);             (* ª = hogestelltes kleines a           *)
      167 : Result := AnsiChar($c2) + AnsiChar($ba);             (* º = hogestelltes kleines o           *)
      168 : Result := AnsiChar($c2) + AnsiChar($bf);             (* ¿ = auf den Kopf gestelltes ?        *)
      169 : Result := AnsiChar($c2) + AnsiChar($ae);             (* ® = Registrierte Marke               *)
      170 : Result := AnsiChar($c2) + AnsiChar($ac);             (* ¬ = Negation                         *)
      171 : Result := AnsiChar($c2) + AnsiChar($bd);             (* ½ = 1/2                              *)
      172 : Result := AnsiChar($c2) + AnsiChar($bc);             (* ¼ = 1/4                              *)
      173 : Result := AnsiChar($c2) + AnsiChar($a1);             (* ¡ = ! umgedreht                      *)
      174 : Result := AnsiChar($c2) + AnsiChar($ab);             (* « = << doppeltes <                   *)
      175 : Result := AnsiChar($c2) + AnsiChar($bb);             (* » = >> doppeltes >                   *)
      176 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($91);  (* ░ = Helle Schattierung               *)
      177 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($92);  (* ▒ = Mittlere Schattierung            *)
      178 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($93);  (* ▓ = Dunkle Schattierung              *)
      179 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($82);  (* │ = Senkrechter Strich               *)
      180 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($a4);  (* ┤ = Senkrecht Mittelstrich links     *)
      181 : Result := AnsiChar($c3) + AnsiChar($81);             (* Á = großes A mit '                   *)
      182 : Result := AnsiChar($c3) + AnsiChar($82);             (* Â = großes A mit ^                   *)
      183 : Result := AnsiChar($c3) + AnsiChar($80);             (* À = großes A mit invers '            *)
      184 : Result := AnsiChar($c2) + AnsiChar($a9);             (* © = Copyright Zeichen                *)
      185 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($a3);  (* ╣ = Doppelstrich T nach links        *)
      186 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($91);  (* ║ = Doppelstrich senkrecht           *)
      187 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($97);  (* ╗ = Doppelstrich Ecke rechts oben    *)
      188 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($9d);  (* ╝ = Doppelstrich Ecke rechts unten   *)
      189 : Result := AnsiChar($c2) + AnsiChar($a2);             (* ¢ = kleines c mit Strichen Cent-Sign *)
      190 : Result := AnsiChar($c2) + AnsiChar($a5);             (* ¥ = Japanisches Yen                  *)
      (* 191 .. 197 : Box-Drawing-Letter *)
      191 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($90);  (* ┐ = Ecke rechts oben                 *)
      192 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($94);  (* └ = Ecke links unten                 *)
      193 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($b4);  (* ┴ = Wagrecht mit Mittelstrich oben   *)
      194 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($ac);  (* ┬ = Wagrecht mit Mittelstrich unten  *)
      195 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($9c);  (* ├ = Senkrecht mit Mittelstrich rechts*)
      196 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($80);  (* ─ = Wagrechter Strich                *)
      197 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($bc);  (* ┼ = Wagrecht und senkrecht Kreuz     *)
      198 : Result := AnsiChar($c3) + AnsiChar($a3);             (* ã = kleines a mit ~                  *)
      199 : Result := AnsiChar($c3) + AnsiChar($83);             (* Ã = großes A mit ~                   *)
      200 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($9a);  (* ╚ = Doppelstrich Ecke links unten    *)
      201 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($94);  (* ╔ = Doppelstrich Ecke links oben     *)
      202 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($a9);  (* ╩ = Doppelstrich T auf dem Kopf      *)
      203 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($a6);  (* ╦ = Doppelstrich T                   *)
      204 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($a0);  (* ╠ = Doppelstrich T nach rechts       *)
      205 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($90);  (* ═ = Doppelstrich waagrecht           *)
      206 : Result := AnsiChar($e2) + AnsiChar($95) + AnsiChar($ac);  (* ╬ = Doppelstrich Kreuz               *)
      207 : Result := AnsiChar($c2) + AnsiChar($a4);             (* ¤ = Currency Sign = kleines o mit 4' *)
      208 : Result := AnsiChar($c3) + AnsiChar($b0);             (* ð = kleines Eth                      *)
      209 : Result := AnsiChar($c3) + AnsiChar($90);             (* Ð = großes Eth                       *)
      210 : Result := AnsiChar($c3) + AnsiChar($8a);             (* Ê = großes E mit ^                   *)
      211 : Result := AnsiChar($c3) + AnsiChar($8b);             (* Ë = großes E mit :                   *)
      212 : Result := AnsiChar($c3) + AnsiChar($88);             (* È = großes E mit invers '            *)
      213 : Result := AnsiChar($c4) + AnsiChar($b1);             (* ı = griechischer Buchstabe i         *)
      214 : Result := AnsiChar($c3) + AnsiChar($8d);             (* Í = großes I mit '                   *)
      215 : Result := AnsiChar($c3) + AnsiChar($8e);             (* Î = großes I mit ^                   *)
      216 : Result := AnsiChar($c3) + AnsiChar($8f);             (* Ï = großes I mit :                   *)
      217 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($98);  (* ┘ = Ecke rechts unten                *)
      218 : Result := AnsiChar($e2) + AnsiChar($94) + AnsiChar($8c);  (* ┌ = Ecke links oben                  *)
      219 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($88);  (* █ = Voller Block                     *)
      220 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($84);  (* ▄ = Halber Block unten               *)
      221 : Result := AnsiChar($c2) + AnsiChar($a6);             (* ¦ = broken vertical bar              *)
      222 : Result := AnsiChar($c3) + AnsiChar($8c);             (* Ì = großes I mit invers '            *)
      223 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($80);  (* ▄ = Halber Block oben                *)
      224 : Result := AnsiChar($c3) + AnsiChar($93);             (* Ó = großes O mit '                   *)
      225 : Result := AnsiChar($c3) + AnsiChar($9f);             (* ß = ss scharfes S                    *)
      226 : Result := AnsiChar($c3) + AnsiChar($94);             (* Ô = großes O mit ^                   *)
      227 : Result := AnsiChar($c3) + AnsiChar($92);             (* Ò = großes O mit invers '            *)
      228 : Result := AnsiChar($c3) + AnsiChar($b5);             (* õ = kleines o mit ~                  *)
      229 : Result := AnsiChar($c3) + AnsiChar($95);             (* õ = großes O mit ~                   *)
      230 : Result := AnsiChar($c2) + AnsiChar($b5);             (* µ = My griechischer Buchstabe        *)
      231 : Result := AnsiChar($c3) + AnsiChar($e9);             (* þ = groß Thorn englischer Buchstabe  *)
      232 : Result := AnsiChar($c3) + AnsiChar($be);             (* Þ = klein Thorn englischer Buchstabe *)
      233 : Result := AnsiChar($c3) + AnsiChar($9a);             (* Ú = großes U mit '                   *)
      234 : Result := AnsiChar($c3) + AnsiChar($9b);             (* Û = großes U mit ^                   *)
      235 : Result := AnsiChar($c3) + AnsiChar($99);             (* Ù = großes U mit invers '            *)
      236 : Result := AnsiChar($c3) + AnsiChar($bd);             (* ý = kleines y mit '                  *)
      237 : Result := AnsiChar($c3) + AnsiChar($9d);             (* Ý = großes y mit '                   *)
      238 : Result := AnsiChar($c2) + AnsiChar($af);             (* ¯ = Markon / Überstrich              *)
      239 : Result := AnsiChar($c2) + AnsiChar($b4);             (* ´ = Hochkomma links                  *)
      240 : Result := AnsiChar($c2) + AnsiChar($ad);             (* ­ = SHY = Weiches Trennzeichen       *)
      241 : Result := AnsiChar($c2) + AnsiChar($b1);             (* ± = +/- PlusMinus                    *)
      242 : Result := AnsiChar($cc) + AnsiChar($b2);             (* ‗ = Doppelter Unterstrich            *)
      243 : Result := AnsiChar($c2) + AnsiChar($be);             (* ¾ = 3/4                              *)
      244 : Result := AnsiChar($c2) + AnsiChar($b6);             (* ¶ = Pilcrow Sing                     *)
      245 : Result := AnsiChar($c2) + AnsiChar($a7);             (* § = Paragraph                        *)
      246 : Result := AnsiChar($c3) + AnsiChar($b7);             (* ÷ = Obelus/Geteiltzeichen            *)
      247 : Result := AnsiChar($c2) + AnsiChar($b8);             (* ¸ = Cedilla/Cedille                  *)
      248 : Result := AnsiChar($c2) + AnsiChar($b0);             (* ° = Grad Zeichen                     *)
      249 : Result := AnsiChar($c2) + AnsiChar($a8);             (* ¨ = Diaeresis/Trema                  *)
      250 : Result := AnsiChar($c2) + AnsiChar($b7);             (* · = Mittiger Punkt                   *)
      251 : Result := AnsiChar($c2) + AnsiChar($b9);             (* ¹ = Hochgestellte 1                  *)
      252 : Result := AnsiChar($c2) + AnsiChar($b3);             (* ³ = Hochgestellte 3                  *)
      253 : Result := AnsiChar($c2) + AnsiChar($b2);             (* ² = Hochgestellte 2                  *)
      254 : Result := AnsiChar($e2) + AnsiChar($96) + AnsiChar($a0);  (* ■ = Schwarzes Quadrat in der Mitte   *)
      255 : Result := AnsiChar($c2) + AnsiChar($a0);             (*   = NBSP non-breaking space / geschütztes Leerzeichen *)
    end;
  end;
end;

Function  Char_CP850_Unicode(ch:AnsiChar) : WideChar;
begin
  Result := WideChar(ch);
  case ord(ch) of
      1 : Result := WideChar($263A);     (* ☺ = Smily white                      *)
      2 : Result := WideChar($263B);     (* ☻ = Smily black                      *)
      3 : Result := WideChar($2665);     (* ♥ = Herz  black                      *)
      4 : Result := WideChar($2666);     (* ♦ = Karro black                      *)
      5 : Result := WideChar($2663);     (* ♣ = Kreuz black                      *)
      6 : Result := WideChar($2660);     (* ♠ = Pik black                        *)
      7 : Result := WideChar($2022);     (* • = BULLET                           *)
      8 : Result := WideChar($25D8);     (* ◘ = INVERSE BULLET                   *)
      9 : Result := WideChar($25CB);     (* ○ = White Circle                     *)
     10 : Result := WideChar($25D9);     (* ◙ = Inverse White Circle             *)
     11 : Result := WideChar($2642);     (* ♂ = Male-Symbol                      *)
     12 : Result := WideChar($2640);     (* ♀ = Female-Symbol                    *)
     13 : Result := WideChar($266A);     (* ♪ = EIGHTH NOTE                      *)
     14 : Result := WideChar($266B);     (* ♫ = BEAMED EIGHTH NOTES              *)
     15 : Result := WideChar($263C);     (* ☼ = WHITE SUN WITH RAYS              *)
     16 : Result := WideChar($25BA);     (* ► = BLACK RIGHT-POINTING POINTER     *)
     17 : Result := WideChar($25C4);     (* ◄ = BLACK LEFT-POINTING POINTER      *)
     18 : Result := WideChar($2195);     (* ↕ = UP DOWN ARROW                    *)
     19 : Result := WideChar($203C);     (* ‼ = DOUBLE EXCLAMATION MARK          *)
     20 : Result := WideChar($00B6);     (* ¶ = Pilcrow Sing                     *)
     21 : Result := WideChar($00A7);     (* § = Paragraph                        *)
     22 : Result := WideChar($25AC);     (* ▬ = BLACK RECTANGLE                  *)
     23 : Result := WideChar($21A8);     (* ↨ = UP DOWN ARROW WITH BASE          *)
     24 : Result := WideChar($2191);     (* ↑ = UPWARDS ARROW                    *)
     25 : Result := WideChar($2193);     (* ↓ = DOWNWARDS ARROW                  *)
     26 : Result := WideChar($2192);     (* → = RIGHTWARDS ARROW                 *)
     27 : Result := WideChar($2190);     (* ← = LEFTWARDS ARROW                  *)
     28 : Result := WideChar($221F);     (* ∟ = RIGHT ANGLE                      *)
     29 : Result := WideChar($2194);     (* ↔ = LEFT RIGHT ARROW                 *)
     30 : Result := WideChar($25B2);     (* ▲ = BLACK UP-POINTING TRIANGLE       *)
     31 : Result := WideChar($25BC);     (* ▼ = BLACK DOWN-POINTING TRIANGLE     *)
     32 .. 126 : Result := WideChar(ord(ch));
    127 : Result := WideChar($2302);     (* ⌂ = House                            *)
    (* In CP850 we use 128=Ç for the € Euro-Sign, therefor we translate          *)
    (* chr(128) to € Euro-sign                                                   *)
 (* 128 : Result := WideChar($00C7);     Ç = C mit Akzent unten                  *)
    128 : Result := WideChar($20AC);     (* € = Euro-Sign                        *)
    129 : Result := WideChar($00FC);     (* ü                                    *)
    130 : Result := WideChar($00E9);     (* é                                    *)
    131 : Result := WideChar($00E2);     (* â                                    *)
    132 : Result := WideChar($00E4);     (* ä                                    *)
    133 : Result := WideChar($00E0);     (* à                                    *)
    134 : Result := WideChar($00E5);     (* å                                    *)
    135 : Result := WideChar($00E7);     (* ç                                    *)
    136 : Result := WideChar($00EA);     (* ê                                    *)
    137 : Result := WideChar($00EB);     (* ë                                    *)
    138 : Result := WideChar($00E8);     (* è                                    *)
    139 : Result := WideChar($00EF);     (* ï                                    *)
    140 : Result := WideChar($00EE);     (* î                                    *)
    141 : Result := WideChar($00EC);     (* ì                                    *)
    142 : Result := WideChar($00C4);     (* Ä                                    *)
    143 : Result := WideChar($00C5);     (* Å                                    *)
    144 : Result := WideChar($00C9);     (* É                                    *)
    145 : Result := WideChar($00E6);     (* æ                                    *)
    146 : Result := WideChar($00C6);     (* Æ                                    *)
    147 : Result := WideChar($00F4);     (* ô                                    *)
    148 : Result := WideChar($00F6);     (* ö                                    *)
    149 : Result := WideChar($00F2);     (* ò                                    *)
    150 : Result := WideChar($00FB);     (* û                                    *)
    151 : Result := WideChar($00F9);     (* ù                                    *)
    152 : Result := WideChar($00FF);     (* ÿ                                    *)
    153 : Result := WideChar($00D6);     (* Ö                                    *)
    154 : Result := WideChar($00DC);     (* Ü                                    *)
    155 : Result := WideChar($00F8);     (* ø                                    *)
    156 : Result := WideChar($00A3);     (* £                                    *)
    157 : Result := WideChar($00D8);     (* Ø                                    *)
    158 : Result := WideChar($00D7);     (* ×                                    *)
    159 : Result := WideChar($0192);     (* ƒ                                    *)
    160 : Result := WideChar($00E1);     (* á                                    *)
    161 : Result := WideChar($00ED);     (* í                                    *)
    162 : Result := WideChar($00F3);     (* ÿ                                    *)
    163 : Result := WideChar($00FA);     (* ú                                    *)
    164 : Result := WideChar($00F1);     (* ñ                                    *)
    165 : Result := WideChar($00D1);     (* Ñ                                    *)
    166 : Result := WideChar($00AA);     (* ª                                    *)
    167 : Result := WideChar($00BA);     (* º                                    *)
    168 : Result := WideChar($00BF);     (* ¿                                    *)
    169 : Result := WideChar($00AE);     (* ®                                    *)
    170 : Result := WideChar($00AC);     (* ¬                                    *)
    171 : Result := WideChar($00BD);     (* ½                                    *)
    172 : Result := WideChar($00BC);     (* ¼                                    *)
    173 : Result := WideChar($00A1);     (* ¡                                    *)
    174 : Result := WideChar($00AB);     (* «                                    *)
    175 : Result := WideChar($00BB);     (* »                                    *)
    176 : Result := WideChar($2591);     (* ░                                    *)
    177 : Result := WideChar($2592);     (* ▒                                    *)
    178 : Result := WideChar($2593);     (* ▓                                    *)
    179 : Result := WideChar($2502);     (* │                                    *)
    180 : Result := WideChar($2524);     (* ┤                                    *)
    181 : Result := WideChar($00C1);     (* Á                                    *)
    182 : Result := WideChar($00C2);     (* Â                                    *)
    183 : Result := WideChar($00C0);     (* À                                    *)
    184 : Result := WideChar($00A9);     (* ©                                    *)
    185 : Result := WideChar($2563);     (* ╣ = Box drawing character            *)
    186 : Result := WideChar($2551);     (* ║                                    *)
    187 : Result := WideChar($2557);     (* ╗                                    *)
    188 : Result := WideChar($255D);     (* ╝                                    *)
    189 : Result := WideChar($00A2);     (* ¢                                    *)
    190 : Result := WideChar($00A5);     (* ¥                                    *)
    191 : Result := WideChar($2510);     (* ┐                                    *)
    192 : Result := WideChar($2514);     (* └                                    *)
    193 : Result := WideChar($2534);     (* ┴                                    *)
    194 : Result := WideChar($252C);     (* ┬                                    *)
    195 : Result := WideChar($251C);     (* ├                                    *)
    196 : Result := WideChar($2500);     (* ─                                    *)
    197 : Result := WideChar($253C);     (* ┼                                    *)
    198 : Result := WideChar($00E3);     (* ã                                    *)
    199 : Result := WideChar($00C3);     (* Ã                                    *)
    200 : Result := WideChar($255A);     (* ╚                                    *)
    201 : Result := WideChar($2554);     (* ╔                                    *)
    202 : Result := WideChar($2569);     (* ╩                                    *)
    203 : Result := WideChar($2566);     (* ╦                                    *)
    204 : Result := WideChar($2560);     (* ╠                                    *)
    205 : Result := WideChar($2550);     (* ═                                    *)
    206 : Result := WideChar($256C);     (* ╬                                    *)
    207 : Result := WideChar($00A4);     (* ¤                                    *)
    208 : Result := WideChar($00F0);     (* ð                                    *)
    209 : Result := WideChar($00D0);     (* Ð                                    *)
    210 : Result := WideChar($00CA);     (* Ê                                    *)
    211 : Result := WideChar($00CB);     (* Ë                                    *)
    212 : Result := WideChar($00C8);     (* È                                    *)
    213 : Result := WideChar($0131);     (* ı                                    *)
    214 : Result := WideChar($00CD);     (* Í                                    *)
    215 : Result := WideChar($00CE);     (* Î                                    *)
    216 : Result := WideChar($00CF);     (* Ï                                    *)
    217 : Result := WideChar($2518);     (* ┘                                    *)
    218 : Result := WideChar($250C);     (* ┌                                    *)
    219 : Result := WideChar($2588);     (* █                                    *)
    220 : Result := WideChar($2584);     (* ▄                                    *)
    221 : Result := WideChar($00A6);     (* ¦                                    *)
    222 : Result := WideChar($00CC);     (* Ì                                    *)
    223 : Result := WideChar($2580);     (* ▀                                    *)
    224 : Result := WideChar($00D3);     (* Ó                                    *)
    225 : Result := WideChar($00DF);     (* ß                                    *)
    226 : Result := WideChar($00D4);     (* Ô                                    *)
    227 : Result := WideChar($00D2);     (* Ò                                    *)
    228 : Result := WideChar($00F5);     (* õ                                    *)
    229 : Result := WideChar($00D5);     (* Õ                                    *)
    230 : Result := WideChar($00B5);     (* µ                                    *)
    231 : Result := WideChar($00FE);     (* þ                                    *)
    232 : Result := WideChar($00DE);     (* Þ                                    *)
    233 : Result := WideChar($00DA);     (* Ú                                    *)
    234 : Result := WideChar($00DB);     (* Û                                    *)
    235 : Result := WideChar($00D9);     (* Ù                                    *)
    236 : Result := WideChar($00FD);     (* ý                                    *)
    237 : Result := WideChar($00DD);     (* Ý                                    *)
    238 : Result := WideChar($00AF);     (* ¯                                    *)
    239 : Result := WideChar($00B4);     (* ´                                    *)
    240 : Result := WideChar($00AD);     (* SHY = Soft hyphen                    *)
    241 : Result := WideChar($00B1);     (* ±                                    *)
    242 : Result := WideChar($2017);     (* ‗ = double underscore                *)
    243 : Result := WideChar($00BE);     (* ¾ = 3/4                              *)
    244 : Result := WideChar($00B6);     (* ¶                                    *)
    245 : Result := WideChar($00A7);     (* §                                    *)
    246 : Result := WideChar($00F7);     (* ÷                                    *)
    247 : Result := WideChar($00B8);     (* ¸                                    *)
    248 : Result := WideChar($00B0);     (* °                                    *)
    249 : Result := WideChar($00A8);     (* ¨                                    *)
    250 : Result := WideChar($00B7);     (* ·                                    *)
    251 : Result := WideChar($00B9);     (* ¹                                    *)
    252 : Result := WideChar($00B3);     (* ³                                    *)
    253 : Result := WideChar($00B2);     (* ²                                    *)
    254 : Result := WideChar($25A0);     (* ■                                    *)
    255 : Result := WideChar($00A0);     (* NBSP = Non-breaking space            *)
  end;
end;

Function  Char_Unicode_CP850(ch:WideChar) : AnsiChar;
begin
  // Result := AnsiChar(ch);
  case ord(ch) of
    $263A : Result := #1;             (* ☺ = Smily white                      *)
    $263B : Result := #2;             (* ☻ = Smily black                      *)
    $2665 : Result := #3;             (* ♥ = Herz  black                      *)
    $2666 : Result := #4;             (* ♦ = Karro black                      *)
    $2663 : Result := #5;             (* ♣ = Kreuz black                      *)
    $2660 : Result := #6;             (* ♠ = Pik black                        *)
    $2022 : Result := #7;             (* • = BULLET                           *)
    $25D8 : Result := #8;             (* ◘ = INVERSE BULLET                   *)
    $25CB : Result := #9;             (* ○ = White Circle                     *)
    $25D9 : Result := #10;            (* ◙ = Inverse White Circle             *)
    $2642 : Result := #11;            (* ♂ = Male-Symbol                      *)
    $2640 : Result := #12;            (* ♀ = Female-Symbol                    *)
    $266A : Result := #13;            (* ♪ = EIGHTH NOTE                      *)
    $266B : Result := #14;            (* ♫ = BEAMED EIGHTH NOTES              *)
    $263C : Result := #15;            (* ☼ = WHITE SUN WITH RAYS              *)
    $25BA : Result := #16;            (* ► = BLACK RIGHT-POINTING POINTER     *)
    $25C4 : Result := #17;            (* ◄ = BLACK LEFT-POINTING POINTER      *)
    $2195 : Result := #18;            (* ↕ = UP DOWN ARROW                    *)
    $203C : Result := #19;            (* ‼ = DOUBLE EXCLAMATION MARK          *)
    $00B6 : Result := #20;            (* ¶ = Pilcrow Sing                     *)
    $00A7 : Result := #21;            (* § = Paragraph                        *)
    $25AC : Result := #22;            (* ▬ = BLACK RECTANGLE                  *)
    $21A8 : Result := #23;            (* ↨ = UP DOWN ARROW WITH BASE          *)
    $2191 : Result := #24;            (* ↑ = UPWARDS ARROW                    *)
    $2193 : Result := #25;            (* ↓ = DOWNWARDS ARROW                  *)
    $2192 : Result := #26;            (* → = RIGHTWARDS ARROW                 *)
    $2190 : Result := #27;            (* ← = LEFTWARDS ARROW                  *)
    $221F : Result := #28;            (* ∟ = RIGHT ANGLE                      *)
    $2194 : Result := #29;            (* ↔ = LEFT RIGHT ARROW                 *)
    $25B2 : Result := #30;            (* ▲ = BLACK UP-POINTING TRIANGLE       *)
    $25BC : Result := #31;            (* ▼ = BLACK DOWN-POINTING TRIANGLE     *)
    $0020 .. $007E : Result := AnsiChar(Lo(ord(ch))); (* #32 .. #126          *)
    $2302 : Result := #127;           (* ⌂ = House                            *)
    (* In CP850 we use 128=Ç for the € Euro-Sign, therefor we translate       *)
    (* chr(128) to € Euro-sign                                                *)
 (* $00C7 : Result := #128;              Ç                                    *)
    $20AC : Result := #128;           (* € = Euro-Sign                        *)
    $00FC : Result := #129;           (* ü                                    *)
    $00E9 : Result := #130;           (* é                                    *)
    $00E2 : Result := #131;           (* â                                    *)
    $00E4 : Result := #132;           (* ä                                    *)
    $00E0 : Result := #133;           (* à                                    *)
    $00E5 : Result := #134;           (* å                                    *)
    $00E7 : Result := #135;           (* ç                                    *)
    $00EA : Result := #136;           (* ê                                    *)
    $00EB : Result := #137;           (* ë                                    *)
    $00E8 : Result := #138;           (* è                                    *)
    $00EF : Result := #139;           (* ï                                    *)
    $00EE : Result := #140;           (* î                                    *)
    $00EC : Result := #141;           (* ì                                    *)
    $00C4 : Result := #142;           (* Ä                                    *)
    $00C5 : Result := #143;           (* Å                                    *)
    $00C9 : Result := #144;           (* É                                    *)
    $00E6 : Result := #145;           (* æ                                    *)
    $00C6 : Result := #146;           (* Æ                                    *)
    $00F4 : Result := #147;           (* ô                                    *)
    $00F6 : Result := #148;           (* ö                                    *)
    $00F2 : Result := #149;           (* ò                                    *)
    $00FB : Result := #150;           (* û                                    *)
    $00F9 : Result := #151;           (* ù                                    *)
    $00FF : Result := #152;           (* ÿ                                    *)
    $00D6 : Result := #153;           (* Ö                                    *)
    $00DC : Result := #154;           (* Ü                                    *)
    $00F8 : Result := #155;           (* ø                                    *)
    $00A3 : Result := #156;           (* £                                    *)
    $00D8 : Result := #157;           (* Ø                                    *)
    $00D7 : Result := #158;           (* ×                                    *)
    $0192 : Result := #159;           (* ƒ                                    *)
    $00E1 : Result := #160;           (* á                                    *)
    $00ED : Result := #161;           (* í                                    *)
    $00F3 : Result := #162;           (* ÿ                                    *)
    $00FA : Result := #163;           (* ú                                    *)
    $00F1 : Result := #164;           (* ñ                                    *)
    $00D1 : Result := #165;           (* Ñ                                    *)
    $00AA : Result := #166;           (* ª                                    *)
    $00BA : Result := #167;           (* º                                    *)
    $00BF : Result := #168;           (* ¿                                    *)
    $00AE : Result := #169;           (* ®                                    *)
    $00AC : Result := #170;           (* ¬                                    *)
    $00BD : Result := #171;           (* ½                                    *)
    $00BC : Result := #172;           (* ¼                                    *)
    $00A1 : Result := #173;           (* ¡                                    *)
    $00AB : Result := #174;           (* «                                    *)
    $00BB : Result := #175;           (* »                                    *)
    $2591 : Result := #176;           (* ░                                    *)
    $2592 : Result := #177;           (* ▒                                    *)
    $2593 : Result := #178;           (* ▓                                    *)
    $2502 : Result := #179;           (* │                                    *)
    $2524 : Result := #180;           (* ┤                                    *)
    $00C1 : Result := #181;           (* Á                                    *)
    $00C2 : Result := #182;           (* Â                                    *)
    $00C0 : Result := #183;           (* À                                    *)
    $00A9 : Result := #184;           (* ©                                    *)
    $2563 : Result := #185;           (* ╣ = Box drawing character            *)
    $2551 : Result := #186;           (* ║                                    *)
    $2557 : Result := #187;           (* ╗                                    *)
    $255D : Result := #188;           (* ╝                                    *)
    $00A2 : Result := #189;           (* ¢                                    *)
    $00A5 : Result := #190;           (* ¥                                    *)
    $2510 : Result := #191;           (* ┐                                    *)
    $2514 : Result := #192;           (* └                                    *)
    $2534 : Result := #193;           (* ┴                                    *)
    $252C : Result := #194;           (* ┬                                    *)
    $251C : Result := #195;           (* ├                                    *)
    $2500 : Result := #196;           (* ─                                    *)
    $253C : Result := #197;           (* ┼                                    *)
    $00E3 : Result := #198;           (* ã                                    *)
    $00C3 : Result := #199;           (* Ã                                    *)
    $255A : Result := #200;           (* ╚                                    *)
    $2554 : Result := #201;           (* ╔                                    *)
    $2569 : Result := #202;           (* ╩                                    *)
    $2566 : Result := #203;           (* ╦                                    *)
    $2560 : Result := #204;           (* ╠                                    *)
    $2550 : Result := #205;           (* ═                                    *)
    $256C : Result := #206;           (* ╬                                    *)
    $00A4 : Result := #207;           (* ¤                                    *)
    $00F0 : Result := #208;           (* ð                                    *)
    $00D0 : Result := #209;           (* Ð                                    *)
    $00CA : Result := #210;           (* Ê                                    *)
    $00CB : Result := #211;           (* Ë                                    *)
    $00C8 : Result := #212;           (* È                                    *)
    $0131 : Result := #213;           (* ı                                    *)
    $00CD : Result := #214;           (* Í                                    *)
    $00CE : Result := #215;           (* Î                                    *)
    $00CF : Result := #216;           (* Ï                                    *)
    $2518 : Result := #217;           (* ┘                                    *)
    $250C : Result := #218;           (* ┌                                    *)
    $2588 : Result := #219;           (* █                                    *)
    $2584 : Result := #220;           (* ▄                                    *)
    $00A6 : Result := #221;           (* ¦                                    *)
    $00CC : Result := #222;           (* Ì                                    *)
    $2580 : Result := #223;           (* ▀                                    *)
    $00D3 : Result := #224;           (* Ó                                    *)
    $00DF : Result := #225;           (* ß                                    *)
    $00D4 : Result := #226;           (* Ô                                    *)
    $00D2 : Result := #227;           (* Ò                                    *)
    $00F5 : Result := #228;           (* õ                                    *)
    $00D5 : Result := #229;           (* Õ                                    *)
    $00B5 : Result := #230;           (* µ                                    *)
    $00FE : Result := #231;           (* þ                                    *)
    $00DE : Result := #232;           (* Þ                                    *)
    $00DA : Result := #233;           (* Ú                                    *)
    $00DB : Result := #234;           (* Û                                    *)
    $00D9 : Result := #235;           (* Ù                                    *)
    $00FD : Result := #236;           (* ý                                    *)
    $00DD : Result := #237;           (* Ý                                    *)
    $00AF : Result := #238;           (* ¯                                    *)
    $00B4 : Result := #239;           (* ´                                    *)
    $00AD : Result := #240;           (* SHY = Soft hyphen                    *)
    $00B1 : Result := #241;           (* ±                                    *)
    $2017 : Result := #242;           (* ‗ = double underscore                *)
    $00BE : Result := #243;           (* ¾ = 3/4                              *)
    // $00B6 : Result := #244;        (* ¶, see $14 / #20                     *)
    // $00A7 : Result := #245;        (* §, see $15 / #21                     *)
    $00F7 : Result := #246;           (* ÷                                    *)
    $00B8 : Result := #247;           (* ¸                                    *)
    $00B0 : Result := #248;           (* °                                    *)
    $00A8 : Result := #249;           (* ¨                                    *)
    $00B7 : Result := #250;           (* ·                                    *)
    $00B9 : Result := #251;           (* ¹                                    *)
    $00B3 : Result := #252;           (* ³                                    *)
    $00B2 : Result := #253;           (* ²                                    *)
    _4_high : Result := '4';          (* ⁴                                    *)
    _5_high : Result := '5';          (* ⁵                                    *)
    _6_high : Result := '6';          (* ⁶                                    *)
    $25A0 : Result := #254;           (* ■                                    *)
    $00A0 : Result := #255;           (* NBSP = Non-breaking space            *)
  else
    Result := #63;                    (* ?                                    *)
  end;
end;

Function  Char_CP1252_CP850(ch:AnsiChar) : AnsiChar;  (* CP1252 -> CP850 *)
begin
  Result := ch;
  case ord(ch) of
 (* 128 : € = Euro-sign                                                     *)
 (* 129 : Not used in CP1252                                                *)
 (* 130 : ‚ SINGLE LOW-9 QUOTATION MARK, not in CP850                       *)
 (* 131 : ƒ LATIN SMALL LETTER F WITH HOOK, not in CP850                    *)
    132 : Result := AnsiChar(34);   (* „ = lower quotes -> " = upper quotes *)
 (* 133 : … Ellipsis, not in CP850                                          *)
    134 : Result := AnsiChar(43);   (* † = DAGGER       -> + = plus sign    *)
    135 : Result := AnsiChar(43);   (* ‡ = DOUBLE DAGGER-> + = plus sign    *)
    136 : Result := AnsiChar(94);   (* ˆ = MODIFIER LETTER CIRCUMFLEX ACCENT -> ^ *)
 (* 137 : ‰ Promill, not in CP850                                           *)
    138 : Result := 'S';            (* Š -> S                               *)
    139 : Result := AnsiChar(60);   (* ‹ = SINGLE LEFT-POINTING ANGLE QUOTATION MARK -> < *)
 (* 140 : Œ - CE-Sign, not in CP850                                         *)
 (* 141 : Not used in CP1252                                                *)
    142 : Result := 'Z';            (* Ž -> Z                               *)
 (* 143 : Not used in CP1252                                                *)
 (* 144 : Not used in CP1252                                                *)
    145 : Result := AnsiChar(27);   (* ‘ = upper quote  -> '                *)
    146 : Result := AnsiChar(27);   (* ’ = upper quote  -> '                *)
    147 : Result := AnsiChar(34);   (* “ = upper quotes -> " = upper quotes *)
    148 : Result := AnsiChar(34);   (* ” = upper quotes -> " = upper quotes *)
    149 : Result := AnsiChar(250);  (* • = BULLET       -> ·                *)
    150 : Result := AnsiChar(45);   (* – = Bindestrich  -> -                *)
    151 : Result := AnsiChar(196);  (* — = EM DASH      -> ─                *)
    152 : Result := AnsiChar(126);  (* ˜ = SMALL TILDE  -> ~                *)
 (* 153 : ™ Trademark-Sign, not in CP850                                    *)
    154 : Result := 's';            (* š -> s                               *)
    155 : Result := AnsiChar(62);   (* › = SINGLE RIGHT-POINTING ANGLE QUOTATION MARK -> > *)
    160 : Result := AnsiChar(255);  (*   = NBSP non-breaking space / geschütztes Leerzeichen *)
    161 : Result := AnsiChar(173);  (* ¡ = ! umgedreht                      *)
    162 : Result := AnsiChar(189);  (* ¢ = kleines c mit Strichen           *)
    163 : Result := AnsiChar(156);  (* £ = GBP (Pfund)                      *)
    164 : Result := AnsiChar(207);  (* ¤ = Currency Sign = kleines o mit 4' *)
    165 : Result := AnsiChar(190);  (* ¥ = Janische Jen Y mit =             *)
    166 : Result := AnsiChar(221);  (* ¦ = broken vertical bar              *)
    167 : Result := AnsiChar(245);  (* § = Paragraph                        *)
    168 : Result := AnsiChar(249);  (* ¨ = Diaeresis/Trema                  *)
    169 : Result := AnsiChar(184);  (* © = C mit Kreis Copyright Zeichen    *)
    170 : Result := AnsiChar(166);  (* ª = hogestelltes kleines a           *)
    171 : Result := AnsiChar(174);  (* « = <<                               *)
    172 : Result := AnsiChar(170);  (* ¬ = Negation                         *)
    173 : Result := AnsiChar(240);  (* ­ = SHY = Weiches Trennzeichen       *)
    174 : Result := AnsiChar(169);  (* ® = R mit Kreis Registrierte Marke   *)
    175 : Result := AnsiChar(238);  (* ¯ = Markon / Überstrich              *)
    176 : Result := AnsiChar(248);  (* ° = Grad-Zeichen                     *)
    177 : Result := AnsiChar(241);  (* ± = +/- Zeichen                      *)
    178 : Result := AnsiChar(253);  (* ² = Hochgestellte 2 (AltGr+2)        *)
    179 : Result := AnsiChar(252);  (* ³ = Hochgestellte 3 (AltGr+3)        *)
    180 : Result := AnsiChar(239);  (* ´ = Akut-Akzent (Hochkomma)          *)
    181 : Result := AnsiChar(230);  (* µ = My griechischer Buchstabe        *)
    182 : Result := AnsiChar(244);  (* ¶ = Pilcrow/Absatzzeichen            *)
    183 : Result := AnsiChar(250);  (* · = Interpunct/Mittelpunkt           *)
    184 : Result := AnsiChar(247);  (* ¸ = Cedilla/Cedille                  *)
    185 : Result := AnsiChar(251);  (* ¹ = Hochgestellte 1                  *)
    186 : Result := AnsiChar(167);  (* º = hogestelltes kleines o           *)
    187 : Result := AnsiChar(175);  (* » = >>                               *)
    188 : Result := AnsiChar(172);  (* ¼ = 1/4                              *)
    189 : Result := AnsiChar(171);  (* ½ = 1/2                              *)
    190 : Result := AnsiChar(243);  (* ¾ = 3/4 Dreiviertel                  *)
    191 : Result := AnsiChar(168);  (* ¿ = auf den Kopf gestelltes ?        *)
    192 : Result := AnsiChar(183);  (* À = großes A mit invers '            *)
    193 : Result := AnsiChar(181);  (* Á = großes A mit '                   *)
    194 : Result := AnsiChar(182);  (* Â = großes A mit ^                   *)
    195 : Result := AnsiChar(199);  (* Ã = großes A mit ~                   *)
    196 : Result := AnsiChar(142);  (* Ä = Ähnlich gross                    *)
    197 : Result := AnsiChar(143);  (* Å = A mit Ring                       *)
    198 : Result := AnsiChar(146);  (* Æ = AE Majuskel                      *)
 (* In CP850, chr(128)=Ç we use for €-Euro-sign, therefore we do not        *)
 (* translate chr(199)=Ç to chr(128) to avoid wrong €-signs                 *)
 (* 199 : Result := AnsiChar(128);     Ç = C mit Akzent unten               *)
    199 : Result := AnsiChar(67);   (* Ç convert to "C"                     *)
    200 : Result := AnsiChar(212);  (* È = großes E mit invers '            *)
    201 : Result := AnsiChar(144);  (* É = E mit '                          *)
    202 : Result := AnsiChar(210);  (* Ê = großes E mit ^                   *)
    203 : Result := AnsiChar(211);  (* Ë = großes E mit :                   *)
    204 : Result := AnsiChar(222);  (* ı = großes I mit invers '            *)
    205 : Result := AnsiChar(214);  (* ı = großes I mit '                   *)
    206 : Result := AnsiChar(215);  (* ı = großes I mit ^                   *)
    207 : Result := AnsiChar(216);  (* ı = großes I mit :                   *)
    208 : Result := AnsiChar(209);  (* Ð = großes Eth                       *)
    209 : Result := AnsiChar(165);  (* Ñ = großes N mit ~                   *)
    210 : Result := AnsiChar(227);  (* Ò = großes O mit invers '            *)
    211 : Result := AnsiChar(224);  (* Ó = großes O mit '                   *)
    212 : Result := AnsiChar(226);  (* Ô = großes O mit ^                   *)
    213 : Result := AnsiChar(229);  (* õ = großes O mit ~                   *)
    214 : Result := AnsiChar(153);  (* Ö = Ökologie gross                   *)
    216 : Result := AnsiChar(157);  (* Ø = großes O durchgestrichen         *)
    217 : Result := AnsiChar(235);  (* Ù = großes U mit invers '            *)
    218 : Result := AnsiChar(233);  (* Ú = großes U mit '                   *)
    219 : Result := AnsiChar(234);  (* Û = großes U mit ^                   *)
    220 : Result := AnsiChar(154);  (* Ü = Übermut gross                    *)
    221 : Result := AnsiChar(237);  (* Ý = großes y mit '                   *)
    222 : Result := AnsiChar(232);  (* Þ = klein Thorn englischer Buchstabe *)
    223 : Result := AnsiChar(225);  (* ß = ss                               *)
    224 : Result := AnsiChar(133);  (* à = a mit invers '                   *)
    225 : Result := AnsiChar(160);  (* á = a mit '                          *)
    226 : Result := AnsiChar(131);  (* â = a mit Dach                       *)
    227 : Result := AnsiChar(198);  (* ã = kleines a mit ~                  *)
    228 : Result := AnsiChar(132);  (* ä = ähnlich klein                    *)
    229 : Result := AnsiChar(134);  (* å = a mit Ring                       *)
    230 : Result := AnsiChar(145);  (* æ = ae Minuskel                      *)
    231 : Result := AnsiChar(135);  (* ç = c mit , unten                    *)
    232 : Result := AnsiChar(138);  (* è = e mit invers '                   *)
    233 : Result := AnsiChar(130);  (* é = René (e mit ')                   *)
    234 : Result := AnsiChar(136);  (* ê = e mit ^                          *)
    235 : Result := AnsiChar(137);  (* ë = e mit :                          *)
    236 : Result := AnsiChar(141);  (* ì = i mit invers '                   *)
    237 : Result := AnsiChar(161);  (* í = i mit '                          *)
    238 : Result := AnsiChar(140);  (* î = i mit ^                          *)
    239 : Result := AnsiChar(139);  (* ï = i mir :                          *)
    240 : Result := AnsiChar(208);  (* ð = kleines Eth                      *)
    241 : Result := AnsiChar(164);  (* ñ = kleines n mit ~                  *)
    242 : Result := AnsiChar(149);  (* ò = o mit invers '                   *)
    243 : Result := AnsiChar(162);  (* ó = o mit '                          *)
    244 : Result := AnsiChar(147);  (* ô = kleines o mit Dach               *)
    245 : Result := AnsiChar(228);  (* õ = kleines o mit ~                  *)
    246 : Result := AnsiChar(148);  (* ö = ökologie klein                   *)
    247 : Result := AnsiChar(246);  (* ÷ = Obelus/Geteiltzeichen            *)
    248 : Result := AnsiChar(155);  (* ø = kleines o durchgestrichen        *)
    249 : Result := AnsiChar(151);  (* ù = kleines u mit invers '           *)
    250 : Result := AnsiChar(163);  (* ú = kleines u mit '                  *)
    251 : Result := AnsiChar(150);  (* û = kleines u mit Dach               *)
    252 : Result := AnsiChar(129);  (* ü = übermut klein                    *)
    253 : Result := AnsiChar(236);  (* ý = kleines y mit '                  *)
    254 : Result := AnsiChar(231);  (* þ = groß Thorn englischer Buchstabe  *)
    255 : Result := AnsiChar(152);  (* ÿ = großes Y mit :                   *)
  end;
end;

Function  Char_CP1252_Unicode(ch:AnsiChar) : WideChar;
begin
  Result := Widechar(ch);
  case ord(ch) of
    128 : Result := WideChar($20AC);(* € = Euro-Sign                        *)
  end;
end;

Function  Char_Unicode_CP1252(wc:WideChar) : AnsiChar;
begin
  case ord(wc) of
    $0021 .. $007E : Result := AnsiChar(Lo(ord(wc))); (* #33 .. #126          *)
    $20AC : Result := #128;           (* € = Euro-Sign                        *)
    $201A : Result := #130;           (* ‚                                    *)
    $0192 : Result := #131;           (* ƒ                                    *)
    $201E : Result := #132;           (* „                                    *)
    $2026 : Result := #133;           (* …                                    *)
    $2020 : Result := #134;           (* †                                    *)
    $2021 : Result := #135;           (* ‡                                    *)
    $02C6 : Result := #136;           (* ˆ                                    *)
    $2030 : Result := #137;           (* ‰                                    *)
    $0160 : Result := #138;           (* Š                                    *)
    $2039 : Result := #139;           (* ‹                                    *)
    $0152 : Result := #140;           (* Œ                                    *)
    $017D : Result := #142;           (* Ž                                    *)
    $2018 : Result := #145;           (* ‘                                    *)
    $2019 : Result := #146;           (* ’                                    *)
    $201C : Result := #147;           (* “                                    *)
    $201D : Result := #148;           (* ”                                    *)
    $2022 : Result := #149;           (* • = BULLET                           *)
    $2013 : Result := #150;           (* –                                    *)
    $2014 : Result := #151;           (* —                                    *)
    $02DC : Result := #152;           (* ˜                                    *)
    $2122 : Result := #153;           (* ™                                    *)
    $0161 : Result := #154;           (* š                                    *)
    $203A : Result := #155;           (* ›                                    *)
    $0153 : Result := #156;           (* œ                                    *)
    $017E : Result := #158;           (* ž                                    *)
    $0178 : Result := #159;           (* Ÿ                                    *)
    // $00A0 .. $00FF | #160 .. #255 is equal to CP1252
    $00A0 .. $00FF : Result := AnsiChar(Lo(ord(wc)));
    // $00A0 : Result := #160;           (* NBSP = Non-breaking space            *)
    // $00A1 : Result := #161;           (* ¡ = Inverted Exclamation Mark        *)
    // $00A2 : Result := #162;           (* ¢ = Cent Sign                        *)
    // $00A3 : Result := #163;           (* £                                    *)
    // $00A4 : Result := #164;           (* ¤ = Currency Sign                    *)
    // $00A5 : Result := #165;           (* ¥                                    *)
    // $00A6 : Result := #166;           (* ¦                                    *)
    // $00A7 : Result := #167;           (* § = Paragraph                        *)
    // $00A8 : Result := #168;           (* ¨                                    *)
    // $00A9 : Result := #169;           (* ©                                    *)
    // $00AA : Result := #170;           (* ª                                    *)
    // $00AB : Result := #171;           (* «                                    *)
    // $00AC : Result := #172;           (* ¬                                    *)
    // $00AD : Result := #173;           (* SHY = Soft hyphen                    *)
    // $00AE : Result := #174;           (* ®                                    *)
    // $00AF : Result := #175;           (* ¯ = Macron                           *)
    // $00B0 : Result := #176;           (* ° = Degree Sign                      *)
    // $00B1 : Result := #177;           (* ±                                    *)
    // $00B2 : Result := #178;           (* ²                                    *)
    // $00B3 : Result := #179;           (* ³                                    *)
    // $00B4 : Result := #180;           (* ´                                    *)
    // $00B5 : Result := #181;           (* µ                                    *)
    // $00B6 : Result := #182;           (* ¶ = Pilcrow Sing                     *)
    // $00B7 : Result := #183;           (* ·                                    *)
    // $00B8 : Result := #184;           (* ¸                                    *)
    // $00B9 : Result := #185;           (* ¹                                    *)
    // $00BA : Result := #186;           (* º                                    *)
    // $00BB : Result := #187;           (* »                                    *)
    // $00BC : Result := #188;           (* ¼                                    *)
    // $00BD : Result := #189;           (* ½                                    *)
    // $00BE : Result := #190;           (* ¾ = 3/4                              *)
    // $00BF : Result := #191;           (* ¿                                    *)
    // $00C0 : Result := #192;           (* À                                    *)
    // $00C1 : Result := #193;           (* Á                                    *)
    // $00C2 : Result := #194;           (* Â                                    *)
    // $00C3 : Result := #195;           (* Ã                                    *)
    // $00C4 : Result := #196;           (* Ä                                    *)
    // $00C5 : Result := #197;           (* Å                                    *)
    // $00C6 : Result := #198;           (* Æ                                    *)
    // $00C7 : Result := #199;           (* Ç                                    *)
    // $00C8 : Result := #200;           (* È                                    *)
    // $00C9 : Result := #201;           (* É                                    *)
    // $00CA : Result := #202;           (* Ê                                    *)
    // $00CB : Result := #203;           (* Ë                                    *)
    // $00CC : Result := #204;           (* Ì                                    *)
    // $00CD : Result := #205;           (* Í                                    *)
    // $00CE : Result := #206;           (* Î                                    *)
    // $00CF : Result := #207;           (* Ï                                    *)
    // $00D0 : Result := #208;           (* Ð                                    *)
    // $00D1 : Result := #209;           (* Ñ                                    *)
    // $00D2 : Result := #210;           (* Ò                                    *)
    // $00D3 : Result := #211;           (* Ó                                    *)
    // $00D4 : Result := #212;           (* Ô                                    *)
    // $00D5 : Result := #213;           (* Õ                                    *)
    // $00D6 : Result := #214;           (* Ö                                    *)
    // $00D7 : Result := #215;           (* ×                                    *)
    // $00D8 : Result := #216;           (* Ø                                    *)
    // $00D9 : Result := #217;           (* Ù                                    *)
    // $00DA : Result := #218;           (* Ú                                    *)
    // $00DB : Result := #219;           (* Û                                    *)
    // $00DC : Result := #220;           (* Ü                                    *)
    // $00DD : Result := #221;           (* Ý                                    *)
    // $00DE : Result := #222;           (* Þ                                    *)
    // $00DF : Result := #223;           (* ß                                    *)
    // $00E0 : Result := #224;           (* à                                    *)
    // $00E1 : Result := #225;           (* á                                    *)
    // $00E2 : Result := #226;           (* â                                    *)
    // $00E3 : Result := #227;           (* ã                                    *)
    // $00E4 : Result := #228;           (* ä                                    *)
    // $00E5 : Result := #229;           (* å                                    *)
    // $00E6 : Result := #230;           (* æ                                    *)
    // $00E7 : Result := #231;           (* ç                                    *)
    // $00E8 : Result := #232;           (* è                                    *)
    // $00E9 : Result := #233;           (* é                                    *)
    // $00EA : Result := #234;           (* ê                                    *)
    // $00EB : Result := #235;           (* ë                                    *)
    // $00EC : Result := #236;           (* ì                                    *)
    // $00ED : Result := #237;           (* í                                    *)
    // $00EE : Result := #238;           (* î                                    *)
    // $00EF : Result := #239;           (* ï                                    *)
    // $00F0 : Result := #240;           (* ð                                    *)
    // $00F1 : Result := #241;           (* ñ                                    *)
    // $00F2 : Result := #242;           (* ò                                    *)
    // $00F3 : Result := #243;           (* ÿ                                    *)
    // $00F4 : Result := #244;           (* ô                                    *)
    // $00F5 : Result := #245;           (* õ                                    *)
    // $00F6 : Result := #246;           (* ö                                    *)
    // $00F7 : Result := #247;           (* ÷                                    *)
    // $00F8 : Result := #248;           (* ø                                    *)
    // $00F9 : Result := #249;           (* ù                                    *)
    // $00FA : Result := #250;           (* ú                                    *)
    // $00FB : Result := #251;           (* û                                    *)
    // $00FC : Result := #252;           (* ü                                    *)
    // $00FD : Result := #253;           (* ý                                    *)
    // $00FE : Result := #254;           (* þ                                    *)
    // $00FF : Result := #255;           (* ÿ                                    *)
    _4_high : Result := '4';          (* ⁴                                    *)
    _5_high : Result := '5';          (* ⁵                                    *)
    _6_high : Result := '6';          (* ⁶                                    *)
  else
    Result := #63;                    (* ?                                    *)
  end;
end;

Function  IsControlCode(ch:AnsiChar) : Boolean;
Var ASCII_Value : Byte;
begin
  ASCII_Value := Ord(ch);
  if (ASCII_Value=  7) or   (* Control Code <BELL>            *)
     (ASCII_Value=  8) or   (* Control Code <BACKSPACE>       *)
     (ASCII_Value=  9) or   (* Control Code <TAB>             *)
     (ASCII_Value= 10) or   (* Control Code <LINE FEED>       *)
     (ASCII_Value= 13) then (* Control Code <CARRIAGE RETURN> *)
  begin
    Result := True;
  end else
  begin
    Result := False;
  end;
end;

Function  Str_CP850_UTF8(aString:RawByteString) : UTF8String;
var SPos                     : Longint;
    UTF8                     : AStr3;
begin
  SPos := 0;
  While (SPos<length(aString)) do
  begin
    inc(SPos);
    UTF8 := Char_CP850_UTF8(aString[SPos]);
    if (UTF8<>aString[sPos]) then
    begin
      // Delete CP850 Char
      delete(aString,SPos,1);
      // Insert UTF8-Chars
      Insert(UTF8,aString,SPos);
      // adjust SPos
      if (length(UTF8)>1) then
      begin
        inc(SPos,length(UTF8)-1);
      end;
    end;
  end;
  Result := aString;
end;

Function  Str_CP850_Unicode(sString:ShortString; ReplaceControlCode:Boolean=False) : UnicodeString;
var
  SPos : Longint;
  uString : UnicodeString;
begin
  uString := '';
  SPos    := 0;
  While (SPos<length(sString)) do
  begin
    inc(SPos);
    (* if char is control code *)
    if (IsControlCode(sString[SPos])) then
    begin
      if (ReplaceControlCode)
         then uString := uString + Char_CP850_Unicode(sString[SPos])
         else uString := uString + WideChar(Ord(sString[SPos]));
    end else
    begin
      uString := uString + Char_CP850_Unicode(sString[SPos]);
    end;
  end;
  Result := uString;
end;

Function  Str_CP850_Unicode(cString:CP850String; ReplaceControlCode:Boolean=False) : UnicodeString;
var
  SPos : Longint;
  uString : UnicodeString;
begin
  uString := '';
  SPos    := 0;
  While (SPos<length(cString)) do
  begin
    inc(SPos);
    (* if char is control code *)
    if (IsControlCode(cString[SPos])) then
    begin
      if (ReplaceControlCode)
         then uString := uString + Char_CP850_Unicode(cString[SPos])
         else uString := uString + WideChar(Ord(cString[SPos]));
    end else
    begin
      uString := uString + Char_CP850_Unicode(cString[SPos]);
    end;
  end;
  Result := uString;
end;

Function  Str_CP1252_CP850(Const cString:RawByteString) : RawByteString;
var
  i : Integer;
  Help : AnsiString;
begin
  SetLength(Help,length(cString));
  for i := 1 to length(cString) do
  begin
    Help[i] := Char_CP1252_CP850(cString[i]);
  end;
  Result := Help;
end;

Function  Str_CP1252_Unicode(Const cString:CP1252String) : UnicodeString;
var
  i : Integer;
  Help : UnicodeString;
begin
  SetLength(Help,length(cString));
  for i := 1 to length(cString) do
  begin
    Help[i] := Char_CP1252_Unicode(cString[i]);
  end;
  Result := Help;
end;

Function  Str_Unicode_CP850(Const uString:UnicodeString) : CP850String;
var
  i : Integer;
  cString : CP850String;
begin
  SetLength(cString,length(uString));
  for i := 1 to length(uString) do
  begin
    cString[i] := Char_Unicode_CP850(uString[i]);
  end;
  Result := cString;
end;

Function  Str_Unicode_RawByteString(Const uString:UnicodeString) : RawByteString;
var
  i : Integer;
  rString : CP850String;
begin
  SetLength(rString,length(uString));
  for i := 1 to length(uString) do
  begin
    rString[i] := Char_Unicode_CP850(uString[i]);
  end;
  Result := rString;
end;

Function  Str_Unicode_ShortString(Const uString:UnicodeString) : ShortString;
var
  i : Integer;
  sLen : Byte;
  sString : ShortString;
begin
  sLen := Min(255,length(uString));
  SetLength(sString,sLen);
  for i := 1 to sLen do
  begin
    sString[i] := Char_Unicode_CP850(uString[i]);
  end;
  Result := sString;
end;

// Most of the special-characters in CP850 and/or CP1252 are coded in UTF8
// with $C2 (┬ or Â), $C3 (├ or Ã) or $E2(Ô or â). Since these characters
// are not normally found very often in normal text, we can assume that if
// there is a frequent occurrence of one of the characters in the text,
// this text is encoded in UFT8.
Function  Guess_UTF8(Const Bytes:TBytes) : Boolean;
Var TotalBytes : Longword;
    C2Bytes : Longword;
    C3Bytes : Longword;
    E2Bytes : Longword;

  Function Count_Byte(ByteValue:Byte) : Longword;
  Var Counter : Longword;
      i : integer;
  begin
    Counter := 0;
    for i := 0 to TotalBytes-1 do
    begin
      if (Bytes[i]=ByteValue) then inc(Counter);
    end;
    Result := Counter;
  end;

begin
  TotalBytes := length(Bytes);
  // chars like '¶§£ªº¿®½¼¹²³' are coded with $c2 in UTF8
  C2Bytes    := Count_Byte($C2);
  // many german umlauts are coded with $c3 in UTF8
  C3Bytes    := Count_Byte($C3);
  // many Box-Drawing-Char are coded with $e2 in UTF8
  E2Bytes    := Count_Byte($E2);
  if (C2Bytes/TotalBytes>0.002) or
     (C3Bytes/TotalBytes>0.002) or
     (E2Bytes/TotalBytes>0.002) then Result := True
                                else Result := False;
end;

Function  Guess_UTF8(Const aString:AnsiString) : Boolean;
Var Bytes : TBytes;
begin
  Bytes := BytesOf(aString);
  Result := Guess_UTF8(Bytes);
end;

initialization
  Ignore_CP850_UTF8 := [];
  PlyAppName := ExeFile_NameName;
end.


