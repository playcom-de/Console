(******************************************************************************

  Name          : Ply.Files.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 02.07.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Files;

interface

{$I Ply.Defines.inc}

Uses
  Ply.Types,
  System.SysUtils;

Const fsOriginFromBeginning = 0;
      fsOriginFromCurrent   = 1;
      fsOriginFromEnd       = 2;

Var FileLastError : Longint = 0;
    FileDebugMode : Boolean = False;

Type tPlyFile = object
     Private
       f : File;
       Function GetFileName : String;
     Public
       Property FileName:String Read GetFileName;
       Procedure Init;
       Function  Open(aFileName:String; aRecSize:tFileRecSize;
                   aFileMode:tFileModeOpen=fmShare) : Boolean;
       Function  Handle : tHandle;
       Function  Mode : TFileModeStatus;
       Function  RecSize : Int64;
       Function  IsOpen : Boolean;
       Function  Eof : Boolean;
       Function  Filepos : Longint;
       Function  Filesize : Longint;
       Function  Seek(FPos:Longint) : Boolean;
       Function  DosRead(Var Daten) : Boolean;
       Function  BlockRead(Var Daten; RecCount:tFileRecCount; Out ReadRec:tFileRecCount) : Boolean;
       Function  DosWrite(Var Daten) : Boolean;
       Function  BlockWrite(Var Daten; RecCount:tFileRecCount; Out WrittenRec:tFileRecCount) : Boolean;
       Procedure Seek_Eof;
       Function  Seek_Read(FPos:Longint; Var Daten) : Boolean;
       Function  Seek_Write(FPos:Longint; Var Daten) : Boolean;
       Procedure Truncate;
       Function  Erase : Boolean;
       Procedure Rename(NewName:String);
       Function  DeleteRecord(FPosRecord:Longint) : Boolean;
       Procedure Close;
       Procedure Close_Delete;
     end;

Type tPlyTextfile = Object
     Private
       tf : Text;
       Function  GetFilename : String;
     Public
       Property  Filename:String Read GetFilename;
       Procedure Init;
       Function  Handle : tHandle;
       Function  Mode : TFileModeStatus;
       Function  GetFilemode : String;
       Function  IsOpen : Boolean;
       Function  Open_Read_Filemode(DName:String; FM:Byte) : Boolean;
       Function  Open_Read(DName:String) : Boolean;
       Function  Open_Read_Exklusiv(DName:String) : Boolean;
       Function  Open_Write_Filemode(DName:String; FM:Byte; UTF8_Bom:Boolean=False) : Boolean;
       Function  Open_Write(DName:String; UTF8_BOM:Boolean=False) : Boolean;
       Function  Open_Write_Exklusiv(DName:String) : Boolean;
                 (* Create = Delete and Open_Write *)
       Function  Create(DName:String; Codepage:Word=_Codepage_850) : Boolean;
       Function  Create_Counter(FName:String; Codepage:Word=_Codepage_850) : Boolean;
       Function  Append : Boolean;
       Function  Eof : Boolean;
       Function  Readln(Var Help:String) : Boolean;
       Function  Write(Help:String) : Boolean;
       Function  Writeln(Help:String) : Boolean;
       Function  Erase : Boolean;
       Function  Rename(NewName:String) : Boolean;
       Procedure Close_System;
       Procedure Close;
       Procedure Close_Delete;
     end;

Function  TextfileOpenRead(var Textfile:Text; Filename:String) : Boolean;
Function  TextfileOpenWrite(var Textfile:Text; Filename:String) : Boolean;

function Filename_Replace_Counter(FileName: String; MinCounter: Longint = 1;
    IncSubDir: Boolean = False; IncZipFiles: Boolean = False): String;
function Filename_Replace_Counter2(FileName: String; IncSubDir, IncZipFiles:
    Boolean): String;

implementation

Uses
  {$IFDEF CONSOLE}
    Ply.Console.Extended,
  {$ELSE}
    VCL.Dialogs,
  {$ENDIF}
  Ply.StrUtils,
  Ply.SysUtils,
  System.Math,
  System.StrUtils;

(* $1000000 = 16.777.216 Byte | Read/Write max 16 MByte *)
Const _BlockRead_MaxByte     : Int64  = $1000000;
      _BlockWrite_MaxByte    : Int64  = $1000000;

Procedure ShowFileErrorMessage(Title,FileName,Msg1:String; Msg2:String='');
begin
  if (FileDebugMode) then
  begin
    {$IFDEF CONSOLE}
      ConsoleShowError('Error('+IntToStr(FileLastError)+'): '+Title
        ,'FileName: '+FileName,Msg1,Msg2);
    {$ELSE}
      ShowMessage(Title+sLineBreak
        +'Error('+IntToStr(FileLastError)+')'+sLineBreak
        +'FileName: '+FileName+sLineBreak
        +Msg1+sLineBreak
        +Msg2+sLineBreak);
    {$ENDIF}
  end;
end;

Function  FileSizeByte(aFileName:String) : Int64;
Var sr : TSearchRec;
begin
  if (FindFirst(aFileName, faAnyFile, sr) = 0) then
  begin
    Result := sr.Size;
  end else
  begin
    Result := -1;  // File not found
  end;
  FindClose(sr);
end;

Function  FileReset(Var f:File; Const aFileName:String; aRecSize:tFileRecSize;
            aFileMode:TFileModeOpen) : Boolean;
begin
  Try
    System.AssignFile(f, aFileName);
    System.FileMode := aFileMode;
    {$I-}
    System.Reset(f,aRecSize);
    {$I+}
    FileLastError := IoResult;
    Result := (FileLastError=0);
  Except
    Result := False;
  End;
end;

Function  FileRewrite(Var f:File; Const aFileName:String; aRecSize:tFileRecSize;
            aFileMode:TFileModeOpen) : Boolean;
begin
  {$I-}
  System.Assign(f, aFileName);
  System.FileMode := aFileMode;
  System.Rewrite(f,aRecSize);
  {$I+}
  FileLastError := IoResult;
  Result := (FileLastError=0);
end;

(***********************************************************)
(* Open exsisting file or create file                      *)
(***********************************************************)
Function  FileOpen(Var f:File; aFileName:String; aRecSize:tFileRecSize;
            aFileMode:TFileModeOpen) : Boolean;
Var lFileSizeByte : Longint;
begin
  if (aFileName<>'') then
  begin
    if (aFileMode<>fmShare) and (aFileMode<>fmDenyRW) and
       (aFileMode<>fmDenyW) and (aFileMode<>fmShareR) then
    begin
      // nwErrorCode := 11; (* 11 = Ungültiges Format *)
      // NetwareLog('FileOpen',DName,'Filemode='+IntToStr(aFileMode),'');
      if (aFileMode in [fmOpenRead..fmOpenReadWrite]) then
      begin
        aFileMode := aFileMode + fmShareDenyNone;
      end;
    end;
    if (FileReset(f,aFileName,aRecSize,aFileMode)) then
    begin
      FileOpen := True;
      (* When Debug-Mode is activated *)
      if (FileDebugMode) then
      begin
        (* Check whether the size of the file fit to aRecSize *)
        if (aRecSize>1) then
        begin
          lFileSizeByte := FileSizeByte(aFileName);
          if (lFileSizeByte>0) then
          begin
            if ((lFileSizeByte mod aRecSize)<>0) then
            begin
              ShowFileErrorMessage('Error: FileOpen (FileSize<>RecSize)'
                ,aFileName
                ,'FileSize: '+IntToStr(lFileSizeByte)
                ,'RecSize: '+IntToStr(aRecSize));
            end;
          end;
        end;
      end;
    end else
    (* Error(2) = File not found          *)
    (* if File does not exist then create *)
    if (FileLastError=2) then
    begin
      Result := FileRewrite(f,aFileName,aRecSize,aFileMode);
      if (FileLastError<>0) then
      begin
        ShowFileErrorMessage('FileOpen (Could not create file)',aFileName,'');
      end;
    end else
    (* Error(3) = Path not found          *)
    if (FileLastError=3) then
    begin
      Result := False;
      ShowFileErrorMessage('FileOpen (Path not found)',aFilename,'');
    end else
    (* Error(4) : Too many files open *)
    if (FileLastError=4) then
    begin
      Result := False;
      ShowFileErrorMessage('FileOpen (Too many files open)',aFilename,'');
    end else
    (* Error(5): Access denied - by other user *)
    if (FileLastError<>5) then
    begin
      Result := False;
      (* nothing to report *)
    end else
    (* if not Error(5) then show Error-Message *)
    begin
      Result := False;
      ShowFileErrorMessage('FileOpen ',aFileName,'');
    end;
  end else
  begin
    Result := False;
    FileLastError := 2; (* 2 = File not found *)
  end;
  (* Set back to Standard-FileMode *)
  System.Filemode := fmShare;
end;

Function  TextfileOpenRead(var Textfile:Text; Filename:String) : Boolean;
begin
  PlyLastResult := 0;
  Filemode := $42; { = nwShare }
  if (FileExists(Filename)) then
  begin
    {$I-}
    Assign(Textfile,Filename);
    Reset(Textfile);
    PlyLastResult := IoResult;
    {$I+}
  end else
  begin
    {$I-}
    Assign(Textfile,Filename);
    Rewrite(Textfile);
    PlyLastResult := IoResult;
    {$I+}
  end;
  Result := (PlyLastResult=0);
end;

Function  TextfileOpenWrite(var Textfile:Text; Filename:String) : Boolean;
begin
  PlyLastResult := 0;
  Filemode := $42; { = nwShare }
  if (FileExists(Filename)) then
  begin
    Assign(Textfile,Filename);
    {$I-}
    Append(Textfile);
    {$I+}
    PlyLastResult := IoResult;
  end else
  begin
    Assign(Textfile,Filename);
    {$I-}
    Rewrite(Textfile);
    {$I+}
    PlyLastResult := IoResult;
  end;
  Result := (PlyLastResult=0);
end;

function Filename_Replace_Counter(FileName: String; MinCounter: Longint = 1;
    IncSubDir: Boolean = False; IncZipFiles: Boolean = False): String;
Var i                        : Integer;
    ZPos                     : Integer;
    FileFound                : Boolean;
    Counter                  : String;
    Counter_Name             : String;
    NewFilename              : String;
begin
  NewFilename := FileName;
  // If a counter is within the FileName
  if (Pos('?',FileName)>0) then
  begin
    MinCounter := Max(0,MinCounter);
    // Check for '??.???'
    Counter := '??.???';
    ZPos    := Pos(Counter,FileName);
    if (ZPos>0) then
    begin
      i := MinCounter;
      Repeat
        Counter_Name := IntToStringLZ(i,5); (* -> NNNNN *)
        Insert('.',Counter_Name,3);  (* 'NNNNN' -> 'NN.NNN' *)
        NewFilename := ReplaceStr(FileName,Counter,Counter_Name);
        if (IncSubDir) then
        begin
          FileFound := (PlyFileExistsSubDir(NewFilename,True)<>'');
        end else
        begin
          FileFound := FileExists(NewFilename);
        end;
        // If you also want to search for ZIP files with the name
        if not(FileFound) and (IncZipFiles) then
        begin
          if (IncSubDir) then
          begin
            FileFound := PlyFileExistsSubDir(FilenameReplaceExtension(NewFilename,'ZIP'),True)<>'';
          end else
          begin
            FileFound := FileExists(FilenameReplaceExtension(NewFilename,'ZIP'));
          end;
        end;
        Inc(i);
      Until (not(FileFound)) or (i>=(Power(10,length(Counter))));
      // If not found and the counter cannot be incremented further (99.999),
      // then replace counter with 00.000..ZZ.ZZZ
      if (FileFound) then
      begin
        // Replace counter with 000..ZZZ
        NewFilename := Filename_Replace_Counter2(FileName,IncSubDir,IncZipFiles);
      end else
      begin
        // Replace Filename with NewFilename to terminate the function because
        // there are no more ? in the filename
        FileName := NewFilename;
      end;
    end else
    // Check for '?????' -> '????' -> '???' -> '??' -> '?'
    begin
      Counter := '?????';
      Repeat
        ZPos := Pos(Counter,FileName);
        if (ZPos>0) then
        begin
          i := MinCounter;
          Repeat
            NewFilename := ReplaceStr(FileName,Counter,IntToStringLZ(i,Length(Counter)));
            if (IncSubDir) then
            begin
              FileFound := PlyFileExistsSubDir(NewFilename,True)<>'';
            end else
            begin
              FileFound := PlyFileExists(NewFilename);
            end;
            // If you also want to search for ZIP files with the name
            if not(FileFound) and (IncZipFiles) then
            begin
              if (IncSubDir) then
              begin
                FileFound := PlyFileExistsSubDir(FilenameReplaceExtension(NewFilename,'ZIP'),True)<>'';
              end else
              begin
                FileFound := PlyFileExists(FilenameReplaceExtension(NewFilename,'ZIP'));
              end;
            end;
            Inc(i);
          Until (not(FileFound)) or (i>=(Power(10,length(Counter))));
          // If not found and the counter cannot be incremented further
          // (9, 99, 999, 9999, 99999), then replace counter with 000..ZZZ
          if (FileFound) then
          begin
            // Replace counter with 000..ZZZ
            NewFilename := Filename_Replace_Counter2(FileName,IncSubDir,IncZipFiles);
          end else
          begin
            // Replace filename with NewFilename to terminate the function
            // because there are no more ? in the filename
            FileName := NewFilename;
          end;
        end else
        begin
          Delete(Counter,1,1); (* ????? -> ???? -> ??? -> ?? -> ? *)
        end;
      Until (Counter='') or (ZPos>0);
    end;
  end;
  Result := NewFilename;
end;

function Filename_Replace_Counter2(FileName: String; IncSubDir,
    IncZipFiles:Boolean): String;
Var i                        : Longint;
    ZPos                     : Byte;
    FileFound                : Boolean;
    Counter                  : String;
    Counter_Name             : String;
    NewFilename              : String;
begin
  NewFilename := FileName;
  // Only if there is a ? in the filename at all
  if (Pos('?',FileName)>0) then
  begin
    (* Check for '??.???' *)
    Counter := '??.???';
    ZPos    := Pos(Counter,FileName);
    if (ZPos>0) then
    begin
      i := 1;
      Repeat
        Counter_Name := IntToCounterFilename(i,5);
        Insert('.',Counter_Name,3);  (* 'ZZZZZ' -> 'ZZ.ZZZ' *)
        NewFilename := ReplaceStr(FileName,Counter,Counter_Name);
        if (IncSubDir) then
        begin
          FileFound := PlyFileExistsSubDir(NewFilename,True)<>'';
        end else
        begin
          FileFound := PlyFileExists(NewFilename);
        end;
        // If you also want to search for ZIP files with the name
        if not(FileFound) and (IncZipFiles) then
        begin
          if (IncSubDir) then
          begin
            FileFound := PlyFileExistsSubDir(FilenameReplaceExtension(NewFilename,'ZIP'),True)<>'';
          end else
          begin
            FileFound := PlyFileExists(FilenameReplaceExtension(NewFilename,'ZIP'));
          end;
        end;
        Inc(i);
      Until (not(FileFound)) or (i>=(Power(36,length(Counter))));
      if (FileFound) then
      begin
        // ToDo: Make an entry in the LogFile
      end else
      begin
        FileName := NewFilename;
      end;
    end else
    (* Check for '?????' -> '????' -> '???' -> '??' -> '?' *)
    begin
      Counter   := '?????';
      Repeat
        ZPos := Pos(Counter,FileName);
        if (ZPos>0) then
        begin
          i := 1;
          Repeat
            NewFilename := ReplaceStr(FileName,Counter,IntToCounterFilename(i,Length(Counter)));
            if (IncSubDir) then
            begin
              FileFound := PlyFileExistsSubDir(NewFilename,True)<>'';
            end else
            begin
              FileFound := PlyFileExists(NewFilename);
            end;
            // If you also want to search for ZIP files with the name
            if not(FileFound) and (IncZipFiles) then
            begin
              if (IncSubDir) then
              begin
                FileFound := PlyFileExistsSubDir(FilenameReplaceExtension(NewFilename,'ZIP'),True)<>'';
              end else
              begin
                FileFound := PlyFileExists(FilenameReplaceExtension(NewFilename,'ZIP'));
              end;
            end;
            Inc(i);
          Until (not(FileFound)) or (i>=(Power(36,length(Counter))));
          if (FileFound) then
          begin
            // ToDo: Make an entry in the LogFile
          end else
          begin
            // Replace Filename with NewFilename to terminate the function
            // because there are no more ? in the filename
            FileName := NewFilename;
          end;
        end else
        begin
          Delete(Counter,1,1); (* ????? -> ???? -> ??? -> ?? -> ? *)
        end;
      Until (Counter='') or (ZPos>0);
    end;
  end;
  Result := NewFilename;
end;

(*******************************)
(***** tFile - Declaration *****)
(*******************************)
Function  tPlyFile.GetFileName: string;
begin
  Result := tFilerec(f).Name;
end;

Procedure tPlyFile.Init;
begin
  FillChar(tFilerec(f),sizeof(tFilerec),#0);
end;

Function  tPlyFile.Open(aFileName:String; aRecSize:tFileRecSize;
            aFileMode:TFileModeOpen=fmShare) : Boolean;
begin
  Init;
  Result := FileOpen(f,aFileName,aRecSize,aFileMode);
end;

Function  tPlyFile.Handle : tHandle;
begin
  Result := tFilerec(f).Handle;
end;

Function  tPlyFile.Mode : TFileModeStatus;
begin
  Result := tFilerec(f).Mode;
end;

Function  tPlyFile.RecSize : Int64;
begin
  Result := tFilerec(f).RecSize;
end;

Function  tPlyFile.IsOpen : Boolean;
Var FMode : TFileModeStatus;
begin
  FMode := Mode;
  if (FMode=FMINPUT)  or
     (FMode=FMOUTPUT) or
     (FMode=FMINOUT)  then Result := True
                      else Result := False;
end;

Function  tPlyFile.Eof : Boolean;
begin
  if (IsOpen) then
  begin
    Result := System.Eof(f);
  end else
  begin
    Result := True;
  end;
end;

Function  tPlyFile.Filepos : Longint;
begin
  if (IsOpen) then
  begin
    Result := System.Filepos(f);
  end else
  begin
    Result := -1;
  end;
end;

Function  tPlyFile.Filesize : Longint;
begin
  if (IsOpen) then
  begin
    Result := System.Filesize(f);
  end else
  begin
    Result := -1;
  end;
end;

Function  tPlyFile.Seek(FPos:Longint) : Boolean;
Var FSize                    : Longint;
begin
  if (FPos<0) then FPos := 0 else
  begin
    FSize := Filesize;
    if (FPos>FSize) then FPos := FSize;
  end;
  {$I-}
  System.Seek(f,FPos);
  {$I+}
  FileLastError := IoResult;
  Result  := (FileLastError=0);
end;

Function  tPlyFile.DosRead(Var Daten) : Boolean;
Var NumRead                  : integer;
begin
  if not(Eof) then
  begin
    {$I-}
    System.BlockRead(f,Daten,1,NumRead); (* 1 = Read 1 record *)
    {$I+}
    FileLastError := IoResult;
    Result  := (FileLastError=0);
  end else
  begin
    FileLastError := 38;   // 38 : End of File
    Result := False;
  end;
end;

Function  tPlyFile.BlockRead(Var Daten; RecCount:tFileRecCount; Out ReadRec:tFileRecCount) : Boolean;
Var CountByte                : Int64;
    Steps                    : Int64;
    RecCountStep             : Int64;
    ReadRec_Total            : tFileRecCount;
    Count_Steps              : Longint;
    DatenPtr                 : PAnsiChar;
begin
  Result := False;
  ReadRec   := 0;
  if not(Eof) then
  begin
    CountByte := RecCount * RecSize;
    // if less then 16 MByte to read
    if (CountByte<=_BlockRead_MaxByte) then
    begin
      {$I-}
      System.BlockRead(f,Daten,RecCount,ReadRec);
      {$I+}
      FileLastError := IOResult;
      if (FileLastError<>0) then
      begin
        ShowFileErrorMessage('tPlyFile.BlockRead'
          ,FileName
          ,'RecCount: '+IntToString(RecCount,5)+'  RecSize: ' +IntToString(RecSize,5)
          +'ReadRec : '+IntToString(ReadRec,5) +'  FileSize: '+IntToString(Filesize,5));
      end;
      if (ReadRec>0) then Result := True;
    end else
    // if more then 16 MByte to read
    begin
      FillChar(Daten,CountByte,#0);
      DatenPtr := @Daten;
      // Calculate steps of 16 MByte to read
      Steps := (CountByte Div _BlockRead_MaxByte) + 1;
      // Calculate number of records per step
      RecCountStep := (RecCount Div Steps) + 1;

      ReadRec_Total := 0;
      Count_Steps   := 0;
      Repeat
        inc(Count_Steps);
        RecCountStep := Min(RecCountStep,RecCount-ReadRec_Total);
        {$I-}
        System.BlockRead(f,DatenPtr[ReadRec_Total*RecSize],RecCountStep,ReadRec);
        {$I+}
        FileLastError := IOResult;
        if (FileLastError=0) then
        begin
          ReadRec_Total := ReadRec_Total + ReadRec;
        end;
      until (Count_Steps>=Steps) or (ReadRec_Total>=RecCount) or (FileLastError<>0);
      if (FileLastError<>0) then
      begin
        ShowFileErrorMessage('tPlyFile.BlockRead Steps'
          ,FileName
          ,'RecCount: '+IntToString(RecCount,5)+'  RecSize: ' +IntToString(RecSize,5)
          +'ReadRec : '+IntToString(ReadRec,5) +'  FileSize: '+IntToString(Filesize,5));
      end;
      // Return how many records are read in total
      ReadRec := ReadRec_Total;
      if (ReadRec>0) then Result := True;
    end;
  end else
  begin
    FileLastError := 38;  // 38 : End of File
  end;
end;

Function  tPlyFile.DosWrite(Var Daten) : Boolean;
Var NumWritten               : tFileRecCount;
begin
  {$I-}
  System.BlockWrite(f,Daten,1,NumWritten);
  {$I+}
  FileLastError := IoResult;
  DosWrite := (FileLastError=0);
end;

Function  tPlyFile.BlockWrite(Var Daten; RecCount:tFileRecCount; Out WrittenRec:tFileRecCount) : Boolean;
Var CountByte                : Int64;
    Steps                    : Int64;
    AnzRec_Step              : Int64;
    WriteRec_Total           : tFileRecCount;
    Count_Steps              : Longint;
    DatenPtr                 : PAnsiChar;
begin
  Result := False;
  WrittenRec := 0;
  CountByte := RecCount * RecSize;
  (* if less then 16 MByte to write *)
  if (CountByte<=_BlockWrite_MaxByte) then
  begin
    {$I-}
    System.BlockWrite(f,Daten,RecCount,WrittenRec);
    {$I+}
    FileLastError := IOResult;
    if (FileLastError<>0) then
    begin
        ShowFileErrorMessage('tPlyFile.BlockWrite'
          ,FileName
          ,'RecCount: '+IntToString(RecCount,5)   +'  RecSize: ' +IntToString(RecSize,5)
          +'ReadRec : '+IntToString(WrittenRec,5) +'  FileSize: '+IntToString(Filesize,5));
    end;
    if (RecCount=WrittenRec) then Result := True;
  end else
  (* if more then 16 MByte to write *)
  begin
    DatenPtr := @Daten;
    (* Calculate steps of 16 MByte to write data *)
    Steps          := (CountByte Div _BlockWrite_MaxByte) + 1;
    (* Calculate number of records per step to write *)
    AnzRec_Step    := (RecCount Div Steps) + 1;
    WriteRec_Total := 0;
    Count_Steps    := 0;
    Repeat
      inc(Count_Steps);
      AnzRec_Step := Min(AnzRec_Step,RecCount-WriteRec_Total);
      {$I-}
      System.BlockWrite(f,DatenPtr[WriteRec_Total*RecSize],AnzRec_Step,WrittenRec);
      {$I+}
      FileLastError := IOResult;
      if (FileLastError=0) then
      begin
        WriteRec_Total := WriteRec_Total + WrittenRec;
      end;
    until (Count_Steps>=Steps) or (WriteRec_Total>=RecCount) or (FileLastError<>0);
    if (FileLastError<>0) then
    begin
      ShowFileErrorMessage('tPlyFile.BlockWrite Steps'
        ,FileName
        ,'RecCount: '+IntToString(RecCount,5)   +'  RecSize: ' +IntToString(RecSize,5)
        +'ReadRec : '+IntToString(WrittenRec,5) +'  FileSize: '+IntToString(Filesize,5));
    end;
    (* Set Out-Parameter *)
    WrittenRec := WriteRec_Total;
    if (WrittenRec=RecCount) then
    begin
      BlockWrite := True;
    end else
    begin
      ShowFileErrorMessage('tPlyFile.BlockWrite Steps'
        ,FileName
        ,'RecCount: '+IntToString(RecCount,5)   +'  RecSize: ' +IntToString(RecSize,5)
        +'ReadRec : '+IntToString(WrittenRec,5) +'  FileSize: '+IntToString(Filesize,5));
    end;
  end;
end;

Procedure tPlyFile.Seek_Eof;
begin
  System.Seek(f,Filesize);
end;

Function  tPlyFile.Seek_Read(FPos:Longint; Var Daten) : Boolean;
begin
  if (FPos>=0) and (FPos<=Filesize) then
  begin
    Seek(FPos);
    Result := DosRead(Daten);
  end else
  begin
    FileLastError := 100; (* Disk Read Error *)
    Result := False;
  end;
end;

Function  tPlyFile.Seek_Write(FPos:Longint; Var Daten) : Boolean;
begin
  if (FPos>=0) and (FPos<=Filesize) then
  begin
    Seek(FPos);
    Result := DosWrite(Daten);
  end else
  begin
    FileLastError := 101; (* Disk Write Error *)
    Result := False;
  end;
end;

Procedure tPlyFile.Truncate;
begin
  {$I-}
  System.Truncate(f);
  {$I+}
  FileLastError := IoResult;
  if (FileLastError<>0) then
  begin
    ShowFileErrorMessage('tPlyFile.Truncate',FileName
      ,'FileSize_Byte : '+FileSizeByte(FileName).ToString);
  end;
end;

Function  tPlyFile.Erase : Boolean;
begin
  {$I-}
  System.Erase(f);
  {$I+}
  FileLastError := IoResult;
  if (FileLastError<>0) and  // Success
     (FileLastError<>5) then // File is still opened by another user
  begin
    ShowFileErrorMessage('tPlyFile.Erase',FileName
      ,'FileSize_Byte : '+FileSizeByte(FileName).ToString);
  end;
  Result := (FileLastError=0);
end;

Procedure tPlyFile.Rename(NewName:String);
begin
  {$I-}
  System.Rename(f,NewName);
  {$I+}
  FileLastError := IoResult;
  if (FileLastError<>0) then
  begin
    ShowFileErrorMessage('tPlyFile.Rename',FileName
      ,'FileSize_Byte : '+FileSizeByte(FileName).ToString);
  end;
end;

Function  tPlyFile.DeleteRecord(FPosRecord:Longint) : Boolean;
Var RecordData               : pByte;
    FPos                     : Longint;
    Error                    : Boolean;
begin
  Result := False;
  if (IsOpen) then
  begin
    if (FPosRecord<Filesize) then
    begin
      GetMem(RecordData,RecSize);
      Error := False;
      FPos  := FPosRecord+1;
      While (FPos<Filesize) and not(Error) do
      begin
        if (Seek_Read(FPos,RecordData^)) then
        begin
          if not(Seek_Write(FPos-1,RecordData^)) then
          begin
            Error := True;
          end;
        end else Error := True;
        inc(FPos);
      end;
      if not(Error) then
      begin
        if (Seek(Filesize-1)) then
        begin
          Truncate;
          Result := True;
        end;
      end;
      FreeMem(RecordData,RecSize);
    end;
  end;
end;

Procedure tPlyFile.Close;
begin
  if (IsOpen) then
  begin
    {$I-}
    System.CloseFile(f);
    {$I+}
    FileLastError := IoResult;
    if (FileLastError<>0) then
    begin
      ShowFileErrorMessage('tPlyFile.Close',FileName
        ,'FileSize_Byte : '+FileSizeByte(FileName).ToString);
    end;
  end;
end;

Procedure tPlyFile.Close_Delete;
begin
  Close;
  Erase;
end;

(***********************************)
(***** TTextfile - Declaration *****)
(***********************************)
Function  tPlyTextfile.GetFilename : String;
begin
  Result := StrPas(tTextRec(tf).Name);
end;

Procedure tPlyTextfile.Init;
begin
  FillChar(tTextrec(tf),sizeof(tTextrec),#0);
end;

Function  tPlyTextfile.Handle : tHandle;
begin
  Result := tTextRec(tf).Handle;
end;

Function  tPlyTextfile.Mode : TFileModeStatus;
begin
  Result := tTextRec(tf).Mode;
end;

Function  tPlyTextfile.GetFilemode : String;
begin
  if (Mode=fmclosed) then Result := 'Closed' else
  if (Mode=FMINPUT)  then Result := 'Input ' else
  if (Mode=FMOUTPUT) then Result := 'Output' else
  if (Mode=FMINOUT)  then Result := 'InOut '
                     else Result := Mode.ToString;
end;

Function  tPlyTextfile.IsOpen : Boolean;
begin
  if (Mode=FMINPUT)  or
     (Mode=FMOUTPUT) or
     (Mode=FMINOUT)  then Result := True
                     else Result := False;
end;

Function  tPlyTextfile.Open_Read_Filemode(DName:String; FM:Byte) : Boolean;
begin
  if (DName<>'') then
  begin
    FileLastError := 0;
    if (FileExists(DName)) then
    begin
      System.Assign(tf,DName);
      System.Filemode := FM;
      {$I-}
      System.Reset(tf);
      {$I+}
      FileLastError := IoResult;
    end else
    begin
      System.Assign(tf,DName);
      System.Filemode := FM;
      {$I-}
      System.Rewrite(tf);
      {$I+}
      FileLastError := IoResult;
    end;
  end else FileLastError := 2;
  Result := (FileLastError=0);
end;

Function  tPlyTextfile.Open_Read(DName:String) : Boolean;
begin
  Result := Open_Read_Filemode(DName,fmShare);
end;

Function  tPlyTextfile.Open_Read_Exklusiv(DName:String) : Boolean;
begin
  Result := Open_Read_Filemode(DName,fmDenyRW);
end;

Function  tPlyTextfile.Open_Write_Filemode(DName:String; FM:Byte;
            UTF8_Bom:Boolean=False) : Boolean;
begin
  if (DName<>'') then
  begin
    FileLastError := 0;
    if (FileExists(DName)) then
    begin
      System.Assign(tf,DName);
      System.Filemode := FM;
      {$I-}
      System.Append(tf);
      {$I+}
      FileLastError := IoResult;
    end else
    begin
      System.Assign(tf,DName);
      System.Filemode := FM;
      {$I-}
      System.Rewrite(tf);
      (* Wenn die Datei in UFT8 erstellt werden soll, dann Byte Order Mark *)
      (* (BOM) in die Datei schreiben                                      *)
      if (UTF8_Bom) then
      begin
        System.Write(tf,#$ef + #$bb + #$bf);
      end;
      {$I+}
      FileLastError := IoResult;
    end;
  end else FileLastError := 2;
  Result := (FileLastError=0);
end;

Function  tPlyTextfile.Open_Write(DName:String; UTF8_BOM:Boolean=False) : Boolean;
begin
  Result := Open_Write_Filemode(DName,fmShare,UTF8_BOM);
end;

Function  tPlyTextfile.Open_Write_Exklusiv(DName:String) : Boolean;
begin
  Result := Open_Write_Filemode(DName,fmDenyRW);
end;

Function  tPlyTextfile.Create(DName:String; Codepage:Word=_Codepage_850) : Boolean;
begin
  if (DName<>'') then
  begin
    if (FileExists(DNAme)) then
    begin
      if (DeleteFile(DName)) then
      begin
        Result := Open_Write(DName,Codepage=_Codepage_UTF8);
      end else Result := False;
    end else
    begin
      Result := Open_Write(DName,Codepage=_Codepage_UTF8);
    end;
  end else Result := False;
end;

Function  tPlyTextfile.Create_Counter(FName:String; Codepage:Word=_Codepage_850) : Boolean;
Var
  Directory : String;
begin
  Result := False;
  if (FName<>'') then
  begin
    Directory := ExtractFilePath(FName);
    (* Delete invalid Characters in Filename *)
    FName := Directory + Filename_Make_valid(ExtractFileName(FName));
    if (Directory<>'') then
    begin
      ForceDirectories(Directory);
    end;
    (* If a counter is within the filename "???" -> Replace it *)
    FName  := Filename_Replace_Counter(FName,0,False,False);
    if (PlyFileDelete(FName)) then
    begin
      if (Open_Write(FName,(Codepage=_Codepage_UTF8))) then
      begin
        Result := True;
      end;
    end;
  end;
end;

Function  tPlyTextfile.Append : Boolean;
begin
  {$I-}
  System.Append(tf);
  {$I+}
  FileLastError := IoResult;
  Result := (FileLastError=0);
end;

Function  tPlyTextfile.Eof : Boolean;
begin
  if (IsOpen) then
  begin
    {$I-}
    Result := System.Eof(tf);
    {$I+}
    FileLastError := IoResult;
  end else
  begin
    Result        := True;
    FileLastError := 103;  // 103 = File not open
    ShowFileErrorMessage('tPlyTextfile.Eof',FileName,'File not open');
  end;
end;

Function  tPlyTextfile.Readln(Var Help:String) : Boolean;
begin
  if not(System.Eof(tf)) then
  begin
    {$I-}
    System.Readln(tf,Help);
    {$I+}
    FileLastError := IoResult;
    Result := (FileLastError=0);
  end else
  begin
    FileLastError := 100;
    Result := False;
  end;
end;

Function  tPlyTextfile.Write(Help:String) : Boolean;
begin
  {$I-}
  System.Write(tf,Help);
  {$I+}
  FileLastError := IoResult;
  Result := (FileLastError=0);
end;

Function  tPlyTextfile.Writeln(Help:String) : Boolean;
begin
  {$I-}
  System.Writeln(tf,Help);
  {$I+}
  FileLastError := IoResult;
  Result  := (FileLastError=0);
end;

Function  tPlyTextfile.Erase : Boolean;
begin
  {$I-}
  System.Erase(tf);
  {$I+}
  FileLastError := IoResult;
  Result := (FileLastError=0);
end;

Function  tPlyTextfile.Rename(NewName:String) : Boolean;
begin
  {$I-}
  System.Rename(tf,NewName);
  {$I+}
  FileLastError := IoResult;
  if (FileLastError=0) then Result := True else
  begin
    Result := False;
    ShowFileErrorMessage('tPlyTextfile.Rename',FileName,'ErrorCode: '+FileLastError.ToString);
  end;
end;

Procedure tPlyTextfile.Close_System;
begin
  // Execute only when file is open
  if (IsOpen) then
  begin
    {$I-}
    System.Close(tf);
    {$I+}
    FileLastError := IoResult;
  end else
  begin
    FileLastError := 103; // 103 = File not open
  end;
end;

Procedure tPlyTextfile.Close;
begin
  Close_System;
end;

Procedure tPlyTextfile.Close_Delete;
begin
  Close_System;
  Erase;
end;

end.

