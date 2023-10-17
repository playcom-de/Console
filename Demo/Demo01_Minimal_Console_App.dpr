program Demo01_Minimal_Console_App;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

Uses Crt;

begin
  Console.Window(80,25);
  TextBackground(White);
  Textcolor(Red);
  ClrScr;
  Writeln('Hello World!');
  Readkey;

  Window(3,3,78,23);
  TextBackground(Blue);
  Textcolor(Yellow);
  ClrScr;
  Writeln('Goodbye World!');
  // wait 2 seconds and quit program
  Delay(2000);
end.
