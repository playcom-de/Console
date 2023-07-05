(******************************************************************************

  Name          : Ply.Console.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 05.07.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Console.Debug;

interface

{$I Ply.Defines.inc}

uses
  Classes,
  Windows;

type
  TPlyConsoleDebug = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

Var PlyConsoleDebug : TPlyConsoleDebug;

implementation

constructor TPlyConsoleDebug.Create(AOwner: TComponent);
begin
  inherited;
  AllocConsole;
end;

destructor TPlyConsoleDebug.Destroy;
begin
  FreeConsole;
  inherited;
end;

begin
  PlyConsoleDebug := TPlyConsoleDebug.Create(Nil);
end.
