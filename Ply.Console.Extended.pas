(******************************************************************************

  Name          : Ply.Console.Extended.pas
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 22.06.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)

unit Ply.Console.Extended;

interface

{$I Ply.Defines.inc}

Uses Crt,
     Ply.Console,
     Ply.Types;

Type TScreenSaveHelper = Record Helper for TScreenSave
     private
       Function  GetFilename : String;
       Procedure SetFilename(Const aFilename:String);
     public
       Property  Filename : String Read GetFilename Write SetFilename;
       Function  FilenameIndex : String;
       Function  FileCount : Integer;
       Function  SaveToFile(Const Index:Integer=-1;
                   eUsername:String=''; eUserId:Integer=-1;
                   eComputername:String=''; eComputerId:Integer=-1) : Integer;
       Function  LoadFromFile(Const Index:Integer) : Boolean;
       Function  SelectFromFile : Boolean;
       Function  DeleteFile : Boolean;
     end;

Type TConsoleInfoExHelper = Class Helper for TConsoleInfoEx
     public
       // ShowDebug: Show internal values for debuging purposes
       Procedure ShowDebug(x,y:Byte; TC:Byte=10);
       Procedure Show_Color(x,y:Byte; ColorIndex:Byte);
       procedure Show_Colors(x,y:Byte);
       Procedure Edit_Color(x,y:Integer; ColorIndex:Byte);
     end;

Type TConsoleLocationHelper = record helper for TConsoleLocation
     public
       Function  Edit(y:Integer; Var WorkAreas:tWorkAreas;
                   Var ConsolePos:TConsoleDesktopRect) : TConsoleLocation;
     end;

Type TConsoleLocationComputerHelper = record helper for tConsoleLocationComputer
     private
       Function  GetFilename : String;
       Procedure SetFilename(Const aFilename:String);
     public
       Property  Filename : String Read GetFilename Write SetFilename;
       Function  LoadFromFile : Boolean;
       Function  SaveToFile : Boolean;
     end;

Type TConsoleLocationUserHelper = record helper for tConsoleLocationUser
     private
       Function  GetFilename : String;
       Procedure SetFilename(Const aFilename:String);
     public
       Property  Filename : String Read GetFilename Write SetFilename;
       Function  LoadFromFile : Boolean;
       Function  SaveToFile : Boolean;
     end;

Function  ConsoleLocationMoveComputer : Boolean;
Procedure ConsoleLocationMoveUser(Index:Integer; SetDefault:Boolean=True);
Procedure ConsoleLocationSaveUser(Index:Integer);
// ConsoleLocationMoveDefault: Set the console window to the position of the
//   computer if given, otherwise set it to the position[0] of the user if given.
//   If there are no values for both defaults (computer & user), do not change
//   the position of the console window.
Procedure ConsoleLocationMoveDefault;

Type tFrameWindow = Record
     Private
       FFrameAttr : TTextAttr;
       FTextAttr : TTextAttr;
       FBackground : Word;
       FTextTopLeft : String;
       FTextTitle : String;
       FTextTopRight : String;
       FTextBottomLeft : String;
       FTextBottomRight : String;
       Function  GetTextColor : Byte;
       Procedure SetTextColor(Const Value: Byte);
       function  GetTextBackground: Byte;
       procedure SetTextBackground(const Value: Byte);
       Function  GetFrameTextcolor : Byte;
       Procedure SetFrameTextColor(Const Value: Byte);
       Function  GetFrameTextBackground : Byte;
       Procedure SetFrameTextBackground(Const Value: Byte);
       Function  GetClrBackground : Boolean;
       Procedure SetClrBackground(Const Value: Boolean);
       Function  GetColorBackground : Byte;
       Procedure SetColorBackground(Const Value: Byte);
     Public
       class operator Initialize (out aFrameWindow: tFrameWindow);
       // FFrameAttr: Frame Textcolor and Textbackground
       Property  FrameAttr : TTextAttr Read FFrameAttr Write FFrameAttr;
       Property  FrameTextColor : Byte Read GetFrameTextcolor Write SetFrameTextColor;
       Property  FrameTextBackground : Byte Read GetFrameTextBackground Write SetFrameTextbackground;
       // FTextAttr: Canvas Textcolor and Textbackground
       Property  CanvasTextAttr : TTextAttr Read FTextAttr Write FTextAttr;
       Property  TextColor : Byte Read GetTextColor Write SetTextColor;
       Property  TextBackground : Byte Read GetTextBackground Write SetTextBackground;
       // ClrBackground: if set background is cleared if FrameWindow < Console.Window
       Property  ClrBackground : Boolean Read GetClrBackground Write SetClrBackground;
       // ColorBackground: Color for Background, if FrameWindow < Console.Window
       Property  ColorBackground : Byte Read GetColorBackground Write SetColorBackground;
       // TextXXX: Text to show on the spezified place within the frame
       Property  TextTopLeft : String Read FTextTopLeft Write FTextTopLeft;
       Property  TextTitle : String Read FTextTitle Write FTextTitle;
       Property  TextTopRight : String Read FTextTopRight Write FTextTopRight;
       Property  TextBottomLeft : String Read FTextBottomLeft Write FTextBottomLeft;
       Property  TextBottomRight : String Read FTextBottomRight Write FTextBottomRight;
       Procedure ClearSettings;
       Function  FrameTextTop : String;
       Function  FrameTextBottom : String;
       Procedure Window; Overload;
       Procedure Window(Const Title:String); Overload;
       Procedure Window(Const Title,BottomLeft:String) Overload;
       Procedure Window(Left, Top, Right, Bottom: Integer); Overload;
       Procedure Window(Left, Top, Right, Bottom: Integer;
                   Title:String; BottomLeft:String=''); Overload;
     End;

Var TextAttrFrameDefault : TTextAttr;

Procedure Window(X1, Y1, X2, Y2: Integer; Title:String; FrameAttr:TTextAttr;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String=''); Overload;
Procedure Window(X1, Y1, X2, Y2: Integer; Title:String;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String=''); Overload;
Procedure Window(Title:String; FrameAttr:TTextAttr;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String=''); Overload;
Procedure Window(Title:String;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String=''); Overload;

Procedure WriteRight(y:Smallint; aString:String);

Procedure CursorMoveField(Var FieldNumber:Integer; MinNum:Integer=0; MaxNum:Integer=99);

Function  InputString(iString:String; iLength,StrLength:Integer; TColor,BColor:Byte;
            Var Key:Word; ShowX:Integer=0; ShowY:Integer=0) : String; Overload
Function  InputString(x,y:Integer; iString:String; iLength,StrLength:Integer;
            TColor,BColor:Byte; Var Key:Word; ShowX:Integer=0; ShowY:Integer=0) : String; Overload

Function  InputString(iString:String; iLength:Integer; TColor,BColor:Byte; var Key:Word) : String; Overload;
Function  InputString(x,y:Integer; iString:String; iLength:Integer; TColor,BColor:Byte; var Key:Word) : String; Overload;

Function  InputString(iString:String; iLength:Integer; var Key:Word) : String; Overload;
Function  InputString(x,y:Integer; iString:String; iLength:Integer; var Key:Word) : String; Overload;

Function  InputString(iString:String; iLength:Integer; StrLength:Integer=-1) : String; Overload;
Function  InputString(x,y:Integer; iString:String; iLength:Integer; StrLength:Integer=-1) : String; Overload;

Function  InputDouble(iDouble:Double; iLength:Integer; Var Key:Word) : Double; Overload;
Function  InputDouble(iDouble:Double; iLength:Integer; Var Key:Word; Width:Integer;
            Comma:Byte=2; DecimalSeparator:WideChar='.';
            ThousandSeparator:WideChar='?') : Double; Overload;

Function  InputInteger(iInteger:Integer; iLength:Integer; Var Key:Word) : Integer; Overload;
Function  InputInteger(iInteger:Int64; iLength:Integer; Var Key:Word) : Int64; Overload;

Function  LineSelectExit(FromY,ToY,FromX,ToX:Integer; var CurrentY:Integer) : Word; Overload;
Function  LineSelectExit(FromY,ToY:Integer; var CurrentY:Integer) : Word; Overload;

Function  LineSelect(FromY,ToY,FromX,ToX:Integer; var CurrentY:Integer) : Word; Overload;
Function  LineSelect(FromY,ToY:Integer; var CurrentY:Integer) : Word; Overload;

Function  CodepageSelect(Const Codepage:Cardinal; CP_Source:Cardinal=1) : Cardinal;
Function  CodepageSelectInstalled(Const Codepage:Cardinal) : Cardinal;
Function  CodepageSelectSupported(Const Codepage:Cardinal) : Cardinal;

Type TSelectSort = (SortUp, SortDown, FPosUp, FPosDown, ShortUp, ShortDown, LongUp, LongDown);

Type tSelectItem             = Record
     FPos                    : Integer;
     NameLong                : TConsoleString;
     NameShort               : TConsoleString;
     SortValue               : TSortValue;
     Procedure Clear;
     Function  IsClear : Boolean;
     Function  SearchName(Short:Boolean) : String;
     Function  TextSelection(LenShort,LenTotal:Integer) : String;
     Procedure WriteSelection(y:Integer; LenShort:Integer);
     end;

Type tSelectItems            = Record
     Private
       Items                 : TArray<TSelectItem>;
       FExitOnPgKey          : Boolean;
       FExitOnNumber         : Boolean;
       FSortExtern           : Boolean;
       FHelpTextNumber       : Integer;
       FLastSort             : TSelectSort;
       Function  GetItemByIndex(Index:Integer) : tSelectItem;
       Function  GetItemByName(Const sName:String) : tSelectItem;
       Procedure SetItemByIndex(Index:Integer; Value:tSelectItem);
     Public
       Procedure   Init;
       Procedure   Done;
       Property    ExitOnPgKey : Boolean Read FExitOnPgKey Write FExitOnPgKey;
       Property    ExitOnNumber : Boolean Read FExitOnNumber Write FExitOnNumber;
       Property    SortExtern : Boolean Read FSortExtern Write FSortExtern;
       Property    HelpTextNumber : Longint Read FHelpTextNumber Write FHelpTextNumber;
       Function    AddItem(eFPos:Longint; eNameLong:String; eNameShort:String='';
                     eColor:Byte=LightGray) : Boolean; Overload;
       Function    AddItem(eFPos:Longint; eNameLong,eNameShort:String; eSortValue:TSortValue;
                     eColor:Byte=LightGray) : Boolean; Overload;
       Function    AddItem(eFPos:Longint; eNameLong:TConsoleString) : Boolean; Overload;
       Function    AddItem(eFPos:Longint; eNameLong,eNameShort:TConsoleString;
                     eSortValue:tSortValue) : Boolean; Overload;
       Procedure   DeleteItem(eFPos:Longint);
       Procedure   UpdateItem(eFPos:Longint; eNameLong:String); Overload;
       Procedure   UpdateItem(eFPos:Longint; eNameLong:String; eColor:Byte); Overload;
       Procedure   Sort(SelectSort:TSelectSort);
       Function    MaxLen_NameShort : Integer;
       Function    MaxLen_NameLong : Integer;
       Function    Count : Integer;
       Function    FPosMin : Integer;
       Function    FPosMax : Integer;
       Function    IsMember(eFPos:Longint) : Boolean;
       Property    Item[Index: integer]: tSelectItem read GetItemByIndex write SetItemByIndex; default;
       Property    Item[const sName: string]: tSelectItem read GetItemByName; default;

       Function    GetIndexByFPos(sFPos:Integer) : Integer;
       Function    GetIndexBySearch(SearchString:String) : Integer;
       Function    GetIndexByNameShort(sNameShort:String) : Integer;
       Function    GetIndexByNameLong(sNameLong:String) : Integer;
       Function    GetItemByFPos(sFPos:Integer; Var aItem:tSelectItem) : Boolean;
       Function    Select(FromY,ToY:Integer; HeadLine:TConsoleString;
                     Var FPosSelect:Integer; Var Key:Word) : Boolean; Overload;
       Function    Select(Left,Top,Right,Bottom:Integer; Title,BottomLeft:String;
                     HeadLine:TConsoleString; Var FPosSelect:Integer; Var Key:Word) : Boolean; Overload;
       Function    Select(Title,BottomLeft:String; HeadLine:TConsoleString;
                     Var FPosSelect:Integer; Var Key:Word) : Boolean; Overload;
     end;

