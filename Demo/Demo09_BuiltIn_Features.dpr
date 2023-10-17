program Demo09_BuiltIn_Features;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt,
  Ply.Console,
  Ply.Console.Extended,
  Ply.Types,
  System.SysUtils;

procedure Console_Demo09_BuiltIn;
Var
  Key : Word;
  FrameAttr : TTextAttr;
begin
  // Set Console-Window-Size to whatever size you want
  Console.Window(100,36);

  // Move Console.Window to a previous user saved position (see below)
  if not(ConsoleLocationMoveUser(0)) then
  begin
    // Move Console.Window (upper left corner) to a position you want
    Console.Desktop.MoveTo(300,10);
  end;

  // Set Console Font & Size
  // Console.Font: 1..5 = Terminal, Consolas, Lucida Console, Courier New, Fira Code
  // Console.Size: 1..9
  Console.Font.SetCurrentFont(_ConsoleFontCourierNew,6);
  // The folowing 2 lines would do the same as last line
  // Console.Font.FontNumber := _ConsoleFontCourierNew;
  // Console.Font.FontSize   := 6; // [Size: 1..9]

  // Create a Crt.Window within which the output takes place
  // The borders should be inside Console.Window
  Window(5,5,90,30);
  Color(Black,White); // Set Textcolor & Textbackground for this Window
  ClrScr;             // Init the Crt.Window with this color-settings
  WriteXY(10,2,'Some Text on Position (10|2) within Crt.Window');
  // Pause, wait for any key to see effect
  Readkey;

  // Create a framed Crt.Window within which the output takes place. There
  // are 4 overloaded procedures to create windows with a frame If you
  // leave the size-information, the window will fill current Console.Window
  FrameAttr.Create(White, Red);
  Window('Window-Title', FrameAttr, 'Text-Bottom-Left'
    , 'Text-Bottom-Right', 'Text-Top-Left', 'Text-Top-Right');
  Writeln('The workspace (crt.window) is smaller than the console window by 2 '
    + 'rows and 2 columns because of the frame.'+sLineBreak
    + 'The default color is Lightgray on Black. You can use Color('
    + 'foreground, background) and ClrScr to change the colors of the workspace.');
  // Pause, wait for any key to see effect
  Readkey;

  Console.Font.FontNumber := _ConsoleFontConsolas;
  Console.Font.FontSize   := 5;
  Color(White,Black);
  ClrScr;
  Repeat
    WriteXY(1, 1,Lightgreen,'Available with the use of "crt.pas"');
    WriteXY(1, 2,Lightblue,'The functions are available (BuiltIn) as soon as a '
      + 'keyboard-input is active.');
    WriteXY(1, 3,Lightblue,'The programmer does not have to write any code for '
      + 'this.');
    WriteXY(1, 5,Yellow,'Console.Window: Fontsize:');
    WriteXY(1, 6,'(Ctrl & Alt & +)      Enlarge fontsize');
    WriteXY(1, 7,'(Ctrl & Alt & -)      Reduce fontsize');
    WriteXY(1, 9,Yellow,'Console.Window: 10 positions & font-settings (save & load)');
    WriteXY(1,10,'(Ctrl & Alt & 0..9)   Load from registry - (Left-Ctrl & Left-Alt)');
    WriteXY(1,11,'(Ctrl & AltGr & 0..9) Save to registry   - (Right-Ctrl & Right-AltGr)');

    WriteXY(1,13,Lightgreen,'Available with the use of "Ply.Console.Extended.pas"');
    WriteXY(1,15,Yellow,'Save & Load ConsoleScreen (Text, Size, Cursorposition, '
      +'etc.) to/from file');
    WriteXY(1,16,'(Ctrl & Alt & S)      Save current Screen to file');
    WriteXY(1,17,'(Ctrl & Alt & L)      Load (select & show) previous saved '
      + 'screen from file');
    WriteXY(1,19,Lightblue,'Loading from and saving to registry are replaced by '
      + 'loading form and saving to file.');
    WriteXY(1,20,'(Ctrl & Alt & 0..9)   Load form file');
    WriteXY(1,21,'(Ctrl & AltGr & 0..9) Save to file');

    GotoXY(1,23);
    Writeln('So in this demo program the functions "form/to file" are always used. '
      + 'However, you can always replace them with "from/to registry" by using '
      + 'the following code at the start of your program:'+sLineBreak
      + '  Proc_CTRL_ALT_0_9    := ConsoleLocationMoveUserRegistry;'+sLineBreak
      + '  Proc_CTRL_ALTGR_0_9  := ConsoleLocationSaveUserRegistry;'+sLineBreak
      + 'For example, when starting the program, you can set the position of the '
      + 'console.window to a position specified by the user (see line 24).'
      + sLineBreak + sLineBreak
      + 'Try any of the Functions above now. Look at the source code, there is '
      + 'no code like '+sLineBreak+'"if (Key=_CTRL_ALT_1) then" necessary.');
    WriteXY(1,33,'User input (Esc for exit): ');
    Readkey(Key);
  Until (Key=_ESC);
end;

begin
  try
    Console_Demo09_BuiltIn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
