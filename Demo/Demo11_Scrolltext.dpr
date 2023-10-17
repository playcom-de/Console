program Demo11_Scrolltext;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt,
  Ply.Console,
  Ply.Console.Extended,
  Ply.StrUtils,
  Ply.SysUtils,
  Ply.Types,
  System.Classes,
  System.SysUtils;

Procedure EnlargeBufferSize;
Var
  i : integer;
  Key : Word;
  uString : String;
  ScreenSave : tScreenSave;
begin
  // ScreenSave is used here only to demonstrate its use. With ScreenSave.Save
  // and ScreenSave.Restore the programmer does not have to worry about which
  // console settings (size, color, CursorPos, etc.) are changed within the
  // current function. With ScreenSave.Restore the old settings and the old
  // contents of the window are simply restored. In the upstream function,
  // the screen then also does not have to be recreated.
  ScreenSave.Save;

  Color(Yellow,DarkGray);
  // enlarge BufferSize;
  Console.Buffer(180,1500);
  // Use Crt.WriteConsole instead of System.Write;
  Console.Modes.AlternateWriteProc := awConsole;

  uString := 'WritelnConsole '+ExeFile_Filename;
  for I := 1 to 300 do
  begin
    // Enlarge StringLength for Demo
    if ((i mod 50)=0) then uString := uString + '├────────┤';
    WritelnConsole('Line['+IntToStringLZ(i,4)+'] : '+uString);
  end;

  uString := 'System.Writeln '+ExeFile_Filename;
  for I := 301 to 600 do
  begin
    // Enlarge StringLength for Demo
    if ((i mod 50)=0) then uString := uString + '├────────┤';
    Writeln('Line['+IntToStringLZ(i,4)+'] : '+uString);
  end;

  Textcolor(LightGreen);
  for I := 1 to 600 do
  begin
    if ((i mod 10)=0) then
    begin
      WriteConsole(14,i,'GreenText');
    end;
  end;

  GotoXYConsole(1,602);
  Textcolor(White);
  Writeln('Done!');
  Writeln('Use Cursor-Keys and/or PgUp|PgDown to scroll text');
  Writeln('(Esc) Exit function');

  Console.ReadkeyScroll(Key);

  // Use default Crt.WriteString instead of System.Write
  Console.Modes.AlternateWriteProc := awCrt;

  ScreenSave.Restore;
end;

Procedure UseStringListConsole;
Var
  i : integer;
  Key : Word;
  Strings : TStringListConsole;
  uString : String;
  ScreenSave : tScreenSave;
begin
  // ScreenSave is used here only to demonstrate its use. With ScreenSave.Save
  // and ScreenSave.Restore the programmer does not have to worry about which
  // console settings (size, color, CursorPos, etc.) are changed within the
  // current function. With ScreenSave.Restore the old settings and the old
  // contents of the window are simply restored. In the upstream function,
  // the screen then also does not have to be recreated.
  ScreenSave.Save;

  Strings := TStringListConsole.Create;
  uString := 'Some text from '+ExeFile_Filename;
  for I := 1 to 600 do
  begin
    // Enlarge StringLength for Demo
    if ((i mod 50)=0) then uString := uString + '├────────┤';
    Strings.Add('Line['+IntToStringLZ(i,4)+'] : '+uString);
  end;
  Repeat
    Key := Strings.Show('Show my Strings','(Alt+F12) Toggle WindowSize │ (Ctrl+S) SaveToFile');
    if (Key=_CTRL_S) then
    begin
      Try
        Strings.SaveToFile(FilenameReplaceExtension(ExeFile_Filename,'txt'),TEncoding.UTF8);
        ConsoleShowNote('Save StringList to File',
          'Strings were saved',FilenameReplaceExtension(ExeFile_Filename,'txt'));
      except
        on E: Exception do
          Writeln(E.ClassName, ': ', E.Message);
      End;
    end;
  Until (Key=_Esc);
  Strings.Free;

  ScreenSave.Restore;
end;

Var
  Key : Word;
begin
  try
    Color(LightGray,Black);
    Console.Window(80,25);
    ClrScr;
    WriteXY(5,2,'(1)   Enlarge ScreenBufferSize');
    WriteXY(5,3,'(2)   Use TStringListConsole');
    WriteXY(5,4,'(Esc) Exit');
    WriteXY(5,6,' =>');
    Repeat
      Readkey(Key);
      if (Key=_1) then EnlargeBufferSize else
      if (Key=_2) then UseStringListConsole;
    Until (Key=_ESC);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