Procedure ConsoleShowMessage(x,y,SizeX,SizeY:Integer; FrameAttr:TTextAttr;
            Title,Msg1:String; Msg2:String=''; Msg3:String='');
Procedure ConsoleShowNote(Title,Msg1:String; Msg2:String=''; Msg3:String='');
Procedure ConsoleShowWarning(Title,Msg1:String; Msg2:String=''; Msg3:String='');
Procedure ConsoleShowError(Title,Msg1:String; Msg2:String=''; Msg3:String='');

implementation

Uses
  Ply.DateTime,
  Ply.Files,
  Ply.Math,
  Ply.StrUtils,
  Ply.SysUtils,
  System.Classes,
  System.Math,
  System.SysUtils,
  Vcl.Clipbrd,
  WinAPI.Windows;

Var AlternateScreenSaveFilename : String = '';

Type TScreenSaveIndex = Record
       Index            : Integer;
       DateTime         : TDateTime;
       UserId           : Integer;
       Username         : WStr30;
       ComputerId       : Integer;
       Computername     : WStr30;
       // Size of Console.Window
       iScreenSize      : TConsoleWindowPoint;
       // WindSize: Position of the active crt.window within the console.window
       iWindSize        : TPlyConWinSize;
       // CursorPos: Position of the cursor within the active crt.window
       iCursorPos       : TConsoleWindowPoint;
       // TextAttr: Current TColor & BColor when saving screen
       iTextAttr        : Word;
       // FPosData: FilePos of ScreenData in ScreenSaveData-File
       FPosData         : Integer;
       Procedure Clr;
       Procedure Init(Var ScreenSave:tScreenSave;
                   eUsername:String=''; eUserId:Integer=-1;
                   eComputername:String=''; eComputerId:Integer=-1);
       Procedure GetSettings(Var ScreenSave:tScreenSave);
       Function  Filename : String;
       Function  Open(var aFile:tFile) : Boolean;
       Function  Load(aIndex:Integer) : Boolean;
       Function  Filesize : Integer;
       Function  SelectString : TConsoleString;
       Function  SelectHeadline : TConsoleString;
     end;

Type TScreenSaveData  = Record
       // Char & Attr of total ScreenSize
       ScreenData : TScreenData;
       Private
         Function  Filename : String;
         Function  Open(Var aFile:tFile) : Boolean;
       Public
         Procedure InitData(Var ScreenSave:tScreenSave);
         Function  WriteData(Var FPos:Integer) : Boolean;
         Function  ReadData(Const ScreenSaveIndex:tScreenSaveIndex) : Boolean;
       end;

Function  TScreenSaveHelper.GetFilename : String;
Var ScreenSaveData : TScreenSaveData;
begin
  Result := ScreenSaveData.Filename;
end;

Procedure TScreenSaveHelper.SetFilename(Const aFilename:String);
begin
  if (aFilename='') then AlternateScreenSaveFilename := '' else
  if (FilenameGetExtension(aFilename)='')
     then AlternateScreenSaveFilename := aFilename + '.ScrDat'
     else AlternateScreenSaveFilename := FilenameReplaceExtension(aFilename,'ScrDat');
end;

Function  TScreenSaveHelper.FilenameIndex : String;
Var ScreenSaveIndex : TScreenSaveIndex;
begin
  Result := ScreenSaveIndex.Filename;
end;

Function  TScreenSaveHelper.FileCount : Integer;
Var ScreenSaveIndex : TScreenSaveIndex;
begin
  Result := ScreenSaveIndex.Filesize;
end;

Function  TScreenSaveHelper.SaveToFile(Const Index:Integer=-1;
            eUsername:String=''; eUserId:Integer=-1;
            eComputername:String=''; eComputerId:Integer=-1) : Integer;
Var
  ScreenSaveIndex : TScreenSaveIndex;
  IndexFile : tFile;
  ScreenSaveData : TScreenSaveData;
begin
  Result := -1;
  if (ScreenSaveIndex.Open(IndexFile)) then
  begin
    // Overwrite existing ScreenData
    if (Index>=0) and (Index<IndexFile.Filesize) then
    begin
      if (IndexFile.Seek_Read(Index,ScreenSaveIndex)) then
      begin
        // Overwrite is only possible if ScreenSize didn't change
        if (FScreen.Size=ScreenSaveIndex.iScreenSize) then
        begin
          ScreenSaveData.InitData(Self);
          ScreenSaveIndex.Init(Self,eUsername, eUserId, eComputername, eComputerId);
          ScreenSaveIndex.Index := Index;
          if (ScreenSaveData.WriteData(ScreenSaveIndex.FPosData)) then
          begin
            if (IndexFile.Seek_Write(ScreenSaveIndex.Index,ScreenSaveIndex)) then
            begin
              Result := ScreenSaveIndex.Index;
            end;
          end;
        end;
      end;
    end else
    // Add new ScreenData at eof
    begin
      ScreenSaveData.InitData(Self);
      ScreenSaveIndex.Init(Self,eUsername, eUserId, eComputername, eComputerId);
      ScreenSaveIndex.Index := IndexFile.Filesize;
      if (ScreenSaveData.WriteData(ScreenSaveIndex.FPosData)) then
      begin
        if (IndexFile.Seek_Write(ScreenSaveIndex.Index,ScreenSaveIndex)) then
        begin
          Result := ScreenSaveIndex.Index;
        end;
      end;
    end;
    IndexFile.Close;
  end;
end;

Function  TScreenSaveHelper.LoadFromFile(Const Index:Integer) : Boolean;
Var
  ScreenSaveIndex : TScreenSaveIndex;
  ScreenSaveData : TScreenSaveData;
begin
  Result := False;
  if (ScreenSaveIndex.Load(Index)) then
  begin
    ScreenSaveIndex.GetSettings(Self);
    ScreenSaveData.ScreenData.Init(ScreenSaveIndex.iScreenSize);
    if (ScreenSaveData.ReadData(ScreenSaveIndex)) then
    begin
      FScreen.SetData(ScreenSaveIndex.iScreenSize,ScreenSaveData.ScreenData);
      Result := True;
    end;
  end;
end;

Function  TScreenSaveHelper.SelectFromFile : Boolean;
Var
  ScreenSaveIndex : TScreenSaveIndex;
  aFile : tFile;
  SelectScreen : tSelectItems;
  FPos : Longint;
  Key : Word;
begin
  Result := False;
  if (FileExists(ScreenSaveIndex.Filename)) then
  begin
    SelectScreen.Init;
    if (ScreenSaveIndex.Open(aFile)) then
    begin
      while not(aFile.Eof) do
      begin
        FPos := aFile.Filepos;
        aFile.DosRead(ScreenSaveIndex);
        SelectScreen.AddItem(FPos,ScreenSaveIndex.SelectString);
      end;
      aFile.Close;
      FPos := 0;
      Repeat
        SelectScreen.Select(Console.WindowSize.x-72,2,Console.WindowSize.X-2
          ,Console.WindowSize.Y-1,'Select Screen','(Enter) Select, (Esc) Exit'
          ,ScreenSaveIndex.SelectHeadline,FPos,Key);
      Until (Key=_Return) or (Key=_Esc);
      if (Key=_Return) then
      begin
        if (LoadFromFile(FPos)) then
        begin
          Result := True;
        end;
      end;
    end;
    SelectScreen.Done;
  end;
end;

Function  TScreenSaveHelper.DeleteFile : Boolean;
Var
  ScreenSaveIndex : TScreenSaveIndex;
  ScreenSaveData : TScreenSaveData;
begin
  Result := False;
  if (PlyFileDelete(ScreenSaveIndex.Filename)) then
  begin
    if (PlyFileDelete(ScreenSaveData.Filename)) then
    begin
      Result := True;
    end;
  end;
end;

