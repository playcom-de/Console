program Demo07_ScreenSave;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Crt,
  Ply.Console,
  Ply.Console.Extended,
  Ply.Math,
  Ply.StrUtils,
  Ply.SysUtils,
  Ply.Types,
  System.SysUtils;

Var
  Key : Word;
  ScreenSave : tScreenSave;
  BColor : Byte;
  FrameWindow : TFrameWindow;
begin
  try
    BColor := 0;
    Color(LightGray,BColor);
    Console.WindowMedium;
    Console.Font.SetDefault;
    ScreenSave.Save;

    FrameWindow.ClearSettings;
    FrameWindow.ClrBackground       := True;
    FrameWindow.ColorBackground     := Magenta;
    FrameWindow.FrameTextColor      := White;
    FrameWindow.FrameTextBackground := Darkgray;
    FrameWindow.TextTopLeft         := 'Text Top Left';
    FrameWindow.TextTitle           := 'Text Top Center';
    FrameWindow.TextTopRight        := 'Text Top Right';
    FrameWindow.TextBottomLeft      := 'Text Bottom Left';
    FrameWindow.TextBottomRight     := 'Text Bottom Right';
    // Print Crt.FrameWindow
    FrameWindow.Window(5,5,MaxX-4,MaxY-4);
    FrameWindow.ClrBackground := False;

    Repeat
      ClrScr;
      WriteXY(1, 1,'Program  : '+FilePathName_Exe);
      WriteXY(1, 3,White,'(1) Edit ProgDataPath        : '+PlyProgDataPath);
      WriteXY(1, 4,White,'(2) Edit ScreenSave.Filename : '+ScreenSave.Filename);
      WriteXY(1, 7,'Current Values :');
      WriteXY(1, 8,'ScreenSave.Filename.Data  : '+ScreenSave.Filename);
      WriteXY(1, 9,'ScreenSave.Filename.Index : '+ScreenSave.FilenameIndex);
      WriteXY(1,10,'ScreenSave.File.Count     : '+IntToString(ScreenSave.FileCount,4));
      WriteXY(1,14,'(Alt+1..5)      Console.Window.Size : '+Console.WindowSize.ToStringSize);
      WriteXY(1,15,'(Tab|Shift+Tab) Crt.Window.Size     : '+WindSize.ToStringSize);
      WriteXY(1,16,'(Ctrl+Alt+S)    Save current Screen to File');
      WriteXY(1,17,'(Ctrl+Alt+L)    Load Screen from File');

      ReadKey(Key);
      if (Key=_1) then
      begin
        GotoXY(32, 3);
        PlyProgDataPath := InputString(32,3,PlyProgDataPath,50,250);
      end else
      if (Key=_2) then
      begin
        ScreenSave.Filename := InputString(32,4,ScreenSave.Filename,50,250);
      end else
      if (Key=_ALT_1) then Console.WindowDefault  else //  80 * 25 =  2000 Chars
      if (Key=_ALT_2) then Console.WindowMedium   else // 100 * 35 =  3500 Chars
      if (Key=_ALT_3) then Console.WindowLarge    else // 120 * 50 =  6000 Chars
      if (Key=_ALT_4) then Console.Window(150,60) else // 150 * 60 =  9000 Chars
      if (Key=_ALT_5) then Console.Window(200,80) else // 200 * 80 = 16000 Chars
      // (TAB) Reduce Crt.Window
      if (Key=_Tab) then
      begin
        inc(BColor); if (BColor>15) then BColor := 0;
        FrameWindow.TextColor      := LightGray;
        FrameWindow.TextBackground := BColor;
        FrameWindow.Window(WindSize.Left+2,WindSize.Top+2,WindSize.Right,WindSize.Bottom);
      end else
      // (Shift+TAB) Enlarge Crt.Window
      if (Key=_SHIFT_TAB) then
      begin
        if (WindSize.Left>0) then
        begin
          inc(BColor); if (BColor>15) then BColor := 0;
          FrameWindow.TextColor      := LightGray;
          FrameWindow.TextBackground := BColor;
          FrameWindow.Window(WindSize.Left-2,WindSize.Top-2,WindSize.Right+4,WindSize.Bottom+4);
        end;
      end;
    Until (Key=_ESC);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
