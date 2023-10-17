(******************************************************************************

  Name          : Ply.Patches.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 10.10.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Patches;

interface

{$I Ply.Defines.inc}

implementation

uses
  Crt,
  System.SysUtils,
  Winapi.Windows;

//  From which version the error is present I can not say, but until at least
//  version 11.3 is the following error in the System.pas.
//  Example:
//  aInt64 : Int64 = 1234;
//  Write(aInt64:10);
//  Results in the output "1234" not "      1234" as expected.
//  In the functions _WriteLong, _WriteInt64 and _WriteUInt64 not width
//  but 0 is specified when converting the integer value, which leads to
//  the fact that in the function _WriteUString to the procedure
//  AlternateWriteUnicodeStringProc the string is passed without the
//  leading spaces. The error only occurs if AlternateWriteUnicodeStringProc
//  is assigned, which is mandatory in the case of the "Playcom Console Library".
//
//  To fix the error I redirect the function System._WriteUString here to my own
//  function WriteUStringFixed to make sure that the correct string with leading
//  spaces is passed.
//
//  To disable this patch, for whatever reason, it is sufficient to comment
//  out "ApplyPatch" in the initialization section at the end of this file.

function GetWriteUStringAddress: Pointer;
asm
  {$ifdef CPUX64}
    mov rax,offset System.@WriteUString
  {$else}
    mov eax,offset System.@WriteUString
  {$endif}
end;

// Fixed Function _WriteUString from System.pas
Function WriteUStringFixed(var t: TTextRec; const s: UnicodeString; width: Integer) : Pointer;
Var uString : UnicodeString;
begin
  if assigned(AlternateWriteUnicodeStringProc) then
  begin
    uString := s;
    while length(uString)<width do uString := ' ' + uString;
    Result := AlternateWriteUnicodeStringProc(t, uString);
  end else
  begin
    WriteString(s);
    Result := @t;
  end;
end;

procedure RedirectFunction(OrgProc, NewProc: Pointer);
type
  TJmpBuffer = packed record
    Jmp: Byte;
    Offset: Integer;
  end;
var
  n: UINT_PTR;
  JmpBuffer: TJmpBuffer;
begin
  JmpBuffer.Jmp := $E9;
  JmpBuffer.Offset := PByte(NewProc) - (PByte(OrgProc) + 5);
  if not WriteProcessMemory(GetCurrentProcess, OrgProc, @JmpBuffer, SizeOf(JmpBuffer), n) then
    RaiseLastOSError;
end;

procedure ApplyPatch;
begin
  if assigned(AlternateWriteUnicodeStringProc) then
  begin
    RedirectFunction(GetWriteUStringAddress, @WriteUStringFixed);
  end;
end;

initialization
  ApplyPatch;

end.
