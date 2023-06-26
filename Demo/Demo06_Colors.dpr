program Demo06_Colors;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Crt,
  Ply.Console,
  Ply.Console.Extended,
  Ply.StrUtils,
  System.SysUtils;

procedure Show_Colors1;
Var
  TB,TC : Byte;
begin
  Console.Window(147,17);
  Console.Font.SetDefault;
  Textbackground(Black);
  clrscr;
  For TB := 0 to 15 do
  begin
    Textbackground(TB);
    For TC := 0 to 15 do
    begin
      Textcolor(TC);
      WriteXY(1+(TB*9),1+TC,'TB'+IntToString(TB,2)+' TC'+IntToString(TC,2)+' ');
    end;
  end;
  Readkey;
end;

procedure Show_Colors2;
Var
  TB,TC : Byte;
  Key : Word;
  dy : Byte;
begin
  Console.Window(55,22);
  Console.Font.SetDefault;
  Textbackground(Black);
  clrscr;
  TB := 0;
  dy := 1;
  Repeat
    Textbackground(TB);
    clrscr;
    for TC := 0 to 15 do
    begin
      Textcolor(TC);
      Writeln('Background :'+IntToString(TB,3)
          +'   Textcolor :'+IntToString(TC,3)
          +'   TextAttr : '+IntToString(TextAttr,5));
    end;
    Writeln;
    Writeln('(↑|↓) Move Cursor');
    Writeln('(←|→) Change background color');
    Writeln('(Esc) Exit');
    Repeat
      InvertString(19,dy,14);
      Readkey(Key);
      InvertString(19,dy,14);
      if (Key=_Down)  and (dy<16) then
      begin
        inc(dy);
      end else
      if (Key=_Up)    and (dy>1)  then
      begin
        dec(dy);
      end;
    Until (Key=_Escape) or (Key=_Right) or (Key=_Left);
    if (Key=_Right) and (TB<15) then inc(TB) else
    if (Key=_Left)  and (TB>0)  then dec(TB);
  Until (Key=_ESC);
end;

Procedure Edit_Colors1;
Var ConsoleInfoEx            : tConsoleInfoEx;
    Key                      : Word;
    BColor                   : Byte;
    CurY                     : Integer;
begin
  Console.Window(100,34);
  Console.Font.SetDefault;
  BColor := Black;
  CurY   := 0;
  ConsoleInfoEx := tConsoleInfoEx.Create;
  Repeat
    if (ConsoleInfoEx.GetInfoEx) then
    begin
      TextBackground(BColor);
      ClrScr;
      WriteXY(1,1,Yellow,'TConsoleScreenBufferInfoEx:');
      ConsoleInfoEx.ShowDebug(1,2);
      WriteXY(50,1,Yellow,'TConsoleBufferInfo:');
      Console.ShowDebug(50,2);
      ConsoleInfoEx.Show_Colors(1,10);
      WriteXY(1,29,'(F2)      Edit Color');
      WriteXY(1,30,'(F3)      Default-ColorTable');
      WriteXY(1,31,'(F4)      Windows-ColorTable');
      WriteXY(1,32,'(Alt +|-) Textbackground : '+IntToString(BColor)+' = '+ColorNames[BColor]);
      WriteXY(1,33,'(ESC)     Exit');
      Key := LineSelectExit(11,11+15,1,68,CurY);
      if (Key=_F2) then ConsoleInfoEx.Edit_Color(1,CurY,CurY-11) else
      if (Key=_F3) then ConsoleInfoEx.SetColorTableDefault       else
      if (Key=_F4) then ConsoleInfoEx.SetColorTableWindows       else
      if (Key=_ALT_Plus)  and (BColor<White) then inc(BColor)    else
      if (Key=_ALT_Minus) and (BColor>Black) then dec(BColor);
    end else Key := _ESC;
  Until (Key=_ESC);
  ConsoleInfoEx.Free;
end;

Var Key : Word;
begin
  try
    Console.Font.SetDefault;
    Repeat
      Color(LightGray,Black);
      Console.Window(80,25);
      Window(3,2,78,24);
      Color(Yellow,Blue);
      ClrScr;
      WriteXY(2,2,'(1)   Show Colors 1');
      WriteXY(2,3,'(2)   Show Colors 2');
      WriteXY(2,4,'(3)   Edit Colors 1');
      WriteXY(2,6,'(Esc) Exit');
      Readkey(Key);
      if (Key=_1) then Show_Colors1 else
      if (Key=_2) then Show_Colors2 else
      if (Key=_3) then Edit_Colors1;
    Until (Key=_Escape);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
