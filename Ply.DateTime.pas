(******************************************************************************

  Name          : Ply.DateTime.pas
  Copyright     : � 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 01.09.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.DateTime;

interface

Uses
  Ply.Types;

{$I Ply.Defines.inc}

Const SecondsPerMinute       = 60;
      SecondsPerHour         = SecondsPerMinute * 60;  // 3600
      SecondsPerDay          = SecondsPerHour * 24;    // 86400
      HoursPerDay            = 24;                     // 24
      MinutesPerDay          = HoursPerDay * 60;       // 1440
      MillisecondsPerDay     = SecondsPerDay * 1000;   // 86400000
      DateTime_Second        : Double = (1/SecondsPerDay);
      DateTime_Minute        : Double = (SecondsPerMinute/SecondsPerDay);
      DateTime_Hour          : Double = (SecondsPerHour/SecondsPerDay);
      DaysOfMonth            : Array [1..12] of Byte = (31,28,31,30,31,30,31,31,30,31,30,31);

Function  SystemDate: String;  // Today as dd.mm.yyyy
Function  SystemTime: String;  // Now as hh:mm:ss

Type
  TDateTimeHelper = record helper for TDateTime
  private
  public
    Procedure Clr;
    procedure ClrDate;
    procedure ClrTime;
    Procedure InitNow;
    Procedure InitUTC;
    Procedure InitSeconds(aSeconds: Int64);
    Procedure Add(aDateTime:tDateTime);
    Procedure AddSeconds(aSeconds:Int64);
              // InitDate: 'dd.mm.yyyy' - changes only the date - time is untouched
    Procedure InitDate(aDate:String); Overload;
    Procedure InitDate(aDay,aMonth,aYear:Integer); Overload;
              // InitTime: 'hh:mm:ss' - changes only the time - date is untouched
    Procedure InitTime(ATime:String);
    Procedure InitMillisecond1970(eMillisecond:Int64);
    Procedure AddDays(CountDays:Integer);
    Procedure AddMonths(CountMonths:Longint);
    Procedure AddYears(CountYears:Longint);
    Procedure AddMilliSeconds(eMilliSeconds:Int64);
    Function  Compare(aDateTime:TDateTime) : Integer;
    Function  Equal(aDateTime:TDateTime) : Boolean;

    Function SecondsTotal : Int64;
    Function MilliSeconds1970 : Int64;
    Function AsDate : TDateTime;        // Date-Value
    Function AsTime : TDateTime;        // Time-Value
    Function AsFileDate : Longint;      // File-TimeStamp
    Function Year : Word;               // 1..9999
    Function Month : Word;              // 1..12
    Function Day : Word;                // 1..31
    Function Hour : Word;               // 0..23
    Function Minute : Word;             // 0..59
    Function Second : Word;             // 0..59
    Function Milliseconds : Word;
    Function Age : TDateTime;
    Function AgeSeconds : Int64;
    Function SortValue : TSortValue;
    Function ToDate: String;            // dd.mm.yyyy
    Function ToDateShort: String;       // dd.mm.yy
    Function ToTime: String;            // hh:mm:ss
    function ToTimeShort: String;       // hh:mm
    Function ToDateTime: String;        // 'dd.mm.yyyy, hh:mm:ss'
    function ToDateTimeExcel: String;   // 'dd.mm.yyyy hh:mm:ss'
    Function ToAge: String;             // [ddd]d hh:mm:ss
    Function YYYY : String;             // 'yyyy'
    Function YYYYMMDD : String;         // 'yyyymmdd'
    Function HHMMSS : String;           // 'HHMMSS'
    Function DateTimeFilename : String; // 'YYYYMMDD_HHMMSS'
    Function DayOfWeek : Word;          // 1..7   : Monday = 1
    Function DayOfYear : Word;          // 1..366 : 01.01.YYYY = 1
    Function CalendarWeek : Word;       // 1..53  : DIN 1355
    Function WeekOfYear : Word;         // Same as CalendarWeek
  end;

  TSeconds       = Type Cardinal;
  TSecondsHelper = Record Helper for TSeconds
  public
    Function ToCardinal : Cardinal;
    Function ToAge : String; //  [ddd]d hh:mm:ss
    Function ToHexString : String;
  End;

implementation

Uses
  Ply.Math,
  Ply.StrUtils,
  Winapi.Windows,
  System.Math,
  System.DateUtils,
  System.SysUtils;

Function  SystemDate : String;  // Today as dd.mm.yyyy
begin
  Result := FormatDateTime('dd.mm.yyyy', Now);
end;

Function  SystemTime: String;  // Now as hh:mm:ss
begin
  Result := FormatDateTime('hh:nn:ss', Now);
end;

procedure AdjustDateFormat(Var aDate:String);
Var Today                    : String;
    J_Dat,J_Heute            : Longint;
begin
  Today := SystemDate;
  // replace "," with "."
  While (Pos(',',aDate)>0) do aDate[Pos(',',aDate)] := '.';
  // replace _Blank with "." if less then two "." in aDate
  While (Pos(' ',aDate)>0) and (aDate.CountChar('.')<2) do aDate[Pos(' ',aDate)] := '.';
  // make ddmmyyyy -> dd.mm.yyyy
  if (aDate.Length=8) and (aDate.CountChar('.')=0) and (aDate=StrGetNumbers(aDate)) then
  begin
    Insert('.',aDate,3);
    Insert('.',aDate,6);
  end;
  (* Leerstellen entfernen *)
  While (Pos(' ',aDate)>0) do Delete(aDate,Pos(' ',aDate),1);
  (* Wenn keine 2*"." dann Punkt hinten anf�gen *)
  While (aDate.CountChar('.')<2) and (length(aDate)<10) do aDate := aDate + '.';
  if (aDate[1] = '.')  then aDate := '01'+ copy(aDate,1,8);
  if (aDate[2] = '.')  then aDate := '0' + copy(aDate,1,9);
  if (aDate[4] = '.')  then aDate := Copy(aDate,1,3) + copy(Today,4,2) + copy(aDate,4,5);
  if (aDate[5] = '.')  then insert('0',aDate,4);
  if (length(aDate)=6) then aDate := aDate + copy(Today,7,4);
  if (length(aDate)=7) then Insert(Copy(Today,7,3),aDate,7);
  (* Wenn das Jahrhundert fehlt *)
  if (length(aDate)=8) then
  begin
    J_Dat    := StrToInt(Copy(aDate,7,2));
    J_Heute  := StrToInt(Copy(Today,7,4));
    While (J_Dat<J_Heute-50) do J_Dat := J_Dat+100;
    Delete(aDate,7,2);
    Insert(IntToStr(J_Dat),aDate,7);
  end;
  if (length(aDate)=9) then Insert(Copy(Today,7,1),aDate,7);
end;

// German: Schaltjahr
Function  LeapYear(Year:Longint) : Boolean;
begin
  LeapYear := False;
  if ((Year mod 4)=0) then
  begin
    if (Year < 1582) then
    begin
      LeapYear := True;
    end else
    begin
      if ((Year mod 100)=0) then
      begin
        if ((Year mod 400)=0) then LeapYear := True;
      end else LeapYear := True;
    end;
  end;
end;

Function  MonthDays(Year,Month:Word) : Word;
begin
  if (Month>=1) and (Month<=12) then
  begin
    if (Month=2) then
    begin
      if (LeapYear(Year)) then MonthDays := 29
                          else MonthDays := DaysOfMonth[Month];
    end else
    begin
      MonthDays := DaysOfMonth[Month];
    end;
  end else MonthDays := 0;
end;

procedure DateToValues(aDate:String; var Year,Month,Day:Word);
begin            {'31.12.1992'==> 31 12 1992 }
  Year  := 0;
  Month := 0;
  Day   := 0;
  if (aDate<>'') then
  begin
    Day := StrToInt(copy(aDate,1,pos('.',aDate)-1));
    Delete(aDate,1,pos('.',aDate));
    Month := StrToInt(copy(aDate,1,pos('.',aDate)-1));
    Delete(aDate,1,pos('.',aDate));
    Year  := StrToInt(copy(aDate,1,10));
    Year  := Max(0,Year);
    Month := Max(1,Month);
    Month := Min(12,Month);
    Day   := Max(1,Day);
    Day   := Min(MonthDays(Year,Month),Day);
  end;
end;

Procedure AdjustTimeFormat(Var aTime:String);
begin
  // replace "," to ":"
  While (Pos(',',aTime)>0) do aTime[Pos(',',aTime)] := ':';
  // replace "." to ":"
  While (Pos('.',aTime)>0) do aTime[Pos('.',aTime)] := ':';
  // add leading Zero[s]
  if (aTime[1] = ':')  then aTime := '00'+ copy(aTime,1,6);
  if (aTime[2] = ':')  then aTime := '0' + copy(aTime,1,7);
  if (aTime[4] = ':')  then aTime := Copy(aTime,1,3) + '0' + copy(aTime,4,5);
  if (aTime[5] = ':')  then insert('0',aTime,4);
  if (length(aTime)=5) then aTime := aTime + ':00';
  if (length(aTime)=6) then aTime := aTime + '00';
  if (length(aTime)=7) then aTime := aTime + '0';
end;

Function  TimeToSeconds(aTime:String) : Cardinal;
begin
  AdjustTimeFormat(aTime);
  TimeToSeconds := StrToInt(copy(aTime,1,2))*SecondsPerHour
                 + StrToInt(copy(aTime,4,2))*SecondsPerMinute
                 + StrToInt(copy(aTime,7,2));
end;

{ TDateTimeHelper }

procedure TDateTimeHelper.Clr;
begin
  Self := 0;
end;

procedure TDateTimeHelper.InitNow;
begin
  Self := Now;
end;

Procedure TDateTimeHelper.InitUTC;
begin
{$IFDEF FPC}
  Self := LocalTimeToUniversal(now);
{$ELSE}
  Self := TTimeZone.Local.ToUniversalTime(now);
{$ENDIF}
end;

Procedure TDateTimeHelper.ClrDate;
begin
  Self := Frac(Self);
end;

Procedure TDateTimeHelper.ClrTime;
begin
  Self := Trunc(Self);
end;

Procedure TDateTimeHelper.InitSeconds(aSeconds:Int64);
begin
  Self := ASeconds / SecondsPerDay;
end;

Procedure TDateTimeHelper.Add(aDateTime:tDateTime);
begin
  Self := Self + aDateTime;
end;

Procedure TDateTimeHelper.AddSeconds(aSeconds:Int64);
begin
  Self := Self + (ASeconds/SecondsPerDay);
end;

Procedure tDateTimeHelper.InitDate(aDate:String);
Var
  Year, Month, Day : Word;
begin
  if (ADate<>'') then
  begin
    AdjustDateFormat(aDate);
    DateToValues(aDate,Year,Month,Day);
    Self := EncodeDate(Year,Month,Day) + Frac(Self);
  end else Self := Frac(Self);
end;

Procedure tDateTimeHelper.InitDate(aDay,aMonth,aYear:Integer);
begin
  // Changes only the date component, the time remains the same
  aYear  := ValueMinMax(aYear ,1,9999);
  aMonth := ValueMinMax(aMonth,1,12);
  aDay   := ValueMinMax(aDay  ,1,System.DateUtils.DaysInAMonth(aYear, aMonth));
  Self   := EncodeDate(aYear,aMonth,aDay) + Frac(Self);
end;

Procedure tDateTimeHelper.InitTime(aTime:String);
begin
  // Changes only the time component, the date remains the same
  if (ATime<>'') then self := Trunc(self) + (TimeToSeconds(ATime) / SecondsPerDay)
                 else self := Trunc(self); // Set Time to zero
end;

Procedure tDateTimeHelper.InitMillisecond1970(eMillisecond:Int64);
(* Var HelpDateTime             : tMyDateTime; *)
begin
  // 25569 = 01.01.1970, 00:00:00
  Self := 25569;
  AddMilliSeconds(eMillisecond);
end;

Procedure TDateTimeHelper.AddDays(CountDays:Integer);
begin
  Self := Self + CountDays;
end;

Procedure TDateTimeHelper.AddMonths(CountMonths:Longint);
Var iDay,iMonth,iYear           : Word;
begin
  iDay   := Day;
  iMonth := Month;
  iYear  := Year;
  if (CountMonths<0) then
  begin
    CountMonths := - CountMonths;
    iYear       := iYear - (CountMonths Div 12);
    CountMonths := (CountMonths Mod 12);
    if (iMonth<=CountMonths) then
    begin
      iYear       := iYear - 1;
      CountMonths := CountMonths - 12;
    end;
    iMonth := iMonth - CountMonths;
  end else
  if (CountMonths>0) then
  begin
    iYear       := iYear + (CountMonths Div 12);
    CountMonths := (CountMonths Mod 12);
    if (iMonth+CountMonths>12) then
    begin
      iYear       := iYear + 1;
      CountMonths := CountMonths - 12;
    end;
    iMonth := iMonth + CountMonths;
  end;
  InitDate(iDay,iMonth,iYear);
end;

Procedure TDateTimeHelper.AddYears(CountYears:Longint);
begin
  InitDate(Day,Month,Year+CountYears);
end;

Procedure TDateTimeHelper.AddMilliSeconds(eMilliSeconds:Int64);
begin
  Self := Self + (eMilliSeconds/MilliSecondsPerDay);
end;

Function TDateTimeHelper.Compare(aDateTime:TDateTime) : Integer;
begin
  if (Self<aDateTime) then Result := -1 else
  if (Self>aDateTime) then Result := 1
                      else Result := 0;
end;

Function TDateTimeHelper.Equal(aDateTime:TDateTime) : Boolean;
Var DifSeconds : Int64;
begin
  DifSeconds := (SecondsTotal-aDateTime.SecondsTotal);
  Result := (DifSeconds>=-1) and (DifSeconds<=1);
end;

Function TDateTimeHelper.SecondsTotal : Int64;
begin
  SecondsTotal := Round(Self * SecondsPerDay);
end;

Function TDateTimeHelper.MilliSeconds1970 : Int64;
begin
  // 25569 = 01.01.1970, 00:00:00 deduct -> value in days since 01.01.1970 *)
  Result := Round((Self-25569)*MilliSecondsPerDay);
end;

Function TDateTimeHelper.AsDate : TDateTime;        // Date-Value
begin
  Result := Trunc(Self);
end;

Function TDateTimeHelper.AsTime : TDateTime;        // Time-Value
begin
  Result := Frac(Self);
end;

Function TDateTimeHelper.AsFileDate : Longint;      // File-TimeStamp
Var hYear : Longint;
    Today : TDateTime;
begin
  // Date from 01.01.1980 to 31.12.2107 = 128 years
  // Time accurate to 2 seconds, i.e. 0,2,4,6,...
  (* Sekunden *)
  Result := Round(Second / 2)   // Seconds
          +  Minute * 32        // Minutes
          +  Hour   * 2048      // Hours
          +  Day    * 65536     // Days
          +  Month  * 2097152;  // Months
  hYear := Year-1980;
  if (hYear<=63) then Result := Result + (hYear*33554432) else
  begin
    Today.InitNow;
    Result := Result + ((ToDay.Year-1980) * 33554432);
  end;
end;

Function TDateTimeHelper.Year : Word;
begin
  Result := System.DateUtils.YearOf(Self);
end;

Function TDateTimeHelper.Month : Word;
begin
  Result := System.DateUtils.MonthOf(Self);
end;

Function TDateTimeHelper.Day : Word;
begin
  Result := System.DateUtils.DayOf(Self);
end;

Function  TDateTimeHelper.Hour : Word;
begin
  Result := Trunc(HoursPerDay * AsTime);
end;

Function  TDateTimeHelper.Minute : Word;
begin
  Result := Trunc(60 * Frac(HoursPerDay * AsTime));
end;

Function  TDateTimeHelper.Second : Word;
begin
  Result := Trunc(60 * Frac(MinutesPerDay * AsTime));
end;

Function  TDateTimeHelper.Milliseconds : Word;
begin
  Result := Trunc(1000 * Frac(SecondsPerDay * AsTime));
end;

Function TDateTimeHelper.Age : TDateTime;
Var CurDateTime : TDateTime;
begin
  CurDateTime.InitNow;
  Result := CurDateTime - Self;
end;

Function TDateTimeHelper.AgeSeconds : Int64;
begin
  Result := Age.SecondsTotal;
end;

Function TDateTimeHelper.SortValue : TSortValue;
begin
  Result := Age.SecondsTotal;
end;

Function TDateTimeHelper.ToDate : String; // dd.mm.yyyy
begin
  Result := FormatDateTime('dd.mm.yyyy', Self);
end;

Function TDateTimeHelper.ToDateShort: String;       // dd.mm.yy
begin
  Result := FormatDateTime('dd.mm.yy', Self);
end;

function TDateTimeHelper.ToTime: String;
begin
  Result := FormatDateTime('hh:nn:ss', Self);
end;

function TDateTimeHelper.ToTimeShort: String;
begin
  Result := FormatDateTime('hh:nn', Self);
end;

function TDateTimeHelper.ToDateTime: String;
begin
  Result := ToDate + ', ' + ToTime;
end;

function TDateTimeHelper.ToDateTimeExcel: String;
begin
  Result := ToDate + ' ' + ToTime;
end;

Function TDateTimeHelper.ToAge : String; // [yyyy]y [ddd]d hh:mm:ss
Var SecTotal : Int64;
    STime    : String;
begin
  sTime := '';
  SecTotal := Self.SecondsTotal;
  if (SecTotal>0) then
  begin
    // Tage
    if (SecTotal div SecondsPerDay > 0) then
    begin
      sTime := (SecTotal div SecondsPerDay).ToString + 'd ';
      SecTotal := SecTotal mod SecondsPerDay;
    end;
    // Stunden
    sTime := sTime + Format('%.2d',[SecTotal div SecondsPerHour])+':';
    if (SecTotal>0) then SecTotal := SecTotal mod SecondsPerHour;
    // Minuten
    sTime := sTime + Format('%.2d',[SecTotal div SecondsPerMinute])+':';
    if (SecTotal>0) then SecTotal := SecTotal mod SecondsPerMinute;
    // Sekunden
    sTime := sTime + Format('%.2d',[SecTotal]);
  end;
  Result := sTime;
end;

Function TDateTimeHelper.YYYY : String;
begin
  Result := System.SysUtils.FormatDateTime('yyyy', Self);
end;

Function TDateTimeHelper.YYYYMMDD : String;       // 'yyyymmdd'
begin
  Result := System.SysUtils.FormatDateTime('yyyymmdd', Self);
end;

Function TDateTimeHelper.HHMMSS : String;
begin
  Result := System.SysUtils.FormatDateTime('hhnnss', Self);
end;

Function TDateTimeHelper.DateTimeFilename : String;
begin
  Result := YYYYMMDD + '_' + HHMMSS;
end;

Function TDateTimeHelper.DayOfWeek: Word;    // 1..7 : Monday = 1
begin
  Result := System.DateUtils.DayOfTheWeek(Self);
end;

Function TDateTimeHelper.DayOfYear : Word;   // 1..366
Var hDateTime : tDateTime;
begin
  hDateTime.InitDate(31,12,Year-1);
  Result := Trunc(Self) - Trunc(hDateTime);
end;

Function  TDateTimeHelper.CalendarWeek : Word;    // 1..53
Const table1 : ARRAY [1..7] of ShortInt = ( 0,  1,  2,  3, -3, -2, -1);
      table2 : ARRAY [1..7] of ShortInt = ( 2,  1,  0, -1, -2, -3, -4);
Var doy1,doy2                : Integer;
    hDateTime                : tDateTime;
begin
  // DIN 1355 :
  // - Monday is the first day of the week
  // - January 4 is always in the first calendar week
  // - December 28 is always in the last calendar week
  hDateTime.InitDate(1,1,Year);

  doy1 := DayofYear + table1[hDateTime.DayOfWeek];
  doy2 := DayofYear + table2[DayOfWeek];

  if (doy1 <= 0) then
  begin
    hDateTime.InitDate(31,12,Year-1);
    Result := hDateTime.CalendarWeek;
  end else
  begin
    hDateTime.InitDate(31,12,Year);
    if (doy2 >= hDateTime.DayofYear)
       then Result := 1
       else Result := ((doy1-1) DIV 7) + 1;
  end;
end;

Function TDateTimeHelper.WeekOfYear : Word;
begin
  Result := System.DateUtils.WeekOfTheYear(Self);
end;

{ TSecondsHelper }

function TSecondsHelper.ToCardinal: Cardinal;
begin
  Result := Cardinal(Self);
end;

function TSecondsHelper.ToHexString: String;
begin
  Result := Cardinal(Self).ToHexString;
end;

function TSecondsHelper.ToAge: String;
Var SecTotal : Cardinal;
    STime    : String;
begin
  sTime := '';
  SecTotal := Self;
  if (SecTotal>0) then
  begin
    // Tage
    if (SecTotal div SecondsPerDay > 0) then
    begin
      sTime := IntToStr(SecTotal div SecondsPerDay) + 'd ';
      SecTotal := SecTotal mod SecondsPerDay;
    end;
    // Stunden
    sTime := sTime + Format('%.2d',[SecTotal div SecondsPerHour])+':';
    if (SecTotal>0) then SecTotal := SecTotal mod SecondsPerHour;
    // Minuten
    sTime := sTime + Format('%.2d',[SecTotal div SecondsPerMinute])+':';
    if (SecTotal>0) then SecTotal := SecTotal mod SecondsPerMinute;
    // Sekunden
    sTime := sTime + Format('%.2d',[SecTotal]);
  end;
  Result := sTime;
end;


end.
