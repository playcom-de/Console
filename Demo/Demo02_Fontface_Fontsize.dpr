program Demo02_Fontface_Fontsize;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt,
  Ply.Console,
  Ply.Types,
  Ply.StrUtils,
  System.SysUtils;

Var
  Key : Word;
  CurWinSize : TConsoleWindowPoint;
begin
  try
    Textcolor(Yellow);
    TextBackground(Blue);
    CurWinSize.Create(70,10);
    Console.Font.SetDefault;
    Repeat
      Console.Window(CurWinSize);
      Console.AutofitPosition;
      ClrScr;
      GotoXY(1,1);
      Writeln('(1..5|TAB)       Fontface    : '+Console.Font.FontNumberText);
      Writeln('(+|-)            Fontsize    : '+Console.Font.FontSizeText);
      Writeln('(Ctrl)&(←|→|↑|↓) Window-Size : '+Console.WindowSize.ToStringSize);
      Writeln('(ESC) Exit');
      WriteXY(1,8,'Desktop.Position : '+Console.Desktop.Area.ToStringPos);
      WriteXY(1,9,'Desktop.Size     : '+Console.Desktop.Area.ToStringSize);
      Readkey(Key);
      if (Key=_CTRL_RIGHT)                       then CurWinSize.x := CurWinSize.x + 1 else
      if (Key=_CTRL_LEFT)  and (CurWinSize.x>51) then CurWinSize.x := CurWinSize.x - 1 else
      if (Key=_CTRL_DOWN)                        then CurWinSize.y := CurWinSize.y + 1 else
      if (Key=_CTRL_Up)    and (CurWinSize.y>5)  then CurWinSize.y := CurWinSize.y - 1 else
      if (Key=_Plus)  then Console.Font.IncFontSize    else
      if (Key=_Minus) then Console.Font.DecFontSize    else
      if (Key=_Tab)  then
      begin
        Console.Font.IncFontNumber;
      end else
      if (Key=_Shift_Tab) then
      begin
        Console.Font.DecFontNumber;
      end else
      if (Key>=_1) and (Key<=_5) then
      begin
        Console.Font.FontNumber := (LastKey-_0);
      end;
    Until (Key=_Esc);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