Procedure TScreenSaveIndex.Clr;
begin
  Index            := -1;
  DateTime         := 0;
  UserId           := -1;
  FillChar(Username,Sizeof(Username),#0);
  ComputerId       := -1;
  FillChar(Computername,Sizeof(Computername),#0);
  iScreenSize.Clear;
  iWindSize.Clear;
  iCursorPos.Clear;
  iTextAttr        := _TextAttr_Default;
  FPosData         := -1;
end;

Procedure TScreenSaveIndex.Init(Var ScreenSave:tScreenSave;
            eUsername:String=''; eUserId:Integer=-1;
            eComputername:String=''; eComputerId:Integer=-1);
begin
  Clr;
  DateTime := Now;
  UserId   := eUserId;
  if (eUsername<>'')
     then StrLCopy(Username,PChar(eUsername),length(Username))
     else StrLCopy(Username,PChar(GetWindowsUsername),length(Username));
  ComputerId := eComputerId;
  if (eComputername<>'')
     then StrLCopy(Computername,PChar(eComputername),length(Computername))
     else StrLCopy(Computername,PChar(GetWindowsComputername),length(Computername));
  // Size of Console.Window
  iScreenSize  := ScreenSave.FScreen.Size;
  // WindSize: Position of the active window within the console window
  iWindSize    := ScreenSave.FWindSize;
  // CursorPos: Position of the cursor within the active window
  iCursorPos   := ScreenSave.FCursorPos;
  // TextAttr: Current TColor & BColor when saving screen
  iTextAttr    := ScreenSave.FTextAttr;
end;

Procedure TScreenSaveIndex.GetSettings(Var ScreenSave:tScreenSave);
begin
  // Size of Console.Window
  ScreenSave.FScreen.Size := iScreenSize;
  // WindSize: Position of the active window within the console window
  ScreenSave.FWindSize    := iWindSize;
  // CursorPos: Position of the cursor within the active window
  ScreenSave.FCursorPos   := iCursorPos;
  // TextAttr: Current TColor & BColor when saving screen
  ScreenSave.FTextAttr    := iTextAttr;
end;

Function  TScreenSaveIndex.Filename: string;
begin
  if (AlternateScreenSaveFilename<>'')
     then Result := FilenameReplaceExtension(AlternateScreenSaveFilename,'ScrIdx')
     else Result := PlyProgDataPath + 'ScreenSave.ScrIdx';
end;

Function  TScreenSaveIndex.Open(Var aFile:tFile) : Boolean;
Var FName : String;
    DirInfo : TDirInfo;
begin
  FName := Filename;
  if not(DirInfo.GetPath(ExtractFilePath(FName))) then
  begin
    PlyDirectoryCreate(ExtractFilePath(FName));
  end;
  Result := aFile.Open(Filename,sizeof(Self));
end;

Function  TScreenSaveIndex.Load(aIndex:Integer) : Boolean;
Var aFile : tFile;
begin
  Result := False;
  if (Open(aFile)) then
  begin
    Result := aFile.Seek_Read(aIndex,Self);
    aFile.Close;
  end;
end;

Function  TScreenSaveIndex.Filesize : Integer;
Var aFile : tFile;
begin
  Result := 0;
  if (FileExists(Filename)) then
  begin
    if (Open(aFile)) then
    begin
      Result := aFile.Filesize;
      aFile.Close;
    end;
  end;
end;

Function  TScreenSaveIndex.SelectString : TConsoleString;
begin
  Result := TConsoleString.Create(IntToString(Index,4)+' ',White)
          + TConsoleString.Create(DateTime.ToDateTime+' ',LightGreen)
          + TConsoleString.Create(iScreenSize.ToStringSize+' ',Yellow)
          + TConsoleString.Create(Username,LightMagenta);
end;

Function  TScreenSaveIndex.SelectHeadline : TConsoleString;
begin
  Result := TConsoleString.Create(' Num ',White)
          + TConsoleString.Create('Screen.Saved         ',LightGreen)
          + TConsoleString.Create('Screen.Size ',Yellow)
          + TConsoleString.Create('User',LightMagenta);
end;

(***************************)
(***** TScreenSaveData *****)
(***************************)
Function  TScreenSaveData.Filename: string;
begin
  if (AlternateScreenSaveFilename<>'')
     then Result := AlternateScreenSaveFilename
     else Result := PlyProgDataPath + 'ScreenSave.ScrDat';
end;

Function  TScreenSaveData.Open(Var aFile:tFile) : Boolean;
begin
  Open := aFile.Open(Filename,1);
end;

Procedure TScreenSaveData.InitData(Var ScreenSave:tScreenSave);
begin
  // Char & Attr of total ScreenSize
  ScreenSave.FScreen.GetData(ScreenData);
end;

Function  TScreenSaveData.WriteData(Var FPos:Integer) : Boolean;
Var
  aFile : tFile;
  WrittenRec : tRecCount;
begin
  Result := False;
  if (Open(aFile)) then
  begin
    if (FPos<0) then FPos := aFile.Filesize;
    aFile.Seek(FPos);
    if (aFile.BlockWrite(ScreenData.CharData[0],ScreenData.SizeChar,WrittenRec)) then
    begin
      if (aFile.BlockWrite(ScreenData.AttrData[0],ScreenData.SizeAttr,WrittenRec)) then
      begin
        Result := True;
      end;
    end;
    aFile.Close;
  end;
end;

Function  TScreenSaveData.ReadData(Const ScreenSaveIndex:tScreenSaveIndex) : Boolean;
Var
  aFile : tFile;
  ReadRec : tRecCount;
begin
  Result := False;
  if (Open(aFile)) then
  begin
    if (ScreenSaveIndex.FPosData<aFile.Filesize) then
    begin
      aFile.Seek(ScreenSaveIndex.FPosData);
      if (aFile.BlockRead(ScreenData.CharData[0],ScreenData.SizeChar,ReadRec)) then
      begin
        if (aFile.BlockRead(ScreenData.AttrData[0],ScreenData.SizeAttr,ReadRec)) then
        begin
          Result := True;
        end;
      end;
    end;
    aFile.Close;
  end;
end;

(********************************)
(***** tConsoleInfoExHelper *****)
(********************************)
procedure tConsoleInfoExHelper.ShowDebug(x,y:Byte; TC:Byte=LightGreen);
Var TextAttr_Save : tTextAttr;

  Function YesNo(Value:Boolean) : String;
  begin
    if (Value) then Result := 'Yes' else Result := 'No';
  end;

  begin
  TextAttr_Save := Crt.TextAttr;
  Textcolor(TC);
  WriteXY(x,y+0,'dwSize      : '+ScreenSize.ToStringSize);
  WriteXY(x,y+1,'dwCursorPos : '+CursorPos.ToStringPos);
  WriteXY(x,y+2,'Attribut    : '+TextAttr_Save.Attr.ToString
               +' : BC = '+TextAttr_Save.Textbackground.ToString
                 +' TC = '+TextAttr_Save.Textcolor.ToString);
  WriteXY(x,y+3,'srWindow    : '+WindowRect.ToStringRect);
  WriteXY(x,y+4,'dwMaxWinSize: '+WindowSizeMax.ToStringSize);
  WriteXY(x,y+5,'Popup-Attr. : '+IntToString(PopupAttributes,3));
  WriteXY(x,y+6,'FullScreen  : '+YesNo(FullscreenSupported));
  Crt.TextAttr := TextAttr_Save;
end;

Procedure tConsoleInfoExHelper.Show_Color(x,y:Byte; ColorIndex:Byte);
begin
  if (ColorIndex in [0..15]) then
  begin
    if (ColorIndex=Textbackground) then
    begin
      if (ColorIndex=White) then Textcolor(Black)
                            else Textcolor(White);
    end else Textcolor(ColorIndex);
    WriteXY(x,y,'['+IntToString(ColorIndex,2)+'] '
      +ColorNames[ColorIndex]+'          ');
    WriteXY(x+18,y,' : '
      +IntToString(ColorTable[ColorIndex],9)
      +IntToString(GetRValue(ColorTable[ColorIndex]),6)
      +IntToString(GetGValue(ColorTable[ColorIndex]),6)
      +IntToString(GetBValue(ColorTable[ColorIndex]),6)
      +'   '+IntToHex(ColorTable[ColorIndex],6)
      +'   '+IntToString(ColorTable[ColorIndex],8));
  end;
end;

procedure tConsoleInfoExHelper.Show_Colors(x,y:Byte);
Var ColorIndex : Byte;
begin
  WriteXY(x,y+0,'[Nr] Colorname     : RGB-Value   RED GREEN  BLUE   Hex-Code Dec-Code');
  For ColorIndex := 0 to 15 do
  begin
    Show_Color(x,y+ColorIndex+1,ColorIndex);
  end;
end;

Procedure tConsoleInfoExHelper.Edit_Color(x,y:Longint; ColorIndex:Byte);
Var R,G,B  : Byte;
    Key    : Word;
    Field  : Integer;
begin
  R     := GetRValue(ColorTable[ColorIndex]);
  G     := GetGValue(ColorTable[ColorIndex]);
  B     := GetBValue(ColorTable[ColorIndex]);
  Field := 0;
  Key   := _Return;
  Repeat
    Show_Color(x,y,ColorIndex);
    if (Field=0) then
    begin
      GotoXY(x+33,y);
      Key := 1;
      R := ValueMinMax(InputInteger(R,3,Key),0,255);
    end else
    if (Field=1) then
    begin
      GotoXY(x+39,y);
      Key := 1;
      G := ValueMinMax(InputInteger(G,3,Key),0,255);
    end else
    if (Field=2) then
    begin
      GotoXY(x+45,y);
      Key := 1;
      B := ValueMinMax(InputInteger(B,3,Key),0,255);
    end;
    CursorMoveField(Field);
    ColorTable[ColorIndex] := RGB(R,G,B);
  Until (Key=_ESC) or (Field>2);
  SetInfoEx;
end;

(**********************************)
(***** TConsoleLocationHelper *****)
(**********************************)
function TConsoleLocationHelper.Edit(y:Integer; Var WorkAreas:tWorkAreas; Var
    ConsolePos:TConsoleDesktopRect): TConsoleLocation;
Var FieldNr                  : Integer;
    Key                      : Word;
    ConPos                   : TConsoleDesktopPoint;
begin
  FieldNr := 0;
  ClrLines(21,23);
  WriteXY(1,22,White,'(Alt+A) Aktuelle Position übernehmen');
  Repeat
    WriteXY(16,y,TextPositionFont); ClrEol;
    if (FieldNr=0) then
    begin
      GotoXY(16,y); Key := 1;
      ConPos    := Position;
      ConPos.X := InputInteger(ConPos.x,4,Key);
      ConPos.X := ValueMinMax(ConPos.X,-1,WorkAreas.MaxRight-ConsolePos.Width);
      Position := ConPos;
    end else
    if (FieldNr=1) then
    begin
      GotoXY(22,y); Key := 1;
      ConPos   := Position;
      ConPos.Y := InputInteger(ConPos.y,4,Key);
      ConPos.Y := ValueMinMax(ConPos.Y,-1,WorkAreas.MaxBottom-ConsolePos.Height);
      Position := ConPos;
    end else
    if (FieldNr=3) then
    begin
      WriteXY(55,y,White,'(+|-) ändern'); ClrEol;
      InvertString(28,y,16);
      GotoXY(28,y);
      Readkey(Key);
      if (Key=_Plus) and (FontNumber<_ConsoleFontNumberMax) then
      begin
        FontNumber := FontNumber + 1;
        Console.Font.SetCurrentFont(FontNumber,FontSize);
      end;
      if (Key=_Minus) and (FontNumber>1) then
      begin
        FontNumber := FontNumber - 1;
        Console.Font.SetCurrentFont(FontNumber,FontSize);
      end;
    end else
    if (FieldNr=4) then
    begin
      WriteXY(55,y,White,'(+|-) ändern'); ClrEol;
      InvertString(46,y,7);
      GotoXY(46,y);
      Readkey(Key);
      if (Key=_Plus) and (FontSize<_ConsoleFontSizeMax) then
      begin
        FontSize := FontSize + 1;
        Console.Font.SetCurrentFont(FontNumber,FontSize);
      end;
      if (Key=_Minus) and (FontSize>1) then
      begin
        FontSize := FontSize - 1;
        Console.Font.SetCurrentFont(FontNumber,FontSize);
      end;
    end;
    ClrLines(22,22);
    (* (Alt+A) Aktuelle Position des Konsolenfensters übernehmen *)
    if (Key=_ALT_A) then
    begin
      Position := Console.Desktop.Area.TopLeft;
    end;
    CursorMoveField(FieldNr);
  until (FieldNr>4) or (Key=_ESC);
  Result := Self;
end;

(******************************************)
(***** TConsoleLocationComputerHelper *****)
(******************************************)
Var AlternateConsoleLocationComputerFilename : String = '';

Function  TConsoleLocationComputerHelper.GetFilename : String;
begin
  if (AlternateConsoleLocationComputerFilename<>'')
     then Result := AlternateConsoleLocationComputerFilename
     else Result := PlyProgDataPath + GetWindowsComputername + '.'
                  + FilenameWithoutExtension(FilePathName_Exe) + '.CLC';
end;

Procedure TConsoleLocationComputerHelper.SetFilename(Const aFilename:String);
begin
  AlternateConsoleLocationComputerFilename := aFilename;
end;

Function  TConsoleLocationComputerHelper.LoadFromFile : Boolean;
Var aFile : tFile;
begin
  Result := False;
  Init;
  if (PlyFileExists(Filename)) then
  begin
    if (aFile.Open(Filename,Sizeof(Self))) then
    begin
      Result := aFile.DosRead(Self);
      aFile.Close;
    end;
  end;
end;

Function  TConsoleLocationComputerHelper.SaveToFile : Boolean;
Var aFile : tFile;
begin
  Result := False;
  if (aFile.Open(Filename,Sizeof(Self))) then
  begin
    Result := aFile.DosWrite(Self);
    aFile.Close;
  end;
end;

(**************************************)
(***** TConsoleLocationUserHelper *****)
(**************************************)
Var AlternateConsoleLocationUserFilename : String = '';

Function  TConsoleLocationUserHelper.GetFilename : String;
begin
  if (AlternateConsoleLocationUserFilename<>'')
     then Result := AlternateConsoleLocationUserFilename
     else Result := PlyProgUserPath + GetWindowsUsername + '.'
                  + FilenameWithoutExtension(FilePathName_Exe) + '.CLU';
end;

Procedure TConsoleLocationUserHelper.SetFilename(Const aFilename:String);
begin
  AlternateConsoleLocationUserFilename := aFilename;
end;

Function  TConsoleLocationUserHelper.LoadFromFile : Boolean;
Var aFile : tFile;
begin
  Result := False;
  Init;
  if (PlyFileExists(Filename)) then
  begin
    if (aFile.Open(Filename,Sizeof(Self))) then
    begin
      Result := aFile.DosRead(Self);
      aFile.Close;
    end;
  end;
end;

Function  TConsoleLocationUserHelper.SaveToFile : Boolean;
Var aFile : tFile;
begin
  Result := False;
  if (aFile.Open(Filename,Sizeof(Self))) then
  begin
    Result := aFile.DosWrite(Self);
    aFile.Close;
  end;
end;

Function  ConsoleLocationMoveComputer : Boolean;
Var ConsoleLocationComputer : tConsoleLocationComputer;
begin
  Result := False;
  if (ConsoleLocationComputer.LoadFromFile) then
  begin
    if (ConsoleLocationComputer.Valid) then
    begin
      // Change ConsolenFont to the saved value
      Console.Font.SetCurrentFont(ConsoleLocationComputer.ConsoleLocation.Font);
      // move console-window to saved position
      Console.Desktop.Position := ConsoleLocationComputer.ConsoleLocation.Position;
      // autofit position on this screen
      ConsoleLocationComputer.ConsoleLocation.AutofitPosition;
      Result := True;
      Exit;
    end;
  end;
  if (ConsoleLocationComputer.LoadFromRegistry) then
  begin
    if (ConsoleLocationComputer.Valid) then
    begin
      // Change ConsolenFont to the saved value
      Console.Font.SetCurrentFont(ConsoleLocationComputer.ConsoleLocation.Font);
      // move console-window to saved position
      Console.Desktop.Position := ConsoleLocationComputer.ConsoleLocation.Position;
      // autofit position on this screen
      ConsoleLocationComputer.ConsoleLocation.AutofitPosition;
      Result := True;
    end;
  end;
end;

Procedure ConsoleLocationMoveUser(Index:Integer; SetDefault:Boolean=True);
Var ConsoleLocationUser      : tConsoleLocationUser;
begin
  if (Index>=0) and (Index<=9) then
  begin
    if (ConsoleLocationUser.LoadFromFile) then
    begin
      if (ConsoleLocationUser.Valid(Index)) then
      begin
        // Change ConsolenFont to the saved value
        Console.Font.SetCurrentFont(ConsoleLocationUser.ConsoleLocation[Index].Font);
        // move console-window to saved position
        Console.Desktop.Position := ConsoleLocationUser.Position[Index];
        // autofit position if out of bounds
        ConsoleLocationUser.ConsoleLocation[Index].AutofitPosition;
        Exit;
      end;
    end;
    if (ConsoleLocationUser.LoadFromRegistry(Index)) then
    begin
      if (ConsoleLocationUser.Valid(Index)) then
      begin
        // Change ConsolenFont to the saved value
        Console.Font.SetCurrentFont(ConsoleLocationUser.ConsoleLocation[Index].Font);
        // move console-window to saved position
        Console.Desktop.Position := ConsoleLocationUser.Position[Index];
        // autofit position if out of bounds
        ConsoleLocationUser.ConsoleLocation[Index].AutofitPosition;
        Exit;
      end;
    end;
    // If no user settings could be loaded, set font to default & don't move window
    if (SetDefault) then
    begin
      // Change ConsolenFont to default value
      Console.Font.SetDefault;
      // autofit position if out of bounds
      Console.AutofitPosition;
    end;
  end;
end;

Procedure ConsoleLocationSaveUser(Index:Integer);
Var UserConsolePosition      : tConsoleLocationUser;
begin
  if (Index>=0) and (Index<=9) then
  begin
    UserConsolePosition.LoadFromFile;
    UserConsolePosition.TakeCurrentSettings(Index);
    if (UserConsolePosition.SaveToFile) then
    begin
      Exit;
    end;
    UserConsolePosition.TakeCurrentSettings(Index);
    UserConsolePosition.SaveToRegistry(Index);
  end;
end;

Procedure ConsoleLocationMoveDefault;
begin
  // If a computer-specific setting is specified, then move console.window to
  // this position and use this font size.
  if not(ConsoleLocationMoveComputer) then
  begin
    // If no computer-specific settings are available, then check whether
    // user-specific settings are available and, if so, use them
    begin
      ConsoleLocationMoveUser(0,False);
    end;
  end;
end;

(************************)
(***** tFrameWindow *****)
(************************)
function tFrameWindow.GetClrBackground: Boolean;
begin
  Result := Hi(FBackground)>0;
end;

function tFrameWindow.GetColorBackground: Byte;
begin
  Result := Lo(FBackground);
end;

function tFrameWindow.GetFrameTextBackground: Byte;
begin
  Result := FFrameAttr.Textbackground;
end;

function tFrameWindow.GetFrameTextcolor: Byte;
begin
  Result := FFrameAttr.Textcolor;
end;

function tFrameWindow.GetTextBackground: Byte;
begin
  Result := FTextAttr.Textbackground;
end;

function tFrameWindow.GetTextColor: Byte;
begin
  Result := FTextAttr.Textcolor;
end;

procedure tFrameWindow.SetClrBackground(const Value: Boolean);
begin
  if (Value) then FBackground := $0100 or Lo(FBackground)
             else FBackground := $0000 or Lo(FBackground);
end;

procedure tFrameWindow.SetColorBackground(const Value: Byte);
begin
  FBackground := (Hi(FBackground) shl 8) + Value;
end;

procedure tFrameWindow.SetFrameTextBackground(const Value: Byte);
begin
  FFrameAttr.Textbackground := Value;
end;

procedure tFrameWindow.SetFrameTextColor(const Value: Byte);
begin
  FFrameAttr.Textcolor := Value;
end;

procedure tFrameWindow.SetTextBackground(const Value: Byte);
begin
  FTextAttr.Textbackground := Value;
end;

procedure tFrameWindow.SetTextColor(const Value: Byte);
begin
  FTextAttr.Textcolor := Value;
end;

class operator tFrameWindow.Initialize (out aFrameWindow: tFrameWindow);
begin
  aFrameWindow.ClearSettings;
end;

Procedure tFrameWindow.ClearSettings;
begin
  FFrameAttr.Color(Yellow,Blue);
  FTextAttr.Color(LightGray,Black);
  // FBackground: Hi=ClrBackground=False, Lo=ColorBackground=Black
  FBackground := $0000;
  FTextTopLeft := '';
  FTextTitle := '';
  FTextTopRight := '';
  FTextBottomLeft := '';
end;

function tFrameWindow.FrameTextTop: String;
Var MaxLen : Integer;
    TextLeft : String;
    TextCenter : String;
    TextRight : String;
    i : integer;
begin
  MaxLen := (MaxX-2);

  if (TextTopLeft<>'')
     then TextLeft := WideChar(_Frame_double_vert_left)
                    + TextTopLeft
                    + WideChar(_Frame_double_vert_right)
     else TextLeft := '';

  if (TextTitle<>'')
     then TextCenter := ' ' + TextTitle + ' '
     else TextTitle  := WideChar(_Frame_double_hori);

  if (TextTopRight<>'')
     then TextRight := WideChar(_Frame_double_vert_left)
                     + TextTopRight
                     + WideChar(_Frame_double_vert_right)
     else TextRight := '';

  // if text to long, then omit TextRight
  if (Length(TextLeft+TextCenter+TextRight) > MaxLen) then TextRight := '';
  // if text still to long, then omit TextLeft
  if (Length(TextLeft+TextCenter+TextRight) > MaxLen) then TextLeft := '';
  // If still too long, then shorten TextCenter
  if (Length(TextCenter) > MaxLen)
     then TextCenter := Copy(TextCenter,1,MaxLen-1) + ' ';

  // Extend with frame-elements to MaxLen
  For i := 1 to ((MaxLen-Length(TextLeft+TextCenter+TextRight)) div 2) do
  begin
    TextCenter := WideChar(_Frame_double_hori)
                + TextCenter
                + WideChar(_Frame_double_hori);
  end;
  if (Length(TextLeft+TextCenter+TextRight) < MaxLen)
     then TextCenter := TextCenter + WideChar(_Frame_double_hori);

  Result := TextLeft + TextCenter + TextRight;
end;

function tFrameWindow.FrameTextBottom: String;
Var MaxLen : Integer;
    TextLeft : String;
    TextRight : String;
    i : Integer;
begin
  MaxLen := (MaxX-2);

  if (FTextBottomLeft<>'')
     then TextLeft := WideChar(_Frame_double_vert_left)
                    + FTextBottomLeft
                    + WideChar(_Frame_double_vert_right)
     else TextLeft := '';

  if (FTextBottomRight<>'')
     then TextRight := WideChar(_Frame_double_vert_left)
                     + FTextBottomRight
                     + WideChar(_Frame_double_vert_right)
     else TextRight := '';

  // if (TextLeft+TextRight) to long, then omit TextRight
  if (Length(TextLeft+TextRight) > MaxLen) then TextRight := '';
  // If still too long, then shorten TextCenter
  if (Length(TextLeft) > MaxLen)
     then TextLeft := Copy(TextLeft,1,MaxLen-1)
                    + WideChar(_Frame_double_vert_right);

  // Extend with frame-elements to MaxLen
  for i := 1 to (MaxLen-Length(TextRight+TextLeft)) do
  begin
    TextLeft := TextLeft + WideChar(_Frame_double_hori);
  end;

  Result := TextLeft + TextRight;
end;

Procedure tFrameWindow.Window(Const Title:String);
begin
  TextTitle := Title;
  Window;
end;

Procedure tFrameWindow.Window(Const Title,BottomLeft:String);
begin
  TextTitle := Title;
  TextBottomLeft := BottomLeft;
  Window;
end;

procedure tFrameWindow.Window(Left, Top, Right, Bottom: Integer);
Var ConsoleScreenBuffer:TConsoleScreenBuffer;
    i : Integer;
begin
  // Check range / adjust to valid values
  Left   := ValueMinMax(Left  ,1     ,Console.WindowSize.X-3);
  Top    := ValueMinMax(Top   ,1     ,Console.WindowSize.y-2);
  Right  := ValueMinMax(Right ,Left+3,Console.WindowSize.x);
  Bottom := ValueMinMax(Bottom,Top+2 ,Console.WindowSize.y);

  // If background should be deleted
  if (ClrBackground) and (ColorBackground<=LightGray) then
  begin
    Crt.Window(1,1,Console.WindowSize.X,Console.WindowSize.Y);
    Crt.Textbackground(ColorBackground);
    ClrScr;
  end;

  // Create shadow when window smaller max
  if ((Right<Console.WindowSize.X-2) or (Bottom<Console.WindowSize.Y-2)) then
  begin
    Crt.Color(DarkGray,Black);
    // Shadow at the bottom
    ReadConsoleRectangular(Left+2,Bottom+1,(Right-Left),1,ConsoleScreenBuffer);
    for I := 0 to length(ConsoleScreenBuffer)-1 do
    begin
      ConsoleScreenBuffer[i].Attributes := Crt.TextAttr;
    end;
    WriteConsoleRectangular(Left+2,Bottom+1,(Right-Left),1,ConsoleScreenBuffer);
    // Shadow on the right side
    ReadConsoleRectangular(Right+1,Top+1,1,(Bottom-Top),ConsoleScreenBuffer);
    for I := 0 to length(ConsoleScreenBuffer)-1 do
    begin
      ConsoleScreenBuffer[i].Attributes := Crt.TextAttr;
    end;
    WriteConsoleRectangular(Right+1,Top+1,1,(Bottom-Top),ConsoleScreenBuffer);

    // Crt.Window(Right+1,Top+1,Right+2,Bottom);
    // Clrscr;
  end;

  // Create Frame
  Crt.Window(Left,Top,Right,Bottom);
  // Frame corners
  Crt.Color(FrameTextColor,FrameTextBackground);
  WriteChar(1             ,1             ,_Frame_double_corner_tl);
  WriteChar(1+(Right-Left),1             ,_Frame_double_corner_tr);
  WriteChar(1             ,(Bottom-Top+1),_Frame_double_corner_bl);
  WriteChar(1+(Right-Left),(Bottom-Top+1),_Frame_double_corner_br);
  // Frame Left & Right
  FillConsoleRectangular(Left ,Top+1,1,Bottom-Top-1,_Frame_double_vert);
  FillConsoleRectangular(Right,Top+1,1,Bottom-Top-1,_Frame_double_vert);

  // Frame & Text top
  WriteString(2,1,FrameTextTop);

  // Frame & Text bottom
  WriteString(2,1+(Bottom-Top),FrameTextBottom);

  // Create inner window / workspace
  Crt.Window(Left+1,Top+1,Right-1,Bottom-1);
  Crt.Color(Textcolor,TextBackground);
  clrscr;
end;

Procedure tFrameWindow.Window(Left, Top, Right, Bottom: Integer;
            Title:String; BottomLeft:String='');
begin
  if (Title<>'')      then TextTitle := Title;
  if (BottomLeft<>'') then TextBottomLeft := BottomLeft;
  Window(Left, Top, Right, Bottom);
end;

Procedure tFrameWindow.Window;
begin
  ClrBackground := False;
  Window(1,1,Console.WindowSize.x,Console.WindowSize.y);
end;

Procedure Window(X1, Y1, X2, Y2: Integer; Title:String; FrameAttr:TTextAttr;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String='');
Var FWindow : TFrameWindow;
begin
  FWindow.TextTitle       := Title;
  FWindow.FrameAttr       := FrameAttr;
  FWindow.TextBottomLeft  := TextBottomLeft;
  FWindow.TextBottomRight := TextBottomRight;
  FWindow.TextTopLeft     := TextTopLeft;
  FWindow.TextTopRight    := TextTopRight;
  FWindow.Window(X1, Y1, X2, Y2);
end;

Procedure Window(X1, Y1, X2, Y2: Integer; Title:String;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String='');
Var FWindow : TFrameWindow;
begin
  FWindow.TextTitle       := Title;
  FWindow.FrameAttr       := TextAttrFrameDefault;
  FWindow.TextBottomLeft  := TextBottomLeft;
  FWindow.TextBottomRight := TextBottomRight;
  FWindow.TextTopLeft     := TextTopLeft;
  FWindow.TextTopRight    := TextTopRight;
  FWindow.Window(X1, Y1, X2, Y2);
end;

Procedure Window(Title:String; FrameAttr:TTextAttr;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String=''); Overload;
begin
  Window(1, 1, Console.WindowSize.x, Console.WindowSize.y, Title
    ,FrameAttr,TextBottomLeft,TextBottomRight,TextTopLeft,TextTopRight);
end;

Procedure Window(Title:String;
            TextBottomLeft:String=''; TextBottomRight:String='';
            TextTopLeft:String=''; TextTopRight:String=''); Overload;
begin
  Window(1, 1, Console.WindowSize.x, Console.WindowSize.y, Title
    ,TextBottomLeft,TextBottomRight,TextTopLeft,TextTopRight);
end;

Procedure WriteRight(y:Smallint; aString:String);
Var PosX : Integer;
begin
  PosX := ValueMinMax((MaxX-length(aString)+1),1,MaxX);
  WriteXY(PosX,y,aString);
end;

Procedure CursorMoveField(Var FieldNumber:Integer; MinNum:Integer=0; MaxNum:Integer=99);
begin
  if (LastKey=_Return) or (LastKey=_PgDown) or
     (LastKey=_Down)   or (LastKey=_TAB)    Then
  begin
    if (FieldNumber<MaxNum) then inc(FieldNumber);
  end else
  if (LastKey=_PgUp)   or (LastKey=_Up)     or
     (LastKey=_SHIFT_Tab)                   Then
  begin
    if (FieldNumber>MinNum) then dec(FieldNumber);
  end;
  FieldNumber := ValueMinMax(FieldNumber,MinNum,MaxNum);
end;

Function  InputString(iString:String; iLength,StrLength:Integer; TColor,BColor:Byte;
            Var Key:Word; ShowX:Integer=0; ShowY:Integer=0) : String; Overload
Var wch                      : WideChar;
    b                        : Integer;
    cx                       : Integer;
    dx,dy                    : Integer;
    SaveString               : String;
    SaveTextAttr             : TTextAttr;
    InpCursorPos1            : Boolean;
    InpExitOnKey             : Boolean;
    InpClrIfKey              : Boolean;
    InpPassword              : Boolean;
    InpInsertMode            : Boolean;
    InpDate                  : Boolean;
    FromPos                  : Integer;

  Procedure EmbeddedOutput;
  Var l                        : Integer;
      AText                    : String;
  begin
    gotoxy(dx,dy);
    AText := Copy(iString,FromPos,iLength);
    if (InpPassword) then
    begin
      Textcolor(TColor+1);
      For l := 1 to length(AText) do
      begin
        AText[l] := '*';
      end;
      Write(StringAlignLeft(iLength,AText));
      Color(TColor,BColor);
    end else
    begin
      WriteXY(dx,dy,StringAlignLeft(iLength,AText));
    end;
    if (FromPos>1) then
    begin
      WriteXY(dx,dy,WideChar($25C4));
    end;
    if (Length(iString)-FromPos-iLength+1>0) then
    begin
      WriteXY(dx+iLength,dy,WideChar($25BA));
    end else
    begin
      if (StrLength>iLength) then
      begin
        Color(TColor,BColor);
        WriteXY(dx+iLength,dy,' ');
      end;
    end;
    if (ShowX>0) and (ShowY>0) then
    begin
      TextAttr := GetTextAttr(ShowX,ShowY);
      WriteXY(ShowX,ShowY,IntToString(FromPos+cx,3)+'|'+IntToString(Length(iString),3)+': ');
      WriteString(iString); ClrEol;
      Color(TColor,BColor);
    end;
    gotoxy(dx+cx,dy);
  end;

begin
  SaveTextAttr  := TextAttr;
  SaveString    := iString;
  dx            := wherex;
  dy            := wherey;
  iLength       := Min(MaxX-dx-0,iLength);
  cx            := Min(Length(iString),iLength);
  FromPos       := Max(Length(iString)-iLength+1,1);
  iString       := Copy(iString,1,StrLength);

  InpCursorPos1 := (Key and _Inp_CursorPos1) = _Inp_CursorPos1;
  InpExitOnKey  := (Key and _Inp_ExitOnKey ) = _Inp_ExitOnKey;
  InpClrIfKey   := (Key and _Inp_ClrIfKey  ) = _Inp_ClrIfKey;
  InpInsertMode := (Key and _Inp_InsertMode) = _Inp_InsertMode;
  InpPassword   := (Key and _Inp_Password  ) = _Inp_Password;
  InpDate       := (Key and _Inp_Date      ) = _Inp_Date;

  Console.Modes.InsertMode := InpInsertMode;
  if (InpInsertMode) then Console.CursorOnBigSize
                     else Console.CursorOnNormalSize;

  // Set the cursor to the beginning of the input field
  if (InpCursorPos1) or (InpClrIfKey) then
  begin
    cx      := 0;
    FromPos := 1;
  end;

  Color(TColor,BColor);
  EmbeddedOutput;

  repeat
    wch := ReadkeyW(Key);

    if (InpClrIfKey) and not(CharIsControlCharacter(wch)) then
    begin
      // Clear iString if first key is normal input / not a movement key
      if (Key<>_Return) and (Key<>_Tab)  and (Key<>_PgDown) and
         (Key<>_PgUp)   and (Key<>_Down) and (Key<>_Up)     then
      begin
        iString := '';
      end;
      InpClrIfKey := False;
    end;

    // Copy to clipboard
    if (Key=_CTRL_C) then
    begin
      Clipboard.AsText := iString;
      Key       := _Pos1; (* Do not Exit *)
    end else
    // Insert from clipboard
    if (Key=_CTRL_V) then
    begin
      iString := Copy(Clipboard.AsText,1,StrLength);
      cx      := 0;     (* Cursor Pos1 *)
      FromPos := 1;
      Key     := _Pos1; (* Do not Exit *)
    end else
    // cut out to clipboard
    if (Key=_CTRL_X) then
    begin
      Clipboard.AsText := iString;
      iString := '';
      cx          := 0;     (* Cursor Pos1 *)
      FromPos     := 1;
      Key         := _Pos1; (* Do not Exit *)
    end else
    if (Key=_CTRL_Left) then
    begin
      b := Max(1,Min(FromPos+cx-1,StrLength));
      While (b>1) and (iString[b]=' ')  do dec(b);
      While (b>1) and (iString[b]<>' ') do dec(b);
      if (b<FromPos+2) then FromPos := Max(1,b-2);
      cx := b-FromPos;
      if (iString[FromPos+cx]=' ') then cx := cx + 1;
    end else
    if (Key=_CTRL_Right) then
    begin
      b := Max(1,Min(FromPos+cx+1,length(iString)));
      While (b<length(iString)) and (iString[b]<>' ') do inc(b);
      While (b<length(iString)) and (iString[b]=' ')  do inc(b);
      if (b+2>FromPos+iLength) then
      begin
        FromPos := Min(Length(iString)-iLength+1,Max(1,b-iLength+2));
      end;
      cx := b-FromPos;
      if (iString[FromPos+cx]=' ') then cx := cx + 1;
    end else
    if (Key=_Right) then
    begin
      if (cx<iLength) then
      begin
        inc(cx);
        if (cx>Length(iString)) then
        begin
          iString := iString + ' ';
        end;
      end else
      if (FromPos+iLength<=Length(iString)) then inc(FromPos);
    end else
    if (Key=_Left) then
    begin
      if (cx>1)     then dec(cx)     else
      if (FromPos>1) then dec(FromPos) else
      if (cx>0)     then dec(cx);
    end else
    if (Key=_Pos1) then
    begin
      cx     := 0;
      FromPos := 1;
    end else
    if (Key=_End) then
    begin
      cx      := Min(Length(iString),iLength-1);
      FromPos := Max(1,Length(iString)-iLength+2);
    end else
    if (Key=_Insert) then
    begin
      InpInsertMode := not(InpInsertMode);
      Console.Modes.InsertMode := InpInsertMode;
      if (InpInsertMode) then Console.CursorOnBigSize
                         else Console.CursorOnNormalSize;
    end else
    if (Key=_CRT_Delete) then
    begin
      if (FromPos+cx<=Length(iString)) then
      begin
        Delete(iString,FromPos+cx,1);
      end;
    end else
    if (Key=_BackSpace) then
    begin
      if (FromPos+cx>1) then
      begin
        Delete(iString,FromPos+cx-1,1);
        if (cx>5)     then dec(cx)     else
        if (FromPos>1) then dec(FromPos) else
        if (cx>0)     then dec(cx);
      end;
    end else
    begin
      // if Date-Input, do not accept  (+|-) as input text, but return as value (key) to the calling function
      if not(InpDate) or ((Key<>_Plus) and (Key<>_Minus)) then
      begin
        if ((Key<_F1)         or  (Key>_F12))        and
           ((Key<_CTRL_F1)    or  (Key>_CTRL_F12))   and
           ((Key<_ALT_F1)     or  (Key>_ALT_F12))    and
           (Key<>_CTRL_Plus)  and (Key<>_CTRL_Minus) and
           (Key<>_ALT_Plus)   and (Key<>_ALT_Minus)  and
           ((Key<_CTRL_A)     or  (Key>_CTRL_Z))     and
           ((Key<_ALT_A)      or  (Key>_ALT_Z))      and
           ((Key<_CTRL_0)     or  (Key>_CTRL_9))     and
           ((Key<_ALT_0)      or  (Key>_ALT_9))      then
        begin
          if (Key<>_ESC)   and (Key<>_Tab)    and (Key<>_Return)      and
             (Key<>_PgUp)  and (Key<>_PgDown) and (Key<>_CTRL_Return) and
             (Key<>_Up)    and (Key<>_Down)   then
          begin
            if not(CharIsControlCharacter(wch)) then
            begin
              if (length(iString)>=FromPos+cx) then
              begin
                if (InpInsertMode) then
                begin
                  if (Length(iString)<StrLength) then
                  begin
                    insert(' ',iString,FromPos+cx);
                    iString[FromPos+cx] := wch;
                    if (cx<iLength) then inc(cx)
                                        else inc(FromPos);
                  end;
                end else
                begin
                  iString[FromPos+cx] := wch;
                  if (cx<iLength) then inc(cx)
                                      else inc(FromPos);
                end;
              end else
              if (length(iString)<StrLength) then
              begin
                iString := iString + wch;
                if (cx<iLength-1) then inc(cx)
                                      else inc(FromPos);
              end;
            end;
          end;
        end;
      end;
    end;
    EmbeddedOutput;
  until((Key=_Return)    or (Key=_Tab)         or (Key=_SHIFT_Tab) or (Key=_Escape)   or
        (Key=_Up)        or (Key=_Down)        or (Key=_PgUp)      or (Key=_PgDown)   or
        (Key=_CTRL_PgUp) or (Key=_CTRL_PgDown) or
        (Key=_CTRL_Up)   or (Key=_CTRL_Down)   or
        (Key=_CTRL_Plus) or (Key=_CTRL_Minus)  or
        (Key=_ALT_Plus)  or (Key=_ALT_Minus)   or
        ((InpExitOnKey) and (Key<>_Pos1) and (Key<>_End) and (Key<>_Left) and (Key<>_Right)) or
        ((Key>=_F1)         and (Key<=_F12))        or
        ((Key>=_Shift_F1)   and (Key<=_Shift_F12))  or
        ((Key>=_CTRL_F1)    and (Key<=_CTRL_F12))   or
        ((Key>=_CTRL_A)     and (Key<=_CTRL_Z))     or
        ((Key>=_Alt_F1)     and (Key<=_Alt_F12))    or
        ((Key>=_Alt_A)      and (Key<=_Alt_Z))      or
        ((Key>=_CTRL_0)     and (Key<=_CTRL_9))     or
        ((Key>=_Alt_0)      and (Key<=_Alt_9)));
  if (Key=_ESC) Then iString := SaveString;
  Result := StringDeleteControlCharacter(iString.TrimRight);
  Console.CursorOnNormalSize;
  TextAttr  := SaveTextAttr;
end;

Function  InputString(x,y:Integer; iString:String; iLength,StrLength:Integer;
            TColor,BColor:Byte; Var Key:Word; ShowX:Integer=0; ShowY:Integer=0) : String; Overload
begin
  GotoXY(x,y);
  Result := InputString(iString,iLength,StrLength,TColor,BColor,Key,ShowX,ShowY);
end;

Function  InputString(iString:String; iLength:Integer; TColor,BColor:Byte; var Key:Word) : String;
begin
  Result := InputString(iString,iLength,iLength,TColor,BColor,Key);
end;

Function  InputString(x,y:Integer; iString:String; iLength:Integer; TColor,BColor:Byte; var Key:Word) : String;
begin
  GotoXY(x,y);
  Result := InputString(iString,iLength,TColor,BColor,Key);
end;

Function  InputString(iString:String; iLength:Integer; var Key:Word) : String;
begin
  Result := InputString(iString,iLength,Black,LightGray,Key);
end;

Function  InputString(x,y:Integer; iString:String; iLength:Integer; var Key:Word) : String;
begin
  GotoXY(x,y);
  Result := InputString(iString,iLength,Key);
end;

Function  InputString(iString:String; iLength:Integer; StrLength:Integer=-1) : String;
Var Key : Word;
begin
  if (StrLength=-1)
     then Result := InputString(iString,iLength,Key)
     else Result := InputString(iString,iLength,StrLength,Black,Lightgray,Key);
end;

Function  InputString(x,y:Integer; iString:String; iLength:Integer; StrLength:Integer=-1) : String;
begin
  GotoXY(x,y);
  Result := InputString(iString,iLength,StrLength);
end;

Function  InputDouble(iDouble:Double; iLength:Integer; Var Key:Word) : Double;
begin
  Result := StringToDouble(InputString(DoubleToString(iDouble),iLength,Key));
end;

Function  InputDouble(iDouble:Double; iLength:Integer; Var Key:Word; Width:Integer;
            Comma:Byte=2; DecimalSeparator:WideChar='.';
            ThousandSeparator:WideChar='?') : Double; Overload;
begin
  Result := StringToDouble(InputString(DoubleToString(iDouble,Width,Comma
              ,DecimalSeparator,ThousandSeparator),iLength,Key),ThousandSeparator);
end;

Function  InputInteger(iInteger:Integer; iLength:Integer; Var Key:Word) : Integer;
Var DoubleResult : Double;
begin
  // Convert via double, to process arithmetic operations
  DoubleResult := StringToDouble(InputString(iInteger.ToString,iLength,Key));
  if (DoubleResult>=Integer.MinValue) and
     (DoubleResult<=Integer.MaxValue) then Result := Round(DoubleResult)
                                      else Result := 0;
end;

Function  InputInteger(iInteger:Int64; iLength:Integer; Var Key:Word) : Int64;
Var DoubleResult : Double;
begin
  // Convert via double, to process arithmetic operations
  DoubleResult := StringToDouble(InputString(iInteger.ToString,iLength,Key));
  if (DoubleResult>=Integer.MinValue) and
     (DoubleResult<=Integer.MaxValue) then Result := Round(DoubleResult)
                                      else Result := 0;
end;

Function  LineSelectExit(FromY,ToY,FromX,ToX:Integer; var CurrentY:Integer) : Word;
Var Key : Word;
begin
  CurrentY := ValueMinMax(CurrentY,FromY,ToY);
  InvertString(FromX,CurrentY,(ToX-FromX+1));
  gotoxy(1,CurrentY);
  Readkey(Key);
  InvertString(FromX,CurrentY,(ToX-FromX+1));
  if (Key=_Pos1) then CurrentY := FromY  else
  if (Key=_End ) then CurrentY := ToY    else
  if (Key=_Up  ) then
  begin
    if (CurrentY>FromY) then dec(CurrentY);
  end else
  if (Key=_Down) then
  begin
    if (CurrentY<ToY) then inc(CurrentY);
  end;
  Result := Key;
end;

Function  LineSelectExit(FromY,ToY:Integer; var CurrentY:Integer) : Word;
begin
  Result := LineSelectExit(FromY,ToY,1,MaxX,CurrentY);
end;

Function  LineSelect(FromY,ToY,FromX,ToX:Integer; var CurrentY:Integer) : Word;
Var Key                      : Word;
    ExitFunc                 : Boolean;
begin
  ExitFunc := False;
  if (CurrentY>ToY)   then CurrentY := ToY;
  if (CurrentY<FromY) then CurrentY := FromY;
  Repeat
    InvertString(FromX,CurrentY,(ToX-FromX+1));
    gotoxy(FromX,CurrentY);
    Readkey(Key);
    InvertString(FromX,CurrentY,(ToX-FromX+1));
    if (Key=_Pos1) then CurrentY := FromY  else
    if (Key=_End ) then CurrentY := ToY    else
    if (Key=_Up  ) then
    begin
      if (CurrentY>FromY) then dec(CurrentY)
                          else ExitFunc := True;
    end else
    if (Key=_Down) then
    begin
      if (CurrentY<ToY) then inc(CurrentY)
                        else ExitFunc := True;
    end;
  Until (Key=_ESC)          or (Key=_Return)        or
        (Key=_Space)        or (Key=_TAB)           or
        (Key=_Insert)       or (Key=_ALT_Insert)    or
        (Key=_CRT_Delete)       or (Key=_ALT_Delete)    or
        (Key=_BackSpace)    or
        (Key=_PgDown)       or (Key=_PgUp)          or
        (Key=_CTRL_Down)    or (Key=_CTRL_Up)       or
        (Key=_CTRL_PgDown)  or (Key=_CTRL_PgUp)     or
        (Key=_CTRL_Pos1)    or (Key=_CTRL_End)      or
        (Key=_CTRL_Minus)   or (Key=_CTRL_Plus)     or
        (Key=_Plus)         or (Key=_Minus)         or
        (Key=_ALT_Plus)     or (Key=_Alt_Minus)     or
        (Key=_Questionmark) or (Key=_SS)            or
        (Key=_AE)           or (Key=_OE)            or
        (Key=_UE)           or
        ((Key>=_A     )   and (Key<=_Z        )) or
        ((Key>=_CTRL_A)   and (Key<=_CTRL_Z   )) or
        ((Key>=_F1    )   and (Key<=_F12      )) or
        ((Key>=_ALT_F1)   and (Key<=_Alt_F12  )) or
        ((Key>=_Shift_F1) and (Key<=_Shift_F12)) or
        ((Key>=_CTRL_F1)  and (Key<=_CTRL_F12 )) or
        ((Key>=_ALT_A)    and (Key<=_Alt_Z    )) or
        ((Key>=_0     )   and (Key<=_9        )) or
        ((Key>=_Alt_0 )   and (Key<=_Alt_9    )) or
        (ExitFunc);
  Result := Key;
end;

Function  LineSelect(FromY,ToY:Integer; var CurrentY:Integer) : Word;
begin
  Result := LineSelect(FromY,ToY,1,MaxX,CurrentY);
end;

Function  CodepageSelect(Const Codepage:Cardinal; CP_Source:Cardinal=1) : Cardinal;
Var CodePageList             : TStrings;
    CP_SelectItem            : tSelectItems;
    CP_Number                : Longint;
    i                        : Integer;
    Key                      : Word;
begin
  Result := Codepage;
  CodePageList := TStringList.Create;
  if (TWindowsCodepages.GetSupported(CodePageList)) then
  begin
    if (CodePageList.Count>0) then
    begin
      CP_SelectItem.Init;
      For i := 0 to CodePageList.Count-1 do
      begin
        CP_Number := StringToInteger(Copy(CodePageList.Strings[i],1,5));
        CP_SelectItem.AddItem(CP_Number,Copy(CodePageList.Strings[i],8,200)
          ,IntToString(CP_Number,5),CP_Number
           // Color: Use 4 colors in alternation
          ,(i mod 4)+7);
      end;
      CP_SelectItem.Sort(FPosUp);
      CP_Number := Console.OutputCodepage;
      if (CP_SelectItem.Select(5,3,80,27,'Select Codepage','','',CP_Number,Key)) then
      begin
        if IsValidCodePage(CP_Number) then
        begin
          Result := CP_Number;
        end;
      end;
      Key := _ALT_C;
      CP_SelectItem.Done;
    end;
  end;
  CodePageList.Free;
end;

Function  CodepageSelectInstalled(Const Codepage:Cardinal) : Cardinal;
begin
  Result := CodepageSelect(Codepage,CP_INSTALLED);
end;

Function  CodepageSelectSupported(Const Codepage:Cardinal) : Cardinal;
begin
  Result := CodepageSelect(Codepage,CP_SUPPORTED);
end;

(***********************)
(***** tSelectItem *****)
(***********************)
procedure tSelectItem.Clear;
begin
  FPos      := -1;
  NameLong  := '';
  NameShort := '';
  SortValue := 0;
end;

Function  tSelectItem.IsClear : Boolean;
begin
  Result := (NameLong='') and (NameShort='');
end;

Function    tSelectItem.SearchName(Short:Boolean) : String;
begin
  if (Short) then Result := NameShort.ToUpper
             else Result := NameLong.ToUpper;
end;

Function    tSelectItem.TextSelection(LenShort,LenTotal:Integer) : String;
begin
  Result := '';
  if (LenShort>0) then
  begin
    Result := StringAlignLeft(LenShort,NameShort,' ',True) + ' : ';
  end;
  Result := Copy(Result + NameLong,1,LenTotal);
end;

Procedure   tSelectItem.WriteSelection(y:Integer; LenShort:Integer);
begin
  if (LenShort>0) then
  begin
    WriteXY(1,y,NameShort.StringCopy(1,LenShort));
    WriteXY(LenShort+1,y,NameShort.GetChar(1).Attr,' : ');
    WriteXY(LenShort+4,y,NameLong.StringAlignLeft(MaxX-LenShort-3));
  end else
  begin
    WriteXY(1,y,NameLong.StringAlignLeft(MaxX-1));
  end;
end;

(************************)
(***** tSelectItems *****)
(************************)
Function  tSelectItems.GetItemByIndex(Index:Integer) : tSelectItem;
begin
  if (Index>=0) and (Index<=High(Items))
     then Result := Items[Index]
     else Result.Clear;
end;

Function  tSelectItems.GetItemByName(Const sName:String) : tSelectItem;
Var Index : Integer;
begin
  Index := GetIndexByNameShort(sName);
  if (Index>=0) and (Index<=High(Items)) then
  begin
    Result := GetItemByIndex(Index);
    Exit;
  end;
  Index := GetIndexByNameLong(sName);
  if (Index>=0) and (Index<=High(Items)) then
  begin
    Result := GetItemByIndex(Index);
    Exit;
  end;
  Result.Clear;
end;

Procedure tSelectItems.SetItemByIndex(Index:Integer; Value:tSelectItem);
begin
  if (Index>=0) and (Index<=High(Items)) then
  begin
    Items[Index] := Value;
  end;
end;

Procedure tSelectItems.Init;
begin
  SetLength(Items,0);
  FExitOnPgKey          := False;
  FExitOnNumber         := False;
  FSortExtern           := False;
  FHelpTextNumber       := -1;
  FLastSort             := LongDown;
end;

Procedure tSelectItems.Done;
begin
  SetLength(Items,0);
end;

Function  tSelectItems.AddItem(eFPos:Integer; eNameLong:String;
            eNameShort:String=''; eColor:Byte=LightGray) : Boolean;
Var NewItem : tSelectItem;
begin
  Try
    NewItem.FPos      := eFPos;
    NewItem.SortValue := eFPos;
    NewItem.NameLong.Init(eNameLong,eColor);
    NewItem.NameShort.Init(eNameShort,eColor);
    TAppender<TSelectItem>.Append(Items,NewItem);
    Result := True;
  Except
    Result := False;
  End;
end;

Function  tSelectItems.AddItem(eFPos:Integer; eNameLong,eNameShort:String;
            eSortValue:TSortValue; eColor:Byte=LightGray) : Boolean;
Var NewItem : tSelectItem;
begin
  Try
    NewItem.FPos      := eFPos;
    NewItem.SortValue := eSortValue;
    NewItem.NameLong.Init(eNameLong,eColor);
    NewItem.NameShort.Init(eNameShort,eColor);
    TAppender<TSelectItem>.Append(Items,NewItem);
    Result := True;
  Except
    Result := False;
  End;
end;

Function  tSelectItems.AddItem(eFPos:Longint; eNameLong:TConsoleString) : Boolean;
Var NewItem : tSelectItem;
begin
  Try
    NewItem.FPos      := eFPos;
    NewItem.SortValue := eFPos;
    NewItem.NameLong  := eNameLong;
    NewItem.NameShort := '';
    TAppender<TSelectItem>.Append(Items,NewItem);
    Result := True;
  Except
    Result := False;
  End;
end;

Function  tSelectItems.AddItem(eFPos:Longint; eNameLong,eNameShort:TConsoleString;
            eSortValue:tSortValue) : Boolean;
Var NewItem : tSelectItem;
begin
  Try
    NewItem.FPos      := eFPos;
    NewItem.SortValue := eSortValue;
    NewItem.NameLong  := eNameLong;
    NewItem.NameShort := eNameShort;
    TAppender<TSelectItem>.Append(Items,NewItem);
    Result := True;
  Except
    Result := False;
  End;
end;

Procedure   tSelectItems.DeleteItem(eFPos:Integer);
Var i : Integer;
begin
  for I := High(Items) downto 0 do
  begin
    if (Items[i].FPos=eFPos) then
    begin
      System.Delete(Items,i,1);
    end;
  end;
end;

Procedure   tSelectItems.UpdateItem(eFPos:Integer; eNameLong:String);
Var i : Integer;
begin
  for I := 0 to High(Items) do
  begin
    if (Items[i].FPos=eFPos) then
    begin
      Items[i].NameLong  := eNameLong;
    end;
  end;
end;

Procedure   tSelectItems.UpdateItem(eFPos:Integer; eNameLong:String; eColor:Byte);
Var i : Integer;
begin
  for I := 0 to High(Items) do
  begin
    if (Items[i].FPos=eFPos) then
    begin
      Items[i].NameLong.Init(eNameLong,eColor);
    end;
  end;
end;

Procedure   tSelectItems.Sort(SelectSort:TSelectSort);
Var i1,i2 : Integer;
    HelpItem : tSelectItem;
begin
  if (Length(Items)>1) then
  begin
    for i1 := 0 to High(Items)-1 do
    begin
      for i2 := i1+1 to High(Items) do
      begin
           (* SortValue *)
        if ((SelectSort=SortUp)    and (Items[i2].SortValue<Items[i1].SortValue)) or
           ((SelectSort=SortDown)  and (Items[i2].SortValue>Items[i1].SortValue)) or
           ((SelectSort=FPosUp)    and (Items[i2].FPos     <Items[i1].FPos))      or
           ((SelectSort=FPosDown)  and (Items[i2].FPos     >Items[i1].FPos))      or
           ((SelectSort=ShortUp)   and (Items[i2].NameShort<Items[i1].NameShort)) or
           ((SelectSort=ShortDown) and (Items[i2].NameShort>Items[i1].NameShort)) or
           ((SelectSort=LongUp)    and (Items[i2].NameLong <Items[i1].NameLong))  or
           ((SelectSort=LongDown)  and (Items[i2].NameLong >Items[i1].NameLong))  then
        begin
          HelpItem  := Items[i1];
          Items[i1] := Items[i2];
          Items[i2] := HelpItem;
        end;
      end;
    end;
  end;
end;

Function    tSelectItems.MaxLen_NameShort : Integer;
Var MaxLen : Integer;
    i      : Integer;
begin
  MaxLen := 0;
  for I := 0 to High(Items) do
  begin
    MaxLen := Max(MaxLen,Length(Items[i].NameShort));
  end;
  Result := MaxLen;
end;

Function    tSelectItems.MaxLen_NameLong : Integer;
Var MaxLen : Integer;
    i      : Integer;
begin
  MaxLen := 0;
  for I := 0 to High(Items) do
  begin
    MaxLen := Max(MaxLen,Length(Items[i].NameLong));
  end;
  Result := MaxLen;
end;

Function    tSelectItems.Count : Integer;
begin
  Result := Length(Items);
end;

Function    tSelectItems.FPosMin : Integer;
Var PosMin : Integer;
    i      : Integer;
begin
  if (Length(Items)>0) then
  begin
    PosMin := High(Integer);
    for I := 0 to High(Items) do
    begin
      PosMin := Min(PosMin,Items[i].FPos);
    end;
    Result := PosMin;
  end else Result := -1;
end;

Function    tSelectItems.FPosMax : Integer;
Var PosMax : Integer;
    i      : Integer;
begin
  if (Length(Items)>0) then
  begin
    PosMax := Low(Integer);
    for I := 0 to High(Items) do
    begin
      PosMax := Min(PosMax,Items[i].FPos);
    end;
    Result := PosMax;
  end else Result := -1;
end;

Function    tSelectItems.IsMember(eFPos:Integer) : Boolean;
Var i : Integer;
begin
  Result := False;
  for I := 0 to High(Items) do
  begin
    if (Items[i].FPos=eFPos) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

Function    tSelectItems.GetIndexByFPos(sFPos:Integer) : Integer;
Var i : Integer;
begin
  Result := -1;
  for I := 0 to High(Items) do
  begin
    if (Items[i].FPos=sFPos) then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

Function    tSelectItems.GetIndexByNameShort(sNameShort:String) : Integer;
Var i : Integer;
begin
  Result := -1;
  for I := 0 to High(Items) do
  begin
    if (CompareStr(Items[i].NameShort,sNameShort)=0) then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

Function    tSelectItems.GetIndexByNameLong(sNameLong:String) : Integer;
Var i : Integer;
begin
  Result := -1;
  for I := 0 to High(Items) do
  begin
    if (CompareStr(Items[i].NameLong,sNameLong)=0) then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

Function    tSelectItems.GetIndexBySearch(SearchString:String) : Integer;
Var DS_Exact                 : Integer;
    DS_Short1                : Integer;
    DS_Short2                : Integer;
    DS_Long1                 : Integer;
    DS_Long2                 : Integer;
    NameShort                : String;
    NameLong                 : String;
    i                        : Integer;
begin
  Result     := -1;
  DS_Exact   := -1;
  DS_Short1  := -1;
  DS_Short2  := -1;
  DS_Long1   := -1;
  DS_Long2   := -1;
  if (SearchString<>'') then
  begin
    SearchString := StringReplaceGermanUmlauts(StringDeleteSpaces(SearchString)).ToUpper;
    for I := 0 to High(Items) do
    begin
      NameShort := StringReplaceGermanUmlauts(StringDeleteSpaces(Items[i].NameShort)).ToUpper;
      NameLong  := StringReplaceGermanUmlauts(StringDeleteSpaces(Items[i].NameLong)).ToUpper;
      if (SearchString=NameShort) or
         (SearchString=NameLong)  then
      begin
        DS_Exact := i;
      end else
      begin
        if (NameShort<>'') then
        begin
          // When NameShort starts with the input 
          if (Copy(NameShort,1,Length(SearchString))=SearchString) and (DS_Short1=-1) then
          begin
            DS_Short1 := i;
          end else
          // If the input is contained in NameShort 
          if (Pos(SearchString,NameShort)>1) and (DS_Short2=-1) then
          begin
            DS_Short2 := i;
          end;
        end;
        if (NameLong<>'') then
        begin
          // When NameLong starts with the input
          if (Copy(NameLong,1,Length(SearchString))=SearchString) and (DS_Long1=-1) then
          begin
            DS_Long1 := i;
          end else
          // if input is contained in NameLong
          if (Pos(SearchString,NameLong)>1) and (DS_Long2=-1) then
          begin
            DS_Long2 := i;
          end;
        end;
      end;
    end;
    if (DS_Exact >=1) then Result := DS_Exact  else
    if (DS_Short1>=1) then Result := DS_Short1 else
    if (DS_Long1>=1)  then Result := DS_Long1 else
    if (DS_Short2>=1) then Result := DS_Short2 else
    if (DS_Long2>=1)  then Result := DS_Long2;
  end;
end;

Function    tSelectItems.GetItemByFPos(sFPos:Integer; Var aItem:tSelectItem) : Boolean;
Var ItemNo : Integer;
begin
  Result := False;
  aItem.Clear;
  ItemNo := GetIndexByFPos(sFPos);
  if (ItemNo>=0) and (ItemNo<=High(Items)) then
  begin
    aItem  := Items[ItemNo];
    Result := True;
  end;
end;

Function    tSelectItems.Select(FromY,ToY:Integer; HeadLine:TConsoleString;
              Var FPosSelect:Integer; Var Key:Word) : Boolean;

  Procedure Clr_EName(Var eName:String);
  begin
    if (eName<>'') then
    begin
      FillChar(EName[1],length(EName),#32);
      WriteRight(1,eName);
      eName := '';
    end;
  end;

Var ItemFrom                 : Integer;
    ItemCurrent              : Integer;
    ItemMax                  : Integer;
    ItemSelect               : Integer;
    LenShort                 : Integer;
    Refresh                  : Boolean;
    YMin                     : Smallint;
    YMax                     : Smallint;
    LinesMax                 : Smallint;
    YCurrent                 : Smallint;
    YSelect                  : Integer;
    eName                    : String;
    SetSelect                : Boolean;
    FPosSave                 : Integer;
begin
  Result      := False;
  if (Count>0) then
  begin
    FPosSave    := FPosSelect;
    LenShort    := MaxLen_NameShort;
    ItemMax     := Count-1;
    YMax        := Min(ToY,MaxY);
    if (HeadLine='') then YMin := FromY else YMin := FromY+1;
    LinesMax    := YMax-YMin+1;
    YCurrent    := YMin;
    // Set ItemFrom to the preselected value 
    ItemFrom    := GetIndexByFPos(FPosSelect);
    // If there are fewer entries, then start the output beforehand 
    if (ItemMax-ItemFrom<(YMax-YMin+1)) then
    begin
      ItemFrom  := ValueMinMax(ItemFrom,0,ItemMax-(YMax-YMin));
    end;
    Refresh     := True;
    eName       := '';
    SetSelect   := True;
    Repeat
      if (Refresh) then
      begin
        Refresh := False;
        ClrLines(FromY,ToY);
        if (ItemFrom>=0) and (ItemFrom<=High(Items)) then
        begin
          ItemCurrent := ItemFrom;
        end else
        begin
          ItemCurrent := 0;
        end;
        if (HeadLine<>'') then
        begin
          WriteXY(1,FromY,HeadLine);
        end;
        YCurrent := YMin;
        Repeat
          Items[ItemCurrent].WriteSelection(YCurrent,LenShort);
          if (SetSelect) and (Items[ItemCurrent].FPos=FPosSelect) then
          begin
            YSelect   := YCurrent;
            SetSelect := False;
          end;
          inc(YCurrent);
          inc(ItemCurrent);
        Until (ItemCurrent>ItemMax) or (YCurrent>YMax);
        // If not displayed from the first entry, then arrow upwards 
        if (ItemFrom>0)  then WriteXY(MaxX-1,YMin,Yellow,WideChar(_Arrow_Up));
        // If not displayed up to the last entry, then arrow downwards 
        if (ItemCurrent<=ItemMax) then WriteXY(MaxX-1,YMax,Yellow,WideChar(_Arrow_Down));
        if (eName<>'') then
        begin
          Textcolor(Yellow);
          WriteRight(1,eName);
        end;
        Textcolor(LightGray);
      end;
      Key := LineSelect(YMin,YCurrent-1,YSelect);
      if not(SortExtern) and (Key>=_Alt_1) and (Key<=_Alt_4) then
      begin
        ItemSelect := ItemFrom + YCurrent - YMin;
        FPosSelect := Item[ItemSelect].FPos;
        if (Key=_ALT_1) then Sort(SortUp)  else
        if (Key=_ALT_2) then Sort(FPosUp)  else
        if (Key=_ALT_3) then Sort(ShortUp) else
        if (Key=_ALT_4) then Sort(LongUp);
        ItemFrom := GetIndexByFPos(FPosSelect);
        // If there are fewer entries, then start the output beforehand 
        if (ItemMax<LinesMax) then ItemFrom := 1 else
        if (ItemFrom>1)       then ItemFrom := Max(0,ItemFrom-(LinesMax div 2));
        SetSelect := True;
      end else
      if ((Key>=_A) and (Key<=_Z)) or (Key=_Space) or
         (Key=_SS)  or (Key=_AE) or (Key=_OE) or (Key=_UE) or
         ((Key>=_0) and (Key<=_9) and not(FExitOnNumber))  or
         (Key=_Questionmark)                               or
         (Key=_BackSpace)                                  then
      begin
        if (Key=_BackSpace) and (eName<>'') then
        begin
          Delete(eName,Length(eName),1);
          WriteRight(1,' '+eName);
          ItemFrom := GetIndexBySearch(eName);
          YCurrent := YMin;
          Refresh  := True;
        end else
        if (Key<>_Space) or (eName<>'') then
        begin
          // The search term cannot be longer than the width of the window
          if (length(eName)<MaxX) then
          begin
            eName    := eName + LastReadKeyChar;
            ItemFrom := GetIndexBySearch(eName);
            if (ItemFrom>=0) then YSelect := YMin;
            Refresh  := True;
          end;
          // If the user has already entered a search text and then enters a 
          // space, the function should not be exited but the space should be 
          // added to the search text.
          if (Key=_Space) then Key := _Right;
        end;
      end else
      if (Key=_Up) then
      begin
        Clr_EName(eName);
        if (ItemFrom>0) then
        begin
          Dec(ItemFrom);
          Refresh := True;
        end;
      end else
      if (Key=_PgUp) and not(ExitOnPgKey) then
      begin
        Clr_EName(eName);
        if (ItemFrom>0) then
        begin
          ItemFrom := Max(0,ItemFrom-YMax+YMin-1);
          Refresh  := True;
        end;
      end else
      if (Key=_CTRL_PgUp) or (Key=_CTRL_Pos1) then
      begin
        ItemFrom := 1;
        Refresh  := True;
        YCurrent := YMin;
      end else
      if (Key=_Down) then
      begin
        Clr_EName(eName);
        if (ItemMax-YMax+YMin > ItemFrom) then
        begin
          inc(ItemFrom);
          Refresh := True;
        end;
      end else
      if (Key=_PgDown) and not(ExitOnPgKey) then
      begin
        Clr_EName(eName);
        if (ItemMax-YMax+YMin > ItemFrom) then
        begin
          ItemFrom := ItemFrom + YMax - YMin + 1;
          ItemFrom := Min(ItemFrom,ItemMax-1);
          Refresh  := True;
        end;
      end else
      if (Key=_CTRL_PgDown) or (Key=_CTRL_End) then
      begin
        FPosSelect := ItemMax-1;
        ItemFrom   := ItemMax - (ToY-FromY) + 1;
        YCurrent   := YMax;
      end;
    Until (Key=_Return)     or  (Key=_ESC)       or (Key=_Space) or
          ((ExitOnPgKey)    and ((Key=_PgUp)     or (Key=_PgDown))) or
          ((SortExtern)     and (Key>=_ALT_1)    and (Key<=_ALT_4)) or
          (Key=_ALT_0)                           or
          ((Key>=_ALT_5)    and (Key<=_ALT_9))   or
          ((Key>=_0)        and (Key<=_9)        and (FExitOnNumber)) or
          ((Key>=_F2)       and (Key<=_F12))     or
          ((Key>=_ALT_F1)   and (Key<=_ALT_F12)) or
          ((Key>=_ALT_A)    and (Key<=_ALT_Z))   or
          ((Key>=_CTRL_A)   and (Key<=_CTRL_Z))  or
          (Key=_CTRL_Up)    or  (Key=_CTRL_Down) or
          (Key=_CTRL_Minus) or  (Key=_CTRL_Plus) or
          (Key=_ALT_Minus)  or  (Key=_ALT_Plus)  or
          (Key=_TAB)        or
          (Key=_Insert)     or  (Key=_ALT_Insert) or
          (Key=_CRT_DELETE)     or  (Key=_ALT_Delete);
    if (Key=_Return)     or  (Key=_TAB)       or
       ((Key>=_F1)       and (Key<=_F12))     or
       ((Key>=_ALT_1)    and (Key<=_ALT_4))   or
       ((Key>=_ALT_F1)   and (Key<=_ALT_F12)) or
       ((Key>=_ALT_A)    and (Key<=_ALT_Z))   or
       ((Key>=_CTRL_A)   and (Key<=_CTRL_Z))  or
       (Key=_CTRL_Up)    or (Key=_CTRL_Down)  or
       (Key=_CTRL_Minus) or (Key=_CTRL_Plus)  or
       (Key=_ALT_Minus)  or  (Key=_ALT_Plus)  or
       (Key=_Space)      or (Key=_CRT_DELETE)     or
       (Key=_Insert) then
    begin
      ItemSelect  := ItemFrom + YSelect - YMin;
      FPosSelect := Item[ItemSelect].FPos;
      if (FPosSelect>=0) and (Key=_Return) then Result := True;
    end else FPosSelect := FPosSave;
  end;
end;

Function  tSelectItems.Select(Left,Top,Right,Bottom:Integer; Title,BottomLeft:String;
            HeadLine:TConsoleString; Var FPosSelect:Integer; Var Key:Word) : Boolean;
Var ScreenSave : tScreenSave;
begin
  if (Count>0) then
  begin
    ScreenSave.Save;
    Window(Left,Top,Right,Bottom,Title,_TextAttr_Yellow_Blue,BottomLeft);
    Result := Select(1,MaxY,HeadLine,FPosSelect,Key);
    ScreenSave.Restore;
  end else
  begin
    Result := False;
    Key    := _ESC;
  end;
end;

Function  tSelectItems.Select(Title,BottomLeft:String; HeadLine:TConsoleString;
            Var FPosSelect:Integer; Var Key:Word) : Boolean;
Var ScreenSave : tScreenSave;
begin
  ScreenSave.Save;
  Window(Title,BottomLeft);
  Result := Select(1,MaxY,HeadLine,FPosSelect,Key);
  ScreenSave.Restore;
end;

Procedure ConsoleShowMessage(x,y,SizeX,SizeY:Integer; FrameAttr:TTextAttr;
            Title,Msg1:String; Msg2:String=''; Msg3:String='');
Var ScreenSave : tScreenSave;
    FrameWindow : tFrameWindow;
begin
  ScreenSave.Save;
  FrameWindow.ClearSettings;
  FrameWindow.TextColor      := White;
  FrameWindow.TextBackground := Black;
  FrameWindow.FrameAttr      := FrameAttr;
  FrameWindow.ClrBackground := False;
  FrameWindow.Window(x,y,x+SizeX,y+SizeY,Title);
  WriteXY(1,1,Msg1);
  WriteXY(1,2,Msg2);
  WriteXY(1,3,Msg3);
  Readkey;
  FrameWindow.ClearSettings;
  ScreenSave.Restore;
end;

Procedure ConsoleShowNote(Title,Msg1:String; Msg2:String=''; Msg3:String='');
Var FrameAttr : TTextAttr;
begin
  FrameAttr.Color(White,Blue);
  if (Title='') then Title := 'Note';
  ConsoleShowMessage(5,5,Console.WindowSize.x-10,4,FrameAttr,Title,Msg1,Msg2,Msg3);
end;

Procedure ConsoleShowWarning(Title,Msg1:String; Msg2:String=''; Msg3:String='');
Var FrameAttr : TTextAttr;
begin
  FrameAttr.Color(Black,Yellow);
  if (Title='') then Title := 'Warning';
  ConsoleShowMessage(5,5,Console.WindowSize.x-10,4,FrameAttr,Title,Msg1,Msg2,Msg3);
end;

Procedure ConsoleShowError(Title,Msg1:String; Msg2:String=''; Msg3:String='');
Var FrameAttr : TTextAttr;
begin
  FrameAttr.Color(White,Red);
  if (Title='') then Title := 'Error';
  ConsoleShowMessage(5,5,Console.WindowSize.x-10,4,FrameAttr,Title,Msg1,Msg2,Msg3);
end;

Procedure ScreenSaveToFile;
Var ScreenSave : TScreenSave;
begin
  ScreenSave.Save;
  ScreenSave.SaveToFile;
end;

Procedure ScreenSelectFromFile;
Var ScreenSave : TScreenSave;
begin
  if (ScreenSave.SelectFromFile) then
  begin
    ScreenSave.Restore;
    Readkey;
  end;
end;

initialization
  TextAttrFrameDefault := _TextAttr_Yellow_Blue;
  Proc_CTRL_ALT_0_9    := ConsoleLocationMoveUser;
  Proc_CTRL_ALTGR_0_9  := ConsoleLocationSaveUser;
  Proc_CTRL_ALT_L      := ScreenSelectFromFile;
  Proc_CTRL_ALT_S      := ScreenSaveToFile;
end.
