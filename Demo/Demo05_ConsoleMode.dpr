program Demo05_ConsoleMode;

{$APPTYPE CONSOLE}

{$R *.res}

{$I Ply.Defines.inc}

uses
  Crt,
  Ply.Console,
  Ply.Console.Extended,
  Ply.StrUtils,
  Ply.Types,
  System.Math,
  System.SysUtils,
  Vcl.Clipbrd;

Procedure TestInputBehavior;
Var
  FieldNumber : Integer;
  Key : Word;
  S1, S2, S3 : String;
begin
  Window(1,25,35,31,'Test Input Behavior','(Esc) Exit');
  FieldNumber := 0;
  Repeat
    WriteXY(1,1,'Field 1 : '+S1); ClrEol;
    WriteXY(1,2,'Field 2 : '+S2); ClrEol;
    WriteXY(1,3,'Field 3 : '+S3); ClrEol;
    if (FieldNumber=0) then s1 := InputString(11,1,s1,20,Key) else
    if (FieldNumber=1) then s2 := InputString(11,2,s2,20,Key) else
    if (FieldNumber=2) then s3 := InputString(11,3,s3,20,Key);
    CursorMoveField(FieldNumber,0,3);
    if (FieldNumber>2) then FieldNumber := 0;
  Until (Key=_ESC);
  Crt.Window;
end;

Procedure Show_Modes;
Var ClipboardText : String;
    TextAttrHead : TTextAttr;
    TextAttrNote : TTextAttr;
