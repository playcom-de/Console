program Demo03_Move_Window;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt in '..\Crt.pas',
  Ply.Console,
  Ply.Types,
  System.SysUtils;

Var corner : Byte;
    WorkAreas : tWorkAreas;
    CurWorkArea : TConsoleDesktopRect;
    CurDeskPos : TConsoleDesktopPoint;
    Key : Word;
begin
  try
    Corner := 0;
    WorkAreas.GetWorkAreas;
    Console.Window(100,30);
    Console.Font.SetDefault;
    Repeat
      CurWorkArea := WorkAreas.GetWorkArea(Console.Desktop.Position).Rect;
      ClrScr;
      Writeln('                │    Size     │       Rectangle          │');
      Writeln('Screen          │ '+CurWorkArea.ToStringSize          +' │ '+CurWorkArea.ToStringRect          +'│');
      Writeln('Console.Desktop │ '+Console.Desktop.Area.ToStringSize +' │ '+Console.Desktop.Area.ToStringRect +'│');
      Writeln('Console.Window  │ '+Console.WindowRect.ToStringSize   +' │ '+Console.WindowRect.ToStringRect   +'│');
      Writeln('Crt.WinSize     │ '+Crt.WindSize.ToStringSize         +' │ '+Crt.WindSize.ToStringRect         +'│');
      Writeln;
      Writeln('(Ctrl+Alt +|-) Console-Font : '+Console.Font.FontText);
      Writeln('(+|-)     alter Console.Window.Size (lines & coloums)');
      Textcolor(Yellow);
      Writeln('          Observe what happens when the console-window becomes larger than the screen.');
      Writeln('          Observe what happens when the console-window is in the bottom right corner.');
      Textcolor(LightGray);
      Writeln('(1|2)     alter Crt.Window.Size');
      Writeln('(←|→|↑|↓) move console-window');
      Writeln('(Enter)   move console-window to corner');
      Writeln('(ESC) Exit');

      Readkey(Key);
      if (Key=_Plus) then
      begin
        Console.Window(Console.WindowSize.X+5,Console.WindowSize.Y+2);
      end else
      if (Key=_Minus) then
      begin
        Console.Window(Console.WindowSize.X-5,Console.WindowSize.Y-2)
      end else
      if (Key=_1) then
      begin
        if (WindSize.Width>10) and (WindSize.Height>10) then
        begin
          ClrScr;
          Window(WindSize.Left+3,WindSize.Top+3,WindSize.Right-1,WindSize.Bottom-1);
          if (TextBackground=Black)
             then TextBackground(Blue)
             else TextBackground(Black);
        end;
      end else
      if (Key=_2) then
      begin
        if (WindSize.Width<Console.WindowRect.Width) then
        begin
          ClrScr;
          Window(WindSize.Left-1,WindSize.Top-1,WindSize.Right+3,WindSize.Bottom+3);
          if (TextBackground=Black)
             then TextBackground(Blue)
             else TextBackground(Black);
        end;
      end else
      if (Key in [_Right,_Left,_Up,_Down]) then
      begin
        CurDeskPos := Console.Desktop.Position;
        if (Key=_Up  )  then CurDeskPos.Y := CurDeskPos.Y - 5 else
        if (Key=_Left)  then CurDeskPos.X := CurDeskPos.X - 5 else
        if (Key=_Down)  then CurDeskPos.Y := CurDeskPos.Y + 5 else
        if (Key=_Right) then CurDeskPos.X := CurDeskPos.X + 5;
        Console.Desktop.Position := CurDeskPos;
      end else
      if (Key=_Return) then
      begin
        inc(corner);
        if (Corner>4) then
        begin
          Corner := 1;
          CurWorkArea := WorkAreas.GetWorkAreaNext(Console.Desktop.Position).Rect;
        end;
        if (corner=1) then
        begin
          CurDeskPos.Init(CurWorkArea.Left,0);
          Console.Desktop.Position := CurDeskPos;
        end else
        if (corner=2) then
        begin
          CurDeskPos.Init(CurWorkArea.Right-Console.Desktop.Area.Width,0);
          Console.Desktop.Position := CurDeskPos;
        end else
        if (corner=3) then
        begin
          CurDeskPos.Init(CurWorkArea.Right-Console.Desktop.Area.Width
            ,CurWorkArea.Bottom - Console.Desktop.Area.Height);
          Console.Desktop.Position := CurDeskPos;
        end else
        if (corner=4) then
        begin
          CurDeskPos.Init(CurWorkArea.Left
            ,CurWorkArea.Bottom-Console.Desktop.Area.Height);
          Console.Desktop.Position := CurDeskPos;
        end;
      end;
    Until (Key=_ESC);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
