program Demo08_ASCII_Charachters;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Crt,
  Ply.Console,
  Ply.Console.Extended,
  Ply.Types,
  Ply.SysUtils,
  Ply.StrUtils,
  System.Classes,
  System.SysUtils,
  Winapi.Windows;

Var ConOutputAnsiWide : Boolean = True;

Function ConOutputAnsiWide_Text : String;
begin
  if (ConOutputAnsiWide)
     then Result := 'AnsiChar'
     else Result := 'WideChar';
end;

Procedure Print_ASCII_Table(Page: Integer);
Var i,x,y : Integer;
begin
  Color(LightGray,Black);
  ClrScr;

  For i := 0 to $F do
  begin
    x := ((i mod 16) + 1) * 4 + 8;
    y := 1;
    WriteXY(x+0,y+0,i.ToHexString(1));
    WriteXY(x-1,y+1,IntToString(i,2));
    x := 1;
    y := i + 4;
    WriteXY(x,y,i.ToHexString(1)+' '+IntToString(i*16,3));
  end;

  for i := (0+(Page*256)) to (255+(Page*256)) do
  begin
    x := ((i mod 16) + 1) * 4 + 8;
    y := ((i mod 256) div 16) + 4;
    if (ConOutputAnsiWide)
       then WriteChar(x,y,AnsiChar(i))
       else WriteChar(x,y,WideChar(i));
  end;
end;

Procedure Print_Menue(Page: Integer);
begin
  Textcolor(White);
  WriteXY(1,21,'(Alt+A) Output : '+ConOutputAnsiWide_Text);
  if (ConOutputAnsiWide) then
  begin
    WriteXY(50,21,Yellow,'Current Codepage : '+IntToString(Console.OutputCodepage,6));
    WriteXY(1,22,'(Alt+C) Codepage Switch');
    WriteXY(1,23,'(Alt+D) Codepage Select');
  end else
  begin
    WriteXY(30,21,'(Tab) Page : '+IntToStr(Page));
    WriteXY(30,22,'#'+IntToStringLZ(Page*256,4)+'..'
                 +'#'+IntToStringLZ(255+(Page*256),4));
    WriteXY(30,23,'$'+(Page*256).ToHexString(4)+'..'
                 +'$'+(255+(Page*256)).ToHexString(4));
  end;
  WriteXY(1,25,'(Alt + 1..5)    Fontface : '+Console.Font.FontName);
  WriteXY(1,26,'(Ctrl+Alt +|-)  Fontsize : '+Console.Font.FontSizeText);
end;

procedure Console_Demo08_ASCII;
Var
  Key : Word;
  Page : Integer;
  CP_Pos : Integer;
  ScreenSave : tScreenSave;

Const CPs : Array [1..12] of tCodepage = (437,720,850,852,855,857,858,860,861,862,949,1252);

begin
  CP_Pos := 3;
  Console.Font.GetCurrentFontEx;
  Console.CursorVisible := False;

  ScreenSave.Save;
  Console.Window(90,30);
  Page    := 0;
  Window('Show ASCII characters','',Console.WindowSize.ToStringSize);
  Repeat
    Print_ASCII_Table(Page);
    Print_Menue(Page);

    Readkey(Key);
    if (Key=_Alt_A) then
    begin
      ConOutputAnsiWide := not(ConOutputAnsiWide);
      if (ConOutputAnsiWide) then
      begin
        Page := 0;
      end;
    end else
    if (Key=_ALT_C) and (ConOutputAnsiWide) then
    begin
      inc(CP_Pos);
      if (CP_Pos>length(CPs)) then CP_Pos := 1;
      Console.OutputCodepage := CPs[CP_Pos];
    end else
    if (Key=_ALT_D) and (ConOutputAnsiWide) then
    begin
      Console.OutputCodepage := CodepageSelect(Console.OutputCodepage);
    end else
    if (Key=_Tab) and not(ConOutputAnsiWide) then
    begin
      inc(Page,1);
      if (Page>255) then Page := 0;
    end else
    if (Key=_Shift_Tab) and not(ConOutputAnsiWide) then
    begin
      dec(Page,1);
      if (Page<0) then Page := 255;
    end else
    if (Key>=_ALT_1) and (Key<=_ALT_5) then
    begin
      Console.Font.FontNumber := (Key-_ALT_0);
    end;

  until (Key=_ESC);
  ScreenSave.Restore;
end;

begin
  try
    Console_Demo08_ASCII;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
