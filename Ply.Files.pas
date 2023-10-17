(******************************************************************************

  Name          : Ply.Files.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 10.10.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Files;

interface

{$I Ply.Defines.inc}

Uses
  Ply.Types,
  System.SysUtils;

resourcestring
  // #3 - ERROR_PATH_NOT_FOUND
  SPathNotFound = 'Path not found';
  // #19 - ERROR_WRITE_PROTECT
  SFileWriteProtected = 'File is write protected';
  // #32 - ERROR_SHARING_VIOLATION
  SSharingViolation = 'Sharing violation';
  // #38 - ERROR_HANDLE_EOF
  SEndOfFile = 'Reached end of file';
  // #90 - ERROR_INVALID_RECSIZE
  SInvalidRecsize = 'Invalid recordsize';
  // #100 - IOERROR_DISK_READ
  SFileReadError = 'File read error';
  // #101 - IOERROR_DISK_WRITE
  SFileWriteError = 'File write error';
  // #102 - IOERROR_FILE_NOT_ASSIGNED
  SFileNotAssigned = 'File not assigned';
  // #103 - IOERROR_FILE_NOT_OPEN
  SFileNotOpen = 'File not open';
  // #104 - IOERROR_FILE_NOT_OPEN_FOR_INPUT
  SFileNotOpenForInput = 'File not open for input';
  // #105 - IOERROR_FILE_NOT_OPEN_FOR_OUTPUT
  SFileNotOpenForOutput = 'File not open for output';
  // #106 - IOERROR_INVALID_NUMERIC_FORMAT
  SInvalidNumericFormat = 'Invalid numeric format';

Const
  ERROR_INVALID_RECSIZE            =  90;
  IOERROR_DISK_READ                = 100;
  IOERROR_DISK_WRITE               = 101;
  IOERROR_FILE_NOT_ASSIGNED        = 102;
  IOERROR_FILE_NOT_OPEN            = 103;
  IOERROR_FILE_NOT_OPEN_FOR_INPUT  = 104;
  IOERROR_FILE_NOT_OPEN_FOR_OUTPUT = 105;
  IOERROR_INVALID_NUMERIC_FORMAT   = 106;

  fsOriginFromBeginning            = 0;
  fsOriginFromCurrent              = 1;
  fsOriginFromEnd                  = 2;

  (* $1000000 = 16.777.216 Byte | Read/Write max 16 MByte *)
  _BlockRead_MaxByte   : Int64     = $1000000;
  _BlockWrite_MaxByte  : Int64     = $1000000;

Type tPlyFile = object
     f : File;
     Private
       FErrorCode : Integer;
       FErrorMessage : String;
     Protected
       Procedure Success;
       Procedure CreateError(eErrorCode:Integer; eErrorMsg:String;
                   eFuncName:String; ePath:String='');
       Procedure HandleException(eException: TObject; Const eFuncName:String;
                   ePath:String='');
       Procedure DebugCheckRecSize(aRecSize:tFileRecSize);
     Private
       Procedure DebugShowError(Title,aFileName,Msg1:String; Msg2:String='');
       Function  GetDebugMode : Boolean;
       Procedure SetDebugMode(Const Value:Boolean);
       Function  GetFileName : String;
                 // Reset: Open exsisting file, fails if file not exists
       Function  Reset(Const aFileName:String; aRecSize:tFileRecSize;
                   aFileModeOpen:TFileModeOpen=fmRW_Share) : Boolean;
                 // Rewrite: Create or Delete & Create if file exists
       Function  Rewrite(Const aFileName:String; aRecSize:tFileRecSize;
                   aFileModeOpen:TFileModeOpen=fmRW_Share) : Boolean;
     Public
       Property  FileName: String Read GetFileName;
       Property  ErrorCode: Integer Read FErrorCode Write FErrorCode;
       Property  ErrorMessage: String Read FErrorMessage Write FErrorMessage;
       Property  GlobalDebugMode: Boolean Read GetDebugMode Write SetDebugMode;
       Procedure Init;
                 // Create: Delete & Create new file
       Function  Create(aFileName:String; aRecSize:tFileRecSize;
                   aFileModeOpen:tFileModeOpen=fmRW_Share) : Boolean;
                 // OpenRead: Open existing file for Read
       Function  OpenRead(aFilename:String; aRecSize:tFileRecSize;
                   aFileModeOpen:TFileModeOpen=fmR_Share) : Boolean;
                 // OpenWrite: Open existing file or Create file
       Function  OpenWrite(aFilename:String; aRecSize:tFileRecSize;
                   aFileModeOpen:TFileModeOpen=fmW_Share) : Boolean;
                 // Open: open existing file or create file for read & write
       Function  Open(aFileName:String; aRecSize:tFileRecSize;
                   aFileModeOpen:tFileModeOpen=fmRW_Share) : Boolean;
       Function  Handle : tHandle;
       Function  FileModeStatus : TFileModeStatus;
       Function  FileModeStatusText : String;
       Function  RecSize : Int64;
       Function  IsOpen : Boolean;
       Function  Eof : Boolean;
       Function  Filepos : Longint;
       Function  Filesize : Longint;
       Function  Seek(FPos:Longint) : Boolean;
       Procedure Seek_Eof;
       Function  DosRead(Var Daten) : Boolean;
       Function  DosWrite(Var Daten) : Boolean;
       Function  BlockRead(Var Daten; RecCount:tFileRecCount;
                   Out ReadRec:tFileRecCount) : Boolean;
       Function  BlockWrite(Var Daten; RecCount:tFileRecCount;
                   Out WrittenRec:tFileRecCount) : Boolean;
       Function  Seek_Read(FPos:Longint; Var Daten) : Boolean;
       Function  Seek_Write(FPos:Longint; Var Daten) : Boolean;
       Procedure Truncate;
       Function  Erase : Boolean;
       Function  Rename(NewFileName:String) : Boolean;
       Function  DeleteRecord(FPosRecord:Longint) : Boolean;
       Function  Close : Boolean;
       Function  Close_Delete : Boolean;
       Function  Close_Rename(NewFileName:String) : Boolean;
     end;

Type tPlyTextfile = Object
     Private
       tf : Text;
       FErrorCode : Integer;
       FErrorMessage : String;
       Procedure Success;
       Procedure CreateError(eErrorCode:Integer; eErrorMsg:String;
                   eFuncName:String; ePath:String='');
       Procedure HandleException(eException: TObject; Const eFuncName:String;
                   ePath:String='');
       Procedure DebugShowError(Title,aFileName,Msg1:String; Msg2:String='');
       Function  GetFilename : String;
     Public
       Property  Filename: String Read GetFilename;
       Property  ErrorCode: Integer Read FErrorCode;
       Property  ErrorMessage: String Read FErrorMessage;
       Procedure Init;
       Function  Handle : tHandle;
       Function  FileModeStatus : TFileModeStatus;
       Function  FileModeStatusText : String;
       Function  IsOpen : Boolean;
       Function  OpenReadFilemode(aFileName:String;
                   aFileModeOpen:TFileModeOpen) : Boolean;
       Function  OpenRead(aFileName:String) : Boolean;
       Function  OpenReadExclusive(aFileName:String) : Boolean;
       Function  OpenWriteFilemode(aFileName:String;
                   aFileModeOpen: TFileModeOpen;
                   UTF8_Bom: Boolean=False) : Boolean;
       Function  OpenWrite(aFileName:String;
                   UTF8_BOM: Boolean=False) : Boolean;
       Function  OpenWriteExclusive(aFileName:String;
                   UTF8_BOM: Boolean=False) : Boolean;
                 // Create = Delete and Open_Write
       Function  Create(aFileName:String; Codepage:Word=_Codepage_850) : Boolean;
       Function  Eof : Boolean;
       Function  Readln(Var Help:String) : Boolean;
       Function  Write(Help:String) : Boolean;
       Function  Writeln(Help:String) : Boolean;
       Function  Erase : Boolean;
       Function  Rename(NewName:String) : Boolean;
       Function  Close : Boolean;
       Function  Close_Delete : Boolean;
     end;

implementation

Uses
  {$IFDEF CONSOLE}
    Ply.Console.Extended,
  {$ELSE}
    VCL.Dialogs,
  {$ENDIF}
  Ply.Math,
  Ply.StrUtils,
  Ply.SysUtils,
  System.SysConst,
  System.Math,
  System.StrUtils,
  Winapi.Windows;

Var FileDebugMode : Boolean = False;

(********************)
(***** tPlyFile *****)
(********************)
Procedure tPlyFile.Success;
begin
  FErrorCode := 0;
  FErrorMessage := '';
end;

Procedure tPlyFile.CreateError(eErrorCode:Integer; eErrorMsg:String;
            eFuncName:String; ePath:String='');
begin
  if (ePath='') then ePath := FileName;
  FErrorCode := eErrorCode;
  FErrorMessage := FErrorCode.ToString + '│'
                 + eErrorMsg           + '│'
                 + eFuncName           + '│'
                 + '[' + ePath + ']';
  DebugShowError(eFuncName,ePath,FErrorMessage);
end;

Procedure tPlyFile.HandleException(eException: TObject; Const eFuncName:String;
            ePath:String='');
begin
  if (ePath='') then ePath := FileName;
  if (Exception(eException).ClassNameIs('EInOutError')) then
  begin
    FErrorCode := EInOutError(eException).ErrorCode;
    FErrorMessage := EInOutError(eException).ErrorCode.ToString + '│';
    case FErrorCode of
      ERROR_PATH_NOT_FOUND    : FErrorMessage := FErrorMessage + SPathNotFound + '│';
      ERROR_SHARING_VIOLATION : FErrorMessage := FErrorMessage + SSharingViolation + '│';
    else
      FErrorMessage := FErrorMessage + EInOutError(eException).Message + '│';
    end;
    FErrorMessage := FErrorMessage + eFuncName;
    {$IFDEF DELPHI10UP}
    if (EInOutError(eException).Path<>'')
       then FErrorMessage := FErrorMessage + '│' + EInOutError(eException).Path else
    {$ENDIF DELPHI10UP}
    if (ePath<>'')
       then FErrorMessage := FErrorMessage + '│' + ePath;
  end else
  begin
    FErrorCode := 0;
    FErrorMessage := Exception(eException).Message + '│'
                   + eFuncName;
    if (ePath<>'')
       then FErrorMessage := FErrorMessage + '│' + ePath;
  end;
  DebugShowError(eFuncName,ePath,FErrorMessage);
end;

Procedure tPlyFile.DebugCheckRecSize(aRecSize:tFileRecSize);
Var lFileSizeByte : Int64;
begin
  (* When Debug-Mode is activated *)
  if (FileDebugMode) then
  begin
    (* Check whether the size of the file fit to aRecSize *)
    if (aRecSize>1) then
    begin
      lFileSizeByte := PlyFileSizeByte(FileName);
      if (lFileSizeByte>0) then
      begin
        if ((lFileSizeByte mod aRecSize)<>0) then
        begin
          CreateError(ERROR_INVALID_RECSIZE
            ,SInvalidRecsize+': FileSizeByte='+IntToStr(lFileSizeByte)
              +', RecSize='+IntToStr(aRecSize)
            ,'tPlyFile.DebugCheckRecSize');
        end;
      end;
    end;
  end;
end;

Procedure tPlyFile.DebugShowError(Title,aFileName,Msg1:String; Msg2:String='');
begin
  if (FileDebugMode) then
  begin
    {$IFDEF CONSOLE}
      ConsoleShowError('Error['+IntToStr(ErrorCode)+']: '+Title
        ,'FileName: '+aFileName,Msg1,Msg2);
    {$ELSE}
      ShowMessage(Title+sLineBreak
        +'Error('+IntToStr(ErrorCode)+')'+sLineBreak
        +'FileName: '+FileName+sLineBreak
        +Msg1+sLineBreak
        +Msg2+sLineBreak);
    {$ENDIF}
  end;
end;

Function  tPlyFile.GetDebugMode : Boolean;
begin
  Result := FileDebugMode;
end;

Procedure tPlyFile.SetDebugMode(Const Value:Boolean);
begin
  FileDebugMode := Value;
end;

Function  tPlyFile.GetFileName: string;
begin
  Result := tFilerec(f).Name;
end;

Function  tPlyFile.Reset(Const aFileName:String; aRecSize:tFileRecSize;
            aFileModeOpen:TFileModeOpen=fmRW_Share) : Boolean;
begin
  Result := False;
  try
    System.AssignFile(f, aFileName);
    System.FileMode := aFileModeOpen;
    System.Reset(f,aRecSize);
    Success;
    Result := True;
  except
    On E : Exception do
      HandleException(e,'tPlyFile.Reset',aFilename);
  end;
end;

Function  tPlyFile.Rewrite(Const aFileName:String; aRecSize:tFileRecSize;
            aFileModeOpen:TFileModeOpen=fmRW_Share) : Boolean;
begin
  Result := False;
  try
    System.AssignFile(f, aFileName);
    System.FileMode := aFileModeOpen;
    System.Rewrite(f,aRecSize);
    Success;
    Result := True;
  except
    On E : Exception do
      HandleException(e,'tPlyFile.Rewrite',aFilename);
  end;
end;

Procedure tPlyFile.Init;
begin
  FillChar(tFilerec(f),sizeof(tFilerec),#0);
  FErrorCode := 0;
  FErrorMessage := '';
end;

Function  tPlyFile.Create(aFileName:String; aRecSize:tFileRecSize;
            aFileModeOpen:tFileModeOpen=fmRW_Share) : Boolean;
begin
  Init;
  Result := False;
  if (PlyFileDelete(aFileName)) then
  begin
    if (Rewrite(aFileName,aRecSize,aFileModeOpen)) then
    begin
      Result := True;    
    end;
  end;
end;

Function  tPlyFile.OpenRead(aFilename:String; aRecSize:tFileRecSize;
            aFileModeOpen:TFileModeOpen=fmR_Share) : Boolean;
Var sRec : tSearchrec;
begin
  Init;
  Result := False;
  if (PlyFileExists(aFilename,sRec)) then
  begin
    // if file is write-protected
    if ((sRec.Attr and faReadOnly)<>0) then
    begin
      // downgrade filemode to read only
      aFileModeOpen := aFileModeOpen and not(FM_W) and not(FM_RW);
    end;
    if (Reset(aFilename,aRecSize,aFileModeOpen)) then
    begin
      Result := True;
      DebugCheckRecSize(aRecSize);
    end;
  end else
  begin
    CreateError(ERROR_FILE_NOT_FOUND,SFileNotFound
      ,'tPlyFile.OpenRead',aFilename);
  end;
end;

Function  tPlyFile.OpenWrite(aFilename:String; aRecSize:tFileRecSize;
            aFileModeOpen:TFileModeOpen=fmW_Share) : Boolean;
Var sRec : tSearchrec;
begin
  Init;
  Result := False;
  if (PlyFileExists(aFilename,sRec)) then
  begin
    // if file is write-protected
    if ((sRec.Attr and faReadOnly)<>0) then
    begin
      CreateError(ERROR_WRITE_PROTECT,SFileWriteProtected
        ,'tPlyFile.OpenWrite',aFilename);
    end else
    if (Reset(aFilename,aRecSize,aFileModeOpen)) then
    begin
      Result := True;
      DebugCheckRecSize(aRecSize);
    end;
  end else
  begin
    if (Rewrite(aFilename,aRecSize,aFileModeOpen)) then
    begin
      Result := True;
    end;
  end;
end;

Function  tPlyFile.Open(aFileName:String; aRecSize:tFileRecSize;
            aFileModeOpen:TFileModeOpen=fmRW_Share) : Boolean;
begin
  Init;
  Result := False;
  if (aFileName<>'') then
  begin
    if (PlyFileExists(aFilename)) then
    begin
      if (Reset(aFileName,aRecSize,aFileModeOpen)) then
      begin
        Result := True;
        DebugCheckRecSize(aRecSize);
      end;
    end else
    // if File does not exist then create file
    begin
      Result := Rewrite(aFileName,aRecSize,aFileModeOpen);
    end;
    (* Error(3) = Path not found          *)
    if (ErrorCode=ERROR_PATH_NOT_FOUND) then
    begin
      DebugShowError('FileOpen (Path not found)'
        ,aFilename,ErrorMessage);
    end else
    (* Error(4) : Too many files open *)
    if (ErrorCode=ERROR_TOO_MANY_OPEN_FILES) then
    begin
      DebugShowError(STooManyOpenFiles+'FileOpen (Too many files open)'
        ,aFilename,ErrorMessage);
    end else
    if (ErrorCode<>0) then
    begin
      DebugShowError('FileOpen ',aFileName,ErrorMessage);
    end;
  end else
  begin
    Result := False;
    CreateError(ERROR_FILE_NOT_FOUND,SFileNotFound
      ,'tPlyFile.Open','no filename');
  end;
  (* Set back to Default-FileMode *)
  System.Filemode := fmRW_Share;
end;

Function  tPlyFile.Handle : tHandle;
begin
  Result := tFilerec(f).Handle;
end;

Function  tPlyFile.FileModeStatus : TFileModeStatus;
begin
  Result := tFilerec(f).Mode;
end;

Function  tPlyFile.FileModeStatusText : String;
begin
  case FileModeStatus of
    fmclosed : Result := 'Closed';
    fmInput  : Result := 'Input ';
    fmOutput : Result := 'Output';
    fmInOut  : Result := 'InOut ';
  else
    Result := IntToString(FileModeStatus,6);
  end;
end;

Function  tPlyFile.RecSize : Int64;
begin
  Result := tFilerec(f).RecSize;
end;

Function  tPlyFile.IsOpen : Boolean;
Var CurFileModeStatus : Word;
begin
  CurFileModeStatus := FileModeStatus;
  Result := (CurFileModeStatus>=fmInput) and (CurFileModeStatus<=fmInOut);
end;

Function  tPlyFile.Eof : Boolean;
begin
  if (IsOpen) then
  begin
    Result := False;
    Try
      Result := System.Eof(f);
      Success;
    Except
      On E : Exception do
        HandleException(e,'tPlyFile.Eof');
    End;
  end else
  begin
    CreateError(IOERROR_FILE_NOT_OPEN,SFileNotOpen
      ,'tPlyFile.Eof');
    Result := True;
  end;
end;

Function  tPlyFile.Filepos : Longint;
begin
  Result := -1;
  Try
    Result := System.Filepos(f);
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Filepos');
  End;
end;

Function  tPlyFile.Filesize : Longint;
begin
  Result := -1;
  Try
    Result := System.Filesize(f);
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Filesize');
  End;
end;

Function  tPlyFile.Seek(FPos:Longint) : Boolean;
begin
  Result := False;
  FPos := ValueMinMax(FPos,0,Filesize);
  Try
    System.Seek(f,FPos);
    Result := True;
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Seek');
  End;
end;

Procedure tPlyFile.Seek_Eof;
begin
  Try
    System.Seek(f,Filesize);
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Seek_Eof');
  End;
end;

Function  tPlyFile.DosRead(Var Daten) : Boolean;
Var NumRead : integer;
begin
  Result := False;
  if not(Eof) then
  begin
    Try
      System.BlockRead(f,Daten,1,NumRead); (* 1 = Read 1 record *)
      Success;
      Result := True;
    Except
      On E : Exception do
        HandleException(e,'tPlyFile.Seek');
    End;
  end;
end;

Function  tPlyFile.DosWrite(Var Daten) : Boolean;
Var NumWritten : tFileRecCount;
begin
  Result := False;
  Try
    System.BlockWrite(f,Daten,1,NumWritten);
    Success;
    Result := True;
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Seek');
  End;
end;

Function  tPlyFile.BlockRead(Var Daten; RecCount:tFileRecCount;
            Out ReadRec:tFileRecCount) : Boolean;
Var CountByte                : Int64;
    Steps                    : Int64;
    RecCountStep             : Int64;
    ReadRec_Total            : tFileRecCount;
    Count_Steps              : Longint;
    DatenPtr                 : PAnsiChar;
begin
  Result  := False;
  ReadRec := 0;
  if not(Eof) then
  begin
    CountByte := RecCount * RecSize;
    // if less then 16 MByte to read
    if (CountByte<=_BlockRead_MaxByte) then
    begin
      Try
        System.BlockRead(f,Daten,RecCount,ReadRec);
        if (ReadRec>0) then
        begin
          Success;
          Result := True;
        end;
      Except
        On E : Exception do
          HandleException(e,'tPlyFile.BlockRead');
      End;
    end else
    // if more then 16 MByte to read
    begin
      FillChar(Daten,CountByte,#0);
      DatenPtr := @Daten;
      // Calculate steps of 16 MByte to read
      Steps := (CountByte Div _BlockRead_MaxByte) + 1;
      // Calculate number of records per step
      RecCountStep  := (RecCount Div Steps) + 1;
      ReadRec_Total := 0;
      Count_Steps   := 0;
      Repeat
        inc(Count_Steps);
        RecCountStep := Min(RecCountStep,RecCount-ReadRec_Total);
        Try
          System.BlockRead(f,DatenPtr[ReadRec_Total*RecSize],RecCountStep,ReadRec);
          ReadRec_Total := ReadRec_Total + ReadRec;
        Except
          On E : Exception do
            HandleException(e,'tPlyFile.BlockRead.Steps');
        End;
      until (Count_Steps>=Steps) or (ReadRec_Total>=RecCount) or (ErrorCode<>0);
      // Return how many records are read in total
      ReadRec := ReadRec_Total;
      if (ReadRec>0) and (ErrorCode=0) then
      begin
        Success;
        Result := True;
      end;
    end;
  end else
  begin
    // 38 : End of File
    // CreateError(ERROR_HANDLE_EOF,SEndOfFile,'tPlyFile.BlockRead');
  end;
end;

Function  tPlyFile.BlockWrite(Var Daten; RecCount:tFileRecCount;
            Out WrittenRec:tFileRecCount) : Boolean;
Var CountByte                : Int64;
    Steps                    : Int64;
    AnzRec_Step              : Int64;
    WriteRec_Total           : tFileRecCount;
    Count_Steps              : Longint;
    DatenPtr                 : PAnsiChar;
begin
  Result     := False;
  WrittenRec := 0;
  CountByte := RecCount * RecSize;
  (* if less then 16 MByte to write *)
  if (CountByte<=_BlockWrite_MaxByte) then
  begin
    Try
      System.BlockWrite(f,Daten,RecCount,WrittenRec);
      if (RecCount=WrittenRec) then
      begin
        Success;
        Result := True;
      end;
    Except
      On E : Exception do
        HandleException(e,'tPlyFile.BlockWrite');
    End;
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
      Try
        System.BlockWrite(f,DatenPtr[WriteRec_Total*RecSize],AnzRec_Step,WrittenRec);
        WriteRec_Total := WriteRec_Total + WrittenRec;
      Except
        On E : Exception do
          HandleException(e,'tPlyFile.BlockWrite.Steps');
      End;
    until (Count_Steps>=Steps) or (WriteRec_Total>=RecCount) or (ErrorCode<>0);
    (* Set Out-Parameter *)
    WrittenRec := WriteRec_Total;
    if (WrittenRec=RecCount) then
    begin
      Success;
      Result := True;
    end;
  end;
end;

Function  tPlyFile.Seek_Read(FPos:Longint; Var Daten) : Boolean;
begin
  if (FPos>=0) and (FPos<=Filesize) then
  begin
    Seek(FPos);
    Result := DosRead(Daten);
  end else
  begin
    CreateError(IOERROR_DISK_READ,SFileReadError,'tPlyFile.Seek_Read');
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
    CreateError(IOERROR_DISK_WRITE,SFileWriteError,'tPlyFile.Seek_Write');
    Result := False;
  end;
end;

Procedure tPlyFile.Truncate;
begin
  Try
    System.Truncate(f);
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Truncate');
  End;
end;

Function  tPlyFile.Erase : Boolean;
begin
  Result := False;
  Try
    System.Erase(f);
    Success;
    Result := True;
  Except
    // ErrorCode=5: File is still opened by another task/user
    On E : Exception do
      HandleException(e,'tPlyFile.Erase');
  End;
end;

Function  tPlyFile.Rename(NewFileName:String) : Boolean;
begin
  Result := False;
  Try
    System.Rename(f,NewFileName);
    Success;
    Result := True;
  Except
    On E : Exception do
      HandleException(e,'tPlyFile.Rename');
  End;
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

Function  tPlyFile.Close : Boolean;
begin
  if (IsOpen) then
  begin
    Result := False;
    Try
      System.CloseFile(f);
      Success;
      Result := True;
    Except
      On E : Exception do
        HandleException(e,'tPlyFile.Close');
    End;
  end else Result := True;
end;

Function  tPlyFile.Close_Delete : Boolean;
begin
  if (Close) then
  begin
    Result := Erase;
  end else Result := False;
end;

Function  tPlyFile.Close_Rename(NewFileName:String) : Boolean;
Var OldFileName : String;
begin
  Result := False;
  OldFileName := Filename;
  if (Close) then
  begin
    Result := True;
    if (NewFileName<>'')          and 
       (NewFileName<>OldFileName) then
    begin
      Result := Rename(NewFileName);
    end;
  end;
end;

(************************)
(***** tPlyTextfile *****)
(************************)
Procedure tPlyTextfile.Success;
begin
  FErrorCode := 0;
  FErrorMessage := '';
end;

Procedure tPlyTextfile.CreateError(eErrorCode:Integer; eErrorMsg:String;
            eFuncName:String; ePath:String='');
begin
  if (ePath='') then ePath := FileName;
  FErrorCode := eErrorCode;
  FErrorMessage := FErrorCode.ToString + '│'
                 + eErrorMsg           + '│'
                 + eFuncName           + '│'
                 + '[' + ePath + ']';
  DebugShowError(eFuncName,ePath,FErrorMessage);
end;

Procedure tPlyTextfile.HandleException(eException: TObject; Const eFuncName:String;
            ePath:String='');
begin
  if (ePath='') then ePath := FileName;
  if (Exception(eException).ClassNameIs('EInOutError')) then
  begin
    FErrorCode := EInOutError(eException).ErrorCode;
    FErrorMessage := EInOutError(eException).ErrorCode.ToString + '│';
    case FErrorCode of
      ERROR_PATH_NOT_FOUND    : FErrorMessage := FErrorMessage + SPathNotFound + '│';
      ERROR_SHARING_VIOLATION : FErrorMessage := FErrorMessage + SSharingViolation + '│';
    else
      FErrorMessage := FErrorMessage + EInOutError(eException).Message + '│';
    end;
    FErrorMessage := FErrorMessage + eFuncName;
    {$IFDEF DELPHI10UP}
    if (EInOutError(eException).Path<>'')
       then FErrorMessage := FErrorMessage + '│' + EInOutError(eException).Path else
    {$ENDIF DELPHI10UP}
    if (ePath<>'')
       then FErrorMessage := FErrorMessage + '│' + ePath;
  end else
  begin
    FErrorCode := 0;
    FErrorMessage := Exception(eException).Message + '│'
                   + eFuncName;
    if (ePath<>'')
       then FErrorMessage := FErrorMessage + '│' + ePath;
  end;
  DebugShowError(eFuncName,ePath,FErrorMessage);
end;

Procedure tPlyTextfile.DebugShowError(Title,aFileName,Msg1:String; Msg2:String='');
begin
  if (FileDebugMode) then
  begin
    {$IFDEF CONSOLE}
      ConsoleShowError('Error['+IntToStr(ErrorCode)+']: '+Title
        ,'FileName: '+aFileName,Msg1,Msg2);
    {$ELSE}
      ShowMessage(Title+sLineBreak
        +'Error('+IntToStr(ErrorCode)+')'+sLineBreak
        +'FileName: '+FileName+sLineBreak
        +Msg1+sLineBreak
        +Msg2+sLineBreak);
    {$ENDIF}
  end;
end;

Function  tPlyTextfile.GetFilename : String;
begin
  Result := StrPas(tTextRec(tf).Name);
end;

Procedure tPlyTextfile.Init;
begin
  FillChar(tTextrec(tf),sizeof(tTextrec),#0);
  FErrorCode := 0;
  FErrorMessage := '';
end;

Function  tPlyTextfile.Handle : tHandle;
begin
  Result := tTextRec(tf).Handle;
end;

Function  tPlyTextfile.FileModeStatus : TFileModeStatus;
begin
  Result := tTextRec(tf).Mode;
end;

Function  tPlyTextfile.FileModeStatusText : String;
begin
  case FileModeStatus of
    fmclosed : Result := 'Closed';
    fmInput  : Result := 'Input ';
    fmOutput : Result := 'Output';
    fmInOut  : Result := 'InOut ';
  else
    Result := IntToString(FileModeStatus,6);
  end;
end;

Function  tPlyTextfile.IsOpen : Boolean;
Var CurFileModeStatus : Word;
begin
  CurFileModeStatus := FileModeStatus;
  Result := (CurFileModeStatus>=fmInput) and (CurFileModeStatus<=fmInOut);
end;

Function  tPlyTextfile.OpenReadFilemode(aFileName:String;
            aFileModeOpen:TFileModeOpen) : Boolean;
begin
  Result := False;
  if (aFileName<>'') then
  begin
    Try
      System.AssignFile(tf,aFileName);
      System.Filemode := aFileModeOpen;
      System.Reset(tf);
      Success;
      Result := True;
    Except
      On E : Exception do
        HandleException(e,'tPlyTextfile.OpenReadFilemode');
    End;
  end else
  begin
    CreateError(ERROR_FILE_NOT_FOUND,SFileNotFound
      ,'tPlyTextfile.OpenReadFilemode','no filename');
  end;
  System.FileMode := fmRW_Share;
end;

Function  tPlyTextfile.OpenRead(aFileName:String) : Boolean;
begin
  Result := OpenReadFilemode(aFileName,fmR_Share);
end;

Function  tPlyTextfile.OpenReadExclusive(aFileName: string): Boolean;
begin
  Result := OpenReadFilemode(aFileName,fmR_DenyRW);
end;

Function  tPlyTextfile.OpenWriteFilemode(aFileName:String;
            aFileModeOpen: TFileModeOpen;
            UTF8_Bom: Boolean=False) : Boolean;
begin
  Result := False;
  if (aFileName<>'') then
  begin
    Try
      System.AssignFile(tf,aFileName);
      System.Filemode := aFileModeOpen;
      if (FileExists(aFileName)) then
      begin
        System.Append(tf);
      end else
      begin
        System.Rewrite(tf);
        // If the file is to be created in UFT8, then write Byte Order Mark (BOM) to the file
        if (UTF8_Bom) then
        begin
          System.Write(tf,#$ef + #$bb + #$bf);
        end;
      end;
      Success;
      Result := True;
    Except
      On E : Exception do
        HandleException(e,'tPlyTextfile.OpenWriteFilemode');
    End;
  end else
  begin
    CreateError(ERROR_FILE_NOT_FOUND,SFileNotFound
      ,'tPlyTextfile.OpenWriteFilemode','no filename');
  end;
end;

Function  tPlyTextfile.OpenWrite(aFileName:String;
            UTF8_BOM:Boolean=False) : Boolean;
begin
  Result := OpenWriteFilemode(aFileName,fmW_Share,UTF8_BOM);
end;

Function  tPlyTextfile.OpenWriteExclusive(aFileName: string;
            UTF8_BOM: Boolean = False): Boolean;
begin
  Result := OpenWriteFilemode(aFileName,fmW_DenyRW);
end;

Function  tPlyTextfile.Create(aFileName:String; Codepage:Word=_Codepage_850) : Boolean;
begin
  if (aFileName<>'') then
  begin
    if (FileExists(aFileName)) then
    begin
      if (System.SysUtils.DeleteFile(aFileName)) then
      begin
        Result := OpenWrite(aFileName,Codepage=_Codepage_UTF8);
      end else Result := False;
    end else
    begin
      Result := OpenWrite(aFileName,Codepage=_Codepage_UTF8);
    end;
  end else Result := False;
end;

Function  tPlyTextfile.Eof : Boolean;
begin
  if (IsOpen) then
  begin
    Result := False;
    Try
      Result := System.Eof(tf);
      Success;
    Except
      On E : Exception do
        HandleException(e,'tPlyTextfile.Eof');
    end;
  end else
  begin
    CreateError(IOERROR_FILE_NOT_OPEN,SFileNotOpen
      ,'tPlyTextFile.Eof');
    Result := True;
  end;
end;

Function  tPlyTextfile.Readln(Var Help:String) : Boolean;
begin
  Result := False;
  if not(Eof) then
  begin
    Try
      System.Readln(tf,Help);
      Success;
      Result := True;
    Except
      On E : Exception do
        HandleException(e,'tPlyTextfile.Readln');
    End;
  end;
end;

Function  tPlyTextfile.Write(Help:String) : Boolean;
begin
  Result := False;
  Try
    System.Write(tf,Help);
    Success;
    Result := True;
  Except
    On E : Exception do
      HandleException(e,'tPlyTextfile.Write');
  End;
end;

Function  tPlyTextfile.Writeln(Help:String) : Boolean;
begin
  Result := False;
  Try
    System.Writeln(tf,Help);
    Success;
    Result := True;
  Except
    On E : Exception do
      HandleException(e,'tPlyTextfile.Writeln');
  End;
end;

Function  tPlyTextfile.Erase : Boolean;
begin
  Result := False;
  Try
    System.Erase(tf);
    Success;
    Result := True;
  Except
    // ErrorCode=5: File is still opened by another task/user
    On E : Exception do
      HandleException(e,'tPlyTextfile.Erase');
  End;
end;

Function  tPlyTextfile.Rename(NewName:String) : Boolean;
begin 
  Result := False;
  Try
    System.Rename(tf,NewName);
    Success;
    Result := True;
  Except
    On E : Exception do
      HandleException(e,'tPlyTextFile.Rename');
  End;
end;

Function  tPlyTextfile.Close : Boolean;
begin
  if (IsOpen) then
  begin
    Result := False;
    Try
      System.CloseFile(tf);
      Success;
      Result := True;
    Except
      On E : Exception do
        HandleException(e,'tPlyTextFile.Close');
    End;
  end else Result := True;
end;

Function  tPlyTextfile.Close_Delete : Boolean;
begin
  if (Close) then
  begin
    Result := Erase;
  end else Result := False;
end;

end.