begin
  ClrScr;
  TextAttrHead.Color(Yellow,Black);
  TextAttrHead.Outline := True;
  TextAttrNote.Color(White,Red);
  TextAttrNote.Underline := True;

  WriteXY( 1, 1,TextAttrHead,'Appearance properties');
  WriteXY( 1, 2,'(1) Cursor-Visible            : '+BoolToStringYesNo(Console.CursorVisible));
  WriteXY( 1, 3,'(2) Cursor-Size               : '+IntToString(Console.CursorSize)); ClrEol;
  {$IFDEF CONSOLEOPACITY}
  WriteXY( 1, 4,'(3) Opacity in %              : '+IntToString(Console.Modes.Opacity));
  WriteXY( 1, 5,'(4) AutoOpacity on focus      : '+BoolToStringYesNo(Console.Modes.AutoOpacityOnFocus));
  {$ENDIF CONSOLEOPACITY}
  WriteXY(40, 1,TextAttrHead,'Crt extended features');
  WriteXY(40, 2,'(5) AlternateWriteProc        : '+Console.Modes.AlternateWriteProcText);
  WriteXY(40, 3,'(6) EnableAsciiCodeInput      : '+BoolToStringYesNo(Console.Modes.EnableAsciiCodeInput));
  WriteXY(40, 4,'(7) WrapWord                  : '+BoolToStringYesNo(Console.Modes.WrapWord));
  WriteXY(40, 5,'(8) ReplaceControlChracter    : '+BoolToStringYesNo(Console.Modes.ReplaceCtrlChar));

  WriteXY( 1, 7,TextAttrHead,'V2 console features');
  WriteXY(23, 7,TextAttrNote,'Note: Some of this V2-features needs restart of application');
  WriteXY( 1, 8,'(F2) ForceV2                  : '+BoolToStringYesNo(Console.Modes.ForceV2));
  WriteXY( 1, 9,'(F3) LineSelection            : '+BoolToStringYesNo(Console.Modes.LineSelection));
  WriteXY( 1,10,'(F4) FilterOnPaste            : '+BoolToStringYesNo(Console.Modes.FilterOnPaste));
  WriteXY( 1,11,'(F5) LineWrap                 : '+BoolToStringYesNo(Console.Modes.LineWrap));
  WriteXY(40, 8,'(F6) CtrlKeyShortcutsDisabled : '+BoolToStringYesNo(Console.Modes.CtrlKeyShortcutsDisabled));
  WriteXY(40, 9,'(F7) ExtendedEditKey          : '+BoolToStringYesNo(Console.Modes.ExtendedEditKey));
  WriteXY(40,10,'(F8) TrimLeadingZeros         : '+BoolToStringYesNo(Console.Modes.TrimLeadingZeros));

  Console.Modes.GetCurrentMode;
  WriteXY( 1,13,TextAttrHead,'Standard-Input-Flags:'+IntToString(Console.Modes.Input,4));
  WriteXY( 1,14,'(A) ProcessedInput            : '+BoolToStringYesNo(Console.Modes.ProcessedInput));
  WriteXY( 1,15,'(B) LineInput                 : '+BoolToStringYesNo(Console.Modes.LineInput));
  WriteXY( 1,16,'(C) EchoInput                 : '+BoolToStringYesNo(Console.Modes.EchoInput));
  WriteXY( 1,17,'(D) WindowInput               : '+BoolToStringYesNo(Console.Modes.WindowInput));
  WriteXY( 1,18,'(E) MouseInput                : '+BoolToStringYesNo(Console.Modes.MouseInput));
  WriteXY( 1,19,'(F) ExtendedFlags             : '+BoolToStringYesNo(Console.Modes.ExtendedFlags));
  WriteXY( 1,20,'    (G) InsertMode            : '+BoolToStringYesNo(Console.Modes.InsertMode));
  WriteXY( 1,21,'    (H) QuickEditMode         : '+BoolToStringYesNo(Console.Modes.QuickEditMode));
  WriteXY( 1,22,'    (I) AutoPosition          : '+BoolToStringYesNo(Console.Modes.AutoPosition));
  WriteXY( 1,23,'(J) VirtualTerminalInput      : '+BoolToStringYesNo(Console.Modes.VirtualTerminalInput));

  WriteXY(40,13,TextAttrHead,'Standard-Output-Flags:'+IntToString(Console.Modes.Output,4));
  WriteXY(40,14,'(K) ProcessedOutput           : '+BoolToStringYesNo(Console.Modes.ProcessedOutput));
  WriteXY(40,15,'(L) WrapOutput                : '+BoolToStringYesNo(Console.Modes.WrapOutput));
  WriteXY(40,16,'(M) VirtualTerminal           : '+BoolToStringYesNo(Console.Modes.VirtualTerminal));
  WriteXY(40,17,'(N) DisableNewlineAutoReturn  : '+BoolToStringYesNo(Console.Modes.DisableNewlineAutoReturn));
  WriteXY(40,18,'(O) LvbGridWorldwide          : '+BoolToStringYesNo(Console.Modes.LvbGridWorldwide));

  WriteXY(1,25,'Console.Font:');
  WriteXY(1,26,Console.Font.FontText);
  WriteXY(1,28,'Console.Desktop.Size:');
  WriteXY(1,29,Console.Desktop.Area.ToStringPosSize);
  WriteXY(1,31,LightMagenta,'(Alt+I) TestInputBehavior');

  Window(40,20,90,35,'Test Output Clipboard','(Alt+V) Set Clipboard to Demostring');
  ClipboardText := Clipboard.AsText;

  TextColor(LightGreen);
  WriteXY(1,1,'Writeln (System.Writeln):');
  GotoXY(1,2); Writeln(ClipboardText);

  Textcolor(LightMagenta);
  WriteXY(1,8,'WriteString (faster):');
  WriteString(1,9,ClipboardText);

  TextColor(LightGray);
  Crt.Window;
end;

Procedure Edit_Flags;
Var
  Key : Word;
  {$IFDEF CONSOLEOPACITY}
  OpacityPercent : Byte;
  {$ENDIF CONSOLEOPACITY}
