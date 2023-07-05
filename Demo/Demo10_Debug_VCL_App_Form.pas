unit Demo10_Debug_VCL_App_Form;

interface

uses
  Crt,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm_Demo10 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    Counter : Integer;
  public
  end;

var
  Form_Demo10: TForm_Demo10;

implementation

{$R *.dfm}

procedure TForm_Demo10.Button1Click(Sender: TObject);
begin
  ClrScr;
  inc(Counter);
  WriteXY(10, 2,'Clicks : '+Counter.ToString);
  WriteXY(10, 5,Lightred,'Button1 pressed');
end;

procedure TForm_Demo10.Button2Click(Sender: TObject);
begin
  ClrScr;
  inc(Counter);
  WriteXY(10, 2,'Clicks : '+Counter.ToString);
  WriteXY(10, 8,Green,'Button2 pressed');
end;

procedure TForm_Demo10.FormCreate(Sender: TObject);
begin
  Counter := 0;
  // Set position of the VCL window on the desktop
  Left := 10;
  Top  := 10;
end;

begin
  // Set title of the Debug-Console-Window
  Console.Title := 'PlyConsole - Debug';
  // Set size of the Debug-Console-Window in Chars (Medium = 100 x 35)
  Console.WindowMedium;
  // Set position of the Console-Window on Desktop
  Console.Desktop.MoveTo(1000,10);
  // Print information for the programmer
  Crt.Window(5,30,95,34);
  Color(White,DarkGray);
  ClrScr;
  WriteXY(3,2,'The unit Ply.Console.Debug must be placed before crt.pas in uses-clauses');
  WriteXY(3,3,'It is recommended to use the unit as the first in the program.');
  WriteXY(3,4,'See Demo10_Debug_VCL_App.dpr');
  // Reduce workingspace to keep this information on Debug-Screen
  Crt.Window(1,1,100,29);
  Color(LightGray,Black);
end.
