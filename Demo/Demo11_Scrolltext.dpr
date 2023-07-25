program Demo11_Scrolltext;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt in '..\Crt.pas',
  Ply.Console,
  Ply.Console.Extended,
  Ply.StrUtils,
    Ply.SysUtils,
  Ply.Types,
  System.Classes,
  System.SysUtils;

Procedure EnlageBufferSize;
Var
  i : integer;
  Key : Word;
  uString : String;
begin
  Console.Buffer(120,1500);
  uString := 'Some text from '+ExeFile_Filename;
  for I := 1 to 600 do
  begin
    // Enlarge StringLength for Demo
    if ((i mod 50)=0) then uString := uString + '├────────┤';
    WritelnConsole('Line['+IntToStringLZ(i,4)+'] : '+uString);
  end;
  Repeat
    Console.ReadkeyScroll(Key);
  Until (Key=_ESC);
end;

Procedure UseStringListConsole;
Var
  i : integer;
  Key : Word;
  Strings : TStringListConsole;
  uString : String;
begin
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
end;

Var
  Key : Word;
begin
  try
    Repeat
      Color(LightGray,Black);
      Console.Window(80,25);
      ClrScr;
      WriteXY(5,2,'(1)   Enlarge ScreenBufferSize');
      WriteXY(5,3,'(2)   Use TStringListConsole');
      WriteXY(5,4,'(Esc) Exit');
      WriteXY(5,6,' =>');
      Readkey(Key);
      if (Key=_1) then EnlageBufferSize else
      if (Key=_2) then UseStringListConsole;
    Until (Key=_ESC);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
