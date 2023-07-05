program Demo10_Debug_VCL_App;

uses
  Ply.Console.Debug,
  Vcl.Forms,
  Demo10_Debug_VCL_App_Form in 'Demo10_Debug_VCL_App_Form.pas' {Form_Demo10};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Demo10, Form_Demo10);
  Application.Run;
end.
