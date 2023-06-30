program Demo04_Input_Keyboard;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt in '..\Crt.pas',
  Ply.Console,
  Ply.Console.Extended,
  Ply.Types,
  Ply.StrUtils,
  System.SysUtils;

Var UStr        : UnicodeString;
    Str850      : CP850String;
    Str437      : CP437String;
    AStr        : AnsiString;
    SStr        : ShortString;
    aString     : String;
    aLongString : String;
    aInteger    : Integer;
    aDouble     : Double;
    wch         : WideChar;
    Key         : Word;
    FieldNumber : Integer;
begin
  uStr        := '';
  aString     := '€äöüß ¹²³⁴⁵⁶ - Length restricted to input-field 0123456789 0123456789';
  aLongString := 'This text is longer than the input-field, with which this text can '
               + 'be edited. In addition, it is possible to display the complete text '
               + 'at a different position during input. With (Ctrl + ←|→) you are able '
               + 'to move the cursor to the beginning of the next word. Using (Crtl '
               + '+ ^) you can insert an Ascii-Char [000..255] from current input-'
               + 'codepage or an Unicode-Char [0000..FFFF]. To use this feature you '
               + 'have to set first "Console.Flags.AsciiCodeInput := True" in your '
               + 'code. E.g. 277A brings you the character "❺" or 260E the telefon'
               + '-character "☎ ". You can also get chinese or japanese characters '
               + 'or something like that "╠" (2560).' ;
  aInteger    := 1234567;
  aDouble     := 12345.67;
  FieldNumber       := 0;
  Console.Modes.EnableAsciiCodeInput := True;
  try
    Console.Window(120,35);
    Repeat
      Color(LightGray,Black);
      ClrScr;
      WriteXY(1,1,'Windows-Codepage : '+Console.CodepageWindows.ToString);
      WriteXY(1,2,'Keyboard-Layout  : $'+Console.KeyboardLayout.ToHexString);
      WriteXY(1,3,'Last Input       : "'+UStr+'"');

      Textcolor(LightGreen);
      WriteXY(1,10,'(Alt+F1..F3) ConInputCodepage       : '+Console.InputCodepage.ToString);
      WriteXY(1,11,'(Alt+F4..F6) ConOutputCodepage      : '+Console.OutputCodepage.ToString);
      WriteXY(1,12,'(Esc) Exit');

      TextAttr.Create(Yellow,Blue,_ExtTextAttrOutline);
      WriteXY( 1,17,'LastInput:');
      WriteXY(90,17,'ASCII-Value first 5 Chars');
      TextAttr.Create(LightGray,Black);

      WriteXY(1,18,'Unicode-String       : ');
        WriteXY(16,18,StringCodePage(UStr).ToString);
        WriteXY(24,18,UStr);
        GotoXY(89,18); ClrEol; Textcolor(LightCyan);
        if (Length(UStr)>0) then WriteXY( 90,18,'$'+Ord(UStr[1]).ToHexString(4));
        if (Length(UStr)>1) then WriteXY( 96,18,'$'+Ord(UStr[2]).ToHexString(4));
        if (Length(UStr)>2) then WriteXY(102,18,'$'+Ord(UStr[3]).ToHexString(4));
        if (Length(UStr)>3) then WriteXY(108,18,'$'+Ord(UStr[4]).ToHexString(4));
        if (Length(UStr)>4) then WriteXY(114,18,'$'+Ord(UStr[5]).ToHexString(4));

      TextColor(LightGray);
      WriteXY(1,19,'Ansi-String          : ');
        WriteXY(16,19,StringCodepage(AStr).ToString);
        WriteXY(24,19,UnicodeString(AStr));
        GotoXY(89,19); ClrEol; Textcolor(LightCyan);
        if (Length(AStr)>0) then WriteXY( 90,19,'$'+Ord(AStr[1]).ToHexString(4));
        if (Length(AStr)>1) then WriteXY( 96,19,'$'+Ord(AStr[2]).ToHexString(4));
        if (Length(AStr)>2) then WriteXY(102,19,'$'+Ord(AStr[3]).ToHexString(4));
        if (Length(AStr)>3) then WriteXY(108,19,'$'+Ord(AStr[4]).ToHexString(4));
        if (Length(AStr)>4) then WriteXY(114,19,'$'+Ord(AStr[5]).ToHexString(4));

      TextColor(LightGray);
      WriteXY(1,20,'CP850-String         : ');
        WriteXY(16,20,StringCodepage(Str850).ToString);
        WriteXY(24,20,Str850);
        GotoXY(89,20); ClrEol; Textcolor(LightCyan);
        if (Length(Str850)>0) then WriteXY( 90,20,'$'+Ord(Str850[1]).ToHexString(4));
        if (Length(Str850)>1) then WriteXY( 96,20,'$'+Ord(Str850[2]).ToHexString(4));
        if (Length(Str850)>2) then WriteXY(102,20,'$'+Ord(Str850[3]).ToHexString(4));
        if (Length(Str850)>3) then WriteXY(108,20,'$'+Ord(Str850[4]).ToHexString(4));
        if (Length(Str850)>4) then WriteXY(114,20,'$'+Ord(Str850[5]).ToHexString(4));

      TextColor(LightGray);
      WriteXY(1,21,'CP437-String         : ');
        WriteXY(16,21,StringCodepage(Str437).ToString);
        WriteXY(24,21,UnicodeString(Str437));
        GotoXY(89,21); ClrEol; Textcolor(LightCyan);
        if (Length(Str437)>0) then WriteXY( 90,21,'$'+Ord(Str437[1]).ToHexString(4));
        if (Length(Str437)>1) then WriteXY( 96,21,'$'+Ord(Str437[2]).ToHexString(4));
        if (Length(Str437)>2) then WriteXY(102,21,'$'+Ord(Str437[3]).ToHexString(4));
        if (Length(Str437)>3) then WriteXY(108,21,'$'+Ord(Str437[4]).ToHexString(4));
        if (Length(Str437)>4) then WriteXY(114,21,'$'+Ord(Str437[5]).ToHexString(4));

      TextColor(LightGray);
      WriteXY(1,22,'Short-String         : ');
        WriteXY(24,22,SStr);
        GotoXY(89,22); ClrEol; Textcolor(LightCyan);
        if (Length(SStr)>0) then WriteXY( 90,22,'$'+Ord(SStr[1]).ToHexString(4));
        if (Length(SStr)>1) then WriteXY( 96,22,'$'+Ord(SStr[2]).ToHexString(4));
        if (Length(SStr)>2) then WriteXY(102,22,'$'+Ord(SStr[3]).ToHexString(4));
        if (Length(SStr)>3) then WriteXY(108,22,'$'+Ord(SStr[4]).ToHexString(4));
        if (Length(SStr)>4) then WriteXY(114,22,'$'+Ord(SStr[5]).ToHexString(4));

      TextColor(LightGray);
      WriteXY(1,5,'Input String      : '+Copy(aString,1,50));
      WriteXY(1,6,'Input Long String : '+Copy(aLongString,1,70));
      WriteXY(1,7,'Input Integer     : '+aInteger.ToString);
      WriteXY(1,8,'Input Double      : '+DoubleToString(aDouble,0,4,',','.'));

      GotoXY(21,5+FieldNumber);
      if (FieldNumber=0) then
      begin
        Key := (_Inp_CursorPos1);
        aString := InputString(aString,50,Key);
        UStr := aString;
      end else
      if (FieldNumber=1) then
      begin
        Key := (_Inp_CursorPos1 or _Inp_InsertMode);
        aLongString := InputString(aLongString,70,1000,Black,LightGray,Key,1,24);
        UStr := aLongString;
      end else
      if (FieldNumber=2) then
      begin
        aInteger := InputInteger(aInteger,40,Key);
        UStr := aInteger.ToString;
      end else
      if (FieldNumber=3) then
      begin
        aDouble  := InputDouble(aDouble,40,Key,0,4,',','.');
        UStr := DoubleToString(aDouble,0,4,',','.');
      end;

      CursorMoveField(FieldNumber,0,3);

      AStr   := AnsiString(UStr);
      Str850 := Str_Unicode_CP850(UStr);
      Str437 := CP437String(UStr);
      SStr   := Str850;

      if (LastKey=_ALT_F1)  then Console.InputCodepage   := _Codepage_437         else
      if (LastKey=_ALT_F2)  then Console.InputCodepage   := _Codepage_850         else
      if (LastKey=_ALT_F3)  then Console.InputCodepage   := _Codepage_1252        else
      if (LastKey=_ALT_F4)  then Console.OutputCodepage  := _Codepage_437         else
      if (LastKey=_ALT_F5)  then Console.OutputCodepage  := _Codepage_850         else
      if (LastKey=_ALT_F6)  then Console.OutputCodepage  := _Codepage_1252;

    Until (LastKey=_ALT_X) or (LastKey=_ESC);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