begin
  Try
    {$IFDEF CONSOLEOPACITY}
    OpacityPercent := 100;
    {$ENDIF CONSOLEOPACITY}
    Repeat
      Show_Modes;
      Readkey(Key);
      if (Key=_1) then Console.CursorVisible := not(Console.CursorVisible) else
      if (Key=_2) then
      begin
        if (Console.CursorSize<100)
           then Console.CursorSize := Min(Console.CursorSize+5,100)
           else Console.CursorSize := 25;
      end else
      {$IFDEF CONSOLEOPACITY}
      if (Key=_3) then
      begin
        if (OpacityPercent>0)
           then OpacityPercent := Max(0,OpacityPercent-5)
           else OpacityPercent := 100;
        Console.Modes.Opacity := OpacityPercent;
      end else
      if (Key=_4) then Console.Modes.AutoOpacityOnFocus        := not(Console.Modes.AutoOpacityOnFocus)       else
      {$ENDIF CONSOLEOPACITY}
      if (Key=_5) then
      begin
        if (Console.Modes.AlternateWriteProc=awOff)
           then Console.Modes.AlternateWriteProc := awCrt else
        if (Console.Modes.AlternateWriteProc=awCrt)
           then Console.Modes.AlternateWriteProc := awConsole
           else Console.Modes.AlternateWriteProc := awOff;
      end else
      if (Key=_6) then Console.Modes.EnableAsciiCodeInput      := not(Console.Modes.EnableAsciiCodeInput)     else
      if (Key=_7) then Console.Modes.WrapWord                  := not(Console.Modes.WrapWord)                 else
      if (Key=_8) then Console.Modes.ReplaceCtrlChar           := not(Console.Modes.ReplaceCtrlChar)          else
      // Special V2 Features
      if (Key=_F2) then Console.Modes.ForceV2                  := not(Console.Modes.ForceV2)                  else
      if (Key=_F3) then Console.Modes.LineSelection            := not(Console.Modes.LineSelection)            else
      if (Key=_F4) then Console.Modes.FilterOnPaste            := not(Console.Modes.FilterOnPaste)            else
      if (Key=_F5) then Console.Modes.LineWrap                 := not(Console.Modes.LineWrap)                 else
      if (Key=_F6) then Console.Modes.CtrlKeyShortcutsDisabled := not(Console.Modes.CtrlKeyShortcutsDisabled) else
      if (Key=_F7) then Console.Modes.ExtendedEditKey          := not(Console.Modes.ExtendedEditKey)          else
      if (Key=_F8) then Console.Modes.TrimLeadingZeros         := not(Console.Modes.TrimLeadingZeros)         else
      // Standard Input/Output Flags
      if (Key=_a) then Console.Modes.ProcessedInput            := not(Console.Modes.ProcessedInput)           else
      if (Key=_b) then Console.Modes.LineInput                 := not(Console.Modes.LineInput)                else
      if (Key=_c) then Console.Modes.EchoInput                 := not(Console.Modes.EchoInput)                else
      if (Key=_d) then Console.Modes.WindowInput               := not(Console.Modes.WindowInput)              else
      if (Key=_e) then Console.Modes.MouseInput                := not(Console.Modes.MouseInput)               else
      if (Key=_f) then Console.Modes.ExtendedFlags             := not(Console.Modes.ExtendedFlags)            else
      if (Key=_g) then Console.Modes.InsertMode                := not(Console.Modes.InsertMode)               else
      if (Key=_h) then Console.Modes.QuickEditMode             := not(Console.Modes.QuickEditMode)            else
      if (Key=_i) then Console.Modes.AutoPosition              := not(Console.Modes.AutoPosition)             else
      if (Key=_j) then Console.Modes.VirtualTerminalInput      := not(Console.Modes.VirtualTerminalInput)     else
      if (Key=_k) then Console.Modes.ProcessedOutput           := not(Console.Modes.ProcessedOutput)          else
      if (Key=_l) then Console.Modes.WrapOutput                := not(Console.Modes.WrapOutput)               else
      if (Key=_m) then Console.Modes.VirtualTerminal           := not(Console.Modes.VirtualTerminal)          else
      if (Key=_n) then Console.Modes.DisableNewlineAutoReturn  := not(Console.Modes.DisableNewlineAutoReturn) else
      if (Key=_o) then Console.Modes.LvbGridWorldwide          := not(Console.Modes.LvbGridWorldwide)         else
      if (Key=_ALT_I) then TestInputBehavior else
      if (Key=_ALT_V) then
      begin
        Clipboard.AsText := 'Line 1.1|Line 1.2|Line 1.3|Line 1.4|Line 1.5|'+sLineBreak
                          + 'Line 2.1|Line 2.2|Line 2.3|Line 2.4|Line 2.5|Line 2.6|'+sLineBreak
                          + 'Line 3.1|Line 3.2|Line 3.3|Line 3.4|Line 3.5|Line 3.6|Line 3.7|';
      end;
    Until (Key=_ESC);
  Except
    On E : EConsoleApiError do
    begin
      ConsoleShowError('EConsoleApiError',E.ClassName,E.Message);
      Readkey;
    end;
  End;
end;

begin
  try
    Crt.UseRegistry := False;
    Crt.UseScreenSaveFile := False;

    Console.Window(91,36);
    Edit_Flags;
  except
    on E: Exception do
      ConsoleShowError('Error',E.ClassName,E.Message);
  end;
end.
