// Created by x00man01d
// Copyright (c) 2015. All rights reserved.

unit uMain;

interface

uses
  Windows, Forms, PlugInIntf, SysUtils, Vcl.Dialogs, System.UITypes;

const // Description of this Plug-In (as displayed in Plug-In configuration dialog)
  Desc: AnsiString = 'Autosave Plugin';

function GetPathByServer(AObjectOwner: AnsiString): AnsiString;
function GetCurrentServer(AObjectOwner: AnsiString): AnsiString;
procedure SaveFile(AObjectName: AnsiString; AFileExt: AnsiString;
  AObjectOwner: AnsiString);


implementation

uses uPref;

// Plug-In identification, a unique identifier is received and
// the description is returned

function IdentifyPlugIn(ID: Integer): PAnsiChar; cdecl;
begin
  PlugInID := ID;
  Result := PAnsiChar(Desc);
end;

procedure AfterExecuteWindow(WindowType, Result: Integer); cdecl;
var
  ObjectType, ObjectOwner, AObjectName, SubObject: PAnsiChar;
  ext: AnsiString;
  PObjectName: AnsiString;
  PObjectOwner: AnsiString;
  SqlText: AnsiString;
begin
  try
    case WindowType of
      wtProcEdit:
        begin
          IDE_GetWindowObject(ObjectType, ObjectOwner, AObjectName, SubObject);
          if (ObjectType = 'PACKAGE') or (ObjectType = 'PACKAGE BODY') then
          begin
            ext := AnsiString('pck');
          end
          else
          begin
            ext := AnsiString(IDE_GetProcEditExtension(ObjectType));
          end;
          SaveFile(AObjectName, ext, ObjectOwner);
        end;
      wtSQL:
        begin
          SqlText := IDE_GetText;
          if Pos('CREATE OR REPLACE VIEW', UpperCase(trim(SqlText))) = 1 then
          begin
            Delete(SqlText, 1, 22);
            SqlText := AnsiString(trim(SqlText));
            PObjectName :=
              AnsiString(trim(Copy(SqlText, 1, Pos(' ', SqlText))));
            if Pos('.', PObjectName) <> 0 then
            begin
              PObjectOwner := Copy(PObjectName, 1, Pos('.', PObjectName) - 1);
              PObjectName := Copy(PObjectName, Pos('.', PObjectName) + 1,
                Length(PObjectName));
            end;
          end
          else
            Exit;
          ext := 'vw';
          SaveFile(PObjectName, ext, PObjectOwner);
        end;
    end;
  except

  end;
end;

procedure SaveFile(AObjectName: AnsiString; AFileExt: AnsiString;
  AObjectOwner: AnsiString);
var
  Path: AnsiString;
  Filename: PAnsiChar;
begin
  Path := GetPathByServer(AObjectOwner);
  if not DirectoryExists(Path) then
    CreateDir(Path);
  Filename := PAnsiChar(Path + AnsiString('\') + AObjectName + AnsiString('.') +
    AFileExt);
  IDE_SetFilename(Filename);
  IDE_SaveFile;
end;

function GetCurrentServer(AObjectOwner: AnsiString): AnsiString;
var
  Username, Password, Database: PAnsiChar;
begin
  IDE_GetConnectionInfo(Username, Password, Database);
  if AObjectOwner = '' then
    AObjectOwner := Username;
  Result := AnsiString(UpperCase(AObjectOwner + AnsiString('@') + Database));
end;

function GetPathByServer(AObjectOwner: AnsiString): AnsiString;
var
  APath: AnsiString;
begin
  Result := '';
  APath := IDE_GetPrefAsString(PlugInID, '',
    PAnsiChar(GetCurrentServer(AObjectOwner)), '');
  if APath = '' then
  begin
    if MessageDlg('ѕуть дл€ сохранени€ файлов не указан.' + #10#13 +
      '”казать сейчас?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes
    then
    begin
      DoPreferences;
      GetPathByServer(AObjectOwner);
    end;
  end;
  Result := APath;
end;

// OnActivate gets called after OnCreate. However, when OnActivate is called PL/SQL
// Developer and the Plug-In are fully initialized. This function is also called when the
// Plug-In is enabled in the configuration dialog. A good point to enable/disable menus.

procedure OnActivate; cdecl;
begin
  Application.Handle := IDE_GetAppHandle;
end;

// This will be called when PL/SQL Developer is about to close. If your PlugIn is not
// ready to close, you can show a message and return False.

function CanClose: Bool; cdecl;
begin
  Result := True;
end;

// This function allows you to take some action before a window is closed. You can
// influence the closing of the window with the following return values:
// 0 = Default behavior
// 1 = Ask the user for confirmation (like the contents was changed)
// 2 = DonТt ask, allow to close without confirmation
// The Changed Boolean indicates the current status of the window.

function OnWindowClose(WindowType: Integer; Changed: Bool): Integer; cdecl;
begin
  Result := 0;
end;

// This function allows you to display an about dialog. You can decide to display a
// dialog yourself (in which case you should return an empty text) or just return the
// about text.

function About: PChar; cdecl;
begin
  Result := 'Autosave Plugin';
end;

// If the Plug-In has a configure dialog you could use this function to activate it. This will
// allow a user to configure your Plug-In using the configure button in the Plug-In
// configuration dialog.

procedure Configure; cdecl;
begin
  DoPreferences;
end;

// Exported functions
exports IdentifyPlugIn, RegisterCallback, OnActivate, CanClose, OnWindowClose,
  About, Configure, AfterExecuteWindow;

end.
