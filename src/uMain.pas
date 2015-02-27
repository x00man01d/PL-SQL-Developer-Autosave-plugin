// Created by x00man01d
// Copyright (c) 2015. All rights reserved.

unit uMain;

interface

uses
  Windows, Forms, PlugInIntf, SysUtils;

const // Description of this Plug-In (as displayed in Plug-In configuration dialog)
  Desc = 'Autosave Plugin';

function GetPathByServer: string;
function GetCurrentServer: string;

implementation

uses uPref;

// Plug-In identification, a unique identifier is received and
// the description is returned

function IdentifyPlugIn(ID: Integer): PChar; cdecl;
begin
  PlugInID := ID;
  Result := Desc;
end;

procedure AfterExecuteWindow(WindowType, Result: Integer); cdecl;
var
  ObjectType, ObjectOwner, ObjectName, SubObject: PChar;
  Filename: PAnsiChar;
  ext: string;
begin
  case WindowType of
    wtProcEdit:
      begin
        IDE_GetWindowObject(ObjectType, ObjectOwner, ObjectName, SubObject);
        ext := IDE_GetProcEditExtension(ObjectType);
        Filename := PAnsichar(GetPathByServer + ObjectName + '.' + ext);
        IDE_SetFilename(Filename);
        IDE_SaveFile;
      end;
  end;
end;

function GetCurrentServer: string;
var
  Username, Password, Database: PChar;
begin
  IDE_GetConnectionInfo(Username, Password, Database);
  Result := UpperCase(Username + '@' + Database);
end;

function GetPathByServer: string;
begin
  result := IDE_GetPrefAsString(PlugInID, '', PChar(GetCurrentServer), '');
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
// 2 = Don’t ask, allow to close without confirmation
// The Changed Boolean indicates the current status of the window.

function OnWindowClose(WindowType: Integer; Changed: BOOL): Integer; cdecl;
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
exports
  IdentifyPlugIn,
  RegisterCallback,
  OnActivate,
  CanClose,
  OnWindowClose,
  About,
  Configure,
  AfterExecuteWindow;

end.

