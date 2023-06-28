(******************************************************************************

  Name          : Ply.SysUtils.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 22.06.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.SysUtils;

interface

{$I Ply.Defines.inc}
// {$WARN SYMBOL_PLATFORM OFF}

Uses
  System.Classes,
  System.SysUtils,
  Ply.DateTime,
  Ply.Types;

  {$WARNINGS OFF}
        // faAllFiles   : $27 = #39 only files
  Const faFile       = faReadOnly + faHidden + faSysFile + faArchive;
        // faAllDirs    : $17 = #23 only directories
  Const faDir        = faReadOnly + faHidden + faSysFile + faDirectory;
        // faFileAndDir : $37 = #55 files & directories
  Const faFileAndDir = faReadOnly + faHidden + faSysFile + faDirectory + faArchive;
  {$WARNINGS ON}

Function  PlyFindFirst(Path:String; Attr:tFileAttribute; var aSearchRec:tSearchRec) : Boolean;
Function  PlyFindNext(var aSearchRec:tSearchRec) : Boolean;
Procedure PlyFindClose(var aSearchRec:tSearchRec);

Function  PlyFileAttributesToString(Attr:tFileAttribute) : String;
function  PlyFileGetAttributes(Const FileName:String) : tFileAttribute;
Function  PlyFileSetAttributes(Const FileName:String; NewAttr:TFileAttribute) : Boolean;
function  PlyFileSetOneAttribute(FileName: String; SetAttr: tFileAttribute): Boolean;
function  PlyFileDelOneAttribute(FileName: String; DelAttr: tFileAttribute): Boolean;

Function  PlyFileSizeByte(Filename:String) : Int64;
Function  PlyFileExists(FileNameWildCards:String; Out aSearchRec:tSearchrec) : Boolean; Overload;
Function  PlyFileExists(FileNameWildCards:String) : Boolean; Overload;
Function  PlyFileExists(FileNameWildCards:String; ResultWithPath:Boolean) : String; Overload;
Function  PlyFileExistsSubDir(FileNameWildCards:String) : Boolean; Overload;
Function  PlyFileExistsSubDir(FileNameWildCards:String; IncludeCurDir:Boolean) : String; Overload;

Function  PlyDirectoryExists(FilePathWildCards:String) : Boolean; Overload;
Function  PlyDirectoryExists(FilePathWildCards:String; Out aSearchRec:tSearchrec) : Boolean; Overload;
Function  PlyDirectoryExists(FilePathWildCards:String; ResultWithPath:Boolean) : String; Overload;

Function  PlyFileCount(FileNameWildCards:String; IncludeSubDir:Boolean=False) : Longint;
Function  PlyFileGetDaTi(Filename:String) : Longint;
Function  PlyFileGetDateTime(Filename:String) : TDateTime;
Procedure PlyFileSetDaTi(Pfad:String; DaTi:Longint);

          // Return first found (FilePath & FileName)
Function  PlyGetFilename(FileNameWildCards:String) : String;
          // First = oldest File
Function  PlyGetFilenameFirst(FileNameWildCards:String) : String;
          // Near = closest (+ or -) to SearchDateTime
Function  PlyGetFilenameNear(FileNameWildCards:String; SearchDateTime:TDateTime) : String;
          // Next = next after SearchDateTime
Function  PlyGetFilenameNext(FileNameWildCards:String; SearchDateTime:TDateTime) : String;
          // FromFile = TTextRec.Name
Function  PlyGetFileNameFromFile(var aFile) : String;

Function  PlyFileRename(OldFilename,NewFilename:String) : Boolean;
Function  PlyDirectoryCreate(Directory:String):Boolean;
Function  PlyDirectoryDelete(Directory:String) : Boolean;
{$IFDEF CONSOLE}
Function  PlyDirectorySelect(StartDirectory:String) : String;
{$ENDIF CONSOLE}

Function  PlyFileCompare_SizeTime(Filename1,Filename2:String) : Boolean;
Function  PlyFileCompare_Content(Filename1,Filename2:String) : Boolean;

Function  PlyFileDelete(Filename:String):Boolean;
Function  PlyFilesDelete(FileNameWildCards:String) : Longint;
Function  PlyFilesDeleteBefore(FileNameWildCards:String; BeforeDateTime:TDateTime) : Longint;
Function  PlyFilesDeleteAgeDays(FileNameWildCards:String; AgeDays:Longint) : Longint;
Function  PlyFilesDeleteAgeMinutes(FileNameWildCards:String; AgeMinutes:Longint) : Longint;

Type TWindowsCodepages = record
     strict private
       class threadvar FList: TStrings;
       class function EnumCodePagesProc(CodePage:PWideChar) : Boolean; static; stdcall;
       class function GetCodepageName(Codepage:Cardinal) : String; static;
     public
       class function GetInstalled(Var CodePageList:TStrings) : Boolean; static;
       class function GetSupported(Var CodePageList:TStrings) : Boolean; static;
       class function GetName(CodePage: Cardinal) : String; static;
     end;

Type tDirInfo                = Record
     Name                    : String;
     Size                    : tFilesize;
     DateTime                : tDateTime;
     Attr                    : tFileAttribute;
     Procedure Clear;
     Function  IsClear : Boolean;
     Procedure Init(Var sr:tSearchRec; FilePath:String=''; ExcludeRootPath:String='');
     Procedure InitDetails(eName:String; eSize:tFilesize; eDateTime:tDateTime; eAttr:tFileAttribute);
     Function  GetFile(aFileName:String) : Boolean;
     Function  GetPath(aFilePath:String) : Boolean;
     {$IFDEF CONSOLE}
     Procedure WriteLine(y:Integer);
     Procedure WriteLines(y:Integer);
     Procedure ShowPopUp;
     Procedure WriteTextSelect(y:Integer; Len:Byte);
     {$ENDIF}
               // TextSizeDateTime: 'Filesizexx│dd.mm.yy│hh:mm:ss'
     Function  TextSizeDateTime : String;
               // TextSelection(TotalLen): filename + '│' + TextSizeDateTime
               // Len(filename) = TotalLen - length('|'+TextInfo)
     Function  TextSelect(TotalLen:Integer=70) : String;
     Function  TextSelectHeadline(TotalLen:Integer=70) : String;
               // ToDate: 'dd.mm.yyyy'
     Function  ToDate : String;
               // ToTime: 'hh:mm:ss'
     Function  ToTime : String;
     Function  SubDir : String;    // only filepath if path is included in name
     Function  FileName : String;  // only filename if path is included in name
     Function  Extension : String;
     Function  ReadOnly : Boolean;
     Function  Hidden : Boolean;
     Function  SysFile : Boolean;
     Function  Archive : Boolean;
     Function  Directory : Boolean;
     Function  Equal(Var aDirInfo:tDirInfo) : Boolean;
     end;

Type tDirInfos = Class(tObject)
     Private
       // RootDir when IncludeSubDirs is activ
       FRootPath               : String;
       {$IFDEF CONSOLE}
       // Save Filename for possible recall on Select
       FSelectedLast           : String;
       // If True, Result is Path not File
       FSelectPath             : Boolean;
       {$ENDIF CONSOLE}
       // Current Dir to search for files
       FSearchPath             : String;
       // AddFiles to the filelist
       FAddFiles               : Boolean;
       // AddSubDirs to the filelist
       FAddDirs                : Boolean;
       // Search also in child-directories
       FIncludeSubDirs         : Boolean;
       Procedure SetSearchPath(Value:String);
       {$IFDEF CONSOLE}
       Procedure SetSelectPath(Value:Boolean);
       {$ENDIF CONSOLE}
       Procedure SetAddFiles(Value:Boolean);
       Procedure SetAddDirs(Value:Boolean);
       Procedure SetIncludeSubDirs(Value:Boolean);
       Function  GetDirInfo(Index: Integer) : tDirInfo; Overload;
       Function  GetDirInfo(Index: Integer; Var Value:tDirInfo) : Boolean; Overload;
       {$IFDEF DELPHIXE8DOWN}
       Procedure DelDirInfo(Index: Integer);
       {$ENDIF DELPHIXE8DOWN}
     Public
       // List of files & directories
       DInfos                  : TArray<TDirInfo>;
       // if IncludeSubDirs, exclude SubDirs matching these list
       ExcludeSubDirs          : TStringList;
       // Add only files matching this filters, if '*' take every file
       IncludeFilter           : TStringList;
       // Do not add file matching these filters
       ExcludeFilter           : TStringList;
       // File.DateTime must be >=, if Zero take every file
       FileStartDateTime       : TDateTime;
       // File.DateTime must be <=, if Zero take every file
       FileEndDateTime         : TDateTime;
       Constructor Create;
       Destructor  Destroy; override;
       Procedure Clear;
       Procedure ClearEntries;
       Property  RootPath: String Read FRootPath;
       Property  SearchPath: String Read FSearchPath Write SetSearchPath;
       {$IFDEF CONSOLE}
       Property  SelectPath: Boolean Read FSelectPath Write SetSelectPath;
       {$ENDIF CONSOLE}
       Property  AddFiles: Boolean Read FAddFiles Write SetAddFiles;
       Property  AddDirs: Boolean Read FAddDirs Write SetAddDirs;
       Property  IncludeSubDirs: Boolean Read FIncludeSubDirs Write SetIncludeSubDirs;
       Property  DirInfo[Index:Integer]:tDirInfo Read GetDirInfo; Default;
       Procedure Add(Var aDirInfo:tDirInfo); Overload;
       Procedure Add(Var sr:tSearchRec; FilePath:String=''); Overload;
       Procedure Add(eName:String; eSize:tFileSize; eDateTime:TDateTime; eAttr:tFileAttribute); Overload;
                 // Delete: Delete Filename form DirInfos if present
       Function  Delete(DeleteFileName:String; All:Boolean=False) : Boolean; Overload;
                 // Delete: Delete all Filenames in Strings form DirInfos
       Procedure Delete(Var Strings:TStringList); Overload;
                 // DeleteNotRecSize: Deletes all entries with a different RecSize from DirInfos
       Procedure DeleteNotRecSize(RecSize:Longint);
                 // DeleteFilter: Deletes all entries that match FilterFilename
       Procedure DeleteFilter(FilterFilename:String);
                 // DeleteNotFilter: Deletes all entries that do not match FilterFilename
       Procedure DeleteNotFilter(FilterFilename:String);
       Function  Execute(eSearchPath:String='') : Boolean;
       Function  GetSubDirs(Filename:String) : Boolean;
       Procedure Sort(FileSort:tFilesort=NameUp);
       Function  Count : Longint;
       Function  Find(Filename:String; Var Value:tDirInfo; eDelete:Boolean=False) : Boolean;
       Procedure ToStrings(aStrings:TStrings; TotalLen:Integer=70);
       Function  TotalSize : TFilesize;
       Function  TextCountSize : String;
       {$IFDEF CONSOLE}
       Procedure Show(DName:String; Attr:tFileAttribute);
       Function  TextSelectTitle : String;
       Function  TextSelectBottom : String;
       Function  TextSelectHeadLine : String;
       Function  Select(Var DirInfo:tDirInfo; Var Key:Word;
                   HelpTextNumber:Integer=-1) : Boolean;
       {$ENDIF CONSOLE}
     end;

Function  GetWindowsMemoryUsage : Longint;
{$IFDEF DELPHI10UP}
Function  GetWindowsStartTime : TDateTime;
{$ENDIF DELPHI10UP}
Function  GetWindowsStartTime2 : TDateTime;

Type tTimecount = Record
     Private
       FStart, FStop, FFrequenzy : Int64;
     Public
       Procedure Start;
       Procedure Stop;
       Function  GetMilliseconds : Extended;
     End;

Var PlyLastResult : Integer = 0;
    PlyProgDataPath : String = '';
    PlyProgUserPath : String = '';

implementation

Uses
  {$IFDEF CONSOLE}
    Crt,
    Ply.Console.Extended,
    System.Math,
  {$ELSE}
    VCL.FileCtrl,
    VCL.Forms,
  {$ENDIF}
  Ply.StrUtils,
  Ply.Files,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.StrUtils,
  WinAPI.PsAPI,
  WinAPI.Windows;

Function  PlyFindFirst(Path:String; Attr:tFileAttribute; var aSearchRec:tSearchRec) : Boolean;
begin
  FillChar(aSearchRec,sizeof(aSearchRec),#0);
  Path := UpperCase(Path);
  {$IFDEF FPC}
    findfirst(Path,attr,aSearchRec);
    PlyLastResult := DosError;
  {$ELSE}
    PlyLastResult := System.SysUtils.FindFirst(Path,Attr,aSearchRec);
  {$ENDIF}
  if (PlyLastResult=0) and (aSearchRec.Name<>'')
     then Result := True
     else Result := False;
end;

Function  PlyFindNext(var aSearchRec:tSearchRec) : Boolean;
begin
  {$IFDEF FPC}
    findnext(DirInfo);
    PlyLastResult := DosError;
  {$ELSE}
    PlyLastResult := System.SysUtils.FindNext(aSearchRec);
  {$ENDIF}
  if (PlyLastResult=0) and (aSearchRec.Name<>'')
     then Result := True
     else Result := False;
end;

Procedure PlyFindClose(var aSearchRec:tSearchRec);
begin
  {$IFDEF FPC}
  {$ELSE}
  System.SysUtils.FindClose(aSearchRec);
  {$ENDIF}
end;

Function  PlyFileAttributesToString(Attr:tFileAttribute) : String;
begin
  Result := '';
  if ((Attr and faReadOnly)  <> 0) then Result := Result + 'Read only  ';
  {$WARNINGS OFF}
  if ((Attr and faHidden)    <> 0) then Result := Result + 'Hidden  ';
  if ((Attr and faSysFile)   <> 0) then Result := Result + 'Systemfile  ';
  if ((Attr and faVolumeID)  <> 0) then Result := Result + 'VolumeID  ';
  if ((Attr and faDirectory) <> 0) then Result := Result + 'Directory  ';
  if ((Attr and faArchive)   <> 0) then Result := Result + 'Archive  ';
  {$WARNINGS ON}
  if ((Attr and faNormal)    <> 0) then Result := Result + 'Normal  ';
  Result := Result;
end;

function PlyFileGetAttributes(Const FileName:String) : tFileAttribute;
{$IFDEF FPC}
  Var CurAttr : tFileAttribute;
{$ENDIF}
begin
  {$IFDEF FPC}
    Assign(f, FileName);
    GetFAttr(F, CurAttr);
    Result := CurAttr;
  {$ELSE}
    {$WARNINGS OFF}
    Result := FileGetAttr(FileName);
    {$WARNINGS ON}
  {$ENDIF}
end;

Function PlyFileSetAttributes(Const FileName:String; NewAttr:TFileAttribute) : Boolean;
begin
  {$IFDEF FPC}
    SetFAttr(F, NewAttr);
    PlyLastError := DosError;
    Result := (PlyLastError=0);
  {$ELSE}
    {$WARNINGS OFF}
    Result := (FileSetAttr(FileName,NewAttr)=0);
    {$WARNINGS ON}
  {$ENDIF}
end;

function PlyFileSetOneAttribute(FileName: String; SetAttr:tFileAttribute): Boolean;
Var Attr : tFileAttribute;
begin
  if (FileExists(FileName)) then
  begin
    {$WARNINGS OFF}
    {$IFDEF FPC}
      Assign(f, FileName);
      GetFAttr(F, Attr);
    {$ELSE}
      Attr := FileGetAttr(FileName);
    {$ENDIF}
    (* Only these 4 attributes of a file can be changed *)
    (* Flag ReadOnly *)
    if ((SetAttr and faReadOnly)=faReadOnly) then Attr := (Attr or faReadOnly);
    (* Flag Hidden *)
    if ((SetAttr and faHidden  )=faHidden  ) then Attr := (Attr or faHidden  );
    (* Flag SysFile *)
    if ((SetAttr and faSysFile )=faSysFile ) then Attr := (Attr or faSysFile );
    (* Flag Archive *)
    if ((SetAttr and faArchive )=faArchive ) then Attr := (Attr or faArchive );
    {$IFDEF FPC}
      SetFAttr(F, SetAttr);
      PlyLastError := DosError;
      Result := (PlyLastError=0);
    {$ELSE}
      Result := (FileSetAttr(FileName,Attr)=0);
    {$ENDIF}
    {$WARNINGS ON}
  end else Result := False;
end;

function PlyFileDelOneAttribute(FileName: String; DelAttr:tFileAttribute): Boolean;

  Procedure DeleteAttrIfSet(var CurAttr: tFileAttribute; DelAttr, ChkAttr:tFileAttribute);
  begin
        // If ChkAttr should be deleted and
    if ((DelAttr and ChkAttr)=ChkAttr) and
        // ChkAttr is Set
       ((CurAttr and ChkAttr)=ChkAttr) then
    begin
      CurAttr := CurAttr - ChkAttr;
    end;
  end;

Var OldAttr, NewAttr : tFileAttribute;
begin
  Result := False;
  if (FileExists(FileName)) then
  begin
    {$WARNINGS OFF}
    {$IFDEF FPC}
      Assign(f, Umlaute_DosWin(FileName));
      GetFAttr(F, CurAttr);
    {$ELSE}
      OldAttr := FileGetAttr(FileName);
    {$ENDIF}
    NewAttr := OldAttr;
    // Only these 4 attributes of a file can be changed
    DeleteAttrIfSet(NewAttr,DelAttr,faReadOnly);
    DeleteAttrIfSet(NewAttr,DelAttr,faHidden);
    DeleteAttrIfSet(NewAttr,DelAttr,faSysFile);
    DeleteAttrIfSet(NewAttr,DelAttr,faArchive);
    // If at least 1 attribute is to be changed
    if (OldAttr<>NewAttr) then
    begin
      {$IFDEF FPC}
        SetFAttr(F, CurAttr);
        PlyLastError := DosError;
        Result := (PlyLastError=0);
      {$ELSE}
        Result := (FileSetAttr(FileName,NewAttr)=0);
      {$ENDIF}
    end else
    begin
      Result := True;
    end;
    {$WARNINGS ON}
  end;
end;

Function  PlyFileSizeByte(Filename:String) : Int64;
Var aSearchRec : tSearchrec;
begin
  if (PlyFileExists(Filename,aSearchRec)) then
  begin
    Result := aSearchRec.Size;
  end else
  begin
    Result := -1;
  end;
end;

// Use wildcards to check if at least one file exists that matches
Function  PlyFileExists(FileNameWildCards:String) : Boolean;
Var aSearchRec : tSearchrec;
begin
  Result := PlyFileExists(FileNameWildCards,aSearchRec);
end;

Function  PlyFileExists(FileNameWildCards:String; Out aSearchRec:tSearchrec) : Boolean;
begin
  Result := False;
  FillChar(aSearchRec,Sizeof(aSearchRec),#0);
  FileNameWildCards := ExcludeTrailingPathDelimiter(FileNameWildCards);
  if (PlyFindFirst(FileNameWildCards,faFile,aSearchRec)) then
  begin
    Repeat
      // if not a directory -> it's a file
      if ((aSearchRec.Attr and faDirectory)=0) then
      begin
        Result := True;
        Break;
      end;
    Until (not PlyFindNext(aSearchRec));
  end;
  PlyFindClose(aSearchRec);
end;

Function  PlyFileExists(FileNameWildCards:String; ResultWithPath:Boolean) : String; Overload;
Var aSearchRec : tSearchRec;
begin
  if (PlyFileExists(FileNameWildCards,aSearchRec)) then
  begin
    if ResultWithPath
       then Result := ExtractFilePath(FileNameWildCards) + aSearchRec.Name
       else Result := aSearchRec.Name;
  end else Result := '';
end;

Function  PlyFileExistsSubDir(FileNameWildCards:String) : Boolean; Overload;
begin
  Result := (PlyFileExistsSubDir(FileNameWildCards,True)<>'');
end;

// Search in all subdirectories for a filename
Function  PlyFileExistsSubDir(FileNameWildCards:String; IncludeCurDir:Boolean) : String;
Var
  SPath : String;
  FPath : String;
  SName : String;
  srPath : tSearchRec;
  srFile : tSearchRec;
begin
  Result := '';
  SPath  := ExcludeTrailingPathDelimiter(ExtractFilePath(FileNameWildCards));
  SName  := ExtractFileName(FileNameWildCards);
  if (PlyFindFirst(SPath,faDir,srPath)) then
  begin
    Repeat
      if ((srPath.Attr and faDirectory)=faDirectory) then
      begin
        FPath := ExtractFilePath(SPath) + srPath.Name + '\';
        if (PlyFileExists(FPath+SName,srFile)) then
        begin
          Result := FPath + srFile.Name;
          Break;
        end else
        if (PlyFindFirst(FPath+'*.*',faFileAndDir,srFile)) then
        begin
          Repeat
            if ((srFile.Attr and faDirectory)=faDirectory) then
            begin
              if (srFile.Name<>'.') and (srFile.Name<>'..') then
              begin
                // Recursive call for Subdirectory
                // IncludeCurrentDirectory of SubDir must be True
                Result := PlyFileExistsSubDir(FPath+srFile.Name+'\'+SName,True);
                if (Result<>'') then Break;
              end;
            end else
            begin
              if (IncludeCurDir) then
              begin
                if (FilenameCheckFilter(srFile.Name,SName,False)) then
                begin
                  Result := FPath+srFile.Name;
                  Break;
                end;
              end;
            end;
          Until (not PlyFindNext(srFile));
        end;
        PlyFindClose(srFile);
        if (Result<>'') then Break;
      end;
    Until (not PlyFindNext(srPath));
    PlyFindClose(srPath);
  end;
end;

Function  PlyDirectoryExists(FilePathWildCards:String) : Boolean;
Var aSearchRec : tSearchrec;
begin
  Result := PlyDirectoryExists(FilePathWildCards,aSearchRec);
end;

Function  PlyDirectoryExists(FilePathWildCards:String; Out aSearchRec:tSearchrec) : Boolean;
begin
  Result := False;
  FillChar(aSearchRec,Sizeof(aSearchRec),#0);
  FilePathWildCards := ExcludeTrailingPathDelimiter(FilePathWildCards);
  if (PlyFindFirst(FilePathWildCards,faDir,aSearchRec)) then
  begin
    Repeat
      if ((aSearchRec.Attr and faDirectory)=faDirectory) then
      begin
        Result := True;
        Break;
      end;
    Until (not PlyFindNext(aSearchRec));
  end;
  PlyFindClose(aSearchRec);
end;

Function  PlyDirectoryExists(FilePathWildCards:String; ResultWithPath:Boolean) : String;
Var aSearchRec : tSearchRec;
begin
  if (PlyDirectoryExists(FilePathWildCards,aSearchRec)) then
  begin
    if ResultWithPath then
    begin
      if (FilePathWildCards=ExtractFilePath(FilePathWildCards))
         then Result := FilePathWildCards
         else Result := ExtractFilePath(FilePathWildCards) + aSearchRec.Name;
    end else Result := aSearchRec.Name;
  end else Result := '';
end;

Function  PlyFileCount(FileNameWildCards:String; IncludeSubDir:Boolean=False) : Longint;
Var
  Counter : integer;
  aSearchRec : tSearchrec;
begin
  Counter := 0;
  if (FileNameWildCards[High(FileNameWildCards)]='\')
     then FileNameWildCards := FileNameWildCards + '*.*';
  if (PlyFindFirst(FileNameWildCards,faFileAndDir,aSearchRec)) then
  begin
    Repeat
      // If Directory
      if ((aSearchRec.Attr and faDirectory)<>0) then
      begin
        if (IncludeSubDir) and (aSearchRec.Name<>'.') and (aSearchRec.Name<>'..') then
        begin
          // Recursive call of the function
          Counter := Counter + PlyFileCount(ExtractFilePath(FileNameWildCards)
            +aSearchRec.Name+'\'+ExtractFileName(FileNameWildCards),IncludeSubDir);
        end;
      end else
      begin
        Inc(Counter);
      end;
    Until (not PlyFindNext(aSearchRec));
  end;
  PlyFindClose(aSearchRec);
  Result := Counter;
end;

Function  PlyFileGetDaTi(Filename:String) : Longint;
Var aSearchRec : tSearchrec;
begin
  if (PlyFileExists(Filename,aSearchRec)) then
  begin
    {$WARNINGS OFF}
    Result := aSearchRec.Time;
    {$WARNINGS ON}
  end else
  begin
    Result := -1;
  end;
end;

Function  PlyFileGetDateTime(Filename:String) : TDateTime;
Var aSearchRec : tSearchrec;
begin
  if (PlyFileExists(Filename,aSearchRec)) then
  begin
    Result := aSearchRec.TimeStamp;
  end else
  begin
    Result := 0;
  end;
end;

Procedure PlyFileSetDaTi(Pfad:String; DaTi:Longint);
{$IFDEF FPC}
Var f : File;
{$ELSE}
Var FileHandle : Longint;
{$ENDIF}
begin
  if (FileExists(Pfad)) then
  begin
    {$IFDEF FPC}
      System.Assign(f, Umlaute_DosWin(Pfad));
      System.Reset(f);
      SetFTime(f,DaTi);
      System.Close(f);
    {$ELSE}
      FileHandle := FileOpen(Pfad, fmOpenReadWrite or fmShareDenyWrite);
      if FileHandle > 0 then
      begin
        {$WARNINGS OFF}
        FileSetDate(FileHandle, DaTi);
        {$WARNINGS ON}
        FileClose(FileHandle);
      end;
    {$ENDIF}
  end;
end;

// Return with upper/lower case of the file name
Function  PlyGetFilename(FileNameWildCards:String) : String;
Var aSearchRec : tSearchrec;
begin
  if (PlyFileExists(FileNameWildCards,aSearchRec)) then
  begin
    Result := ExtractFilePath(FileNameWildCards) + aSearchRec.Name;
  end else
  begin
    Result := '';
  end;
end;

// If there are several files with the searched filename (wildcards)
// then supply the filename of the oldest (first) file
Function  PlyGetFilenameFirst(FileNameWildCards:String) : String;
Var
  aSearchRec : tSearchrec;
  FName : TFileName;
  FTime : Longint;
begin
  FName := '';
  if (PlyFindFirst(FileNameWildCards,faFile,aSearchRec)) then
  begin
    FName := aSearchRec.Name;
    {$WARNINGS OFF}
    FTime := aSearchRec.Time;
    While (PlyFindNext(aSearchRec)) do
    begin
      if (aSearchRec.Time<FTime) then
      begin
        FName := aSearchRec.Name;
        FTime := aSearchRec.Time;
      end;
    end;
    {$WARNINGS ON}
  end;
  PlyFindClose(aSearchRec);
  if (FName<>'') then Result := ExtractFilePath(FileNameWildCards) + FName
                 else Result := '';
end;

// If there are several files with the searched filename (wildcards),
// then return the filename that is closest in time to the searched time
Function  PlyGetFilenameNear(FileNameWildCards:String; SearchDateTime:TDateTime) : String;
Var aSearchRec : tSearchRec;
    FName      : TFileName;
    FDateTime  : TDateTime;
    NDateTime  : TDateTime;
begin
  FName := '';
  if (PlyFindFirst(FileNameWildCards,faFile,aSearchRec)) then
  begin
    FName      := aSearchRec.Name;
    FDateTime  := aSearchRec.TimeStamp;
    While (PlyFindNext(aSearchRec)) do
    begin
      NDateTime := aSearchRec.TimeStamp;
      if (Abs(NDateTime-SearchDateTime)<Abs(FDateTime-SearchDateTime)) then
      begin
        FName     := aSearchRec.Name;
        FDateTime := NDateTime;
      end;
    end;
  end;
  PlyFindClose(aSearchRec);
  if (FName<>'') then Result := ExtractFilePath(FileNameWildCards) + FName
                 else Result := '';
end;

// If there are several files with the searched filename (wildcards),
// then return the filename that is next in time after the searched time
Function  PlyGetFilenameNext(FileNameWildCards:String; SearchDateTime:TDateTime) : String;
Var aSearchRec : tSearchRec;
    FName      : TFileName;
    FDateTime  : TDateTime;
    NDateTime  : TDateTime;
begin
  FName := '';
  FDateTime.Clr;
  if (PlyFindFirst(FileNameWildCards,faFile,aSearchRec)) then
  begin
    Repeat
      NDateTime := aSearchRec.TimeStamp;
      if (NDateTime>=SearchDateTime) then
      begin
        if (Abs(NDateTime-SearchDateTime)<Abs(FDateTime-SearchDateTime)) then
        begin
          FName     := aSearchRec.Name;
          FDateTime := NDateTime;
        end;
      end;
    Until (not PlyFindNext(aSearchRec));
  end;
  PlyFindClose(aSearchRec);
  if (FName<>'') then Result := ExtractFilePath(FileNameWildCards) + FName
                 else Result := '';
end;

Function  PlyFileRename(OldFilename,NewFilename:String) : Boolean;
{$IFDEF FPC}
  Var Datei : File;
{$ENDIF}
begin
  {$IFDEF FPC}
    if (PlyFileExists(OldFilename)) then
    begin
      Assign(Datei,Umlaute_DosWin(OldFilename));
      {$I-}
      Rename(Datei,Umlaute_DosWin(NewFilename));
      {$I+}
      PlyLastResult := IOResult;
    end else PlyLastResult := 2; (* Datei nicht gefunden *)
    Result := (PlyLastResult=0);
  {$ELSE}
    if (System.SysUtils.RenameFile(OldFilename,NewFilename)) then
    begin
      Result   := True;
      PlyLastResult := 0;
    end else
    begin
      Result := False;
      PlyLastResult := GetLastError;
    end;
  {$ENDIF}
end;

// Creates directory including subdirectories
Function  PlyDirectoryCreate(Directory:String) : Boolean;
Var ParentDir                : String;
    Success                  : Boolean;
begin
  Result := False;
  Directory := ExcludeTrailingPathDelimiter(Directory.ToUpper);
  if (Directory<>'') then
  begin
    if not(PlyDirectoryExists(Directory)) then
    begin
      ParentDir := ExtractParrentFilePath(Directory);
      // Sub_Dir > e.g. 'C:\'
      if (length(ParentDir)>3) then
      begin
        // recursive call
        Success := PlyDirectoryCreate(ParentDir);
      end else
      begin
        // Check if the specified drive exists
        Success := PlyDirectoryExists(ParentDir);
      end;
      PlyLastResult  := 0;
      // If the ParentDir exists or could be created, then try to
      // create the directory
      if (Success) then
      begin
        {$I-}
        MkDir(Directory);
        {$I+}
        PlyLastResult := IoResult;
        Result       := (PlyLastResult=0);
      end;
    end else
    begin
      // Directory already exists -> True
      Result := True;
    end;
  end;
end;

Function  PlyDirectoryDelete(Directory:String) : Boolean;
begin
  Result := False;
  Directory := ExcludeTrailingPathDelimiter(Directory.ToUpper);
  if (Directory<>'') then
  begin
    if (PlyDirectoryExists(Directory)) then
    begin
      {$I-}
      RmDir(Directory);
      {$I+}
      PlyLastResult := IoResult;
      Result       := (PlyLastResult=0);
    end else
    begin
      // Directory does not exist -> True
      Result := True;
    end;
  end;
end;


{$IFDEF CONSOLE}
Function  PlyDirectorySelect(StartDirectory:String) : String;
Var
  DirInfos : tDirInfos;
  DirInfo : tDirInfo;
  Key : Word;
begin
  Result := '';
  DirInfos := TDirInfos.Create;
  DirInfos.SearchPath := StartDirectory;
  DirInfos.SelectPath := True;
  Repeat
    DirInfos.ClearEntries;
    if (DirInfos.Execute) then
    begin
      DirInfos.Select(DirInfo,Key);
      if (Key=_Return) then
      begin
        DirInfos.SearchPath := DirInfo.Name;
      end;
    end;
  Until (Key=_F10) or (Key=_Esc);
  if (Key=_F10) then Result := DirInfo.Name;
  DirInfos.Destroy;
end;
{$ENDIF CONSOLE}

Function  PlyFileCompare_SizeTime(Filename1,Filename2:String) : Boolean;
Var SearchRec1 : tSearchRec;
    SearchRec2 : tSearchRec;
begin
  Result := False;
  if (PlyFileExists(Filename1,SearchRec1)) then
  begin
    if (PlyFileExists(Filename2,SearchRec2)) then
    begin
      if (SearchRec1.Size=SearchRec2.Size) then
      begin
        {$WARNINGS OFF}
        if (SearchRec1.Time=SearchRec2.Time) then
        begin
          Result := True;
        end;
        {$WARNINGS ON}
      end;
    end;
  end;
end;

Function  PlyFileCompare_Content(Filename1,Filename2:String) : Boolean;
Var SearchRec1               : tSearchRec;
    SearchRec2               : tSearchRec;
    File1,File2              : tFile;
    Data1,Data2              : Array [1..16384] of Byte;
    ReadRec1,ReadRec2        : tRecCount;
    Equal                    : Boolean;
begin
  Result := False;
  if (PlyFileExists(Filename1,SearchRec1)) then
  begin
    if (PlyFileExists(Filename2,SearchRec2)) then
    begin
      if (SearchRec1.Size=SearchRec2.Size) then
      begin
        if (SearchRec1.Size=0) then
        begin
          Result := True;
        end else
        begin
          File1.Init;
          if (File1.Open(Filename1,1)) then
          begin
            File2.Init;
            if (File2.Open(Filename2,1)) then
            begin
              Equal := True;
              Repeat
                File1.BlockRead(Data1,sizeof(Data1),ReadRec1);
                File2.BlockRead(Data2,sizeof(Data2),ReadRec2);
                if (ReadRec1=ReadRec2) then
                begin
                  if not(DataEqual(Data1,Data2,ReadRec1)) then
                  begin
                    Equal := False;
                  end;
                end else Equal := False;
              Until not(Equal) or (File1.Eof) or (File2.Eof);
              Result := Equal;
              File2.Close;
            end;
            File1.Close;
          end;
        end;
      end;
    end;
  end;
end;

Function  PlyGetFileNameFromFile(var aFile) : String;
begin
  {$IFDEF FPC}
    Result := StrPas(TextRec(aFile).Name);
  {$ELSE}
    Result := StrPas(TTextRec(aFile).Name);
  {$ENDIF}
end;

Function  PlyFileDelete(Filename:String) : Boolean;
Var Datei                    : Text;
begin
  Result := False;
  if (System.SysUtils.FileExists(Filename)) then
  begin
    {$IFDEF FPC}
    AssignFile(Datei,Umlaute_DosWin(Filename));
      try
        Erase(Datei);
        PlyLastResult := 0;
      except
        on E: EInOutError do
        begin
          PlyLastResult := E.ErrorCode;
        end;
      end;
    {$ELSE}
      AssignFile(Datei,Filename);
      Erase(Datei);
      if (FileExists(Filename)) then PlyLastResult := 5
                                else PlyLastResult := 0;
    {$ENDIF}
    if (PlyLastResult=0) then Result := True;
  end else Result := True;
end;

// All files in the directory which correspond to the specified
// filename (wildcards) are deleted.
// ATTENTION, there is no query whether to delete or not.
Function  PlyFilesDelete(FileNameWildCards:String) : Longint;
Var aSearchRec : tSearchRec;
    FPath      : TFileName;
    Count     : Longint;
begin
  Count := 0;
  if (PlyFindFirst(FileNameWildCards,faFile,aSearchRec)) then
  begin
    FPath := ExtractFilePath(FileNameWildCards);
    repeat
      // if not a directory -> it's a file
      if ((aSearchRec.Attr and faDirectory)=0) then
      begin
        if (PlyFileDelete(FPath+aSearchRec.Name)) then
        begin
          inc(Count);
        end;
      end;
    until (not PlyFindNext(aSearchRec));
  end;
  PlyFindClose(aSearchRec);
  Result := Count;
end;

// All files in the directory that match the specified filename (wildcards)
// and were created before the specified DateTime will be deleted
// ATTENTION, there is no query whether to delete or not
Function  PlyFilesDeleteBefore(FileNameWildCards:String; BeforeDateTime:TDateTime) : Longint;
Var
  aSearchRec : tSearchRec;
  FileDateTime : TDateTime;
  FPath : String;
  Count : Longint;
begin
  Count := 0;
  if (PlyFindFirst(FileNameWildCards,faFile,aSearchRec)) then
  begin
    FPath := ExtractFilePath(FileNameWildCards);
    repeat
      FileDateTime := aSearchRec.TimeStamp;
      If (FileDateTime<BeforeDateTime) then
      begin
        if (PlyFileDelete(FPath+aSearchRec.Name)) then
        begin
          inc(Count);
        end;
      end;
    until (not PlyFindNext(aSearchRec));
  end;
  PlyFindClose(aSearchRec);
  Result := Count;
end;

// AgeDays=0 : Delete all files
// AgeDays=1 : Delete all files from yesterday and older
Function  PlyFilesDeleteAgeDays(FileNameWildCards:String; AgeDays:Longint) : Longint;
Var BeforeDateTime : TDateTime;
begin
  BeforeDateTime := Trunc(Now);
  BeforeDateTime.AddDays(-AgeDays+1);
  Result := PlyFilesDeleteBefore(FileNameWildCards,BeforeDateTime);
end;

Function  PlyFilesDeleteAgeMinutes(FileNameWildCards:String; AgeMinutes:Longint) : Longint;
Var BeforeDateTime : TDateTime;
begin
  BeforeDateTime.InitNow;
  BeforeDateTime.AddSeconds(-AgeMinutes*60);
  Result := PlyFilesDeleteBefore(FileNameWildCards,BeforeDateTime);
end;

(*****************************)
(***** TWindowsCodepages *****)
(*****************************)
class function TWindowsCodepages.GetCodepageName(Codepage:Cardinal) : String;
var CpInfoEx : TCPInfoEx;
begin
  Result := '';
  if IsValidCodePage(Codepage) then
  begin
    if (GetCPInfoEx(Codepage, 0, CpInfoEx)) then
    begin
      Result := CpInfoEx.CodePageName;
      Result := Result.Substring(7,Length(Result)-8);
    end;
  end;
end;

class function  TWindowsCodepages.EnumCodePagesProc(CodePage:PWideChar) : Boolean;
Var CP : cardinal;
begin
  Result := False;
  if (CodePage<>Nil) then
  begin
    if (Length(Codepage)>0) then
    begin
      {$IFDEF DELPHI10UP}
      CP := StrToUIntDef(CodePage,0);
      {$ELSE}
      CP := StrToIntDef(Codepage,0);
      {$ENDIF DELPHI10UP}
      if (CP>0) then
      begin
        FList.Add(Format('%.5d: %s', [CP, GetCodepageName(CP)]));
        Result := True;
      end;
    end;
  end;
end;

class function TWindowsCodepages.GetInstalled(Var CodePageList:TStrings) : Boolean;
begin
  Result := False;
  FList := TStringList.Create;
  try
    if (EnumSystemCodePagesW(@EnumCodePagesProc,CP_INSTALLED)) then
    begin
      CodePageList.AddStrings(FList);
      FList.Clear;
      Result := True;
    end;
  finally
    FList.Free;
    FList := Nil;
  end;
end;

class function TWindowsCodepages.GetSupported(Var CodePageList:TStrings) : Boolean;
begin
  Result := False;
  FList := TStringList.Create;
  try
    if (EnumSystemCodePagesW(@EnumCodePagesProc,CP_SUPPORTED)) then
    begin
      CodePageList.AddStrings(FList);
      FList.Clear;
      Result := True;
    end;
  finally
    FList.Free;
    FList := Nil;
  end;
end;

class function TWindowsCodepages.GetName(CodePage: Cardinal) : String;
begin
  Result := GetCodepageName(CodePage);
end;

(********************)
(***** tDirInfo *****)
(********************)
Procedure tDirInfo.Clear;
begin
  Name     := '';
  Size     := 0;
  DateTime := 0;
  Attr     := 0;
end;

Function  tDirInfo.IsClear : Boolean;
begin
  Result := (Name='') and (Size=0);
end;

Procedure tDirInfo.Init(Var sr:tSearchRec; FilePath:String=''; ExcludeRootPath:String='');
begin
  Attr     := sr.Attr;
  if (FilePath<>'') and (ExcludeRootPath<>'') then
  begin
    FilePath := ReplaceText(FilePath,ExcludeRootPath,'');
  end;
  Name     := FilePath + sr.Name;
  Size     := sr.Size;
  DateTime := sr.TimeStamp;
end;

Procedure tDirInfo.InitDetails(eName:String; eSize:tFileSize; eDateTime:tDateTime; eAttr:tFileAttribute);
begin
  Name       := eName;
  Size       := eSize;
  DateTime   := eDateTime;
  Attr       := eAttr;
end;

Function  tDirInfo.GetFile(aFileName:String) : Boolean;
Var sr : tSearchrec;
begin
  Clear;
  if (PlyFileExists(aFileName,sr)) then
  begin
    Init(sr);
    Result := True;
  end else Result := False;
end;

Function  tDirInfo.GetPath(aFilePath:String) : Boolean;
Var sr : tSearchrec;
begin
  Clear;
  if (PlyDirectoryExists(aFilePath,sr)) then
  begin
    Init(sr);
    Result := True;
  end else Result := False;
end;

{$IFDEF CONSOLE}
Procedure tDirInfo.WriteLine(y:Integer);
Var Mx : Integer;
begin
  Mx := MaxX;
  WriteXY( 1,y,Copy(Name,1,Mx-38));
  WriteXY(Mx-37,y,IntToString(Size,8)+' Byte');
  WriteXY(Mx-22,y,DateTime.ToDate);
  WriteXY(Mx-10,y,DateTime.ToTime);
end;

Procedure tDirInfo.WriteLines(y:Integer);
begin
  ClrLines(y+0,y+3);
  WriteXY(1,y+0,'Filename   : '+Name);
  WriteXY(1,y+1,'Filesize   : '+IntToString(Size,0,'.')+' Byte | '+Size.ToStringReadable(False));
  WriteXY(1,y+2,'Filetime   : '+DateTime.ToDateTime);
  WriteXY(1,y+3,'Attributes : '+PlyFileAttributesToString(Attr));
end;

Procedure tDirInfo.ShowPopUp;
Var ScreenSave : tScreenSave;
begin
  ScreenSave.Save;
  Window(5,5,Max(55,length(Name)+20),10,'File-Properties');
  WriteLines(1);
  Readkey;
  ScreenSave.Restore;
end;

Procedure tDirInfo.WriteTextSelect(y:Integer; Len:Byte);
begin
  WriteXY(1,y,TextSelect(Len));
end;
{$ENDIF}

Function  tDirInfo.TextSizeDateTime: string;
begin
  if (Directory) then
  begin
    if (Name='..')
       then Result := '   UP--DIR'
       else Result := '   SUB-DIR';
  end else Result := Size.ToString(10);
  Result := Result + WideChar(_Frame_single_vert) + DateTime.ToDateShort
                   + WideChar(_Frame_single_vert) + DateTime.ToTime;
end;

Function  tDirInfo.TextSelect(TotalLen:Integer=70) : String;
Var
  FileExtension : String;
begin
  if (Directory) then
  begin
    Result := StringAlignLeft(TotalLen-30,Name,' ',True);
  end else
  begin
    FileExtension := FilenameGetExtension(Name);
    if (Length(FileExtension)>0)  and
       (Length(FileExtension)<=6) then
    begin
      Result := StringAlignLeft(TotalLen-36
              , ExtractFilePath(Name)+FilenameWithoutExtension(Name),' ',True)
              + StringAlignLeft(6,FileExtension);
    end else
    begin
      Result := StringAlignLeft(TotalLen-30,Name,' ',True);
    end;
  end;
  Result := Result + WideChar(_Frame_single_vert) + TextSizeDateTime;
end;

Function  tDirInfo.TextSelectHeadline(TotalLen:Integer=70) : String;
begin
  Result := 'Filename                                          '
   + '            Exten│    Size  │    Date│    Time';
end;

Function  tDirInfo.ToDate : String;
begin
  Result := DateTime.ToDate;
end;

Function  tDirInfo.ToTime : String;
begin
  Result := DateTime.ToTime;
end;

Function  tDirInfo.SubDir : String;
begin
  Result := ExtractFilePath(Name);
end;

Function  tDirInfo.FileName : String;
begin
  Result := ExtractFileName(Name);
end;

Function  tDirInfo.Extension : String;
begin
  Result := ExtractFileExt(Name);
end;

Function  tDirInfo.ReadOnly : Boolean;
begin
  Result := ((Attr and faReadOnly) = faReadOnly);
end;

{$WARNINGS OFF}
Function  tDirInfo.Hidden : Boolean;
begin
  Result := ((Attr and faHidden) = faHidden);
end;

Function  tDirInfo.SysFile : Boolean;
begin
  Result := ((Attr and faSysFile) = faSysFile);
end;

Function  tDirInfo.Archive : Boolean;
begin
  Result := ((Attr and faArchive) = faArchive);
end;

Function  tDirInfo.Directory: Boolean;
begin
  Result := ((Attr and faDirectory) = faDirectory);
end;
{$WARNINGS ON}

Function  tDirInfo.Equal(var aDirInfo: tDirInfo): Boolean;
begin
  Result := False;
  if (aDirInfo.Size=Size) then
  begin
    if (aDirInfo.DateTime=DateTime) then
    begin
      if (AnsiCompareText(aDirInfo.Name,Name)=0) then Result := True;
    end;
  end;
end;

(*********************)
(***** tDirInfos *****)
(*********************)
Procedure tDirInfos.SetSearchPath(Value:String);
Var FileFilter : String;
begin
  Value      := Value.ToUpper;
  FileFilter := ExtractFilename(Value);
  if (FileFilter<>'') then
  begin
    IncludeFilter.Clear;
    IncludeFilter.Add(FileFilter);
  end;
  FSearchPath := IncludeTrailingPathDelimiter(ExtractFilePath(Value));
end;

{$IFDEF CONSOLE}
Procedure tDirInfos.SetSelectPath(Value:Boolean);
begin
  if Value then
  begin
    FIncludeSubDirs := False;
    FAddFiles       := False;
    FAddDirs        := True;
  end;
  FSelectPath := Value;
end;
{$ENDIF CONSOLE}

Procedure tDirInfos.SetAddFiles(Value:Boolean);
begin
  if not(Value) then FAddDirs := True;
  FAddFiles := Value;
end;

Procedure tDirInfos.SetAddDirs(Value:Boolean);
begin
  if Value then FIncludeSubDirs := False
           else FAddFiles := True;
  FAddDirs := Value;
end;

Procedure tDirInfos.SetIncludeSubDirs(Value:Boolean);
begin
  if Value then FAddDirs := False;
  FIncludeSubDirs := Value;
end;

Function  tDirInfos.GetDirInfo(Index: Integer) : tDirInfo;
begin
  if (Index>=0) and (Index<=High(DInfos)) then
  begin
    Result := DInfos[Index];
    if (Result.Directory) then
    begin
      if (Result.Name='..')
         then Result.Name := ExtractParrentFilePath(FRootPath).ToUpper
         else Result.Name := IncludeTrailingPathDelimiter(FRootPath + Result.Name).ToUpper;
    end else Result.Name := FRootPath + Result.Name;
  end else Result.Clear;
end;

Function  tDirInfos.GetDirInfo(Index: Integer; Var Value:tDirInfo) : Boolean;
begin
  if (Index>=0) and (Index<=High(DInfos)) then
  begin
    Value      := GetDirInfo(Index);
    Result     := True;
  end else
  begin
    Value.Clear;
    Result := False;
  end;
end;

{$IFDEF DELPHIXE8DOWN}
Procedure tDirInfos.DelDirInfo(Index: Integer);
Var
  i : Integer;
  Count : Integer;
begin
  Count := Length(DInfos);
  Count := High(DInfos);
  if (Index<=Count) then
  begin
    for i := Index to Count-1 do
    begin
      DInfos[i] := DInfos[i+1];
    end;
    SetLength(DInfos,Length(DInfos)-1);
  end;
end;
{$ENDIF DELPHIXE8DOWN}

Constructor tDirInfos.Create;
begin
  Inherited Create;
  FRootPath         := '';
  {$IFDEF CONSOLE}
  FSelectedLast     := '';
  FSelectPath       := False;  // Default: Select Files
  {$ENDIF CONSOLE}
  FSearchPath       := '';
  SetLength(DInfos,0);
  AddFiles          := True;
  AddDirs           := False;
  IncludeSubDirs    := False;
  ExcludeSubDirs    := TStringList.Create;
  IncludeFilter     := TStringList.Create;
  ExcludeFilter     := TStringList.Create;
  FileStartDateTime := 0;
  FileEndDateTime   := 0;
end;

Destructor tDirInfos.Destroy;
begin
  ExcludeSubDirs.Destroy;
  IncludeFilter.Destroy;
  ExcludeFilter.Destroy;
  SetLength(DInfos,0);
  Inherited Destroy;
end;

Procedure tDirInfos.Clear;
begin
  FRootPath         := '';
  {$IFDEF CONSOLE}
  FSelectedLast     := '';
  FSelectPath       := False;  // Default: Select Files
  {$ENDIF CONSOLE}
  FSearchPath       := '';
  SetLength(DInfos,0);
  AddFiles          := True;
  AddDirs           := False;
  IncludeSubDirs    := False;
  ExcludeSubDirs.Clear;
  IncludeFilter.Clear;
  ExcludeFilter.Clear;
  FileStartDateTime := 0;
  FileEndDateTime   := 0;
end;

Procedure tDirInfos.ClearEntries;
begin
  SetLength(DInfos,0);
end;

Procedure tDirInfos.Add(Var aDirInfo:tDirInfo);
begin
  TAppender<TDirInfo>.Append(DInfos,aDirInfo);
end;

Procedure tDirInfos.Add(Var sr:tSearchRec; FilePath:String='');
Var aDirInfo : tDirInfo;
begin
  aDirInfo.Init(sr,FilePath,FRootPath);
  TAppender<TDirInfo>.Append(DInfos,aDirInfo);
end;

Procedure tDirInfos.Add(eName:String; eSize:tFileSize; eDateTime:tDateTime; eAttr:tFileAttribute);
Var aDirInfo : tDirInfo;
begin
  aDirInfo.InitDetails(eName,eSize,eDateTime,eAttr);
  TAppender<TDirInfo>.Append(DInfos,aDirInfo);
end;

Function  tDirInfos.Delete(DeleteFileName:String; All:Boolean=False) : Boolean;
Var i : Integer;
begin
  Result := False;
  DeleteFileName := DeleteFileName.ToUpper;
  for I := High(DInfos) downto 0 do
  begin
    if (AnsiCompareText(DInfos[i].Name,DeleteFileName)=0) then
    begin
      {$IFDEF DELPHI10UP}
      System.Delete(DInfos,i,1);
      {$ELSE}
      DelDirInfo(i);
      {$ENDIF DELPHI10UP}
      Result := True;
      if not(All) then Exit;
    end;
  end;
end;

Procedure tDirInfos.Delete(Var Strings:TStringList);
Var i : integer;
begin
  for i := 0 to Strings.Count-1 do
  begin
    Delete(Strings[i]);
  end;
end;

Procedure tDirInfos.DeleteNotRecSize(RecSize:Longint);
Var i : Integer;
begin
  for I := High(DInfos) downto 0 do
  begin
    {$IFDEF DEBUG}
      {$IFDEF CONSOLE}
        ClrLines(13,20);
        WriteXY(1,13,'Files.Count   : '+IntToString(Count,6));
        WriteXY(1,14,'DirInfo.Name  : '+DInfos[i].Name);
        WriteXY(1,15,'DirInfo.Size  : '+IntToString(DInfos[i].Size,6));
      {$ENDIF}
    {$ENDIF}
    if ((DInfos[i].Size mod RecSize)>0) then
    begin
      {$IFDEF DELPHI10UP}
      System.Delete(DInfos,i,1);
      {$ELSE}
      DelDirInfo(i);
      {$ENDIF DELPHI10UP}
    end;
  end;
end;

Procedure tDirInfos.DeleteFilter(FilterFilename:String);
Var i : Integer;
begin
  if (FilterFilename<>'') then
  begin
    for I := High(DInfos) downto 0 do
    begin
      if (FilenameCheckFilter(DInfos[i].Name,FilterFilename,False)) then
      begin
        {$IFDEF DELPHI10UP}
        System.Delete(DInfos,i,1);
        {$ELSE}
        DelDirInfo(i);
        {$ENDIF DELPHI10UP}
      end;
    end;
  end;
end;

Procedure tDirInfos.DeleteNotFilter(FilterFilename:String);
Var i : Integer;
begin
  if (FilterFilename<>'') then
  begin
    for I := High(DInfos) downto 0 do
    begin
      if (not(FilenameCheckFilter(DInfos[i].Name,FilterFilename,False))) then
      begin
        {$IFDEF DELPHI10UP}
        System.Delete(DInfos,i,1);
        {$ELSE}
        DelDirInfo(i);
        {$ENDIF DELPHI10UP}
      end;
    end;
  end;
end;

Function  tDirInfos.Execute(eSearchPath: string=''): Boolean;
Var sr                       : tSearchRec;
    SearchAttr               : tFileAttribute;
begin
  Result := False;
  // Init FSearchPath and determine possible FileFilter
  if (eSearchPath<>'') then SearchPath := eSearchPath;
  // If no filter is specified, then load all files
  if (IncludeFilter.Count<=0) then IncludeFilter.Add('*');
  // Set RootDir, when IncludeSubDir is active don't change
  if (FRootPath='') then FRootPath := SearchPath;
  // Set SearchAttr according to user-settings (AddFile | AddDir)
  if (AddFiles) then
  begin
    SearchAttr := faFile;
    if (AddDirs) or (IncludeSubDirs) then SearchAttr := SearchAttr + faDirectory;
  end else
  begin
    SearchAttr := faDir;
  end;
  if (PlyFindFirst(SearchPath+'*',SearchAttr,sr)) then
  begin
    Repeat
      if ((sr.Attr and faDirectory)=faDirectory) then
      begin
        // ignore CurrentDir
        if (sr.Name<>'.') then
        begin
          // exclude these directories
          if (ExcludeSubDirs.IndexOf(sr.Name)<0) then
          begin
            if (AddDirs) then
            begin
              Add(sr,SearchPath);
              Result := True;
            end else
            // if IncludeSubDirs ignore UpperDir
            if (IncludeSubDirs) and (sr.Name<>'..') then
            begin
              // Recursive call for SubDir
              if (Execute(SearchPath + sr.Name + '\')) then
              begin
                Result := True;
              end;
              if (eSearchPath<>'')
                 then SearchPath := eSearchPath
                 else SearchPath := FRootPath;
            end;
          end;
        end;
      end else
      {$WARNINGS OFF}
      if ((sr.Attr and faVolumeID)=0) and ((sr.Attr and faDirectory)=0) then
      {$WARNINGS ON}
      begin
        if (AddFiles) then
        begin
          if (FilenameCheckFilter(sr.Name,IncludeFilter))    and
             not(FilenameCheckFilter(sr.Name,ExcludeFilter)) then
          begin
            if ((FileStartDateTime=0) or (sr.TimeStamp >= FileStartDateTime)) and
               ((FileEndDateTime=0)   or (sr.TimeStamp <= FileEndDateTime))   then
            begin
              Add(sr,SearchPath);
              Result := True;
            end;
          end;
        end;
      end;
    Until (not PlyFindNext(sr));
  end;
  PlyFindClose(sr);
end;

Function  tDirInfos.GetSubDirs(Filename:String) : Boolean;
begin
  Result := Execute(Filename);
end;

Procedure tDirInfos.Sort(FileSort:TFilesort=NameUp);
begin
  TArray.Sort<TDirInfo>(DInfos, TComparer<TDirInfo>.Construct(

    function (const A, B: TDirInfo) : Integer
    Var LResult : Integer;
    begin
      if (a.Directory) and (b.Directory) then
      begin
        // UpperDir always on first Pos
        if a.Name='..' then Result := -1 else
        if b.Name='..' then Result := 1  else
        // If sort by Time, also Sort directories by time
        if FileSort=DateTimeUp    then Result := Round(A.DateTime - B.DateTime)  else
        if FileSort=DateTimeDown  then Result := Round(B.DateTime - A.DateTime)
        // otherwise, Sort directroies always by NameUp
                                  else Result := CompareText(A.Name, B.Name);
      end else
      // Directories always before files
      if a.Directory      and not(b.Directory) then Result := -1 else
      if not(a.Directory) and (b.Directory)    then Result := 1  else
      // Sort SubDirs
      if (a.SubDir='')    and (b.SubDir<>'')   then Result := -1 else
      if (a.SubDir<>'')   and (b.SubDir='')    then Result := 1  else
      if (a.SubDir<>'')   and (b.SubDir<>'')   then
      begin
        LResult := AnsiCompareText(a.SubDir,b.SubDir);
        // Same SubDir -> Sort by Parameter
        if (LResult=0) then
        begin
          if FileSort=NameUp        then Result := AnsiCompareText(A.FileName, B.FileName) else
          if FileSort=NameDown      then Result := AnsiCompareText(B.FileName, A.FileName) else
          if FileSort=ExtensionUp   then Result := AnsiCompareText(A.Extension, B.Extension) else
          if FileSort=ExtensionDown then Result := AnsiCompareText(B.Extension, A.Extension) else
          if FileSort=SizeUp        then Result := A.Size - B.Size                 else
          if FileSort=SizeDown      then Result := B.Size - A.Size                 else
          if FileSort=DateTimeUp    then Result := Round(A.DateTime - B.DateTime)  else
          if FileSort=DateTimeDown  then Result := Round(B.DateTime - A.DateTime)
                                    else Result := 0;
        end else
        // Different SubDir Sort by SubDir
        begin
          Result := LResult;
        end;
      end else
      begin
        // Sort files by parameter
        if FileSort=NameUp        then Result := AnsiCompareText(A.Name, B.Name) else
        if FileSort=NameDown      then Result := AnsiCompareText(B.Name, A.Name) else
        if FileSort=ExtensionUp   then Result := AnsiCompareText(A.Extension, B.Extension) else
        if FileSort=ExtensionDown then Result := AnsiCompareText(B.Extension, A.Extension) else
        if FileSort=SizeUp        then Result := A.Size - B.Size                 else
        if FileSort=SizeDown      then Result := B.Size - A.Size                 else
        if FileSort=DateTimeUp    then Result := Round(A.DateTime - B.DateTime)  else
        if FileSort=DateTimeDown  then Result := Round(B.DateTime - A.DateTime)
                                  else Result := 0;
      end;
    end));
end;

Function  tDirInfos.Count : Longint;
begin
  Result := Length(DInfos);
end;

Function  tDirInfos.Find(Filename:String; Var Value:tDirInfo; eDelete:Boolean=False) : Boolean;
Var i : integer;
begin
  Value.Clear;
  Filename     := Filename.ToUpper;
  Result       := False;
  for i := High(DInfos) downto 0 do
  begin
    if (AnsiCompareText(DInfos[i].Name,Filename)=0) then
    begin
      Result := True;
      Value  := DInfos[i];
      if (eDelete) then
      begin
        {$IFDEF DELPHI10UP}
        System.Delete(DInfos,i,1);
        {$ELSE}
        DelDirInfo(i);
        {$ENDIF DELPHI10UP}
      end;
      Exit;
    end;
  end;
end;

Procedure tDirInfos.ToStrings(aStrings:TStrings; TotalLen:Integer=70);
Var i : Integer;
begin
  for i := 0 to High(DInfos) do
  begin
    if (DInfos[i].Name<>'') then
    begin
      aStrings.Add(DInfos[i].TextSelect(TotalLen));
    end;
  end;
end;

Function  tDirInfos.TotalSize : TFilesize;
Var i : Integer;
begin
  Result := 0;
  for I := 0 to High(DInfos) do
  begin
    Result := Result + DInfos[i].Size;
  end;
end;

Function  tDirInfos.TextCountSize : String;
begin
  Result := Length(DInfos).ToString + ' Files │ '
          + IntToString(TotalSize,15,'.') + ' Byte │ '
          + IntToString(Round(TotalSize/1048576),10,'.')+' MByte';
end;

{$IFDEF CONSOLE}
Procedure tDirInfos.Show(DName:String; Attr:tFileAttribute);
Var
  sr : tSearchrec;
  Anz : Array [0..$3F] of Word;
  Cnt : Array [0..$3F] of Word;
  w : Word;
begin
  FillChar(Anz,sizeof(Anz),#0);
  FillChar(Cnt,sizeof(Cnt),#0);
  DName := DName.ToUpper;
  if (PlyFindFirst(DName,Attr,sr)) then
  begin
    Repeat
      inc(Anz[sr.Attr]);
      {$WARNINGS OFF}
      if ((Attr and faReadOnly) <>0) and ((sr.Attr and faReadOnly) <>0) or
         ((Attr and faHidden)   <>0) and ((sr.Attr and faHidden)   <>0) or
         ((Attr and faSysFile)  <>0) and ((sr.Attr and faSysFile)  <>0) or
         ((Attr and faVolumeId) <>0) and ((sr.Attr and faVolumeId) <>0) or
         ((Attr and faDirectory)<>0) and ((sr.Attr and faDirectory)<>0) or
         ((Attr and faArchive)  <>0) and ((sr.Attr and faArchive)  <>0) then
      begin
        inc(Cnt[sr.Attr]);
      end;
      {$WARNINGS ON}
    Until (not PlyFindNext(sr));
    Writeln('SearchAttr : ',Attr:3,' ',PlyFileAttributesToString(Attr));
    For w := 0 to $3F do
    begin
      if (Anz[w]>0) then
      begin
        Writeln(w:3,' ',Anz[w]:3,' ',Cnt[w]:3,' ',PlyFileAttributesToString(w));
      end;
    end;
  end;
  PlyFindClose(sr);
end;

Function  tDirInfos.TextSelectTitle : String;
begin
  if (FRootPath<>'') then Result := FRootPath else
  if (SelectPath)    then Result := 'Select Directory - '+FRootPath
                     else Result := 'Select File - '+FRootPath;
end;

Function  tDirInfos.TextSelectBottom : String;
begin
  if (SelectPath)
     then Result := '(F10) Select directory'
     else Result := 'Files : '+Count.ToString+'│F1 Help';
end;

Function  tDirInfos.TextSelectHeadLine : String;
begin
  Result := 'Filename                                          '
          + '            Exten│    Size  │    Date│    Time';
end;

Function  tDirInfos.Select(Var DirInfo:tDirInfo; Var Key:Word;
            HelpTextNumber:Integer=-1) : Boolean;
Var SelectItems              : tSelectItems;
    ItemPos                  : Longint;
    SelectedItem             : Longint;
    FileSort                 : TFilesort;
    Refresh                  : Boolean;
    ScreenSave               : tScreenSave;
    HeadLine                 : TConsoleString;
begin
  ScreenSave.Save;
  Result := False;
  if (Length(DInfos)>0) then
  begin
    Key      := _ESC;
    SelectItems.Init;
    FSelectedLast := ReplaceText(FSelectedLast,FRootPath,'');
    FileSort := NameUp;
    Repeat
      Refresh      := False;
      SelectedItem := 0;
      ItemPos      := 0;
      Repeat
        SelectItems.AddItem(ItemPos,DInfos[ItemPos].TextSelect(97),'',DInfos[ItemPos].Size);
        // Place the cursor on this record
        if (DInfos[ItemPos].Name=FSelectedLast) then
        begin
          SelectedItem := ItemPos;
        end;
        inc(ItemPos);
      Until (ItemPos>High(DInfos));
      Repeat
        SelectItems.HelpTextNumber := HelpTextNumber;

        Window(TextSelectTitle,TextSelectBottom);
        SelectItems.ExitOnPgKey := False;
        SelectItems.SortExtern  := True;
        HeadLine.Create(TextSelectHeadLine);
        SelectItems.Select(1,MaxY,HeadLine,SelectedItem,Key);
        if (Key>=_ALT_1) and (Key<=_ALT_4) then
        begin
          Refresh := True;
          // _ALT_1 : Sort by file name
          if (Key=_ALT_1) then
          begin
            if (FileSort=NameUp)
               then FileSort := NameDown
               else FileSort := NameUp;
          end else
          // _ALT_2 : Sort by file extension
          if (Key=_ALT_2) then
          begin
            if (FileSort=ExtensionUp)
               then FileSort := ExtensionDown
               else FileSort := ExtensionUp;
          end else
          // Sort by FileSize
          if (Key=_ALT_3) then
          begin
            if (FileSort=SizeUp)
               then FileSort := SizeDown
               else FileSort := SizeUp;
          end else
          // _ALT_3 : Sort by File-DateTime
          if (Key=_ALT_4) then
          begin
            if (FileSort=DateTimeUp)
               then FileSort := DateTimeDown
               else FileSort := DateTimeUp;
          end;
          Sort(FileSort);
        end else
        if (Key=_Return) then
        begin
          if (GetDirInfo(SelectedItem,DirInfo)) then
          begin
            // If (SelectPath) is activ and DirInfo is not a Directory, then only
            // ShowFileInfo an don't exit the function
            if (SelectPath) and not(DInfos[SelectedItem].Directory) then
            begin
              DirInfo := DInfos[SelectedItem];
              DirInfo.ShowPopUp;
              Key := _Space;
            end;
          end;
        end else
        if (Key=_F2) or (Key=_Space) then
        begin
          if (GetDirInfo(SelectedItem,DirInfo)) then
          begin
            DirInfo.ShowPopUp;
          end;
        end else
        // F8 = Delete File
        if (Key=_F8) then Key := _CRT_Delete;
      Until (Refresh)     or
            (Key=_Return) or   // Select File or Directory
            (Key=_CRT_Delete) or   // _Delete or F8: Delete File
            (Key=_Insert) or   // Create Directory
            (Key=_ESC)    or   // Exit, do not select
            (Key=_F3)     or   // Program-specific: e.g. Show File or Copy to FTP
            (Key=_F4)     or   // Rename File
            (Key=_F5)     or   // Refresh/Reload DirInfos
            (Key=_F6)     or   // Program-specific: e.g. Move File or Copy from FTP
            ((Key=_F10) and (SelectPath)) or
            (Key=_ALT_F6) or   // Program-specific: e.g. Move from FTP
            (Key=_ALT_F8) or   // Delete multiple files
            (Key=_ALT_E)  or   // Extract files if ZipFile
            (Key=_ALT_Z);      // Zip Files in ZipFile
      SelectItems.Done;
    Until (Key=_ESC)    or
          (Key=_Return) or
          (Key=_CRT_Delete) or
          (Key=_Insert) or
          (Key=_F3)     or
          (Key=_F4)     or
          (Key=_F5)     or
          (Key=_F6)     or
          ((Key=_F10) and (SelectPath)) or
          (Key=_ALT_F6) or
          (Key=_ALT_F8) or
          (Key=_ALT_E)  or
          (Key=_ALT_Z);
    if (Key<>_ESC) then
    begin
      if (Key=_F10) or
         ((SelectPath) and (Key<>_Return)) then
      begin
        DirInfo.GetPath(FRootPath);
        DirInfo.Name := FRootPath;
        Result := True;
      end else
      // Return DirInfo from current Cursor-Position
      if (GetDirInfo(SelectedItem,DirInfo)) then
      begin
        // Save Filename so that the cursor jumps
        // to this entry when the function is called again
        FSelectedLast := DirInfo.Name;
        if (DirInfo.Directory) then
        begin
          FRootPath := DirInfo.Name;
        end;
        Result := True;
      end;
    end else DirInfo.Clear;
  end else
  begin
    DirInfo.Clear;
    Key := _ESC;
  end;
  ScreenSave.Restore;
end;
{$ENDIF CONSOLE}

Function  GetWindowsMemoryUsage : Longint;
Var PMC                      : _PROCESS_MEMORY_COUNTERS;
    ThisApp                  : THandle;
begin
  GetWindowsMemoryUsage := -1;
  ThisApp := GetCurrentProcessID();
  ThisApp := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, ThisApp );
  if (ThisApp>0) then
  begin
    {$IFDEF FPC}
    if(GetProcessMemoryInfo(ThisApp, PMC, sizeof(_PROCESS_MEMORY_COUNTERS)) <> LongBool(0)) then
    {$ELSE}
    if(GetProcessMemoryInfo(ThisApp, @PMC, sizeof(_PROCESS_MEMORY_COUNTERS)) <> LongBool(0)) then
    {$ENDIF}
    begin
      GetWindowsMemoryUsage := PMC.WorkingSetSize;
    end;
    CloseHandle(ThisApp);
  end;
end;

// When Windows 10 is shut down via the "Shut Down" button in the Start menu,
// the operating system is not really shut down. The pure Windows operating system
// is rather put into a kind of "snooze state" (similar to hibernation) so that
// it can be automatically restarted as quickly as possible via the quick start
// option the next time it is started. This means that the system's startup time
// is not reset and may well be several days in the past until a restart is
// performed after an update, for example.

{$IFDEF DELPHI10UP}
Function  GetWindowsStartTime : TDateTime;
begin
  Result := Now - (GetTickCount64/86400000);
end;
{$ENDIF DELPHI10UP}

Function  GetWindowsStartTime2 : TDateTime;
var n1,n2                    : Int64;
begin
  // local init
  Result := 0.0;
  n1 := 0;
  n2 := 0;
  // local main
  QueryPerformanceFrequency(n1); // counts per second
  QueryPerformanceCounter(n2);   // counts since system boot time
  if (n1<>0) then
  begin
    n1 := Round(n2/n1); // seconds since system boot time
    // 1 Day = 86400 Seconds 60sec * 60min * 24hours
    Result := Now - (n1/86400);
  end;
end;

function tTimecount.GetMilliseconds: Extended;
begin
  Result := (FStop - FStart) * 1000 / FFrequenzy;
end;

procedure tTimecount.Start;
begin
  QueryPerformanceFrequency(FFrequenzy);
  QueryPerformanceCounter(FStart);
end;

procedure tTimecount.Stop;
begin
  QueryPerformanceCounter(FStop);
end;

initialization
  PlyProgDataPath := IncludeTrailingPathDelimiter(Filepath_Progamdata + PlyCompanyName);
  PlyProgUserPath := IncludeTrailingPathDelimiter(Filepath_AppDataRoaming + PlyCompanyName);

end.
