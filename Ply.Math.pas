(******************************************************************************

  Name          : Ply.Mathe.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 01.05.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Math;

interface

{$I Ply.Defines.inc}

Function  ValueMinMax(Value, MinValue, MaxValue: Byte) : Byte; Overload;
Function  ValueMinMax(Value, MinValue, MaxValue, DefaultValue: Byte) : Byte; Overload;

Function  ValueMinMax(Value, MinValue, MaxValue: Longint) : Longint; Overload;
Function  ValueMinMax(Value, MinValue, MaxValue: Int64) : Int64; Overload;
Function  ValueMinMax(Value, MinValue, MaxValue: Single) : Single; Overload;
Function  ValueMinMax(Value, MinValue, MaxValue: Double) : Double; Overload;
Function  ValueMinMax(Value, MinValue, MaxValue: Extended) : Extended; Overload;

Function  IsPrime(n:Int64) : Boolean;

implementation

Uses
  System.Math;

Function  ValueMinMax(Value, MinValue, MaxValue: Byte) : Byte;
begin
  Result := Max(Min(Value,MaxValue),MinValue);
end;

Function  ValueMinMax(Value, MinValue, MaxValue, DefaultValue: Byte) : Byte;
begin
  if (Value<MinValue) then Result := DefaultValue else
  if (Value>MaxValue) then Result := DefaultValue
                      else Result := Value;
end;

Function  ValueMinMax(Value, MinValue, MaxValue: Longint) : Longint;
begin
  Result := Max(Min(Value,MaxValue),MinValue);
end;

Function  ValueMinMax(Value, MinValue, MaxValue: Int64) : Int64;
begin
  Result := Max(Min(Value,MaxValue),MinValue);
end;

Function  ValueMinMax(Value, MinValue, MaxValue: Single) : Single;
begin
  Result := Max(Min(Value,MaxValue),MinValue);
end;

Function  ValueMinMax(Value, MinValue, MaxValue: Double) : Double;
begin
  Result := Max(Min(Value,MaxValue),MinValue);
end;

Function  ValueMinMax(Value, MinValue, MaxValue: Extended) : Extended;
begin
  Result := Max(Min(Value,MaxValue),MinValue);
end;

Function IsPrime(n:Int64) : Boolean;
Var maxvalue : Int64;
    i        : Int64;
begin
  // The numbers 0 and 1 are not prime numbers by definition
  if (n <= 1) then Result := False else
  // The number 2 is a prime number
  if (n=2) then Result := True else
  // If the number is divisible by 2 -> not a prime number
  if ((n mod 2)=0) then Result := False else
  begin
    // Check divisibility only up to the root of n
    maxvalue := trunc(sqrt(n));
    // Check for divisibility for all odd numbers starting from the number 3
    i := 3;
    while (i <= maxvalue) do
    begin
      if ((n mod i) = 0) then
      begin
        Result := False;
        Exit;
      end else
      begin
        i := i + 2;
      end;
    end;
    Result := True;
  end;
end;

end.
